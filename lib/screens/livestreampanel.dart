import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../controller/streamdata.dart';
import '../controller/youtube.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

import '../provider/debug.dart';
import '../provider/global.dart';

class LiveStreamScreen extends StatefulWidget {
  const LiveStreamScreen({super.key});

  @override
  State<LiveStreamScreen> createState() => _LiveStreamScreenState();
}

class _LiveStreamScreenState extends State<LiveStreamScreen> {
  final _singleton = Singletons();
  final bool _useSelenium = true;

  final textmessage = """2022年10月09日 禮中堂主日崇拜
講員：姚澤煌牧師
講題：朝聖之民心所向
經文：詩篇84篇1至12節

https://youtu.be/mR6OF3cNUF8

(10:45am可以進入靜候11:00am崇拜開始)

「主日崇拜網上出席表」連結（請以個人單位填寫）：
https://forms.gle/95cuCRnGk2LdGJZ39 """;

  setClippboard(String text) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
    } catch (e) {
      print(e);
    }
  }

  callLocalFlask(String text, {bool useSelenium = false}) async {
    String webLink = "";
    String automationMode = 'pyautogui';

    setState(() {
      _singleton.message = text;
    });

    if (useSelenium) {
      automationMode = 'selenium';
    }

    try {
      var response = await http.post(
        Uri.http('localhost:2339', automationMode),
        headers: {
          'Content-Type': 'application/json',
          "Access-Control-Allow-Origin": "*"
        },
        body: jsonEncode(<String, String>{
          // 'title': "YYYYEWEEET",
          'message': text,
        }),
      );
      print("Yo: ${response.body}");
      webLink = response.body;
    } catch (e) {
      print(e);
      launchUrlString("https://web.whatsapp.com");
    }

    if (useSelenium) return;
    launchUrlString(webLink);
  }

  Future<String> _confirmText() async {
    List<String> data = await CrckcHelperAPI.get();
    //Remove the a" in the back
    DateTime t = DateTime.parse(data[3].substring(0, data[3].length - 1));
    // DateTime updateTime = DateTime.parse(data[3]);
    return "Use The Following Data?\n\n講員: ${data[0]}\n講題: ${data[1]}\n經文: ${data[2]}\n\nData Updated On:\n${t.day}/${t.month} - ${t.hour}:${t.minute}";
  }

  Future _confirmSchedule(confirmText) => showDialog(
      context: context,
      builder: (context) {
        submit(bool confirm) async {
          Navigator.of(context).pop();
          List data = [];
          if (confirm) {
            if (DebugSingleton().debug) {
              data = [
                "https://studio.youtube.com/channel/1/livestreaming",
                confirmText
              ];
            } else {
              data = await Youtube.scheduleStream();
            }

            if (data.isNotEmpty) {
              callLocalFlask(data[1], useSelenium: _useSelenium);
              launchUrlString(data[0]);
            }
          }
        }

        return AlertDialog(
          title: Text(confirmText),
          actions: [
            TextButton(
                onPressed: (() => submit(false)), child: const Text("Cancel")),
            TextButton(
                onPressed: (() => submit(true)), child: const Text("Confirm")),
          ],
        );
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Live Stream Control Panel")),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FractionallySizedBox(
                widthFactor: 0.2,
                // widthFactor: 0.6,
                child: AspectRatio(
                  aspectRatio: 10 / 3,
                  child: ElevatedButton(
                      onPressed: () async {
                        _confirmSchedule(await _confirmText());
                      },
                      child: const Text("Schedule Stream")),
                ),
              ),
            ),
            Text(_singleton.message),
            ElevatedButton(
                onPressed: () async {
                  await Clipboard.setData(
                      ClipboardData(text: _singleton.message));
                  // copied successfully
                },
                child: const Text("Copy Message")),
            DebugSingleton().debug
                ? ElevatedButton(
                    onPressed: () =>
                        callLocalFlask("yo", useSelenium: _useSelenium),
                    child: const Text("Testing"),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

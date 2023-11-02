// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../controller/streamdata.dart';
import '../controller/youtube.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import "help.dart";
import '../provider/options.dart';
import '../provider/global.dart';

class LiveStreamScreen extends StatefulWidget {
  const LiveStreamScreen({super.key});

  @override
  State<LiveStreamScreen> createState() => _LiveStreamScreenState();
}

class _LiveStreamScreenState extends State<LiveStreamScreen> {
  final _singleton = Singletons();
  final bool _useSelenium = true;

  setClippboard(String text) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
    } catch (e) {
      // print(e);
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
        Uri.http('127.0.0.1:2339', automationMode),
        headers: {
          'Content-Type': 'application/json',
          "Access-Control-Allow-Origin": "*"
        },
        body: jsonEncode(<String, String>{
          // 'title': "YYYYEWEEET",
          'message': text,
        }),
      );
      // print("Yo: ${response.body}");
      webLink = response.body;
      if (response.statusCode == 500) {
        assert(false);
      }
    } catch (e) {
      // print(e);
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
    String confirmation;
    if (DateTime.now().difference(t) < const Duration(days: 7)) {
      confirmation = "\nData should be up to date";
    } else {
      confirmation = "\nData might be outdated";
    }
    return "Use The Following Data?\n\n講員: ${data[0]}\n講題: ${data[1]}\n經文: ${data[2]}\n\nData Updated On:\n${t.day}/${t.month} - ${t.hour}:${t.minute}$confirmation";
  }

  Future _confirmSchedule(confirmText) => showDialog(
      context: context,
      builder: (context) {
        submit(bool confirm) async {
          Navigator.of(context).pop();
          List data = [];
          if (confirm) {
            if (OptionSingleton().debug) {
              data = [
                "https://studio.youtube.com/channel/1/livestreaming",
                confirmText
              ];
            } else {
              try {
                data = await Youtube.scheduleStream();
              } catch (e) {
                debugPrint("Failed To Schedule Stream");
              }
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

  void goToHelpPage() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      //Signin Page Frame
      return const HelpPage();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Stream Control Panel"),
        actions: [
          InkWell(
            onTap: () => goToHelpPage(),
            child: const Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.help_outline_sharp),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0, right: 10.0, top: 8.0),
                  child: Text(
                    "Help",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
              child: const Text("Copy Message"),
            ),
            ElevatedButton(
              onPressed: () async {
                await http.get(
                  Uri.http('127.0.0.1:2339', "start/obs"),
                );
              },
              child: const Text("Start OBS"),
            ),
            OptionSingleton().debug
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

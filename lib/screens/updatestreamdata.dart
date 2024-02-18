// import 'package:crckclivestreamhelper/model/streamdatamodel.dart';

import 'package:crckclivestreamhelper/provider/options.dart';

import '../controller/streamdata.dart';
import 'package:flutter/material.dart';

class StreamDataScreen extends StatefulWidget {
  const StreamDataScreen({super.key});

  @override
  State<StreamDataScreen> createState() => _StreamDataScreenState();
}

class _StreamDataScreenState extends State<StreamDataScreen> {
  TextEditingController speaker = TextEditingController();
  TextEditingController topic = TextEditingController();
  TextEditingController verse = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // final _formKey = GlobalKey<FormState>();
  Future _submitForm() => showDialog(
      context: context,
      builder: (context) {
        final data = CrckcStreamData(
          speaker: speaker.text,
          topic: topic.text,
          verse: verse.text,
        );

        submit(bool confirm) async {
          Navigator.of(context).pop();
          if (confirm) {
            CrckcHelperAPI.addData(data);
          }
        }

        return AlertDialog(
          title: Text(
              "Confirm Changed Data?\n\n講員: ${data.speaker}\n講題: ${data.topic}\n經文: ${data.verse}"),
          actions: [
            // TextButton(
            //     onPressed: (() => SystemChannels.platform
            //         .invokeMethod<void>('SystemNavigator.pop')),
            //     child: const Text("Exit")),
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
      appBar: AppBar(
        title: const Text("Update Livestream Data"),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "講員",
                    border: OutlineInputBorder(),
                  ),
                  controller: speaker,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "講題",
                    border: OutlineInputBorder(),
                  ),
                  controller: topic,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "經文",
                    border: OutlineInputBorder(),
                  ),
                  controller: verse,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
              ),
              TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() ||
                        OptionSingleton().debug) {
                      _submitForm();
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(content: Text('Processing Data')),
                      // );
                    }
                  },
                  child: const Text("Submit")),
              // TextButton(
              //     onPressed: () => print("Oh no you pressed the "), //YoutubeController.init(),
              //     child: const Text("login"))
            ],
          ),
        ),
      )),
    );
  }
}

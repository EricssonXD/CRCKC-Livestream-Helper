// import 'package:crckclivestreamhelper/model/streamdatamodel.dart';
import 'package:flutter/services.dart';

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

  // final _formKey = GlobalKey<FormState>();
  Future _submitForm() => showDialog(
      context: context,
      builder: (context) {
        submit() async {
          Navigator.of(context).pop();
        }

        List<String> row = [speaker.text, topic.text, verse.text];
        // print(row);
        CrckcHelperAPI.insert(row);
        return AlertDialog(
          title:
              Text("Data Updated\n講員: ${row[0]}\n講題: ${row[1]}\n經文: ${row[2]}"),
          actions: [
            // TextButton(
            //     onPressed: (() => SystemChannels.platform
            //         .invokeMethod<void>('SystemNavigator.pop')),
            //     child: const Text("Exit")),
            TextButton(onPressed: (() => submit()), child: const Text("Done"))
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
                ),
              ),
              TextButton(
                  onPressed: (() => _submitForm()), child: const Text("Submit"))
            ],
          ),
        ),
      )),
    );
  }
}

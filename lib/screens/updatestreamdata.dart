// import 'package:crckclivestreamhelper/model/streamdatamodel.dart';
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
  void _submitForm() {
    List<String> row = [speaker.text, topic.text, verse.text];
    // print(row);
    CrckcHelperAPI.insert(row);
  }

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
                    labelText: "Speaker",
                    border: OutlineInputBorder(),
                  ),
                  controller: speaker,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Topic",
                    border: OutlineInputBorder(),
                  ),
                  controller: topic,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Verse",
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

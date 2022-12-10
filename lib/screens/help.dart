import "package:crckclivestreamhelper/provider/options.dart";
import "package:flutter/material.dart";
// import 'package:http/http.dart' as http;

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  void back() {
    Navigator.of(context).pop();
  }

  Widget body() {
    return ListView(
      children: const [
        ExpansionTile(
          title: Text("Setup Youtube Stream and Send Whatsapp"),
          children: [
            Text("1) Press the Schedule Stream Button"),
            Text(
                "2) Check to see if the informations are correct, then press confirm"),
            Text("3) It should auto send the Whatsapp Message with the Helper"),
            Text(
                "4) If it cannot send the message, press copy message and send the message yourself with WhatsappWeb"),
          ],
        ),
        ExpansionTile(
          title: Text("Setup Camera and Other Equipments"),
          children: [
            Text(
                "1) Setup The camera, plug in the audio wire, laptop charger, stream deck controller"),
            Text(""),
          ],
        ),
        ExpansionTile(
          title: Text("Start OBS and Edit Camera Positions"),
          children: [
            Text("1) Ensure the camera is conneted, and open OBS"),
            Text(
                "2) In OBS, go to PPT Big, and change the camera positions accordingly"),
          ],
        ),
        ExpansionTile(
          title: Text("Setup Discord and Start Stream"),
          children: [
            Text("1) Start discord"),
            Text("2) Start the call and open the shared screen"),
            Text(
                "3) Press popout and fullscreen, then use Alt-Tab to switch back to OBS"),
            // TestWidget(),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => back(),
        ),
      ),
      body: body(),
    );
  }
}

class HelpPageWidget extends StatelessWidget {
  const HelpPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    void goToHelpPage() {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        //Signin Page Frame
        return const HelpPage();
      }));
    }

    return InkWell(
      onTap: () => goToHelpPage(),
      child: Row(
        children: const [
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
    );
  }
}

class TestWidget extends StatefulWidget {
  const TestWidget({super.key});

  @override
  State<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  Widget display = const Text("Loading");

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    var widget = const Text("Nothing");
    // Widget Changing Code Start

    // Widget Changing Code End

    setState(() {
      display = widget;
    });
  }

  @override
  Widget build(BuildContext context) {
    // return display;
    return OptionSingleton().debug
        ? Column(
            children: [
              Text(OptionSingleton().debug.toString()),
              TextButton(
                  onPressed: () =>
                      OptionSingleton().debug = !OptionSingleton().debug,
                  child: const Text("ChangeSingleton"))
            ],
          )
        : Container();
  }
}

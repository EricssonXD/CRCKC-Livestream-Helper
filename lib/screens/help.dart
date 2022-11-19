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
            Text("1step"),
            Text("2step"),
          ],
        ),
        ExpansionTile(
          title: Text("Setup Camera and Other Equipments"),
          children: [
            Text("1step"),
            Text("2step"),
          ],
        ),
        ExpansionTile(
          title: Text("Start OBS and Edit Camera Positions"),
          children: [
            Text("1step"),
            Text("2step"),
          ],
        ),
        ExpansionTile(
          title: Text("Setup Discord and Start Stream"),
          children: [
            Text("1step"),
            Text("2step"),
            TestWidget(),
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
                  child: Text("ChangeSingleton"))
            ],
          )
        : Container();
  }
}

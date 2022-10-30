import "package:flutter/material.dart";

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
      children: [
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
            Image.network(
                "https://raw.githubusercontent.com/EricssonXD/CRCKC-Livestream-Helper/master/assets/thumbnailTemplate.JPG"),
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

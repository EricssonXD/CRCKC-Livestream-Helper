import 'package:flutter/material.dart';
import 'screens/index.dart';
import 'controller/streamdata.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await CrckcHelperAPI.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamDataScreen();
  }
}

// import 'package:crckclivestreamhelper/controller/youtube.dart';
import 'package:crckclivestreamhelper/controller/login.dart';
import 'package:crckclivestreamhelper/provider/options.dart';
import 'package:flutter/material.dart';
import 'screens/index.dart';
import 'provider/google.dart';
// import 'provider/debug.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GoogleAPI.init();
  OptionSingleton();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => GoogleProvider()),
      // ChangeNotifierProvider(create: (_) => DebugController()),
      ChangeNotifierProvider(create: (_) => Options()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  @override
  void initState() {
    if (GoogleAPI.loggedIn) {
      _selectedIndex = 2;
    }
    super.initState();
  }

  static const List<Widget> _widgetOptions = <Widget>[
    StreamDataScreen(),
    Settings(),
    LiveStreamScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget defaultbody() {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.upload),
            label: 'Update Data',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.school),
          //   label: 'School',
          // ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  Widget livestreamBody() {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.upload),
            label: 'Update Data',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_call_rounded),
            label: 'LiveStream',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // bool loggedIn = context.watch<GoogleProvider>().loggedIn;
    return livestreamBody();
  }
}

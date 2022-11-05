// import 'dart:html';

import 'package:crckclivestreamhelper/provider/debug.dart';
import 'package:crckclivestreamhelper/provider/google.dart';
import 'package:flutter/material.dart';
import '../controller/login.dart';
// import '../controller/youtube.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'help.dart';

class Settings extends StatefulWidget {
  /// Creates the main widget of this demo.
  const Settings({Key? key}) : super(key: key);

  @override
  State createState() => SettingsState();
}

/// The state of the main widget.
class SettingsState extends State<Settings> {
  @override
  void initState() {
    // GoogleAPI.init();
    super.initState();
  }

  ///Login Page body

  ///Open Signin Page and Contains Sign In Page Frame
  void goToSignInPage() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      //Signin Page Frame
      return const SigninPage();
    }));
  }

  Widget _settingsBody() {
    bool debugMode = context.watch<DebugController>().debug;
    bool loggedIn = context.watch<GoogleProvider>().loggedIn;
    return ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: ListView(
        children: [
          ListTile(
            onTap: () => goToSignInPage(),
            title: const Center(child: Text("Sign In")),
          ),
          ListTile(
            title: const Center(child: Text("Debug Mode")),
            tileColor: debugMode ? Colors.green[300] : Colors.red[300],
            trailing: Icon(
                debugMode ? Icons.check_box : Icons.check_box_outline_blank),
            onTap: () => context.read<DebugController>().setDebug(!debugMode),
          ),
          ListTile(
            title: const Center(child: Text("Forced Signin")),
            trailing: Icon(
                loggedIn ? Icons.check_box : Icons.check_box_outline_blank),
            onTap: () => context.read<GoogleProvider>().setLoggedin(!loggedIn),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // context.watch<GoogleProvider>().loggedIn;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: const [
          HelpPageWidget(),
        ],
      ),
      body: _settingsBody(),
    );
  }
}

class SigninPage extends StatefulWidget {
  const SigninPage({
    super.key,
  });

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  late bool debugHover = false;

  void back() {
    Navigator.of(context).pop();
  }

  Widget _loginPage() {
    var user = GoogleAPI.currentUser;
    if (user != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ListTile(
            leading: GoogleUserCircleAvatar(
              identity: user,
            ),
            title: Text(user.displayName ?? ''),
            subtitle: Text(user.email),
          ),
          const Text('Signed in successfully.'),
          ElevatedButton(
            onPressed: () async {
              await GoogleAPI.handleSignOut();
              // ignore: use_build_context_synchronously
              context.read<GoogleProvider>().setLoggedin(false);
            },
            child: const Text('SIGN OUT'),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Text('You are not currently signed in.'),
          ElevatedButton(
            onPressed: () async {
              bool success = await GoogleAPI.handleSignIn();
              // ignore: use_build_context_synchronously
              context.read<GoogleProvider>().setLoggedin(success);
            },
            child: const Text(
              'SIGN IN',
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => back(),
          ),
          title: const Text("Google Sign In"),
          actions: [
            context.watch<DebugController>().debug
                ? FractionallySizedBox(
                    heightFactor: 1,
                    child: InkWell(
                      onHover: (hovered) {
                        setState(() {
                          debugHover = hovered;
                        });
                      },
                      onTap: () => context.read<GoogleProvider>().setLoggedin(
                          !context
                              .read<GoogleProvider>()
                              .loggedIn), // ignore: avoid_print
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'DEBUG SIGNIN',
                            style: TextStyle(
                                color:
                                    debugHover ? Colors.white70 : Colors.white),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
        body: Center(child: _loginPage()));
  }
}

import 'package:crckclivestreamhelper/provider/google.dart';
import 'package:flutter/material.dart';
import '../controller/login.dart';
import '../controller/youtube.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  Widget _buildBody() {
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
          ElevatedButton(
            onPressed: () => Youtube.scheduleStream(), // ignore: avoid_print
            child: const Text('REFRESH'),
          ),
          // ElevatedButton(
          //   onPressed: () => context.read<GoogleProvider>().setLoggedin(!context
          //       .read<GoogleProvider>()
          //       .loggedIn), // ignore: avoid_print
          //   child: const Text('Test'),
          // ),
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
            child: const Text('SIGN IN'),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<GoogleProvider>().loggedIn;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Sign In'),
      ),
      body: ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: _buildBody(),
      ),
    );
  }
}

// // import 'package:googleapis_auth/auth_io.dart';
// import 'package:googleapis/youtube/v3.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';

// class YoutubeController {
//   static bool _loggedIn = false;
//   static GoogleSignInAccount? _currentUser;
//   var _youtubeClient;

//   get loggedIn => _loggedIn;
//   get user => _currentUser;

//   static Future init() async {
//     final googleSignIn = GoogleSignIn(
//       scopes: [
//         "https://www.googleapis.com/auth/youtube.upload",
//       ],
//     );
//     googleSignIn.signIn();

//     googleSignIn.onCurrentUserChanged.listen((account) {
//       _currentUser = account;
//       if (_currentUser != null) {
//         _loggedIn = true;
//       }
//     });

//     var httpClient = (await googleSignIn.authenticatedClient())!;
//     var _youtubeClient = YouTubeApi(httpClient);
//   }

//   test() async {
//     var youTubeApi = _youtubeClient;

//     var favorites = await youTubeApi.playlistItems.list(
//       ['snippet'],
//       playlistId: 'LL', // Liked List
//     );

//     print(favorites);
//   }
// }
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'dart:async';

import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/people/v1.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth show AuthClient;

final GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  clientId:
      '56469135193-10vkl9nko95u4a70bsqe0150jbhcff12.apps.googleusercontent.com',
  scopes: <String>[
    PeopleServiceApi.contactsReadonlyScope,
    YouTubeApi.youtubeUploadScope,
  ],
);

/// The main widget of this demo.
class Settings extends StatefulWidget {
  /// Creates the main widget of this demo.
  const Settings({Key? key}) : super(key: key);

  @override
  State createState() => SettingsState();
}

/// The state of the main widget.
class SettingsState extends State<Settings> {
// Create storage
  // final storage = const FlutterSecureStorage();

// Read value

// Write value

  GoogleSignInAccount? _currentUser;

  @override
  void initState() {
    super.initState();
    // String? value = await storage.read(key: "login");
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        // ignore: avoid_print
        // print(_currentUser);
      }
    });
    // _googleSignIn.signInSilently();
    _handleSignIn();
  }

  Future<void> _handleSignIn() async {
    _googleSignIn.signInSilently().then((value) {
      print("Successfully Signed In");
      return;
    }).catchError((err) {
      // ignore: avoid_print
      print("cannot auto signin");
    });
    await _googleSignIn.signIn().then((result) {
      // result?.authentication.then((googleKey) {
      //   // print("Access Token:\n${googleKey.accessToken}");
      //   // print("\n\nId Token:\n${googleKey.idToken}");
      // }).catchError((err) {
      //   // ignore: avoid_print
      //   print('inner error $err');
      // });
    }).catchError((err) {
      // ignore: avoid_print
      print('error occured $err');
    });
    // var string = GoogleSignInAuthentication.toString();
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  Widget _buildBody() {
    final GoogleSignInAccount? user = _currentUser;
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
            onPressed: _handleSignOut,
            child: const Text('SIGN OUT'),
          ),
          ElevatedButton(
            onPressed: () => print("no refresh lolz"), // ignore: avoid_print
            child: const Text('REFRESH'),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Text('You are not currently signed in.'),
          ElevatedButton(
            onPressed: _handleSignIn,
            child: const Text('SIGN IN'),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Google Sign In'),
        ),
        body: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: _buildBody(),
        ));
  }
}

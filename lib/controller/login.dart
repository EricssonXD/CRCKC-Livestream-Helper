import 'dart:async';

import 'package:googleapis/youtube/v3.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import '../provider/google.dart';
import 'youtube.dart';
import '../auth/secrets.dart';

class GoogleAPI {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: SECRETS.clientWeb,
    scopes: <String>[
      // PeopleServiceApi.contactsReadonlyScope,
      YouTubeApi.youtubeUploadScope,
      YouTubeApi.youtubeScope,
      // YouTubeApi.youtubepartnerScope,
      // YouTubeApi.youtubepartnerChannelAuditScope,
    ],
  );

  static get googleSignIn => _googleSignIn;

  static GoogleSignInAccount? _currentUser;
  static get currentUser => _currentUser;

  // ignore: prefer_typing_uninitialized_variables
  static var _httpClient;
  static get httpClient => _httpClient;

  static bool _loggedIn = false;
  static get loggedIn => _loggedIn;

  static init() async {
    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
      _currentUser = account;
      if (_currentUser != null) {
        GoogleProvider().setLoggedin(true);
        _httpClient = (await _googleSignIn.authenticatedClient())!;
        Youtube.init();
        _loggedIn = true;
        // callYoutube();
        // print(_currentUser);
      } else {
        GoogleProvider().setLoggedin(false);
      }
    });
    handleSignIn(popup: false);
  }

  static Future<bool> handleSignIn({bool popup = true}) async {
    _googleSignIn.signInSilently().then((value) {
      // print("Successfully Signed In");
      return true;
    }).catchError((err) {
      // ignore: avoid_print
      print("cannot auto signin");
      return false;
    });

    popup
        ? await _googleSignIn.signIn().then((result) {
            return true;
          }).catchError((err) {
            // ignore: avoid_print
            print('error occured $err');
            return false;
          })
        : null;

    return false;
  }

  static Future<void> handleSignOut() => _googleSignIn.disconnect();
}

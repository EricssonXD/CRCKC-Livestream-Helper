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
        // ignore: avoid_print
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
    // _googleSignIn.signInSilently();
    handleSignIn(popup: false);
  }

  static Future<bool> handleSignIn({bool popup = true}) async {
    _googleSignIn.signInSilently().then((value) {
      // print("Successfully Signed In");
      return true;
    }).catchError((err) {
      // ignore: avoid_print
      print("cannot auto signin");
    });

    popup
        ? await _googleSignIn.signIn().then((result) {
            // result?.authentication.then((googleKey) {
            //   // print("Access Token:\n${googleKey.accessToken}");
            //   // print("\n\nId Token:\n${googleKey.idToken}");
            // }).catchError((err) {
            //   // ignore: avoid_print
            //   print('inner error $err');
            // });
            return true;
          }).catchError((err) {
            // ignore: avoid_print
            print('error occured $err');
          })
        : null;
    // var string = GoogleSignInAuthentication.toString();
    return false;
  }

  static Future<void> handleSignOut() => _googleSignIn.disconnect();

  // static Future<void> callYoutube() async {
  //   try {
  //     // print("HTTPCLIENT: $httpClient");
  //     var api = YouTubeApi(httpClient);
  //     Youtube.init(api);
  //   } catch (e) {
  //     // ignore: avoid_print
  //     print("YT Login Error:\n$e");
  //   }
  // }
}

// class Youtube {
//   static YouTubeApi? _youtubeClient;
//   get api => _youtubeClient;
//   // static var abc;

//   static init() {
//     _youtubeClient = YouTubeApi(GoogleAPI.httpClient);
//   }

//   static test() async {
//     DateTime today = DateTime.now();
//     DateTime nextweek = today.add(const Duration(days: 7));
//     print("start");

//     // try {
//     //   var favorites = await _youtubeClient?.playlistItems.list(
//     //     ['snippet'],
//     //     playlistId: 'LL',
//     //     // onBehalfOfContentOwner: "UCoIdOGfU0ouk0MsTPEzluYw" // Liked List
//     //   );

//     //   var _favvids = favorites?.items!.map((e) => e.snippet!).toList();

//     //   print(_favvids?[0].title);
//     // } catch (e) {
//     //   print(e);
//     // }

//     // print("start 2");

//     // try {
//     //   var favorites = await _youtubeClient?.channels.list(
//     //     ["snippet", "contentDetails"], managedByMe: true,
//     //     // onBehalfOfContentOwner: "UCoIdOGfU0ouk0MsTPEzluYw" // Liked List
//     //   );
//     // } catch (e) {
//     //   print(e);
//     // }

//     try {
//       var response = await _youtubeClient?.liveBroadcasts.insert(
//         LiveBroadcast(
//           snippet: LiveBroadcastSnippet(
//             scheduledStartTime: nextweek,
//             title: "Yoink",
//           ),
//           status: LiveBroadcastStatus(
//             privacyStatus: "private",
//             selfDeclaredMadeForKids: false,
//           ),
//           contentDetails: LiveBroadcastContentDetails(
//             enableAutoStart: false,
//             enableAutoStop: true,
//           ),
//         ),
//         ["snippet", "contentDetails", "status"],
//       );

//       print("end");
//       print(response);
//     } catch (e) {
//       print("Error Occured:\n$e");
//     }
//   }

//   // static test() async {
//   //   var youTubeApi = _youtubeClient;
//   //   var favorites = await youTubeApi!.playlistItems.list(
//   //     ['snippet'],
//   //     playlistId: 'LL', // Liked List
//   //   );

//   //   print(favorites);
//   // }
// }

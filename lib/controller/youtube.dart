import 'package:crckclivestreamhelper/auth/secrets.dart';
import 'package:flutter/services.dart';
import 'package:googleapis/youtube/v3.dart';
import 'streamdata.dart';
import 'login.dart';
import 'package:http/http.dart' as http;

// import '../provider/debug.dart';
// import 'dart:js' as js;

class Youtube {
  static YouTubeApi? _youtubeClient;
  get api => _youtubeClient;
  // static var abc;

  static init() {
    _youtubeClient = YouTubeApi(GoogleAPI.httpClient);
  }

  ///Output = [LivestreamControlURL, WhatsappMessage]
  static Future<List> scheduleStream() async {
    //Get Stream Time
    DateTime getStreamTime() {
      DateTime streamTime = DateTime.now();

      while (streamTime.weekday != DateTime.sunday) {
        streamTime = streamTime.add(const Duration(days: 1));
      }

      // streamTime = DateTime.parse(
      //     "${streamTime.year}-${streamTime.month}-${streamTime.day} 11:00:00");
      streamTime = DateTime(
          streamTime.year, streamTime.month, streamTime.day, 11, 0, 0, 0, 0);

      if (streamTime.isAfter(DateTime.now())) {
        return streamTime;
      } else {
        return DateTime.now().add(const Duration(minutes: 5));
      }
    }

    String dateTimetoTitleString(DateTime d) {
      String prefix0(int n) {
        if (n < 10) {
          return "0$n";
        }
        return "$n";
      }

      return "${d.year}年${prefix0(d.month)}月${prefix0(d.day)}日";
    }

    //Get Stream Title
    //Schedule Stream
    try {
      DateTime streamTime = getStreamTime();

      List<String> data = await CrckcHelperAPI.get();
      String streamTitle =
          "${dateTimetoTitleString(streamTime)} 講員：${data[0]} / 講題：${data[1]} / 經文：${data[2]}";

      var response = await _youtubeClient?.liveBroadcasts.insert(
        LiveBroadcast(
          snippet: LiveBroadcastSnippet(
            scheduledStartTime: streamTime,
            title: streamTitle,
          ),
          status: LiveBroadcastStatus(
            privacyStatus: "public",
            // privacyStatus: "private",
            selfDeclaredMadeForKids: false,
          ),
          contentDetails: LiveBroadcastContentDetails(
            enableAutoStart: false,
            enableAutoStop: true,
            monitorStream: MonitorStreamInfo(
              enableMonitorStream: true,
            ),
            enableDvr: true,
            enableEmbed: true,
          ),
        ),
        ["snippet", "contentDetails", "status"],
      );

      if (response == null) return [];

      String id = response.id ?? "";

      getThumbnailBytes() async {
        var response = await http.get(
          Uri.http('localhost:2339', "thumbnailgen"),
        );
        return response.bodyBytes;
      }

      getBitStream() async {
        try {
          return await getThumbnailBytes();
        } catch (e) {
          return (await rootBundle.load("assets/thumbnailTemplate.jpeg"))
              .buffer
              .asUint8List();
        }
      }

      var bitStream = List<int>.from(await getBitStream());

      _youtubeClient!.thumbnails.set(id,
          uploadMedia: Media(Stream.value(bitStream), bitStream.length));

      // print("end");
      // print(response?.toJson());
      String ytlink = "https://youtu.be/${response.id}";
      String liveStreamUrl =
          "https://studio.youtube.com/video/${response.id}/livestreaming";
      // js.context.callMethod('open', [liveStreamUrl, '_blank']);
      // _data["ytControlUrl"] = liveStreamUrl;
      String whatsappMessage = '''${dateTimetoTitleString(streamTime)} 禮中堂主日崇拜
講員：${data[0]}
講題：${data[1]}
經文：${data[2]}

$ytlink

(10:45am可以進入靜候11:00am崇拜開始)

「主日崇拜網上出席表」連結（請以個人單位填寫）：
${SECRETS.churchForm} ''';
      // _data["message"] = whatsappMessage;
      return [liveStreamUrl, whatsappMessage];
    } catch (e) {
      // ignore: avoid_print
      print("Error Occured:\n$e");
      return [];
    }
  }
}

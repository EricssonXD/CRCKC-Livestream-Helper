import 'package:crckclivestreamhelper/auth/secrets.dart';
import 'package:googleapis/youtube/v3.dart';
import 'streamdata.dart';
import 'login.dart';
import '../provider/debug.dart';
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

      streamTime = DateTime.parse(
          "${streamTime.year}-${streamTime.month}-${streamTime.day} 11:00:00");

      if (streamTime.isAfter(DateTime.now())) {
        return streamTime;
      } else {
        return DateTime.now().add(const Duration(minutes: 5));
      }
    }

    DateTime streamTime = getStreamTime();

    //Get Stream Title
    List<String> data = await CrckcHelperAPI.get();
    String streamTitle =
        "${streamTime.year}年${streamTime.month}月${streamTime.day}日 講員：${data[0]} / 講題：${data[1]} / 經文：${data[2]}";

    //Schedule Stream
    try {
      var response = await _youtubeClient?.liveBroadcasts.insert(
        LiveBroadcast(
          snippet: LiveBroadcastSnippet(
            scheduledStartTime: streamTime,
            title: streamTitle,
          ),
          status: LiveBroadcastStatus(
            privacyStatus: "private",
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

      // print("end");
      // print(response?.toJson());
      String ytlink = "https://youtu.be/${response?.id}";
      String liveStreamUrl =
          "https://studio.youtube.com/video/${response?.id}/livestreaming";
      // js.context.callMethod('open', [liveStreamUrl, '_blank']);
      // _data["ytControlUrl"] = liveStreamUrl;
      String whatsappMessage =
          '''${streamTime.year}年${streamTime.month}月${streamTime.day}日 禮中堂主日崇拜
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

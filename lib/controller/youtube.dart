import 'package:crckclivestreamhelper/auth/secrets.dart';
import 'package:flutter/services.dart';
import 'package:googleapis/youtube/v3.dart';
import 'streamdata.dart';
import 'login.dart';
// import 'package:http/http.dart' as http;
import 'package:crckclivestreamhelper/provider/options.dart';
import 'package:image/image.dart' as img;

// import '../provider/debug.dart';
// import 'dart:js' as js;

class Youtube {
  static YouTubeApi? _youtubeClient;
  get api => _youtubeClient;
  // static var abc;

  static init() {
    _youtubeClient = YouTubeApi(GoogleAPI.httpClient);
  }

  //Get Stream Time
  static DateTime _getStreamTime() {
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

  static String _prefix0(int n) {
    if (n < 10) {
      return "0$n";
    }
    return "$n";
  }

  ///Output = [LivestreamControlURL, WhatsappMessage]
  static Future<List> scheduleStream() async {
    String dateTimetoTitleString(DateTime d) {
      return "${d.year}年${_prefix0(d.month)}月${_prefix0(d.day)}日";
    }

    //Get Stream Title
    //Schedule Stream
    try {
      DateTime streamTime = _getStreamTime();

      CrckcStreamData data = await CrckcHelperAPI.getNewestData();
      String streamTitle =
          "${dateTimetoTitleString(streamTime)} 講員：${data.speaker} / 講題：${data.topic} / 經文：${data.verse}";
      bool autoStart = OptionSingleton().autoStart;

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
            enableAutoStart: autoStart,
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
      setThumbnail(id);

      // print("end");
      // print(response?.toJson());
      String ytlink = "https://youtu.be/${response.id}";
      String liveStreamUrl =
          "https://studio.youtube.com/video/${response.id}/livestreaming";
      // js.context.callMethod('open', [liveStreamUrl, '_blank']);
      // _data["ytControlUrl"] = liveStreamUrl;
      String whatsappMessage = '''${dateTimetoTitleString(streamTime)} 禮中堂主日崇拜
講員：${data.speaker}
講題：${data.topic}
經文：${data.verse}

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

  static Future<Uint8List> getThumbnail() async {
    final fontZipFile = await rootBundle.load('assets/fonts/CRCKCFont.zip');
    final font = img.BitmapFont.fromZip(fontZipFile.buffer.asUint8List());

    final image = img.decodeJpg(
        (await rootBundle.load('assets/thumbnailTemplate.jpeg'))
            .buffer
            .asUint8List())!;

    final streamTime = _getStreamTime();
    const xCord = 385;
    const yCord = 200;
    final text =
        "${streamTime.year}-${_prefix0(streamTime.month)}-${_prefix0(streamTime.day)}";

    img.drawString(
      image,
      text,
      font: font,
      x: xCord,
      y: yCord,
    );

    return img.encodeJpg(image);
  }

  static void setThumbnail(String videoId) async {
    var bitStream = List<int>.from(await getThumbnail());

    _youtubeClient!.thumbnails.set(videoId,
        uploadMedia: Media(Stream.value(bitStream), bitStream.length));
  }
}

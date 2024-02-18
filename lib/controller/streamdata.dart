import 'package:dio/dio.dart';

abstract class CrckcHelperAPI {
  static const _getPath = '/exec';

  static final _dio = Dio(
    BaseOptions(
      baseUrl:
          'https://script.google.com/macros/s/AKfycbzZ6KbU-tPYTxZQHMFFW3kSCxRvu0lGk_ysFbJ2r2FEHMdo-c9fACAUkD3cMdGuKqaUCQ',
    ),
  );

  static Future<CrckcStreamData> getNewestData() async {
    final response = await _dio.get(
      _getPath,
      queryParameters: {
        "action": "getNewest",
      },
    );

    return CrckcStreamData.fromJson(response.data["data"]);
  }

  static Future<dynamic> addData(CrckcStreamData data) async {
    final response = await _dio.get(
      _getPath,
      queryParameters: {
        "action": "addData",
        ...data.toJson(),
      },
    );

    return response.data;
  }
}

class CrckcStreamData {
  CrckcStreamData({
    required this.speaker,
    required this.topic,
    required this.verse,
    DateTime? updateTime,
  }) {
    this.updateTime = updateTime ?? DateTime.now();
  }

  final String speaker;
  final String topic;
  final String verse;
  late final DateTime updateTime;

  factory CrckcStreamData.fromJson(Map<String, dynamic> json) {
    return CrckcStreamData(
      speaker: json['speaker'].toString(),
      topic: json['topic'].toString(),
      verse: json['verse'].toString(),
      updateTime: DateTime.fromMillisecondsSinceEpoch(json['update_time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'speaker': speaker,
      'topic': topic,
      'verse': verse,
      'update_time': updateTime.millisecondsSinceEpoch,
    };
  }

  @override
  String toString() {
    return 'CrckcStreamData(speaker: $speaker, topic: $topic, verse: $verse, updateTime: $updateTime)';
  }
}

/// FeedbackForm is a data class which stores data fields of Feedback.
class StreamData {
  String speaker;
  String topic;
  String verse;

  StreamData(this.speaker, this.topic, this.verse);

  // factory StreamData.fromJson(dynamic json) {
  //   return StreamData(
  //       "${json['speaker']}", "${json['topic']}", "${json['verse']}");
  // }

  // // Method to make GET parameters.
  // Map toJson() => {
  //       'speaker': speaker,
  //       'topic': topic,
  //       'verse': verse,
  //     };
}

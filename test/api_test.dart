import 'package:crckclivestreamhelper/controller/streamdata.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("Test Time", () async {
    final date =
        DateTime.fromMillisecondsSinceEpoch(1708271718783, isUtc: false);
    debugPrint(date.toLocal().toString());
  });
  test("Get Data", () async {
    final result = await CrckcHelperAPI.getNewestData();
    debugPrint(result.toString());
  });
}

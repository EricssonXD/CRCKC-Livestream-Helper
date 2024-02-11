import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'dart:io';

void main() {
  test('Test Image Generation', () async {
    final fontZipFile = await File('assets/fonts/myFont.zip').readAsBytes();
    final font = img.BitmapFont.fromZip(fontZipFile);

    final image =
        img.decodeJpg(File('assets/thumbnailTemplate.jpeg').readAsBytesSync())!;

    img.drawString(image, '2024-02-20', font: font, x: 500, y: 100);
    await img.encodePngFile('testFont.png', image);
  });
}

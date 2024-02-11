import 'package:crckclivestreamhelper/controller/youtube.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'dart:io';

void main() {
  test('Test Image Generation', () async {
    final fontZipFile = await File('assets/fonts/CRCKCFont.zip').readAsBytes();
    final font = img.BitmapFont.fromZip(fontZipFile);

    final image =
        img.decodeJpg(File('assets/thumbnailTemplate.jpeg').readAsBytesSync())!;

    const xCord = 385;
    const yCord = 200;
    const text = '20-02-2024';

    img.drawString(
      image,
      text,
      font: font,
      x: xCord,
      y: yCord,
    );

    await img.encodePngFile('testFont.png', image);
  });
  test('Image Class Function', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final image = img.decodeJpg(await Youtube.getThumbnail())!;
    await img.encodePngFile('testFont.png', image);
  });
}

// def generateThumbnail():
//     def getThumbnailText():
//         d = date.today()
//         while d.weekday() != 6:
//             d += timedelta(1)
//         return str(d)
    
//     def serve_pil_image(pil_img):
//         img_io = BytesIO()
//         pil_img.save(img_io, 'JPEG', quality=70)
//         img_io.seek(0)
//         return send_file(img_io, mimetype='image/jpeg')

//     xy = (385, 200)
//     text = getThumbnailText()
//     fontsize = 110
//     font = "assets/ARIALBD.TTF"
//     shadowColor = (255, 255, 255)
//     shadowSize = 6
//     strokeColor = (0, 0, 0)

//     img = Image.open("assets/thumbnailTemplate.JPG")
//     img = img.resize((1280,720))

//     font = ImageFont.truetype(font, fontsize)

//     d = ImageDraw.Draw(img)
//     # Draw Outline
//     d.text((xy[0],xy[1]), text, fill=shadowColor, font=font, stroke_width=shadowSize)
//     # Draw Text
//     d.text((xy[0],xy[1]), text, fill=strokeColor, font=font)
//     return serve_pil_image(img) 
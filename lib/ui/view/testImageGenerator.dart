import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test2/ui/actions/controller.dart';

import '../../core/static.dart';
import '../components/images/ImageLoaderClass.dart';

class ImageGenerator extends StatefulWidget {
  // const Game({this.child = const Text('GG124689'), super.key});
  // Widget child;
  const ImageGenerator({super.key});

  @override
  State<ImageGenerator> createState() => _ImageGeneratorState();
}

class _ImageGeneratorState extends State<ImageGenerator> {
  ByteData? imgBytes;
  late Uint8List imgBytes2;
  Uint8List? imageData;
  late ui.Image baseImg;
  ui.Image? outputImg2;
  double canvasSize = 200.0;

  late Uint8List bmp;
  late BMP332Header header;
  Random r = Random();

  @override
  void initState() {
    super.initState();

    loadAsset(); // test Uint8List data

    header = BMP332Header(100, 100);
    bmp = header.appendBitmap(
        Uint8List.fromList(List<int>.generate(10000, (i) => r.nextInt(255))));

    ImageLoaderClass.loader
        .loadImageByProvider(const AssetImage("images/Q_SPAWN.jpg"))
        .then((img) {
      print('ttttt. ImageLoaderClass is loadd >>>>> $img');
      baseImg = img;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12.0),
            child: ElevatedButton(
              child: Text('Generate image'),
              onPressed: (() async {
                print('click Generate');

                // web 不支援
                /**
                testGetImg().then((value) {
                  print("testGetImg $value");
                });
                */

                ui.PictureRecorder recorder = ui.PictureRecorder();
                Canvas canvas = Canvas(
                    recorder,
                    Rect.fromPoints(
                        Offset(0.0, 0.0), Offset(canvasSize, canvasSize)));
                Paint paint = Paint()..color = Colors.red;
                canvas.drawRect(
                    Rect.fromLTWH(0.0, 0.0, canvasSize, canvasSize), paint);
                Path _path = Path()
                  ..moveTo(100, 50)
                  ..lineTo(50, 150)
                  ..lineTo(150, 150)
                  ..lineTo(100, 50);
                canvas.clipPath(_path);

                // Rect _bound = _path.getBounds();
                // canvas draw image web 可能不支援
                canvas.drawImageRect(
                    baseImg,
                    Rect.fromLTRB(0, 0, baseImg.width.toDouble(),
                        baseImg.height.toDouble()),
                    Rect.fromLTWH(0, 0, 200, 200),
                    paint);

                canvas.drawRect(Rect.fromLTWH(0.0, 0.0, canvasSize, canvasSize),
                    Paint()..color = Colors.yellow);
                print('ttttt.baseImg >>> $baseImg');

                // // 停止录制 生成image
                ui.Picture pic = recorder.endRecording();
                ui.Image img2 =
                    await pic.toImage(canvasSize.toInt(), canvasSize.toInt());
                ByteData? pngBytes =
                    await img2.toByteData(format: ui.ImageByteFormat.png);

                var show = pngBytes;
                print('ttttt.pngBytes show >>> $show');
                imageData = pngBytes!.buffer.asUint8List();
                // imgBytes = pngBytes.buffer.asUint8List();
                // outputImg2 = img2;
                setState(() {});
              }),
            ),
          ),

          // Load asset image to Uint8List
          imageData != null
              ? Container(
                  child: Image.memory(
                    // Uint8List.view(imgBytes2!.buffer),
                    imageData!,
                    width: canvasSize,
                    height: canvasSize,
                  ),
                  // child: CustomPaint(
                  //   painter: ShowImageClass(outputImg2),
                  // ),
                )
              : Container(),
          // Get url data to test bmp ...
          bmp != null
              ? Container(
                  child: Image.memory(
                    bmp!,
                    width: canvasSize,
                    height: canvasSize,
                  ),
                )
              : Container(),
          Padding(
            padding: EdgeInsets.all(12.0),
            child: ElevatedButton(
              child: Text('Back home.'),
              onPressed: (() {
                //print('click Generate');
                Pressed.goPath(context, R.home);
              }),
            ),
          ),
        ],
      ),
    );
  }

  void loadAsset() async {
    Uint8List data =
        (await rootBundle.load('images/Q_SPAWN.jpg')).buffer.asUint8List();
    setState(() => this.imageData = data);
  }

  // Future<Uint8List?> testGetImg() async {
  //   Uint8List data = (await NetworkAssetBundle(
  //               Uri.parse('https://luckly007.oss-cn-beijing.aliyuncs.com'))
  //           .load("/image/image-20211124085239175.png"))
  //       .buffer
  //       .asUint8List();
  //   return data;
  // }
}

class ShowImageClass extends CustomPainter {
  ui.Image? myImg;
  ShowImageClass(this.myImg);

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    // TODO: implement paint
    print('ttttt.test run ShowImageClass. $myImg');
    if (myImg == null) return;
    canvas.drawCircle(Offset(10, 10), 50, Paint());
    canvas.drawImageRect(
        myImg!,
        Rect.fromLTRB(0, 0, myImg!.width.toDouble(), myImg!.height.toDouble()),
        Rect.fromLTWH(0, 0, 200, 200),
        Paint());
    // canvas.drawRect(
    //     Rect.fromLTWH(0.0, 0.0, canvasSize, canvasSize), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }
}

class BMP332Header {
  int _width; // NOTE: width must be multiple of 4 as no account is made for bitmap padding
  int _height;

  late Uint8List _bmp;
  late int _totalHeaderSize;

  BMP332Header(this._width, this._height) : assert(_width & 3 == 0) {
    int baseHeaderSize = 54;
    _totalHeaderSize = baseHeaderSize + 1024; // base + color map
    int fileLength = _totalHeaderSize + _width * _height; // header + bitmap
    _bmp = new Uint8List(fileLength);
    ByteData bd = _bmp.buffer.asByteData();
    bd.setUint8(0, 0x42);
    bd.setUint8(1, 0x4d);
    bd.setUint32(2, fileLength, Endian.little); // file length
    bd.setUint32(10, _totalHeaderSize, Endian.little); // start of the bitmap
    bd.setUint32(14, 40, Endian.little); // info header size
    bd.setUint32(18, _width, Endian.little);
    bd.setUint32(22, _height, Endian.little);
    bd.setUint16(26, 1, Endian.little); // planes
    bd.setUint32(28, 8, Endian.little); // bpp
    bd.setUint32(30, 0, Endian.little); // compression
    bd.setUint32(34, _width * _height, Endian.little); // bitmap size
    // leave everything else as zero

    // there are 256 possible variations of pixel
    // build the indexed color map that maps from packed byte to RGBA32
    // better still, create a lookup table see: http://unwind.se/bgr233/
    for (int rgb = 0; rgb < 256; rgb++) {
      int offset = baseHeaderSize + rgb * 4;

      int red = rgb & 0xe0;
      int green = rgb << 3 & 0xe0;
      int blue = rgb & 6 & 0xc0;

      bd.setUint8(offset + 3, 255); // A
      bd.setUint8(offset + 2, red); // R
      bd.setUint8(offset + 1, green); // G
      bd.setUint8(offset, blue); // B
    }
  }

  /// Insert the provided bitmap after the header and return the whole BMP
  Uint8List appendBitmap(Uint8List bitmap) {
    int size = _width * _height;
    assert(bitmap.length == size);
    _bmp.setRange(_totalHeaderSize, _totalHeaderSize + size, bitmap);
    return _bmp;
  }
}

//--- old test --------------------------------------------------------------------
class CustomAppBar extends SliverPersistentHeaderDelegate {
  final double height;
  const CustomAppBar({required this.height});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // TODO: implement build

    return new Container(
        color: Colors.transparent,
        child: Stack(
          fit: StackFit.loose,
          children: <Widget>[
            Container(
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width,
              height: height,
              child: CustomPaint(
                painter: CustomToolbarShape(lineColor: Colors.deepOrange),
              ),
            ),
          ],
        ));
  }

  @override
  // TODO: implement maxExtent
  // double get maxExtent => throw UnimplementedError();
  double get maxExtent => height;

  @override
  // TODO: implement minExtent
  // double get minExtent => throw UnimplementedError();
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    // throw UnimplementedError();
    return false;
  }
}

class CustomToolbarShape extends CustomPainter {
  final Color lineColor;
  const CustomToolbarShape({required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    Paint paint = Paint();

    //First oval
    Path path = Path();
    Rect pathGradientRect = new Rect.fromCircle(
      center: new Offset(size.width / 4, 0),
      radius: size.width / 1.4,
    );

    Gradient gradient = new LinearGradient(
      colors: <Color>[
        Color.fromRGBO(225, 89, 89, 1).withOpacity(1),
        Color.fromRGBO(255, 128, 16, 1).withOpacity(1),
      ],
      stops: [
        0.3,
        1.0,
      ],
    );

    path.lineTo(-size.width / 1.4, 0);
    path.quadraticBezierTo(
        size.width / 2, size.height * 2, size.width + size.width / 1.4, 0);

    paint.color = Colors.deepOrange;
    paint.shader = gradient.createShader(pathGradientRect);
    paint.strokeWidth = 40;
    path.close();

    canvas.drawPath(path, paint);

    //Second oval
    Rect secondOvalRect = new Rect.fromPoints(
      Offset(-size.width / 2.5, -size.height),
      Offset(size.width * 1.4, size.height / 1.5),
    );

    gradient = new LinearGradient(
      colors: <Color>[
        Color.fromRGBO(225, 255, 255, 1).withOpacity(0.1),
        Color.fromRGBO(255, 206, 31, 1).withOpacity(0.2),
      ],
      stops: [
        0.0,
        1.0,
      ],
    );
    Paint secondOvalPaint = Paint()
      ..color = Colors.deepOrange
      ..shader = gradient.createShader(secondOvalRect);

    canvas.drawOval(secondOvalRect, secondOvalPaint);

    //Third oval
    Rect thirdOvalRect = new Rect.fromPoints(
      Offset(-size.width / 2.5, -size.height),
      Offset(size.width * 1.4, size.height / 2.7),
    );

    gradient = new LinearGradient(
      colors: <Color>[
        Color.fromRGBO(225, 255, 255, 1).withOpacity(0.05),
        Color.fromRGBO(255, 196, 21, 1).withOpacity(0.2),
      ],
      stops: [
        0.0,
        1.0,
      ],
    );
    Paint thirdOvalPaint = Paint()
      ..color = Colors.deepOrange
      ..shader = gradient.createShader(thirdOvalRect);

    canvas.drawOval(thirdOvalRect, thirdOvalPaint);

    //Fourth oval
    Rect fourthOvalRect = new Rect.fromPoints(
      Offset(-size.width / 2.4, -size.width / 1.875),
      Offset(size.width / 1.34, size.height / 1.14),
    );

    gradient = new LinearGradient(
      colors: <Color>[
        Colors.red.withOpacity(0.9),
        Color.fromRGBO(255, 128, 16, 1).withOpacity(0.3),
      ],
      stops: [
        0.3,
        1.0,
      ],
    );
    Paint fourthOvalPaint = Paint()
      ..color = Colors.deepOrange
      ..shader = gradient.createShader(fourthOvalRect);
    canvas.drawOval(fourthOvalRect, fourthOvalPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    // throw UnimplementedError();
    return false;
  }
}

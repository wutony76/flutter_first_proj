import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as image;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test2/core/manager.dart';
import 'dart:developer' as dev;
import 'dart:ui' as ui;

import '../components/baseScaffold.dart';
import '../components/images/ImageLoaderClass.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({super.key});

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  ui.Image? myImg;
  // @override
  // initState() {
  //   loadImageByFile("images/Q_SPAWN.jpg").then((img) {
  //     // => myImg = val
  //     print('ttttt tony loadImageByFile>>> $img');
  //     myImg = img;
  //   }).whenComplete(() {
  //     print('ttttt tony myImg1>>> $myImg');
  //     setState(() {});
  //   });

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    Manager.getInst()?.setContext(context);
    print('ttttt >>> into my images views.');

    //从资源部获取Image
    // var futureAsset = ImageLoader.loader
    //     .loadImageByProvider(AssetImage("images/wy_300x200.jpg"));
    // //从网络获取Image
    // var imageUrl =
    //     'https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-user-assets/2018/7/9/1647cc06a3e9e9c4~tplv-t2oaga2asx-image.image'
    //     '/1/w/180/h/180/q/85/format/webp/interlace/1';
    // var futureNet =
    //     ImageLoader.loader.loadImageByProvider(NetworkImage(imageUrl));
    // //从文件获取Image
    // var path = "/data/data/com.toly1994.flutter_image/cache/wy_300x200.jpg";
    // var futureFile =
    //     ImageLoader.loader.loadImageByProvider(FileImage(File(path)));

    return BaseScaffold(context).defaultScaffold(
        "",
        Scaffold(
          appBar: BaseScaffold(context).defalutBar("Test UI-Image"),
          body: Container(
            //     child: CustomPaint(
            //   painter: ImagePainter(myImg),
            // )
            child: FutureBuilder<ui.Image>(
              // future: loadImageByFile("images/Q_SPAWN.jpg"), // get img method01
              future: ImageLoaderClass.loader.loadImageByProvider(
                  const AssetImage("images/Q_SPAWN.jpg")), // get img method02
              builder: (context, snapshot) {
                var show = snapshot;
                print('[Image] -FutureBuilder snapshot status >>> $show');
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Waiting...");
                }
                return CustomPaint(
                  painter: ImagePainter(snapshot.data),
                );
              },
            ),

            // child: CustomPaint(
            //   painter: ImagePainter(),
            // ),
          ),
        ));
  }
}

// test load img method1.
Future<ui.Image> loadImageByFile(String path) async {
  final ByteData assetImageByteData = await rootBundle.load(path);
  ui.Codec codec =
      await ui.instantiateImageCodec(assetImageByteData.buffer.asUint8List());
  ui.FrameInfo frame = await codec.getNextFrame();
  var testShow = frame.image.toString();
  return frame.image;
}

// test load img method2.
Future<ui.Image> loadImageByFile2(String path) async {
  ImageStream stream;
  stream = AssetImage(path).resolve(ImageConfiguration.empty);
  Completer<ui.Image> completer = Completer<ui.Image>();
  listener(ImageInfo frame, bool synchronousCall) {
    final ui.Image image = frame.image;
    completer.complete(image);
    stream.removeListener(ImageStreamListener(listener));
  }

  stream.addListener(ImageStreamListener(listener));
  return completer.future;
}

class ImagePainter extends CustomPainter {
  late Paint mainPaint;
  ui.Image? myImg;
  ImagePainter(this.myImg) {
    mainPaint = Paint();

    // mainPaint = Paint();
    // mainPaint.color = Colors.red;
    // mainPaint = Paint()..color = Colors.yellow;
    print('ttttt ImagePainter myImg>>>  $myImg');
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(100, 100), 50, mainPaint);
    if (myImg == null) return;
    canvas.drawImage(myImg!, Offset(0, 0), mainPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}

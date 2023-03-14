import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:test2/core/static.dart';

class ImageLoaderClass {
  ImageLoaderClass._(); //私有化构造
  static final ImageLoaderClass loader = ImageLoaderClass._(); //单例模式

  //通过 文件读取Image
  Future<ui.Image> loadImageByFile(
    String path, {
    required int width,
    required int height,
  }) async {
    var list = await File(path).readAsBytes();
    return loadImageByUint8List(list, width: width, height: height);
  }

//通过[Uint8List]获取图片,默认宽高[width][height]
  Future<ui.Image> loadImageByUint8List(
    Uint8List list, {
    required int width,
    required int height,
  }) async {
    ui.Codec codec = await ui.instantiateImageCodec(list,
        targetWidth: width, targetHeight: height);
    ui.FrameInfo frame = await codec.getNextFrame();
    return frame.image;
  }

  //通过ImageProvider读取Image
  Future<ui.Image> loadImageByProvider(
    ImageProvider provider, {
    ImageConfiguration config = ImageConfiguration.empty,
  }) async {
    Completer<ui.Image> completer = Completer<ui.Image>();
    if (GameInfo.baseIMG == null) {
      //完成的回调
      // ImageStreamListener listener;
      ImageStream stream = provider.resolve(config); //获取图片流
      listener(ImageInfo frame, bool synchronousCall) {
        final ui.Image image = frame.image;
        completer.complete(image);
        stream.removeListener(ImageStreamListener(listener));
      }

      stream.addListener(ImageStreamListener(listener));
    } else {
      completer.complete(GameInfo.baseIMG);
    }
    return completer.future;
  }

  Future<Uint8List> loadImageByProviderToUint8List(
    ImageProvider provider, {
    ImageConfiguration config = ImageConfiguration.empty,
  }) async {
    Completer<Uint8List> completer = Completer<Uint8List>();
    ImageStream stream = provider.resolve(config); //获取图片流
    listener(ImageInfo frame, bool synchronousCall) async {
      final ui.Image image = frame.image;
      var data = await image.toByteData();
      Uint8List bytes = data!.buffer.asUint8List();
      print('test.get.loadImageByProviderToByteData >>> $data');
      completer.complete(bytes);
      stream.removeListener(ImageStreamListener(listener));
    }

    stream.addListener(ImageStreamListener(listener));
    return completer.future;
  }

  ///缩放加载[provider],缩放比例[scale]
  Future<ui.Image> scaleLoad(ImageProvider provider, double scale) async {
    var img = await loadImageByProvider(provider);
    return _resize(
        img, (img.width * scale).toInt(), (img.height * scale).toInt());
  }

  ///缩放加载[provider],缩放比例[scale]
  Future<ui.Image> resizeLoad(
      ImageProvider provider, int dstWidth, int dstHeight) async {
    var img = await loadImageByProvider(provider);
    return _resize(img, dstWidth, dstHeight);
  }

  Future<ui.Image> _resize(ui.Image image, int dstWidth, int dstHeight) {
    var recorder = ui.PictureRecorder(); //使用PictureRecorder对图片进行录制
    Paint paint = Paint();
    Canvas canvas = Canvas(recorder);
    double srcWidth = image.width.toDouble();
    double srcHeight = image.height.toDouble();
    canvas.drawImageRect(
        image, //使用drawImageRect对图片进行定尺寸填充
        Rect.fromLTWH(0, 0, srcWidth, srcHeight),
        Rect.fromLTWH(0, 0, dstWidth.toDouble(), dstHeight.toDouble()),
        paint);
    return recorder.endRecording().toImage(dstWidth, dstHeight); //返回图片
  }

  // image uint8 2 img 互轉
  //Future<ui.Image> uint8List2Image

  // image to uint8list -
  Future<ByteData?> image2ByteData(ui.Image image) async {
    return await image.toByteData();
  }

  Future<Uint8List?> image2Uint8List(ui.Image image) async {
    print('ttt.image2Uint8List image >>> $image');
    ByteData? byteData = await image!.toByteData(); // web 不能用
    print('ttt.image2Uint8List byteData >>> $byteData');
    if (byteData != null) {
      Uint8List bytes = byteData.buffer.asUint8List();
      return bytes;
    }
    return null;
  }
}

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';

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
    Completer<ui.Image> completer = Completer<ui.Image>(); //完成的回调
    // ImageStreamListener listener;
    ImageStream stream = provider.resolve(config); //获取图片流
    listener(ImageInfo frame, bool synchronousCall) {
      final ui.Image image = frame.image;
      completer.complete(image);
      stream.removeListener(ImageStreamListener(listener));
    }

    stream.addListener(ImageStreamListener(listener));

    // ImageStreamListener listener =
    //     ImageStreamListener((ImageInfo frame, bool sync) {
    //   //监听
    //   final ui.Image image = frame.image;
    //   completer.complete(image); //完成
    //   stream.removeListener(listener); //移除监听
    // });
    // stream.addListener(listener); //添加监听
    return completer.future; //返回
  }
}

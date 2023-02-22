import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'dart:developer' as dev;

class ImageZoomClass extends CustomPainter {
  ui.Image? myImg;
  Offset center;

  late Paint mainPaint;
  late Path circlePath;
  double _radius = 60;
  double rate = 1.3;
  bool isZoom = false;

  ImageZoomClass(this.myImg, this.center, this.isZoom) {
    mainPaint = Paint();
    print('ttttt.draw ImageZoomClass center >>>  $center');
    circlePath = Path();
  }

  @override
  void paint(Canvas canvas, Size size) {
    // if (myImg == null) return;
    if (myImg != null) {
      canvas.drawImage(myImg!, Offset(0, 0), mainPaint);

      if (isZoom) {
        //遮罩
        Rect rect = Offset.zero & size;
        canvas.clipRect(rect);
        circlePath.addOval(Rect.fromCircle(center: center, radius: _radius));
        canvas.clipPath(circlePath);

        // 放大鏡
        canvas.drawImageRect(
            myImg!,
            Rect.fromLTRB(
              center.dx - _radius, // start x
              center.dy - _radius, // start y
              center.dx + _radius, // end x
              center.dy + _radius, // end y
            ),
            Rect.fromLTWH(
                center.dx - _radius * rate, // start draw x
                center.dy - _radius * rate, // start draw y
                _radius * rate * 2,
                _radius * rate * 2),
            mainPaint);
      }

      // 縮小鏡
      /**
      canvas.drawImageRect(
          myImg!,
          Rect.fromLTRB(
            center.dx - _radius, // start x
            center.dy - _radius, // start y
            center.dx + _radius, // end x
            center.dy + _radius, // end y
          ),
          Rect.fromLTWH(
              center.dx - 40, // start draw x
              center.dy - 40, // start draw y
              80,
              80),
          mainPaint);
        */

      // 測試遮罩
      /**
      Path _path = Path()
        ..moveTo(100, 50)
        ..lineTo(50, 150)
        ..lineTo(150, 150)
        ..lineTo(100, 50);
      canvas.clipPath(_path);
      canvas.drawImageRect(
          myImg!,
          Rect.fromLTWH(
              0, 0, myImg!.width.toDouble(), myImg!.height.toDouble()),
          Rect.fromLTWH(0, 0, 200, 200),
          Paint());
           */
    }
    canvas.drawCircle(
        center, // center
        _radius,
        Paint()
          ..color = Colors.red
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    // throw UnimplementedError();
    return this != oldDelegate;
    // return false;
  }
}

import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'dart:developer' as dev;

class ImagePainterClass extends CustomPainter {
  double percentage;
  Offset center;
  List<Offset> points;
  Color color;
  late Paint mainPaint;

  ImagePainterClass(this.percentage, this.center, this.points, this.color) {
    // print('ttttt ImagePainterClass >>> $percentage');
    mainPaint = Paint();
    mainPaint.color = color ?? Colors.red;
    mainPaint.strokeWidth = 3;
    mainPaint.style = PaintingStyle.stroke;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var show = (percentage ~/ 360).isOdd; // isOdd 奇数，则此属性返回布尔值true
    // print('ttttt ImagePainterClass >>> $percentage');
    // print('ttttt ImagePainterClass paint >>> $show');
    canvas.drawCircle(
        const Offset(100, 100), 20, Paint()..color = Colors.yellow);

    // 畫動畫
    bool useCenter = false;
    if ((percentage ~/ 360).isOdd) {
      mainPaint.style = PaintingStyle.fill;
      useCenter = true;
    } else {
      mainPaint.style = PaintingStyle.stroke;
      useCenter = false;
    }

    Rect rect = Rect.fromCircle(
      center: center ?? Offset(100, 250),
      radius: 40,
    );
    canvas.drawArc(
        rect, // 中心
        0,
        2 * pi * (percentage % 360 / 360), // 畫弧度
        true, // useCenter 中心相連
        mainPaint);

    // 畫圖
    // for (int i = 0; i < points.length - 1; i++) {
    //   if (points[i] != null && points[i + 1] != null) {
    //     canvas.drawLine(points[i], points[i + 1], mainPaint);
    //   }
    // }
    canvas.drawPoints(ui.PointMode.points, points, mainPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    // throw UnimplementedError();
    return this != oldDelegate;
  }
}

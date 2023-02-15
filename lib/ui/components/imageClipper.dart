import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class ImageClipper extends CustomPainter {
  //final ui.Image image;
  final ui.Image image;
  ImageClipper(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    Paint paint = Paint();
    canvas.drawImageRect(
        image,
        Rect.fromLTRB(image.width * 0.1, image.height * 0.1, image.width * 0.1,
            image.height * 0.1),
        Rect.fromLTWH(0, 0, size.width, size.height),
        paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    // throw UnimplementedError();
    return false;
  }
}

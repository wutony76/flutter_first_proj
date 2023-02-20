import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'dart:developer' as dev;

class ImageGameClass extends CustomPainter {
  late Paint mainPaint;
  ui.Image? myImg;
  List sliceArr = [];
  ImageGameClass(this.myImg, this.sliceArr) {
    mainPaint = Paint();
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (myImg == null) return;
    ui.Image oriImg = myImg!;
    double sx = 0;
    double sy = 0;
    double w = oriImg.width / 3;
    double h = oriImg.height / 3;
    int index = 0;

    TextPainter textPainter;

    // 畫圖
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        int spaceIndex = sliceArr[index]["index"];
        // print('tttttttttt spaceIndex >>> $spaceIndex  ');
        if (spaceIndex == sliceArr.length - 1) print('>>> no print.');
        if (spaceIndex != sliceArr.length - 1) {
          canvas.drawImageRect(
              myImg!,
              // Rect.fromLTRB(myImg!.width * 0.2, myImg!.height * 0.2,
              //     myImg!.width * 0.3, myImg!.height * 0.1),
              Rect.fromLTRB(
                sliceArr[index]["startx"], // start x
                sliceArr[index]["starty"],
                sliceArr[index]["endx"],
                sliceArr[index]["endy"],
              ), // end y
              Rect.fromLTWH(
                  // sliceArr[index]["startx"], // start x
                  // sliceArr[index]["starty"],
                  sx + i.toDouble() * w, // start draw x
                  sy + j.toDouble() * h, // start draw y
                  w,
                  h),
              mainPaint);
        }

        // print to img 索引
        /***
        textPainter = TextPainter(
          text: TextSpan(
            text: spaceIndex.toString(),
            style: TextStyle(
              color: Colors.red,
              fontSize: 30,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout(
          minWidth: 0,
          maxWidth: size.width,
        );
        Offset offset =
            Offset(sx + i.toDouble() * w + 50, sy + j.toDouble() * h + 50);
        textPainter.paint(canvas, offset);
         */
        index++;
      }
    }

    // canvas.drawImage(myImg!, Offset(100, 100), mainPaint);
    // canvas.drawImage(myImg!, Offset(200, 300), mainPaint);

    // for (int i = 0; i < 10; i++) {
    //   canvas.drawImage(
    //       myImg!,
    //       Offset(sx + i.toDouble() * 50, 0
    //           // Random().nextInt(500).toDouble(),
    //           // Random().nextInt(500).toDouble(),
    //           ),
    //       mainPaint);
    //   //   canvas.drawCircle(
    //   //       Offset(Random().nextInt(500).toDouble(),
    //   //           Random().nextInt(500).toDouble()),
    //   //       10,
    //   //       Paint()..color = Colors.red);
    // }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    // throw UnimplementedError();
    return false;
    // return false;
  }
}

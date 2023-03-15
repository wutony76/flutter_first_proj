import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/material.dart';
import 'package:test2/core/manager.dart';
import 'dart:developer' as dev;
import 'dart:ui' as ui;
import 'package:image/image.dart' as IMG;

import 'package:test2/ui/actions/controller.dart';
import 'package:test2/ui/view/testApp.dart';
import 'package:test2/ui/view/testUiImage.dart';

import '../../core/static.dart';
import '../components/baseScaffold.dart';
import '../components/imageClipper.dart';
import '../components/images/ImageGameClass.dart';
import '../components/images/ImageLoaderClass.dart';
import '../components/images/ImagePainterClass.dart';
import '../components/images/ImageZoomClass.dart';

class Zoom extends StatefulWidget {
  // const Game({this.child = const Text('GG124689'), super.key});
  // Widget child;
  const Zoom({super.key});

  @override
  State<Zoom> createState() => _ZoomState();
}

class _ZoomState extends State<Zoom> with SingleTickerProviderStateMixin {
  BuildContext? mainContext;
  late AnimationController _controller;
  late Animation<Alignment> _animation;
  Alignment _dragAlignment = Alignment.center;

  List sliceArr = []; // 圖片巢
  // ImageClipper clipper = ImageClipper(Image.asset("images/Q_SPAWN.jpg"));
  late ui.Image baseImage;
  String gameMsg = '';

  bool isMove = false;
  bool isZoom = false;
  Offset zoomCenter = Offset(100, 100); // zoom center
  double zoomRadius = 50; // zoom radius

  void _runAnimation(Offset pixelsPerSecond, Size size) {
    _animation = _controller.drive(
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment.center,
      ),
    );
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);
    _controller.animateWith(simulation);
    var show = _controller.isCompleted;
    print('tttt test $show');
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _controller.addListener(() {
      setState(() {
        _dragAlignment = _animation.value;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 49, 49, 49),
      child: FutureBuilder<ui.Image>(
          future: ImageLoaderClass.loader
              .loadImageByProvider(const AssetImage("images/Q_SPAWN.jpg")),
          builder: (context, snapshot) {
            return GestureDetector(
              onPanDown: (e) {
                print('ttttt.ZOOM.onPanDown');
                Offset startPoint = e.localPosition;
                double distance = sqrt(pow(startPoint.dx - zoomCenter.dx, 2) +
                    pow(startPoint.dy - zoomCenter.dy, 2));

                if (distance <= zoomRadius) {
                  isMove = true;
                  isZoom = true;
                }
                setState(() {});
              },
              onPanUpdate: (e) {
                print('ttttt.ZOOM.onPanUpdate');
                if (isMove) {
                  zoomCenter = e.localPosition;
                  setState(() {});
                }
              },
              onPanEnd: (e) {
                print('ttttt.ZOOM.onPanEnd');
                isMove = false;
                isZoom = false;
                setState(() {});
              },
              child: CustomPaint(
                painter: ImageZoomClass(
                  snapshot.data,
                  zoomCenter,
                  isZoom,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      child: Text('Back'),
                      onPressed: () {
                        Pressed.goPath(context, R.home);
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return FutureBuilder<ui.Image>(
  //       future: ImageLoaderClass.loader
  //           .loadImageByProvider(const AssetImage("images/Q_SPAWN.jpg")),
  //       builder: (context, snapshot) {
  //         return GestureDetector(
  //           onPanDown: (e) {
  //             print('ttttt.ZOOM.onPanDown');
  //             Offset startPoint = e.localPosition;
  //             double distance = sqrt(pow(startPoint.dx - zoomCenter.dx, 2) +
  //                 pow(startPoint.dy - zoomCenter.dy, 2));

  //             if (distance <= zoomRadius) {
  //               isMove = true;
  //               isZoom = true;
  //             }
  //             setState(() {});
  //           },
  //           onPanUpdate: (e) {
  //             print('ttttt.ZOOM.onPanUpdate');
  //             if (isMove) {
  //               zoomCenter = e.localPosition;
  //               setState(() {});
  //             }
  //           },
  //           onPanEnd: (e) {
  //             print('ttttt.ZOOM.onPanEnd');
  //             isMove = false;
  //             isZoom = false;
  //             setState(() {});
  //           },
  //           child: CustomPaint(
  //             painter: ImageZoomClass(
  //               snapshot.data,
  //               zoomCenter,
  //               isZoom,
  //             ),
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.end,
  //               children: [
  //                 ElevatedButton(
  //                   child: Text('Back'),
  //                   onPressed: () {
  //                     Pressed.goPath(context, R.home);
  //                   },
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }
}

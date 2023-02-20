import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:image/image.dart' as image;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test2/core/manager.dart';
import 'dart:developer' as dev;
import 'dart:ui' as ui;

import '../components/baseScaffold.dart';
import '../components/images/ImageLoaderClass.dart';
import '../components/images/ImagePainterClass.dart';

class PainterPage extends StatefulWidget {
  const PainterPage({super.key});

  @override
  State<PainterPage> createState() => _PainterState();
}

class _PainterState extends State<PainterPage>
    with SingleTickerProviderStateMixin {
  ui.Image? myImg;
  late AnimationController _controller;
  double _percentage = 0.0;
  Offset _center = Offset(100, 250); // 預設中心點
  bool _inner = false;
  List<Offset> _points = [];
  Color _color = Colors.red;

  @override
  void initState() {
    // TODO: implement initState
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _controller.addListener(() {
      setState(() {
        _percentage = _percentage + 1;
      });
    });

    _controller.repeat();
    // _controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Manager.getInst()?.setContext(context);

    return BaseScaffold(context).defaultScaffold(
        "",
        Scaffold(
          appBar: BaseScaffold(context).defalutBar("Test painter"),
          body: Container(
              child: GestureDetector(
            onPanDown: (details) {
              Offset loc =
                  Offset(details.localPosition.dx, details.localPosition.dy);
              // Offset center = Offset(100, 250);
              Offset center = _center;
              double distance = sqrt(
                  pow((loc.dx - center.dx), 2) + pow((loc.dy - center.dy), 2));
              if (distance <= 40) {
                _inner = true;
              }
              print('......>> onPanDown  -$_inner $details');
            },
            onPanUpdate: (details) {
              print('......>> onPanUpdate');
              Offset loc =
                  Offset(details.localPosition.dx, details.localPosition.dy);
              if (_inner ?? false) {
                _center = loc;
              } else {
                _points = List.from(_points)..add(loc);
              }
              setState(() {});
            },
            onPanEnd: (details) {
              _inner = false;
              print('......>> onPanEnd -$_inner');
            },
            child: CustomPaint(
              painter: ImagePainterClass(_percentage, _center, _points, _color),
              child: Column(
                children: [
                  Center(
                    child: Text('You can will start test and draw'),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        child: Text(''),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          minimumSize: Size(30, 40),
                        ),
                        onPressed: () {
                          _color = Colors.red;
                        },
                      ),
                      ElevatedButton(
                        child: Text(''),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          minimumSize: Size(30, 40),
                        ),
                        onPressed: () {
                          _color = Colors.blue;
                        },
                      ),
                      ElevatedButton(
                        child: Text(''),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.yellow,
                          minimumSize: Size(30, 40),
                        ),
                        onPressed: () {
                          _color = Colors.yellow;
                        },
                      ),
                      OutlinedButton(
                        child: Text(
                          'Clear',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(30, 40),
                        ),
                        onPressed: () {
                          _points = [];
                        },
                      ),
                    ],
                  )
                ],
              ),
              // foregroundPainter: ImagePainterClass(_percentage),
            ),
          )),
        ));
  }
}

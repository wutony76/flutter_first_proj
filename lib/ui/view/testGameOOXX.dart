import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;
import 'dart:ui' as ui;

import 'package:test2/ui/actions/controller.dart';

import '../../core/static.dart';
import '../../logic/OOXX/game.dart';

class GameOOXXView extends StatefulWidget {
  const GameOOXXView({super.key});
  @override
  State<GameOOXXView> createState() => _GameOOXXState();
}

class _GameOOXXState extends State<GameOOXXView> {
  Uint8List? viewData;
  double gameSize = 200;
  Offset? clickPoint;
  GameOOXX? game;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12.0),
            child: ElevatedButton(
              child: Text('START GAME!'),
              onPressed: (() async {
                print('click btn');
                game = GameOOXX(this);
                Paint player1 = Paint()..color = Colors.red;
                Paint player2 = Paint()..color = Colors.blue;

                ui.PictureRecorder recorder = ui.PictureRecorder();
                Canvas canvas = Canvas(recorder,
                    Rect.fromPoints(Offset(0, 0), Offset(gameSize, gameSize)));

                // draw checkerBoard .....
                canvas.drawRect(Rect.fromLTWH(0, 0, gameSize, gameSize),
                    Paint()..color = Color.fromARGB(255, 230, 154, 15));
                Paint line = Paint();
                canvas.drawLine(
                    Offset(0, gameSize / 3), Offset(200, gameSize / 3), line);
                canvas.drawLine(Offset(0, gameSize / 3 * 2),
                    Offset(200, gameSize / 3 * 2), line);

                canvas.drawLine(
                    Offset(gameSize / 3, 0), Offset(gameSize / 3, 200), line);
                canvas.drawLine(Offset(gameSize / 3 * 2, 0),
                    Offset(gameSize / 3 * 2, 200), line);

                // int spaceIndex = 0;
                for (var item in game!.getSelectArr()) {
                  Offset sp = item['startPoint'];
                  Offset ep = item['endPoint'];
                  int index = item['index'];
                  // print('getSelectArr -index >>> $index ');

                  // draw data index .....
                  TextPainter textPainter = TextPainter(
                    text: TextSpan(
                      text: index.toString(),
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 30,
                      ),
                    ),
                    textDirection: TextDirection.ltr,
                  );
                  textPainter.layout(
                    minWidth: 0,
                    maxWidth: gameSize / 3,
                  );
                  Offset offset = Offset(sp.dx + 1, sp.dy + 1);
                  textPainter.paint(canvas, offset);

                  // draw data .....
                  if (item['isHasValue']) {
                    int type = item['value'];
                    if (type == Player.circle) {
                      canvas.drawCircle(
                          Offset((ep.dx - sp.dx) / 2, (ep.dy - sp.dy) / 2),
                          (ep.dx - sp.dx) / 2 - sp.dx,
                          player1);
                    } else {
                      canvas.drawCircle(
                          Offset((ep.dx - sp.dx) / 2, (ep.dy - sp.dy) / 2),
                          (ep.dx - sp.dx) / 2 - sp.dx,
                          player2);
                    }
                  }
                }

                // 停止录制 生成image
                ui.Picture pic = recorder.endRecording();
                ui.Image checkerboard =
                    await pic.toImage(gameSize.toInt(), gameSize.toInt());
                ByteData? pngBytes = await checkerboard.toByteData(
                    format: ui.ImageByteFormat.png);
                viewData = pngBytes!.buffer.asUint8List();
                // imgBytes = pngBytes.buffer.asUint8List();
                // outputImg2 = img2;
                setState(() {});
              }),
            ),
          ),

          // Load asset image to Uint8List
          GestureDetector(
            onPanDown: (details) {
              print('onPanDown');
              clickPoint = details.localPosition;
            },
            onPanUpdate: (details) {
              print('onPanUpdate');
              clickPoint = details.localPosition;
            },
            onPanEnd: (details) {
              print('onPanEnd $clickPoint');
              game!.setSelect(clickPoint!);
              viewRefresh();
            },
            child: viewData != null
                ? Container(
                    child: Image.memory(
                      // Uint8List.view(imgBytes2!.buffer),
                      viewData!,
                      width: gameSize,
                      height: gameSize,
                    ),
                    // child: CustomPaint(
                    //   painter: ShowImageClass(outputImg2),
                    // ),
                  )
                : Container(),
          ),

          Padding(
            padding: EdgeInsets.all(12.0),
            child: ElevatedButton(
              child: Text('Back home.'),
              onPressed: (() {
                Pressed.goPath(context, R.home);
              }),
            ),
          ),
        ],
      ),
    );
  }

  viewRefresh() async {
    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas canvas = Canvas(
        recorder, Rect.fromPoints(Offset(0, 0), Offset(gameSize, gameSize)));

    // 更新遊戲畫面
    game!.refresh(canvas);

    // 停止录制 生成image
    ui.Picture pic = recorder.endRecording();
    ui.Image checkerboard =
        await pic.toImage(gameSize.toInt(), gameSize.toInt());
    ByteData? pngBytes =
        await checkerboard.toByteData(format: ui.ImageByteFormat.png);
    viewData = pngBytes!.buffer.asUint8List();
    setState(() {});
  }
}

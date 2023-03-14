import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:test2/logic/OOXX/ai.dart';

class Rule {
  // static winGroup = {};
}

class Player {
  static int circle = 0;
  static int fork = 1;
  static String user = "user";
  static String ai = "ai";
}

class DataInfo {
  static Map indexToPoints = {}; // 所有 Slice 對應 Offset
  static Set allSlice = {0, 1, 2, 3, 4, 5, 6, 7, 8};
  static Set winGroup = {
    //colum 列
    {0, 3, 6},
    {1, 4, 7},
    {2, 5, 8},

    //row 排
    {0, 1, 2},
    {3, 4, 5},
    {6, 7, 8},

    //diagonal 斜
    {0, 4, 8},
    {2, 4, 6},
  };
}

class GameOOXX {
  late double gameWidth;
  late double gameHeight;
  List<Map> canSelect = [];
  int step = 0;
  bool canClick = true;
  late Ai npc;
  dynamic mainUi;

  GameOOXX(_gameOOXXState, {this.gameWidth = 200, this.gameHeight = 200}) {
    // game GameOOXX 建構式
    mainUi = _gameOOXXState;
    init();
    npc = Ai(game: this);
  }

  setSelect(Offset select) {
    if (!canClick) return;
    return updateSelectData(select, Player.user);
  }

  updateSelectData(Offset select, String playType) {
    for (var item in canSelect) {
      Offset sPoint = item['startPoint'];
      Offset ePoint = item['endPoint'];
      if (select.dx <= ePoint.dx && select.dy <= ePoint.dy) {
        if (select.dx >= sPoint.dx && select.dy >= sPoint.dy) {
          //print('you select  $item');
          // update this select
          if (!item['isHasValue']) {
            step++;
            item['isHasValue'] = true;
            item['value'] = step % 2 == 1 ? Player.circle : Player.fork;
            item['step'] = step;
            print('ttttt -game step- >>> $step');

            if (playType == Player.user) {
              canClick = false; // change ai play.
              Future.delayed(Duration(milliseconds: 1000)).then((value) {
                npc.play();
                canClick = true;
                print(
                    'ttttt DataInfo.indexToPoints >>>  ${DataInfo.indexToPoints}');
              });
            }
            return [item, item['value']];
          }
        }
      }
    }
    return null;
  }

  getSelectArr() {
    return canSelect;
  }

  init() {
    canSelect = [];
    double w = gameWidth / 3;
    double h = gameHeight / 3;
    int index = 0;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        Map<String, Object> singleInfo = {};
        double sx = i.toDouble() * w;
        double sy = j.toDouble() * h;
        singleInfo['index'] = index;
        singleInfo['isHasValue'] = false;
        singleInfo['startPoint'] = Offset(sx, sy);
        singleInfo['endPoint'] = Offset(sx + w, sy + h);
        // arr.add(Offset(sx, sy));
        // arr.add(Offset(sx + w, sy + h));
        canSelect.add(singleInfo);
        DataInfo.indexToPoints[index] =
            Offset((sx + sx + w) / 2, (sy + sy + h) / 2); // 格對應座標...
        index++;
      }
    }
    // print('this.ooxx points arr >>>  $canSelect');
  }

  _calcPlayingEnd() {
    //print('ttttt.gameOOXX._calcPlayingEnd >>> $canSelect- $step');
    int status = -1;
    if (step < 4) return status;
    Set winGroup = {
      //colum 列
      {0, 3, 6},
      {1, 4, 7},
      {2, 5, 8},

      //row 排
      {0, 1, 2},
      {3, 4, 5},
      {6, 7, 8},

      //diagonal 斜
      {0, 4, 8},
      {2, 4, 6},
    };

    Set analyzeArr = {};
    //只選取有值的格子
    canSelect.forEach((item) {
      if (item['isHasValue']) analyzeArr.add(item['index']);
    });
    winGroup.forEach((item) {
      Set isHasSet = item.intersection(analyzeArr);
      if (isHasSet.toList().length == 3) {
        // 符合判斷
        List isHasArr = isHasSet.toList();
        var grid1 = canSelect[isHasArr[0]];
        var grid2 = canSelect[isHasArr[1]];
        var grid3 = canSelect[isHasArr[2]];

        if (grid1["value"] == grid2["value"] &&
            grid1["value"] == grid3["value"]) {
          status = grid1["value"];
          canClick = false;
          // ignore: void_checks
          return grid1["value"];
        }
      }
    });
    return status;
  }

  refresh(Canvas canvas) {
    drawCheckerBoard(canvas);
    drawPlaying(canvas);
    var isType = _calcPlayingEnd();
    print('_calcPlayingEnd isType >>> $isType');
    if (isType != null && isType != -1) {
      drawResult(canvas, isType);
    }
  }

  // draw checkerBoard .....
  drawCheckerBoard(Canvas canvas) {
    canvas.drawRect(Rect.fromLTWH(0, 0, gameWidth, gameHeight),
        Paint()..color = Color.fromARGB(255, 230, 154, 15));
    Paint line = Paint();

    // 橫線 ...
    canvas.drawLine(Offset(0, gameWidth / 3), Offset(200, gameWidth / 3), line);
    canvas.drawLine(
        Offset(0, gameWidth / 3 * 2), Offset(200, gameWidth / 3 * 2), line);

    // 直線 ...
    canvas.drawLine(
        Offset(gameHeight / 3, 0), Offset(gameHeight / 3, 200), line);
    canvas.drawLine(
        Offset(gameHeight / 3 * 2, 0), Offset(gameHeight / 3 * 2, 200), line);
  }

  drawPlaying(Canvas canvas) {
    Paint player1 = Paint()
      ..color = ui.Color.fromARGB(255, 248, 0, 136)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
    Paint player2 = Paint()
      ..color = ui.Color.fromARGB(255, 47, 198, 236)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    for (var item in canSelect) {
      Offset sp = item['startPoint'];
      Offset ep = item['endPoint'];
      int index = item['index'];

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
        maxWidth: gameWidth / 3,
      );
      Offset offset = Offset(sp.dx + 1, sp.dy + 1);
      textPainter.paint(canvas, offset);

      // draw data .....
      if (item['isHasValue']) {
        int type = item['value'];
        if (type == Player.circle) {
          canvas.drawCircle(Offset((ep.dx + sp.dx) / 2, (ep.dy + sp.dy) / 2),
              (ep.dx - sp.dx) / 2 - 3, player1);
        } else {
          canvas.drawLine(Offset(sp.dx + 3, sp.dy + 3),
              Offset(ep.dx - 3, ep.dy - 3), player2);
          canvas.drawLine(Offset(sp.dx + 3 + (ep.dx - sp.dx - 6), sp.dy + 3),
              Offset(sp.dx + 3, ep.dy - 3), player2);
        }
      }
    }
  }

  drawResult(Canvas canvas, int type) {
    String player = '';
    String gameRes = '';
    if (type == Player.circle) player = 'OO';
    if (type == Player.fork) player = 'XX';
    gameRes = '$player is WIN.';
    if (type == 2) gameRes = 'PLAY AGAIN.'; // 平手
    print(gameRes);

    canvas.drawRect(Rect.fromLTWH(0, 0, gameWidth, gameHeight),
        Paint()..color = ui.Color.fromARGB(31, 0, 0, 0));

    // draw data index .....
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: gameRes,
        style: TextStyle(
          color: ui.Color.fromARGB(255, 251, 255, 2),
          fontSize: 30,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: gameWidth,
    );
    Offset offset = Offset(30, gameHeight / 2 - 30);
    textPainter.paint(canvas, offset);
  }
}

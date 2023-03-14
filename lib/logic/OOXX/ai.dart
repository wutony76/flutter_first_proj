import 'dart:math';

import 'package:flutter/material.dart';

import 'game.dart';
import 'tool.dart';

class Ai {
  GameOOXX game;
  List<dynamic>? canSelectArr;
  Ai({required this.game}) {
    init();
  }

  init() {
    canSelectArr = game.canSelect;
  }

  play() {
    int aiSelect = -1;
    // canSelec
    //tArr = canSelect;
    // if (canSelectArr == null) return;
    print('this is ai play. ${game.step}');
    // print('ttttt game.canSelect >>> ${game.canSelect}');

    Map analyzeData = {};
    List checkPosSelectArr = []; // 所有已被選擇的空格
    List isSelectArr = [];
    List defaultSelectArr = [];
    List playArr = []; // 預設策略 Arr

    switch (game.step) {
      case 1:
        analyzeData = Tool.getCanSelectSet(game.canSelect);
        checkPosSelectArr = analyzeData.keys.toList();
        // step1.
        if (!checkPosSelectArr.contains(4)) {
          aiSelect = 4;
          break;
        }
        defaultSelectArr = [0, 2, 6, 8];
        // test random
        // for (int i = 0; i < 20; i++) {
        //   print('random ${Random().nextInt(defaultSelectArr.length)}');
        // }
        while (true) {
          int index = Random().nextInt(defaultSelectArr.length);
          aiSelect = defaultSelectArr[index];
          if (aiSelect != -1) {
            break;
          }
        }
        break;
      case 3:
        // step3.
        analyzeData = Tool.getAnalyzeCanSelectSet(game.canSelect);
        isSelectArr = analyzeData[Player.circle]; // 取畫圈位置
        checkPosSelectArr = Tool.getCanSelectSet(game.canSelect).keys.toList();
        print('ttttt.isSelectArr >>> $isSelectArr');

        Set? arr = Tool.getAnalyzeSelectTwoNum(isSelectArr);
        print('get arr >>> $arr');

        // 對手已兩連線
        if (arr != null) {
          for (var group in DataInfo.winGroup) {
            if (aiSelect != -1) break;
            print('test break 2. aiSelect- $aiSelect');

            for (var enemy in arr) {
              Set isHasSet = group.intersection(enemy);
              if (isHasSet.toList().length == 2) {
                Set data = group.difference(enemy);
                if (!checkPosSelectArr.contains(data.first)) {
                  aiSelect = data.first;
                  print('get data >>> $data - $aiSelect');
                  break;
                }
                print('test break 1.');
              }
            }
          }
          if (aiSelect != -1) break;
          print('test break 3. aiSelect- $aiSelect');
        }

        /**
         *  對手未兩連線，換己方攻擊
         *  var _set = {...list};   List 轉 Set
         *  */
        playArr = [
          {0, 4, 8},
          {2, 4, 6}
        ];
        for (var group in playArr) {
          if (aiSelect != -1) break;
          if (group.intersection({...checkPosSelectArr}).toList().length == 3) {
            defaultSelectArr = [1, 3, 5, 7];
            while (true) {
              int index = Random().nextInt(defaultSelectArr.length);
              aiSelect = defaultSelectArr[index];
              if (aiSelect != -1) {
                break;
              }
            }
          }
        }
        if (aiSelect != -1) break;

        /**
         *  simulation run test.
         * 
         */
        aiSelect = simulationAIplay(analyzeData, checkPosSelectArr);
        break;

      case 5:
      case 7:
        analyzeData = Tool.getAnalyzeCanSelectSet(game.canSelect);
        checkPosSelectArr = Tool.getCanSelectSet(game.canSelect).keys.toList();
        aiSelect = simulationAIplay(analyzeData, checkPosSelectArr);
        break;
    }

    // 最外層UI重畫
    if (aiSelect != -1) {
      game.updateSelectData(DataInfo.indexToPoints[aiSelect], Player.user);
      game.mainUi.viewRefresh();
      return aiSelect;
    }
    return aiSelect;
  }

  // 返回兩兩線，第三格可填寫位置
  findTwoLine(int type, {Map? analyzeData, Map? analyzeData2}) {
    List posArr = [];
    List checkPosSelectArr = [];
    int select = -1;
    List circleList = analyzeData2![Player.circle] ?? [];
    List forkList = analyzeData2[Player.fork] ?? [];
    if (analyzeData != null) {
      posArr = analyzeData[type];
      checkPosSelectArr = Tool.getCanSelectSet(game.canSelect).keys.toList();
    }
    if (analyzeData2 != null) {
      posArr = analyzeData2[type];
      List newArr = List.from(circleList);
      newArr.addAll(forkList);
      checkPosSelectArr = newArr;
    }

    for (var group in DataInfo.winGroup) {
      if (select != -1) break;

      Set? arr = Tool.getAnalyzeSelectTwoNum(posArr);
      for (var twoTwoGroup in arr!) {
        Set isHasSet = group.intersection(twoTwoGroup);
        if (isHasSet.toList().length == 2) {
          Set data = group.difference(twoTwoGroup);
          if (!checkPosSelectArr.contains(data.first)) {
            select = data.first;
            break;
          }
        }
      }
    }
    return select;
  }

  simulationAIplay(analyzeData, checkPosSelectArr) {
    print('simulationAIplay');
    print('simulationAIplay analyzeData >>> $analyzeData');
    print('simulationAIplay checkPosSelectArr >>> $checkPosSelectArr');
    int deDefaultSelect = -1;
    Set spaceArr = DataInfo.allSlice.difference({...checkPosSelectArr});
    List circleArr = List.from(analyzeData[Player.circle]); // list 深拷貝
    List forkArr = List.from(analyzeData[Player.fork]);
    deDefaultSelect = subRunTest(circleArr, forkArr, spaceArr, Player.fork, 1);
    if (deDefaultSelect != -1) return deDefaultSelect;
  }

  /**
   *  type = 0 圈圈先走
   *  type = 1 叉叉先走
   *  spaceArr2 可選位置
   *  LogLV 印出log標記(層數) // -1 隱藏
   */
  subRunTest(circleArr, forkArr, spaceArr2, type, LogLV) {
    LogLV++;
    print('$LogLV subRunTest...');
    List circleArrSub = List.from(circleArr);
    List forkArrSub = List.from(forkArr);
    Set nowSelectArr = {...circleArrSub}.union({...forkArrSub}); // OX已選擇
    Set spaceArr = DataInfo.allSlice.difference(nowSelectArr); // 可選位置
    Map simulationRes = {}; // 記錄權重值
    int step; // 步數
    int deDefaultSelect = -1;
    int score = -1;
    List scoreArr = [];
    bool isLoopWin = false; //是否有獲勝，有獲勝跳出迴圈權重加+1

    print('$LogLV VsubRunTest ... circleArrSub >>> $circleArrSub');
    print('$LogLV subRunTest ... forkArrSub >>> $forkArrSub');
    print('$LogLV spaceArr >>> ${spaceArr.toList()}');

    // 可選位置逐一選擇
    spaceArr.toList().forEach((slice) {
      // slice select loop init ...
      step = 0;
      simulationRes[slice] = 0;
      isLoopWin = false;
      circleArrSub = List.from(circleArr);
      forkArrSub = List.from(forkArr);

      print('$LogLV for-init subRunTest ... circleArrSub >>> $circleArrSub');
      print('$LogLV for-init subRunTest ... forkArrSub >>> $forkArrSub');

      // select slice ...
      if (type == Player.circle) {
        circleArrSub.add(slice);
      } else {
        forkArrSub.add(slice);
      }
      step++;

      // start while ...
      while (true) {
        // if (step > 20) break;
        print('$LogLV subRunTest (while)... circleArrSub >>> $circleArrSub');
        print('$LogLV  subRunTest (while)... forkArrSub >>> $forkArrSub');

        String whosePlay = checkWhosePlay(type, step);
        switch (whosePlay) {
          case 'circle': // circle
            print('圈圈走');
            circleArrSub =
                updatePlaying(circleArrSub, forkArrSub, Player.circle);
            break;
          case 'fork': // fork
            print('叉叉走');
            forkArrSub = updatePlaying(circleArrSub, forkArrSub, Player.fork);
            break;
        }
        step++;

        print('subRunTest... circleArrSub >>>$step $circleArrSub');
        print('subRunTest... forkArrSub >>>$step $forkArrSub');

        // 判斷輸贏.增加權重
        List args1 = type == Player.circle ? circleArrSub : forkArrSub;
        DataInfo.winGroup.forEach((group) {
          if (group
                  .intersection({...circleArrSub}.union({...forkArrSub}))
                  .toList()
                  .length ==
              3) {
            // 符合判斷
            if (group.intersection({...args1}).toList().length == 3) {
              int value = simulationRes[slice];
              value++; // 權重 +1
              simulationRes[slice] = value;
              isLoopWin = true;
              // print('simulation win group >>> $group');
            }
          }
        });

        // 離開迴圈條件...
        if ((circleArrSub.length + forkArrSub.length) == 9 || isLoopWin) break;
      }
    });

    // 取權重最高值
    print('$LogLV subRunTest... simulationRes >>>  $simulationRes');
    simulationRes.forEach((key, value) {
      // print('$LogLV deDefaultSelect >>>  $key - $value');
      if (value > score) {
        score = value;
        scoreArr = [];
        scoreArr.add(key);
      } else if (value == score) {
        scoreArr.add(key);
      }
    });

    if (scoreArr.isNotEmpty) {
      deDefaultSelect = scoreArr[Random().nextInt(scoreArr.length)];
    }
    print('$LogLV subRunTest... deDefaultSelect >>>  $deDefaultSelect');
    return deDefaultSelect;
  }

  checkWhosePlay(type, step) {
    int calc = step % 2;
    return calc == type ? 'circle' : 'fork';
  }

  List updatePlaying(circleArr, forkArr, type) {
    int defaultSelect = -1;
    Map analyzeData2Data = {
      Player.circle: circleArr,
      Player.fork: forkArr,
    };

    // ---找自己兩格---
    int args1 = type == Player.circle ? Player.circle : Player.fork;
    defaultSelect = findTwoLine(args1, analyzeData2: analyzeData2Data);
    print('deDefaultSelect1 >>> $defaultSelect');

    // ---找對手兩格---
    if (defaultSelect == -1) {
      int args2 = type == Player.circle ? Player.fork : Player.circle;
      defaultSelect = findTwoLine(args2, analyzeData2: analyzeData2Data);
      print('deDefaultSelect2 >>> $defaultSelect');
    }

    // ---只剩下最後一格---
    if (defaultSelect == -1) {
      List remainArr = List.from(circleArr);
      remainArr.addAll(forkArr);
      if (remainArr.length == 8) {
        defaultSelect = DataInfo.allSlice
            .difference(
                {...List.from(circleArr)}.union({...List.from(forkArr)}))
            .first;
      }
      print('deDefaultSelect4 >>> $defaultSelect');
    }

    // ---計算權重，來判斷---
    if (defaultSelect == -1) {
      Set nowSelectArr =
          {...List.from(circleArr)}.union({...List.from(forkArr)}); // OX已選擇
      Set spaceArr2 = DataInfo.allSlice.difference(nowSelectArr); // 可選位置
      int args3 = type == Player.circle ? Player.circle : Player.fork;
      defaultSelect = subRunTest(circleArr, forkArr, spaceArr2, args3, 10);
      print('deDefaultSelect5 >>> $defaultSelect');
    }

    switch (type) {
      case 0:
        circleArr.add(defaultSelect);
        break;
      case 1:
        forkArr.add(defaultSelect);
        break;
    }
    return type == Player.circle ? circleArr : forkArr;
  }

  // winGroup.forEach((item) {
  //     Set isHasSet = item.intersection(analyzeArr);
  //     if (isHasSet.toList().length == 3) {
  //       // 符合判斷
  //       List isHasArr = isHasSet.toList();
  //       var grid1 = canSelect[isHasArr[0]];
  //       var grid2 = canSelect[isHasArr[1]];
  //       var grid3 = canSelect[isHasArr[2]];

  //       if (grid1["value"] == grid2["value"] &&
  //           grid1["value"] == grid3["value"]) {
  //         status = grid1["value"];
  //         canClick = false;
  //         // ignore: void_checks
  //         return grid1["value"];
  //       }
  //     }
  //   });
}

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/material.dart';
import 'package:test2/core/manager.dart';
import 'dart:developer' as dev;
import 'dart:ui' as ui;

import 'package:test2/ui/actions/controller.dart';
import 'package:test2/ui/view/testUiImage.dart';

import '../components/baseScaffold.dart';
import '../components/imageClipper.dart';
import '../components/images/ImageGameClass.dart';
import '../components/images/ImageLoaderClass.dart';
import '../components/images/ImagePainterClass.dart';

class Game extends StatefulWidget {
  // const Game({this.child = const Text('GG124689'), super.key});
  // Widget child;
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _animation;
  Alignment _dragAlignment = Alignment.center;

  List sliceArr = []; // 圖片巢
  // ImageClipper clipper = ImageClipper(Image.asset("images/Q_SPAWN.jpg"));
  late ui.Image baseImage;
  String gameMsg = '';

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
    // _controller.reset();
    // _controller.forward();

    var show = _controller.isCompleted;
    print('tttt test $show');
  }

  init(double imgWidth, double imgHeight) {
    // 產生對應座標
    double sx = 0;
    double sy = 0;
    double w = imgWidth / 3;
    double h = imgHeight / 3;
    int index = 0;

    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        var map = {};
        map['index'] = index;
        map['startx'] = 0 + i.toDouble() * w;
        map['starty'] = 0 + j.toDouble() * h;
        map['endx'] = w + i.toDouble() * w;
        map['endy'] = h + j.toDouble() * h;
        sliceArr.add(map);
        index++;
      }
    }
    var lastNode = sliceArr.removeLast(); //挖洞
    // print('ttttt.lastNode >>> $lastNode');

    // 打亂數據
    int getRandomInt(int min, int max) {
      final random = Random();
      return random.nextInt((max - min).floor()) + min;
    }

    List newArr = [];
    newArr.addAll(sliceArr);
    for (var i = 1; i < newArr.length; i++) {
      var j = getRandomInt(0, i);
      var t = newArr[i];
      newArr[i] = newArr[j];
      newArr[j] = t;
    }
    sliceArr = newArr; //打亂
    sliceArr.add(lastNode);
  }

  @override
  void initState() {
    super.initState();
    print('ttttt print initState');
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _controller.addListener(() {
      setState(() {
        _dragAlignment = _animation.value;
      });
    });

    ImageLoaderClass.loader
        .loadImageByProvider(const AssetImage("images/Q_SPAWN.jpg"))
        .then((res) {
      print('ttt.initState Q_SPAWN ImageLoaderClass >> $res');

      baseImage = res;
      init(baseImage.width.toDouble(), baseImage.height.toDouble());

      setState(() {});
    });

    // init(loadImg!.width.toDouble(),
    //     loadImg!.height.toDouble());
    // init(365, 365);
  }

  @override
  void dispose() {
    print('ttttt print dispose');
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Manager.getInst()?.setContext(context);
    var size = MediaQuery.of(context).size;
    Offset startPoint = Offset(-1, -1);
    Offset endPoint = Offset(-1, -1);

    return BaseScaffold(context).defaultScaffold(
        "Test Game",
        Scaffold(
            appBar: BaseScaffold(context).defalutBar("Test Game"),
            body: GestureDetector(
              onPanDown: (details) {
                _controller.stop();
                // print('......>> onPanDown $details');
                startPoint = details.localPosition;
              },
              onPanUpdate: (details) {
                endPoint = details.localPosition;
              },
              onPanEnd: (details) {
                // _runAnimation(details.velocity.pixelsPerSecond, size);
                // Offset endPoint = details.primaryVelocity;
                //     Offset(details.localPosition.dx, details.localPosition.dy);
                var indexListArr = [];
                sliceArr.forEach((e) {
                  indexListArr.add(e['index']);
                });
                int selectIndex = indexListArr.indexOf(8);
                int posCloum = selectIndex ~/ 3;
                int posRow = selectIndex % 3;
                print('run sliceArr 1111111 >>> $indexListArr - $selectIndex');

                if ((endPoint.dx - startPoint.dx) > 50) {
                  // if (cowRow == 2) return; //最左邊
                  var storgeSlice = sliceArr[selectIndex];
                  sliceArr[selectIndex] = sliceArr[selectIndex - 3];
                  sliceArr[selectIndex - 3] = storgeSlice;
                  print('run right');
                } else if ((endPoint.dx - startPoint.dx) < -50) {
                  // if (cowRow == 2) return; //最右邊
                  var storgeSlice = sliceArr[selectIndex];
                  sliceArr[selectIndex] = sliceArr[selectIndex + 3];
                  sliceArr[selectIndex + 3] = storgeSlice;
                  print('run left $sliceArr');
                } else if ((endPoint.dy - startPoint.dy) > 50) {
                  print('run down');
                  if (posRow == 0) return; //最下邊
                  var storgeSlice = sliceArr[selectIndex];
                  sliceArr[selectIndex] = sliceArr[selectIndex - 1];
                  sliceArr[selectIndex - 1] = storgeSlice;
                } else if ((endPoint.dy - startPoint.dy) < -50) {
                  print('run up');
                  if (posRow == 2) return; //最上邊
                  // var storgeSlice = sliceArr[selectIndex];
                  // sliceArr[selectIndex] = sliceArr[selectIndex - 1];
                  // sliceArr[selectIndex - 1] = storgeSlice;
                  var storgeSlice = sliceArr[selectIndex];
                  sliceArr[selectIndex] = sliceArr[selectIndex + 1];
                  sliceArr[selectIndex + 1] = storgeSlice;
                }

                indexListArr = [];
                sliceArr.forEach((e) {
                  indexListArr.add(e['index']);
                });
                var indexListArrSort = List.from(indexListArr); // 遊戲完成順序
                indexListArrSort.sort();

                bool isSuccesss = listEquals(indexListArr, indexListArrSort);
                if (isSuccesss) {
                  gameMsg = '恭喜，遊戲完成';
                } else {
                  gameMsg = '遊戲中...';
                }

                // print('ttttt.indexListArr.chek >>> $indexListArr');
                // print(
                //     'ttttt.indexListArr.indexListArrSort >>> $indexListArrSort - $isSuccesss');
                setState(() {});

                // setState(() {
                //   _dragAlignment += Alignment(
                //     details.delta.dx / (size.width / 2),
                //     details.delta.dy / (size.height / 2),
                //   );
                // });
              },
              child: Align(
                alignment: _dragAlignment,
                child: Container(
                  alignment: Alignment.topLeft,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Color.fromARGB(255, 255, 160, 250))),
                  child:
                      // CustomPaint(
                      //   painter: ImageGameClass(baseImage, sliceArr),
                      // ),

                      FutureBuilder<ui.Image>(
                    future: ImageLoaderClass.loader.loadImageByProvider(
                        const AssetImage("images/Q_SPAWN.jpg")),
                    builder: (context, snapshot) {
                      var show = snapshot;
                      print('[Image] -FutureBuilder snapshot status >>> $show');
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text("Waiting...");
                      }
                      // ui.Image? loadImg = snapshot.data;

                      return CustomPaint(
                        painter: ImageGameClass(baseImage, sliceArr),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Center(
                              child: Column(
                                children: [
                                  Text(
                                    gameMsg,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // child: Card(
                //   // child: widget.child,
                //   child: Image.asset("images/Q_SPAWN.jpg"),
                // ),
              ),
            )));
  }
}

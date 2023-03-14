import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:test2/ui/actions/controller.dart';
import '../../core/manager.dart';
import '../../core/static.dart';
import '../../core/word.dart';
import '../components/baseScaffold.dart';
import 'baseDialog.dart';

/**
 *  Func goDetailPage
 *  Func goNewPage
 *  Class NewPage 
 *  Button
 */

void goDetailPage(BuildContext _context, Widget widget) {
  Navigator.of(_context).push(
    MaterialPageRoute(builder: (context) => widget),
  );
}

void goNewPage(BuildContext _context, String _content) {
  // Navigator.pop(_context); // 關閉 drawer
  Navigator.of(_context).push(
    MaterialPageRoute(builder: (context) => NewPage(content: _content)),
  );
}

/** Test fast page */
class NewPage extends StatelessWidget {
  final String content;
  const NewPage({Key? key, this.content = 'None'}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(context).testScaffold(content);
  }
}

/** Test fast page change to login views. */
class ChangeLoginPage extends StatelessWidget {
  const ChangeLoginPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(context).loginScaffold();
  }
}

void goNewPageHasView(BuildContext outContext, views) {
  // Navigator.pop(_context); // 關閉 drawer
  Navigator.of(outContext).push(
    MaterialPageRoute(builder: (context) => views),
  );
}

InkResponse closeBtn(BuildContext context, [Function? actions]) {
  return InkResponse(
    onTap: () {
      if (actions == null) {
        Navigator.of(context).pop();
      } else {
        actions();
      }
    },
    child: const CircleAvatar(
      backgroundColor: Colors.red,
      child: Icon(Icons.close, color: Colors.white),
    ),
  );
}

/** set public bar btn */
IconButton dataBtn() {
  BuildContext? context = Manager.getInst()?.mainContext;
  return IconButton(
    icon: const Icon(Icons.data_usage),
    onPressed: () {
      Pressed.goPath(context, R.data);
    },
  );
}

IconButton logoutBtn() {
  // BuildContext? _context = Manager.getInst()?.mainContext;
  BuildContext? context = Manager.getInst()!.returnContext();
  BaseDialog? dialog = Manager.getInst()!.returnDialog();

  return IconButton(
    icon: const Icon(Icons.exit_to_app),
    onPressed: () {
      if (dialog != null) dialog.close();
      dialog!.confirmBox(W.strLogout, () {
        Member.token = '';
        Future.delayed(const Duration(milliseconds: 1000)).then((value) {
          if (context != null) Pressed.goPath(context, R.login);
        });
      });
    },
  );
}

IconButton gameBtn() {
  BuildContext? context = Manager.getInst()?.mainContext;
  return IconButton(
    icon: const Icon(Icons.games),
    onPressed: () {
      Pressed.goPath(context, R.game);
    },
  );
}

IconButton gameOOXXBtn() {
  BuildContext? context = Manager.getInst()?.mainContext;
  return IconButton(
    icon: const Icon(Icons.circle_outlined),
    onPressed: () {
      Pressed.goPath(context, R.gameOOXX);
    },
  );
}

IconButton painterBtn() {
  BuildContext? context = Manager.getInst()?.mainContext;
  return IconButton(
    icon: const Icon(Icons.format_paint),
    onPressed: () {
      Pressed.goPath(context, R.painter);
    },
  );
}

IconButton zoomBtn() {
  BuildContext? context = Manager.getInst()?.mainContext;
  return IconButton(
    icon: const Icon(Icons.zoom_in_sharp),
    onPressed: () {
      Pressed.goPath(context, R.zoom);
    },
  );
}

checkHasToken(BuildContext _context) {
  if (Member.token != '') {
    Future.delayed(const Duration(milliseconds: 1))
        .then((value) => Pressed.goPath(_context, R.home));
  }
}

checkNoToken(BuildContext _context) {
  if (Member.token == '') {
    Future.delayed(Duration(milliseconds: 15000))
        .then((value) => Pressed.goPath(_context, R.login));
    return true;
  }
  return false;
}

class RandomGenerator {
  int seed;
  RandomGenerator({this.seed = 0});
  double next() {
    int primeNumber = 2147483647;
    if (seed == 0) {
      seed = 98765433;
    }
    seed = (seed * 16807) % primeNumber; // 用質數進行運算（Lehmer亂數演算法）
    return seed / primeNumber;
  }
}

class Tools {
  static String addToken(int number) {
    String charsAllowed =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    String token = '';
    const setLength = 15; // default length
    RandomGenerator random = RandomGenerator(seed: number);
    while (token.length < setLength) {
      // int index = Mat
      int index = (random.next() * charsAllowed.length).floor();
      String nextChar = charsAllowed.substring(index, index + 1);
      token += nextChar;
    }
    print('produce.token >>> $token');
    return token;
  }
}

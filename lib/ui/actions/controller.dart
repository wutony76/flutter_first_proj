import 'package:flutter/material.dart';
import 'package:test2/core/manager.dart';

import '../../core/static.dart';
import '../view/testDataAdd.dart';
import '../view/testDataList.dart';
import '../view/testLogin.dart';
import '../view/testRandomWords.dart';

// ignore: slash_for_doc_comments
/**
 * 
 * Navigator.of(context).pushNamed("/home");
 * Navigator.of(context).popUntil((route) => route.isFirst);
 * Navigator.pop(context); // 回到上一頁
 */
class Pressed {
  static gohome([context]) {
    // BuildContext? targetContext;
    // targetContext = Manager.getInst()!.returnContext();
    // if (context) targetContext = context;
    // if (targetContext != null) Navigator.of(targetContext).pushNamed(R.home);
    Navigator.of(context).pushNamed(R.home);
  }

  static goPath(context, path) {
    // BuildContext? targetContext = Manager.getInst()!.returnContext();
    // if (context) targetContext = context;
    Navigator.of(context).pushNamed(path);
  }

  static goPath2(String path, [context]) {
    // BuildContext? targetContext = Manager.getInst()!.returnContext();
    // if (context) targetContext = context;
    // if (targetContext != null)
    Navigator.of(context).push(_createRoute(path));
  }

  static Route _createRoute(path) {
    var view;
    switch (path) {
      case R.login:
        view = LoginView();
        break;
      case R.home:
        view = RandomWords();
        break;
      case R.add:
        view = AddView();
        break;
      case R.data:
        view = DataView();
        break;
    }
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => view,
      transitionDuration: Duration(milliseconds: 700), // 动画时间为1000毫秒
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 1.0;
        var curve = Curves.ease;
        // final tween = Tween(begin: begin, end: end);
        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return FadeTransition(
          opacity: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}

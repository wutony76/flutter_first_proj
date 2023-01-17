import 'package:flutter/material.dart';

import '../../core/static.dart';

// ignore: slash_for_doc_comments
/**
 * 
 * Navigator.of(context).pushNamed("/home");
 * Navigator.of(context).popUntil((route) => route.isFirst);
 * Navigator.pop(context); // 回到上一頁
 */
class Pressed {
  static gohome(context) {
    Navigator.of(context).pushNamed(R.home);
  }

  static goPath(context, path) {
    Navigator.of(context).pushNamed(path);
  }
}

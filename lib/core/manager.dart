// ignore: slash_for_doc_comments
import 'package:flutter/material.dart';

import '../ui/components/baseDialog.dart';
// import 'package:synchronized/synchronized.dart';

class Manager {
  static Manager? _inst;
  // static Object? _syncInst = Object();
  BuildContext? mainContext;
  BaseDialog? dialog;

  // static final _lock = Lock();
  Manager() {
    print('new Manager');
  }

  static Manager? getInst() {
    _inst ??= Manager();
    /**
     * 
    if (_inst == null) {
      //synchronized 保證區塊內同時間只會被一個 Thread 執行
      // await _lock.synchronized(() async {
      //   print('ttttt new Manager112315631');
      //   if (_inst == null) {
      //     print('ttttt new Manager');
      //     _inst = new Manager();
      //   }
      // });
      _inst = new Manager();
    }
    */
    return _inst;
  }

  setContext(BuildContext context) {
    mainContext = context;
    dialog = BaseDialog(context);
  }

  BuildContext? returnContext() {
    return mainContext;
  }

  BaseDialog? returnDialog() {
    return dialog;
  }
}

// ignore: slash_for_doc_comments
import 'package:flutter/material.dart';
// import 'package:synchronized/synchronized.dart';

class Manager {
  static Manager? _inst;
  static Object? _syncInst = new Object();
  BuildContext? mainContext;

  // static final _lock = Lock();
  Manager() {
    print('new Manager');
  }

  static Manager? getInst() {
    print('ttttt run getInst');
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
    return _inst;
  }

  void setContext(BuildContext context) {
    print('ttttt setContext $context');
    mainContext = context;
  }
}

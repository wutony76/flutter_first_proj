import 'package:flutter/material.dart';

class BaseDialog {
  BuildContext widgetContext;
  BaseDialog(this.widgetContext);
  bool isShow = false;

  Future<bool?> msg(String msg) {
    if (isShow) Navigator.of(widgetContext).pop();
    isShow = true;
    return showDialog(
        context: widgetContext,
        builder: (viewContext) {
          return AlertDialog(
            content:
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(msg, textAlign: TextAlign.center),
            ]),
          );
        });
  }
}

import 'package:flutter/material.dart';
import 'package:test2/core/dataModel.dart';

import 'baseScaffold.dart';
import 'utils.dart';

class BaseDialog {
  BuildContext widgetContext;
  BaseDialog(this.widgetContext);
  bool isShow = false;

  _showInit() {
    if (isShow) Navigator.of(widgetContext).pop(false);
    isShow = true;
  }

  Future<bool?> msg(String msg) {
    _showInit();
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

  Future<bool?> editBox(DataInfo dataInfo) {
    _showInit();
    DataForm dataForm = DataForm(widgetContext, model: dataInfo);
    dataForm.init();
    String postId = dataInfo.id.toString();
    print(postId);
    dataForm.setUrl('https://jsonplaceholder.typicode.com/posts/$postId');
    dataForm.setBtnActions('EDIT', () {
      dataForm.actionEdit();
    }, () => dataForm.actionEditBack());

    return showDialog(
        context: widgetContext,
        builder: (viewContext) {
          return AlertDialog(
            content: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: closeBtn(viewContext),
                ),
                dataForm.show(),
              ],
            ),
          );
        });
  }

  Future<bool?> alert(String msg) {
    _showInit();

    Widget okButton = Center(
        child: ElevatedButton(
      child: Text("OK"),
      onPressed: () {
        close();
      },
    ));
    AlertDialog alert = AlertDialog(
      // title: Text('Alert'),
      content: Text(msg),
      actions: [
        okButton,
      ],
    );
    return showDialog(
        context: widgetContext,
        builder: (viewContext) {
          return alert;
        });
  }

  Future<bool?> confirmBox(String msg, Function actions) {
    _showInit();
    Widget okButton = Center(
        child: ElevatedButton(
      child: Text("OK"),
      onPressed: () {
        actions();
      },
    ));
    Widget cancelButton = Center(
        child: OutlinedButton(
      child: Text("Cancel"),
      onPressed: () {
        close();
      },
    ));

    AlertDialog alert = AlertDialog(
      // title: Text('Alert'),
      content: Text(msg),
      actions: [
        Center(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          okButton,
          const Padding(padding: EdgeInsets.all(5.0)),
          cancelButton,
        ]))
      ],
    );
    return showDialog(
        context: widgetContext,
        builder: (viewContext) {
          return alert;
        });
  }

  close() {
    if (isShow) {
      if (widgetContext != null) Navigator.of(widgetContext).pop();
    }
  }

  close2(BuildContext _context) {
    Navigator.of(_context).pop();
  }
}

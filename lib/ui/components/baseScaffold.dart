import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';

import '../../core/conn.dart';
import '../../core/dataModel.dart';
import '../../core/static.dart';
import '../actions/controller.dart';
import 'baseDialog.dart';

class BaseScaffold {
  final _formKey = GlobalKey<FormState>();
  DataInfo model = DataInfo();
  BuildContext viewContext;
  BaseScaffold(this.viewContext);

  Scaffold defaultScaffold(String title) {
    return Scaffold(
      appBar: bar(title),
      body: content(),
    );
  }

  AppBar bar(String title) {
    return AppBar(title: Text(title));
  }

  Padding input({
    String? decoration,
    Function? cbSaved,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: TextEditingController(),
        decoration: InputDecoration(
          labelText: decoration,
        ),
        onSaved: (v) {
          if (cbSaved == null) return;
          print('intput show =  $v');
          cbSaved(v);
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },

        /**
        onSaved:  (value) {
          model.body = value;
          print('content value = $value');
        },
         */
      ),
    );
  }

  Padding buttonBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
              child: Text('ADD'),
              onPressed: () {
                // if (pressed == null) return;
                // pressed();
              }),
          Padding(padding: EdgeInsets.only(left: 8)),
          ElevatedButton(
              child: Text('CANCEL'),
              onPressed: () {
                // if (pressed == null) return;
                // pressed();
              }),
        ],
      ),

      //  ElevatedButton(
      //     child: Text(buttonText),
      //     onPressed: () {
      //       if (pressed == null) return;
      //       pressed();
      //     }),
    );
  }

  Stack content() {
    BaseInput titleInput = BaseInput(
        decoration: 'Title',
        cbSaved: (value) {
          model.title = value;
        });

    BaseInput contentInput = BaseInput(
        decoration: 'Content',
        cbSaved: (value) {
          model.body = value;
        });

    BaseDialog dialog = BaseDialog(viewContext);

    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        /** 
        Positioned(
          right: -40.0,
          top: -40.0,
          child: InkResponse(
            onTap: () {
              // Navigator.of(context).pop();
            },
            child: const CircleAvatar(
              child: Icon(Icons.close),
              backgroundColor: Colors.red,
            ),
          ),
        ),
        */
        Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const Text('TEST add new data...'),
              titleInput.show(),
              contentInput.show(),
              ButtonBar(actionAdd: () {
                // print('button click!!!!!');
                _formKey.currentState!.save();
                // print(!_formKey.currentState!.validate());
                if (!_formKey.currentState!.validate()) return;

                model.userId = 1;
                var pramas = {
                  // 'id': model.id,
                  'userId': model.userId,
                  'title': model.title,
                  'body': model.body,
                };
                // post api add data.
                ConnServ()
                    .post(
                  pramas: json.encode(pramas),
                  url: 'https://jsonplaceholder.typicode.com/posts',
                )
                    .then((res) {
                  if (res != null) {
                    String key = "post_dataAdd";
                    Map addMap = new Map();
                    addMap[res['id']] = DataInfo(
                      id: res['id'],
                      userId: res['userId'],
                      title: res['title'],
                      body: res['body'],
                    );
                    var saveData = Cache.setData(key, addMap);
                    dev.log('>>> $saveData', name: 'HTTP POST. req');
                    Pressed.goPath(viewContext, R.data);
                    return;
                  }
                  titleInput.inputController.clear();
                  contentInput.inputController.clear();
                  dialog.msg('新增失敗');

                  // Pressed.goPath(viewContext, R.data);
                }, onError: (e) {
                  print('errors:');
                  print(e);
                  dialog.msg('內部錯誤');
                  // msgDialog(msg: '內部錯誤');
                });
              }, actionCancel: () {
                titleInput.inputController.clear();
                contentInput.inputController.clear();
              }).show(),
            ],
          ),
        ),
      ],
    );
  }

  Future<bool?> msgDialog({String msg = 'no data.'}) {
    print('run msgDialog... ');
    return showDialog(
        context: viewContext,
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

class BaseInput {
  String? decoration;
  Function? cbSaved;
  TextEditingController inputController = TextEditingController();
  BaseInput({this.decoration, this.cbSaved});

  Widget show() {
    String? decoration = this.decoration;
    Function? cbSaved = this.cbSaved;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: inputController,
        decoration: InputDecoration(
          labelText: decoration,
        ),
        onSaved: (v) {
          if (cbSaved == null) return;
          print('class intput show =  $v');
          cbSaved(v);
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
      ),
    );
  }
}

class ButtonBar {
  DataInfo model = DataInfo();
  Function? actionAdd;
  Function? actionCancel;
  ButtonBar({this.actionAdd, this.actionCancel});
  Widget show() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
              child: Text('ADD'),
              onPressed: () {
                if (actionAdd != null) actionAdd!();
              }),
          Padding(padding: EdgeInsets.only(left: 8)),
          OutlinedButton(
              child: Text('CANCEL'),
              onPressed: () {
                if (actionCancel != null) actionCancel!();
              }),
        ],
      ),
    );
  }
}

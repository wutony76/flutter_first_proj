import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';

import '../../core/conn.dart';
import '../../core/dataModel.dart';
import '../../core/static.dart';
import '../../core/word.dart';
import '../actions/controller.dart';
import 'baseDialog.dart';

class BaseScaffold {
  final _formKey = GlobalKey<FormState>();
  DataInfo model = DataInfo();
  BuildContext viewContext;
  BaseScaffold(this.viewContext);

  Scaffold defaultScaffold(
    String? title,
    Scaffold? _scaffold,
  ) {
    if (_scaffold != null) return _scaffold;
    title ??= "DefaultScaffold title";
    return _defaultScaffold(title);
  }

  Scaffold testScaffold(String title) {
    return _defaultScaffold(title);
  }

  Scaffold loginScaffold() {
    // return _defaultScaffold('PLEASE, SIGN IN?');
    String title = 'TEST CHANGE SIGN IN?';
    String body = 'PLEASE, SIGN IN?';
    return Scaffold(
      appBar: defalutBar(title),
      body: testContent(body, () {
        Pressed.goPath(viewContext, R.login);
      }, "SING IN", Colors.green),
    );
  }

  Scaffold addScaffold(String title) {
    return Scaffold(
      appBar: bar(title),
      // body: testContent(title),
      body: addContent(),
    );
  }

  Scaffold _defaultScaffold(String title) {
    return Scaffold(
      appBar: defalutBar(title),
      body: testContent(title),
    );
  }

  /**  Widget 
   * 
   *  Scaffold 骨架
   *  Stack 层叠布局
   *  Column 線性布局
   * 
  */
  Column testContent(String content,
      [Function? actions, String btnName = 'Go back!', _color = Colors.blue]) {
    return Column(
      mainAxisAlignment:
          MainAxisAlignment.center, // (optional) will center horizontally.
      // child: Text(content),
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(content),
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
            onPressed: () {
              Future.delayed(const Duration(milliseconds: 0)).then((value) {
                // ignore: unnecessary_null_comparison
                if (actions == null) {
                  Pressed.goPath(viewContext, R.home);
                } else {
                  actions();
                }
              });
            },
            child: Text(btnName),
            style: ButtonStyle(
              backgroundColor: ButtonStyleButton.allOrNull<Color>(_color),
            ),
          ),
        ]),
      ],
    );

    // return Center(
    //   child: Text(content, textDirection: TextDirection.ltr),
    // );
  }

  Stack addContent() {
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
    DataInfo dataInfo = DataInfo();
    DataForm dataForm = DataForm(viewContext, model: dataInfo);
    dataForm.init();

    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        dataForm.show(),
      ],
    );
  }

  /** UI components  */
  AppBar mainBar(String title, List<Widget> actions) {
    return AppBar(title: Text(title), actions: actions);
  }

  AppBar bar(String title) {
    return AppBar(title: Text(title));
  }

  AppBar defalutBar(String title) {
    return AppBar(
      title: Text(title),
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () => Pressed.gohome(viewContext),
      ),
    );
  }

  AppBar normalBar(String title, Function actions) {
    return AppBar(
      title: Text(title),
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () => actions(),
      ),
    );
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
}

class BaseInput {
  String? decoration;
  Function? cbSaved;
  TextEditingController inputController = TextEditingController();
  String? defaultVal;
  late InputDecoration setInputDecoration;
  late EdgeInsetsGeometry setEdgeInsetsGeometry;

  BaseInput({this.decoration, this.cbSaved, this.defaultVal}) {
    print('ttt BaseInput');
    setInputDecoration = defaultInputDecoration();
    setEdgeInsetsGeometry = defaultPadding();
  }

  setStyle({String style = 'NONE'}) {
    if (style == 'LOGIN') {
      setInputDecoration = borderInputDecoration();
      setEdgeInsetsGeometry = borderPadding();
    } else {
      setInputDecoration = defaultInputDecoration();
      setEdgeInsetsGeometry = defaultPadding();
    }
  }

  InputDecoration defaultInputDecoration() {
    return InputDecoration(
      labelText: decoration,
    );
  }

  InputDecoration borderInputDecoration() {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      labelText: decoration,
    );
  }

  EdgeInsetsGeometry defaultPadding() {
    return EdgeInsets.all(10.0);
  }

  EdgeInsetsGeometry borderPadding() {
    return EdgeInsets.only(left: 100.0, right: 100.0, top: 10, bottom: 10);
  }

  Widget show() {
    String? decoration = this.decoration;
    Function? cbSaved = this.cbSaved;
    inputController.text = defaultVal ?? '';

    return Padding(
      //padding: const EdgeInsets.all(100.0),
      padding: setEdgeInsetsGeometry,
      child: TextFormField(
        // initialValue: 'default data',
        maxLines: null,
        controller: inputController,
        decoration: setInputDecoration,
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
  Function? actionAdd;
  Function? actionCancel;
  String btnName = 'ADD';
  // late Function actions;
  late MainAxisAlignment setMainAxisAlignment;

  ButtonBar({this.actionAdd, this.actionCancel}) {
    setMainAxisAlignment = MainAxisAlignment.end;
  }

  setStyle({String style = 'NONE'}) {
    if (style == 'LOGIN') {
      setMainAxisAlignment = MainAxisAlignment.center;
    } else {
      setMainAxisAlignment = MainAxisAlignment.end;
    }
  }

  setBtnAction(String _name, [Function? _actions, Function? _actions2]) {
    btnName = _name;
    // ignore: unnecessary_null_comparison
    if (_actions != null) {
      actionAdd = _actions;
    }
    if (_actions2 != null) {
      actionCancel = _actions2;
    }
  }

  Widget show() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: setMainAxisAlignment,
        children: [
          ElevatedButton(
              child: Text(btnName),
              onPressed: () {
                // ignore: unnecessary_null_comparison
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

class DataForm {
  final _formKey = GlobalKey<FormState>();
  final String formTitle;
  final DataInfo model;
  String postUrl = 'https://jsonplaceholder.typicode.com/posts';
  BuildContext viewContext;

  late BaseInput titleInput;
  late BaseInput contentInput;
  late BaseDialog dialog;
  late ButtonBar buttonbar;
  double setButtonBarBlock = 7.0;

  DataForm(this.viewContext, {this.formTitle = '', required this.model});

  init({String? setTitle, String? setContent, String style = "NONE"}) {
    String strTitle = setTitle ?? 'Title';
    String strContent = setContent ?? 'Content';

    titleInput = BaseInput(
        decoration: strTitle,
        defaultVal: model.title,
        cbSaved: (value) {
          model.title = value;
        });
    contentInput = BaseInput(
        decoration: strContent,
        defaultVal: model.body,
        cbSaved: (value) {
          model.body = value;
        });
    titleInput.setStyle(style: style);
    contentInput.setStyle(style: style);

    dialog = BaseDialog(viewContext);
    buttonbar = ButtonBar(
        actionAdd: () => actionAdd(), actionCancel: () => actionCancel());
    buttonbar.setStyle(style: style);

    if (style == 'LOGIN') {
      setButtonBarBlock = 18;
    }
  }

  setUrl(String url) {
    postUrl = url;
  }

  setBtnActions(String btnName, [Function? actions, Function? actions2]) {
    if (actions != null && actions2 != null) {
      buttonbar.setBtnAction(btnName, actions, actions2);
    } else if (actions2 != null) {
      buttonbar.setBtnAction(btnName, null, actions2);
    } else if (actions != null) {
      buttonbar.setBtnAction(btnName, actions);
    } else {
      buttonbar.setBtnAction(btnName);
    }
  }

  actionLogin() {
    _formKey.currentState!.save();
    if (!_formKey.currentState!.validate()) return;
    var pramas = {
      // 'id': model.id,
      'userId': 1,
      'title': model.title,
      'body': model.body,
    };
    // ConnServ()
    //     .post(
    //   pramas: json.encode(pramas),
    //   url: postUrl,
    // )
    //     .then((res) {
    //   dialog.msg(W.strLoginSuccess);
    // });
    dialog.msg(W.strLoginSuccess);
    Future.delayed(Duration(milliseconds: 500)).then((value) {
      dialog.close();
    }).then((value) {
      Pressed.goPath(viewContext, R.home);
    });
  }

  actionAdd() {
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
      url: postUrl,
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
        dialog.msg('新增成功');

        // ttt.test flutter delay run .....
        Future.delayed(Duration(milliseconds: 500)).then((value) {
          dialog.close();
        }).then((value) => Pressed.goPath(viewContext, R.data));
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
  }

  actionEdit() {
    _formKey.currentState!.save();
    if (!_formKey.currentState!.validate()) return;

    var show = model.userId;
    print('ttt edit >>> $show');
    var pramas = {
      'id': model.id,
      'userId': model.userId,
      'title': model.title,
      'body': model.body,
    };
    print('ttt edit >>> $pramas');
    ConnServ()
        .post(
      pramas: json.encode(pramas),
      url: postUrl,
    )
        .then((res) {
      if (res != null) {
        String key = "post_dataEdit";
        Map addMap = new Map();
        addMap[res['id']] = DataInfo(
          id: res['id'],
          userId: res['userId'],
          title: res['title'],
          body: res['body'],
        );
        var saveData = Cache.setData(key, addMap);
        dev.log('>>> $saveData', name: 'HTTP POST. req');
        dialog.msg('修改成功');

        // ttt.test flutter delay run .....
        Future.delayed(Duration(milliseconds: 500)).then((value) {
          dialog.close();
        }).then((value) => Pressed.goPath(viewContext, R.data));
        return;
      }
      dialog.msg('修改失敗');
      Future.delayed(Duration(milliseconds: 1000))
          .then((value) => dialog.close());
      // Pressed.goPath(viewContext, R.data);
    }, onError: (e) {
      print('errors:');
      print(e);
      dialog.msg('內部錯誤');
      // msgDialog(msg: '內部錯誤');
    });
  }

  actionEditBack() {
    titleInput.inputController.text = model.title ?? '';
    contentInput.inputController.text = model.body ?? '';
  }

  actionDelete(DataInfo dataInfo) {
    String postId = dataInfo.id.toString();
    postUrl = 'https://jsonplaceholder.typicode.com/posts/$postId';
    ConnServ().post(
      url: postUrl,
    );
  }

  actionCancel() {
    titleInput.inputController.clear();
    contentInput.inputController.clear();
  }

  Form show() {
    return Form(
      key: _formKey,
      child: Column(
        /**
                 *  default MainAxisSize.max.
                 *  MainAxisSize.min表示尽可能少的占用水平空间，当子组件没有占满水平剩余空间，
                 *  则Row的实际宽度等于所有子组件占用的的水平空间；
                 */
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(formTitle),
          titleInput.show(),
          contentInput.show(),
          Padding(padding: EdgeInsets.all(setButtonBarBlock)),
          buttonbar.show(),
        ],
      ),
    );
  }
}

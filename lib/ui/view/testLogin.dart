import 'dart:math';

import 'package:flutter/material.dart';
import 'package:test2/ui/actions/controller.dart';
import 'package:test2/ui/components/baseScaffold.dart';

import '../../core/dataModel.dart';
import '../../core/manager.dart';
import '../../core/static.dart';
import '../components/utils.dart';

class LoginView extends StatefulWidget {
  LoginView({super.key}) {}

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  BuildContext? _thisContext;
  @override
  Widget build(BuildContext context) {
    Manager.getInst()!.setContext(context);
    _thisContext = context;

    // return BaseScaffold(context).defaultScaffold('Login', thisView());
    return FutureBuilder(builder: (context, snapshot) {
      // if (Member.token != '') {
      //   Future.delayed(Duration(milliseconds: 1))
      //       .then((value) => Pressed.goPath(context, R.home));
      // }
      checkHasToken(context);
      return BaseScaffold(context).defaultScaffold('Login', thisView());
    });
  }

  Scaffold thisView() {
    // DataInfo defaultFormData = DataInfo();
    DataInfo defaultFormData = DataInfo(title: 'tony', body: '123456');
    DataForm dataForm = DataForm(_thisContext!, model: defaultFormData);
    dataForm.init(setTitle: 'Account', setContent: 'Password', style: "LOGIN");
    dataForm.setBtnActions('LOGIN', () {
      Member.token = Tools.addToken(Random().nextInt(9999999));
      dataForm.actionLogin();
    });

    return Scaffold(
      body: Center(
        // constraints: BoxConstraints.expand(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('LOGO'),
            Padding(padding: EdgeInsets.all(50)),
            Stack(clipBehavior: Clip.none, children: [dataForm.show()]),
          ],
        ),
      ),
    );
  }
}

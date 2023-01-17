import 'dart:convert';

import 'package:flutter/material.dart';

import '../../core/conn.dart';
import '../../core/dataModel.dart';

class BaseScaffold {
  final _formKey = GlobalKey<FormState>();
  DataInfo model = DataInfo();

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

  Padding button({
    String buttonText = 'None',
    Function? pressed,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
          child: Text(buttonText),
          onPressed: () {
            if (pressed == null) return;
            pressed();
          }),
    );
  }

  Stack content() {
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
              input(
                  decoration: 'Title',
                  cbSaved: (value) {
                    model.title = value;
                  }),
              input(
                  decoration: 'Content',
                  cbSaved: (value) {
                    model.body = value;
                  }),
              button(
                  buttonText: 'ADD',
                  pressed: () {
                    print('button click!!!!!');
                    _formKey.currentState!.save();
                    print(!_formKey.currentState!.validate());
                    if (!_formKey.currentState!.validate()) return;
                    model.userId = 1;
                    var pramas = {
                      // 'id': model.id,
                      'userId': model.userId,
                      'title': model.title,
                      'body': model.body,
                    };
                    ConnServ()
                        .post(
                          pramas: json.encode(pramas),
                          url: 'https://jsonplaceholder.typicode.com/posts',
                        )
                        .then(() {});
                  }),
            ],
          ),
        ),
      ],
    );
  }
}

// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'dart:developer' as dev;

// ttt test app single view . hello word.
class TestAppSample extends StatelessWidget {
  String? text;
  TestAppSample({Key? key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // const content = 'hello word25681';
    const String content = 'hello word25681';
    dev.log('ttttt $content');
    dev.log('ttttt $text');
    const output = Center(
      child: Text(content, textDirection: TextDirection.ltr),
    );

    return output;
  }
}

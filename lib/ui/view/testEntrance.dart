import 'package:flutter/material.dart';
import 'package:test2/core/manager.dart';
import 'package:test2/ui/actions/controller.dart';
import 'dart:developer' as dev;

import '../../core/static.dart';
import 'testLogin.dart';

class Entrance extends StatefulWidget {
  @override
  State<Entrance> createState() => _EntranceState();
}

class _EntranceState extends State<Entrance> {
  @override
  Widget build(BuildContext context) {
    Manager.getInst()!.setContext(context);
    // return Scaffold(
    //   body: _buildView(context),
    // );
    return FutureBuilder(
        future: Future.delayed(Duration(milliseconds: 2000)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: _buildView(context),
            );
          }

          Future.delayed(const Duration(milliseconds: 100)).then((value) {
            print('url >>> go to R.login');
            Pressed.goPath(context, R.login);
          });
          return Scaffold(
            body: LoginView(),
          );
        });
  }

  // bool _visible = false;
  bool _visible = true;

  FutureBuilder _buildView2(context) {
    return FutureBuilder(
      future: Future.delayed(Duration(milliseconds: 1000 * 5)),
      builder: ((context, snapshot) {
        var status = snapshot.connectionState;
        if (snapshot.connectionState == ConnectionState.waiting) {
          print('ttttt >> waiting...  $status');
          return _buildView(context);
        } else {
          print('ttttt >> index...  $status');
          return _buildView3(context);
        }
        // return Text('test123456');
      }),
    );
  }

  Widget _buildView3(context) {
    // Future.delayed(Duration(milliseconds: 500)).then((value) {
    //   print('run delayed _buildView');
    //   _visible = true;
    //   // setState(() {});
    // });
    return Scaffold(
      body: GestureDetector(
        child: AnimatedOpacity(
          // If the widget is visible, animate to 0.0 (invisible).
          // If the widget is hidden, animate to 1.0 (fully visible).
          opacity: _visible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          // The green box must be a child of the AnimatedOpacity widget.
          child: Center(
            child: Text('HOME'),
            // child: Container(
            //   width: 200.0,
            //   height: 200.0,
            //   color: Colors.green,
            // ),
          ),
        ),
        onTap: () {
          // _visible = true;
          print('ttttt click......');
          setState(() {
            _visible = true;
          });
        },

        //   AnimatedOpacity(
        // // If the widget is visible, animate to 0.0 (invisible).
        // // If the widget is hidden, animate to 1.0 (fully visible).
        // opacity: _visible ? 1.0 : 0.0,
        // duration: const Duration(milliseconds: 500),
        // // The green box must be a child of the AnimatedOpacity widget.
        // child: Container(
        //   width: 200.0,
        //   height: 200.0,
        //   color: Colors.green,
        // ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Call setState. This tells Flutter to rebuild the
          // UI with the changes.
          setState(() {
            _visible = !_visible;
          });
        },
        tooltip: 'Toggle Opacity',
        child: const Icon(Icons.flip),
      ),
    );
  }

  Widget _buildView(context) {
    _visible = true;
    return FutureBuilder(
      future: Future.delayed(Duration(milliseconds: 700)),
      builder: ((context, snapshot) {
        var status = snapshot.connectionState;
        if (snapshot.connectionState == ConnectionState.waiting) {
          print('ttttt >> waiting...  $status');
          //return _buildView(context);
        } else {
          print('ttttt >> index...  $status');
          _visible = false;
        }
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
          case ConnectionState.done:
        }

        return AnimatedOpacity(
          opacity: _visible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 1000),
          // The green box must be a child of the AnimatedOpacity widget.
          child: Center(
            child: Text('MY LOG'),
          ),
        );
        // return Text('test123456');
      }),
    );
  }
}

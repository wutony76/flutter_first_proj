import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:test2/ui/components/baseScaffold.dart';

import '../../core/manager.dart';
import '../components/utils.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  String pageTitle = 'Test Bottom Nav';
  @override
  Widget build(BuildContext context) {
    Manager.getInst()!.setContext(context);
    // TODO: implement build
    // return Text('can start add. data.');
    //return BaseScaffold(context).addScaffold('Test Bottom Nav');
    return BaseScaffold(context).defaultScaffold(
        pageTitle,
        Scaffold(
          // appBar: BaseScaffold(context).defalutBar(pageTitle),
          body: _bottomNavPages[_selectedIndex],
          bottomNavigationBar: navigationBar2(),
        ));
  }

  navigationBar1() {
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              flex: 1,
              child: Container(
                height: 50,
                color: Colors.white,
              )),
          Expanded(
              flex: 1,
              child: Container(
                height: 50,
                color: Colors.red,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'B',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              )),
          Expanded(
              flex: 1,
              child: Container(
                height: 50,
                color: Colors.white,
              )),
        ],
      ),
    );
  }

  // navigationBar2
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _bottomNavPages = [];
  void initState() {
    super.initState();
    // _bottomNavPages
    //   ..add(NewPage(content: '??????A'))
    //   ..add(NewPage(content: '??????B'))
    //   ..add(NewPage(content: '??????C'));
    _bottomNavPages.add(NewPage(content: '??????A'));
    _bottomNavPages.add(NewPage(content: '??????B'));
    _bottomNavPages.add(NewPage(content: '??????C'));
  }

  navigationBar2() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.settings_accessibility), label: '??????A'),
        BottomNavigationBarItem(
            icon: Icon(Icons.settings_accessibility_rounded), label: '??????B'),
        BottomNavigationBarItem(
            icon: Icon(Icons.settings_applications), label: '??????C'),

        // has style
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.teal,
      onTap: _onItemTapped,
    );
  }
}

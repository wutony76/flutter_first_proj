import 'package:flutter/material.dart';

import '../components/baseScaffold.dart';
import '../components/utils.dart';
import 'testDraggableCard.dart';
import 'testUiImage.dart';

Drawer leftMenu(BuildContext _context) {
  return Drawer(
    child: ListView(
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.black12,
          ),
          child: Center(
            child: Text('Drawer Header123456789',
                textDirection: TextDirection.ltr),
          ),
        ),
        ListTile(
          leading: Icon(Icons.message),
          title: Text('Messages'),
          onTap: () => goNewPage(_context, 'Messages'),
        ),
        ListTile(
          leading: Icon(Icons.account_circle),
          title: Text('Profile'),
          onTap: () => goNewPage(_context, 'Profile'),
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Settings'),
          onTap: () => goNewPage(_context, 'Settings'),
        ),
        ListTile(
          leading: Icon(Icons.animation),
          title: Text('Test Animation'),
          onTap: () {
            print('Test Animation');
            goNewPageHasView(
                _context,
                DraggableCard(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text('Test DraggableCard'),
                  ),
                ));
            // DraggableCard();
          },
        ),
        ListTile(
          leading: const Icon(Icons.image_sharp),
          title: const Text('Test Ui.Image'),
          onTap: () {
            goNewPageHasView(
              _context,
              ImagePage(),
            );
            // DraggableCard();
          },
        ),
      ],
    ),
  );
}

// void goNewPage(BuildContext _context, String _content) {
//   Navigator.pop(_context); // 關閉 drawer
//   Navigator.of(_context).push(
//     MaterialPageRoute(builder: (context) => NewPage(content: _content)),
//   );
// }

// /** Test fast page */
// class NewPage extends StatelessWidget {
//   final String content;
//   const NewPage({Key? key, this.content = 'None'}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return BaseScaffold(context).testScaffold(content);
//   }
// }

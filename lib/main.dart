// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:html';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;
import 'dart:math';

void main() {
  runApp(const MyApp());
  // runApp(TestSample(text: "test"));
}

// ttt test.
class TestSample extends StatelessWidget {
  final String text;
  const TestSample({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const content = 'hello word25681';
    dev.log('ttttt $content');
    dev.log('ttttt this.text');

    const output = Center(
      child: Text(content, textDirection: TextDirection.ltr),
    );

    return output;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    String testTitle = 'Startup Name Generator';
    return MaterialApp(
        routes: {
          //Map<String, WidgetBuilder>
          // "/splash": (context) => new SplashPage(),
          // "/login": (context) => new LoginPage(),
          "/home": (context) => new RandomWords(),
          // "/detail": (context) => new DetailPage(),
        },
        title: testTitle,
        theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.dark,
          primaryColor: Colors.lightBlue[800],

          // Define the default font family.
          fontFamily: 'Georgia',

          // Define the default `TextTheme`. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: const TextTheme(
            headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          ),
        ),
        home: RandomWords());
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final List<WordPair> _suggestions = <WordPair>[];
  final List<Map> _mainList = <Map>[];

  final Set<WordPair> _saved = new Set<WordPair>();
  final Set<Map> _saved2 = new Set<Map>();
  final TextStyle _biggerFont = const TextStyle(fontSize: 14.0);
  final TextStyle _subFont = const TextStyle(fontSize: 9.0);
  // final _biggerFont = const TextStyle(fontSize: 16);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        // leading: IconButton(onPressed: () {
        //   Navigator.of(context).push(
        //     new MaterialPageRoute(builder: (BuildContext context) {
        //       return new Scaffold(
        //         appBar: new AppBar(
        //           title: const Text('Settings'),
        //         ),
        //          drawer: Drawer(),
        //       );
        //     }),
        //   );
        // }, icon: const Icon(Icons.menu)),
        actions: <Widget>[
          IconButton(onPressed: _pushSaved, icon: const Icon(Icons.list)),
          IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),

      // 側邊選單
      // endDrawer
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
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
              onTap: () => _goNewPage('Messages'),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
              onTap: () => _goNewPage('Profile'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () => _goNewPage('Settings'),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _goNewPage('FloatingActionButton'),
      ),

      body: _buildSuggestions(),
      // bottomNavigationBar: new BottomNavigationBarItem(icon: icon),
    );
  }

  Widget _buildSuggestions() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (BuildContext _context, int i) {
          if (i.isOdd) return const Divider();
          final int index = i ~/ 2;
          // if (index >= _suggestions.length) {
          //   _suggestions.addAll(generateWordPairs().take(10));
          // }
          // return _buildRow(_suggestions[index]);
          if (index >= _mainList.length) {
            Map _data = {};
            Iterable<WordPair> word = generateWordPairs().take(2);
            _data['word'] = word.elementAt(0);
            _data['sub'] = word.elementAt(1);
            _data['icon'] = _getRandomIcon();
            _data['color'] = Color.fromRGBO(Random().nextInt(256),
                Random().nextInt(256), Random().nextInt(256), 1);
            _mainList.add(_data);
          }
          return _buildRow2(_mainList[index]);
        });
  }

  Widget _buildRow2(Map item) {
    final bool isSaved = _saved2.contains(item);
    Color _rColor = item['color'];
    TextStyle _mainText = TextStyle(fontSize: 20.0, color: _rColor);
    TextStyle _subText = TextStyle(fontSize: 9.0, color: _rColor);

    return new ListTile(
        title: new Text(
            // item.toString(),
            item['word'].asPascalCase,
            style: _mainText),
        subtitle: new Text(item['sub'].asPascalCase, style: _subText),
        leading: new Icon(
          item['icon'],
          color: _rColor,
        ),
        trailing: new Icon(
          isSaved ? Icons.favorite : Icons.favorite_border,
          color: isSaved ? Colors.red : null,
        ),
        onTap: () {
          setState(() {
            if (isSaved) {
              _saved2.remove(item);
            } else {
              _saved2.add(item);
            }
          });
        });
  }

  IconData _getRandomIcon() {
    final List<IconData> _iconList = <IconData>[];
    _iconList.add(Icons.abc);
    _iconList.add(Icons.ad_units_outlined);
    _iconList.add(Icons.zoom_out_map_rounded);
    _iconList.add(Icons.ac_unit_rounded);
    _iconList.add(Icons.account_balance_wallet);
    return _iconList[Random().nextInt(_iconList.length)];
  }

  void _pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute(builder: (BuildContext context) {
        final Iterable<ListTile> _tiles = _saved2.map((Map item) {
          TextStyle _mainStyle =
              TextStyle(fontSize: 20.0, color: item['color']);
          return new ListTile(
              title: new Text(item['word'].asPascalCase, style: _mainStyle));
        });
        final List<Widget> divided =
            ListTile.divideTiles(context: context, tiles: _tiles).toList();

        return new Scaffold(
          appBar: new AppBar(
            title: const Text('Saved Suggestions'),
          ),
          // drawer: Drawer(),
          body: new ListView(children: divided),
        );
      }),
    );
  }

  void _goNewPage(String _content) {
    Navigator.pop(context); // 關閉 drawer
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => NewPage(content: _content)),
    );
  }

  // old
  Widget _buildRow(WordPair pair) {
    final bool isSaved = _saved.contains(pair);
    final List<IconData> _iconList = <IconData>[];
    _iconList.add(Icons.abc);
    _iconList.add(Icons.ad_units_outlined);
    _iconList.add(Icons.zoom_out_map_rounded);
    _iconList.add(Icons.ac_unit_rounded);
    _iconList.add(Icons.account_balance_wallet);
    int num = Random().nextInt(_iconList.length);
    IconData getRandomIcon = _iconList[num];
    dev.log('ttt _iconList = $_iconList num= $num get= $getRandomIcon',
        name: '_buildRow ');
    Color randomColor = Color.fromRGBO(
        Random().nextInt(256), Random().nextInt(256), Random().nextInt(256), 1);
    TextStyle _mainText = TextStyle(fontSize: 14.0, color: randomColor);
    TextStyle _subText = TextStyle(fontSize: 9.0, color: randomColor);
    //var num = Icons.
    // Icons.forEach()

    return new ListTile(
        title: new Text(
          pair.asPascalCase,
          style: _mainText,
        ),
        subtitle: new Text(
          pair.asUpperCase,
          style: _subText,
        ),

        //使文本更小，并将所有内容打包在一起
        dense: true,
        leading: new Icon(getRandomIcon, color: randomColor),

        //设置拖尾将在列表的末尾放置一个图像。这对于指示主-细节布局特别有用。
        trailing: new Icon(
          isSaved ? Icons.favorite : Icons.favorite_border,
          color: isSaved ? Colors.red : null,
        ),
        onTap: () {
          setState(() {
            if (isSaved) {
              _saved.remove(pair);
            } else {
              _saved.add(pair);
            }
          });
        });
  }
}

// 新的頁面
class NewPage extends StatelessWidget {
  final String content;
  const NewPage({Key? key, this.content = 'None'}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(content),
      ),
      body: Column(
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
                String pageName = '/home';
                Navigator.of(context).pushNamed("/home");
                // Navigator.of(context).popUntil((route) => route.isFirst);
                // Navigator.pop(context); // 回到上一頁
              },
              child: const Text('Go back!'),
            ),
          ]),
        ],
      ),
    );
  }
}

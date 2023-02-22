import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:test2/core/manager.dart';
import 'dart:developer' as dev;
import 'dart:math';
import '../components/baseScaffold.dart';
import '../components/utils.dart';
import 'testLeftMenu.dart';

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
    Manager.getInst()?.setContext(context);

    // 設定上方功能紐
    List<Widget> btnArr = [
      IconButton(onPressed: _pushSaved, icon: const Icon(Icons.favorite)),
      dataBtn(),
      painterBtn(),
      gameBtn(),
      zoomBtn(),
      logoutBtn(),
    ];

    return FutureBuilder(builder: (context, snapshot) {
      bool isToken = checkNoToken(context);
      if (isToken) return ChangeLoginPage();
      return Scaffold(
        appBar: BaseScaffold(context).mainBar('Startup Name Generator', btnArr),
        /** 側邊選單 */
        // endDrawer
        drawer: leftMenu(context),

        /** 浮動按鈕 */
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            //onPressed: () => _goNewPage('FloatingActionButton'),
            onPressed: () => goNewPage(context, 'FloatingActionButton')),
        body: _buildSuggestions(),
        // bottomNavigationBar: new BottomNavigationBarItem(icon: icon),
      );
    });
  }

  Widget _buildSuggestions() {
    return ListView.builder(
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

    return ListTile(
        title: Text(
            // item.toString(),
            item['word'].asPascalCase,
            style: _mainText),
        subtitle: Text(item['sub'].asPascalCase, style: _subText),
        leading: Icon(
          item['icon'],
          color: _rColor,
        ),
        trailing: Icon(
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
      MaterialPageRoute(builder: (BuildContext context) {
        final Iterable<ListTile> _tiles = _saved2.map((Map item) {
          TextStyle _mainStyle =
              TextStyle(fontSize: 20.0, color: item['color']);
          return ListTile(
              title: Text(item['word'].asPascalCase, style: _mainStyle));
        });
        final List<Widget> divided =
            ListTile.divideTiles(context: context, tiles: _tiles).toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Saved Suggestions'),
          ),
          // drawer: Drawer(),
          body: ListView(children: divided),
        );
      }),
    );
  }

  // old
  // Widget _buildRow(WordPair pair) {
  //   final bool isSaved = _saved.contains(pair);
  //   final List<IconData> _iconList = <IconData>[];
  //   _iconList.add(Icons.abc);
  //   _iconList.add(Icons.ad_units_outlined);
  //   _iconList.add(Icons.zoom_out_map_rounded);
  //   _iconList.add(Icons.ac_unit_rounded);
  //   _iconList.add(Icons.account_balance_wallet);
  //   int num = Random().nextInt(_iconList.length);
  //   IconData getRandomIcon = _iconList[num];
  //   dev.log('ttt _iconList = $_iconList num= $num get= $getRandomIcon',
  //       name: '_buildRow ');
  //   Color randomColor = Color.fromRGBO(
  //       Random().nextInt(256), Random().nextInt(256), Random().nextInt(256), 1);
  //   TextStyle _mainText = TextStyle(fontSize: 14.0, color: randomColor);
  //   TextStyle _subText = TextStyle(fontSize: 9.0, color: randomColor);
  //   //var num = Icons.
  //   // Icons.forEach()

  //   return new ListTile(
  //       title: new Text(
  //         pair.asPascalCase,
  //         style: _mainText,
  //       ),
  //       subtitle: new Text(
  //         pair.asUpperCase,
  //         style: _subText,
  //       ),

  //       //使文本更小，并将所有内容打包在一起
  //       dense: true,
  //       leading: new Icon(getRandomIcon, color: randomColor),

  //       //设置拖尾将在列表的末尾放置一个图像。这对于指示主-细节布局特别有用。
  //       trailing: new Icon(
  //         isSaved ? Icons.favorite : Icons.favorite_border,
  //         color: isSaved ? Colors.red : null,
  //       ),
  //       onTap: () {
  //         setState(() {
  //           if (isSaved) {
  //             _saved.remove(pair);
  //           } else {
  //             _saved.add(pair);
  //           }
  //         });
  //       });
  // }
}

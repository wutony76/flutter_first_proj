import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:test2/core/manager.dart';
import 'package:test2/ui/actions/controller.dart';
import 'package:test2/ui/view/testDataAdd.dart';
import 'dart:developer' as dev;

import '../../core/static.dart';
import '../../core/word.dart';
import 'testDataList.dart';
import 'testDraggableCard.dart';
import 'testEntrance.dart';
import 'testGame.dart';
import 'testLogin.dart';
import 'testPainter.dart';
import 'testRandomWords.dart';

class TestApp extends StatelessWidget {
  const TestApp({super.key});
  sum(n) {
    var sum = 0;
    for (var i = 1; i <= n; i++) {
      sum += i;
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    init();
    testCoding(context);

    String testTitle = 'Startup Name Generator';
    return MaterialApp(
      // routes: {
      //   //Map<String, WidgetBuilder>
      //   // "/splash": (context) => new SplashPage(),
      //   // "/login": (context) => new LoginPage(),
      //   R.login: (context) => LoginView(),
      //   R.home: (context) => RandomWords(),
      //   R.data: (context) => DataView(),
      //   R.add: (context) => AddView(),
      //   // "/detail": (context) => new DetailPage(),
      // },
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

      home: Entrance(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case R.root:
            return pageRouteBuilder(settings, Entrance());
          case R.login:
            return pageRouteBuilder(settings, LoginView());
          case R.home:
            return pageRouteBuilder(settings, RandomWords());
          case R.data:
            return pageRouteBuilder(settings, const DataView());
          case R.add:
            return pageRouteBuilder(settings, const AddView());
          case R.game:
            return pageRouteBuilder(settings, const Game());
          case R.painter:
            return pageRouteBuilder(settings, const PainterPage());
        }
        // Unknown route
        return MaterialPageRoute(builder: (context) => Entrance());
      },
    );
  }

  init() {
    W.defaultLang();
  }

  PageRouteBuilder pageRouteBuilder(settings, view) {
    return PageRouteBuilder(
      settings:
          settings, // Pass this to make popUntil(), pushNamedAndRemoveUntil(), works
      pageBuilder: (context, animation, secondaryAnimation) => view,
      transitionDuration: Duration(milliseconds: 700), // 动画时间为1000毫秒
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 1.0;
        var curve = Curves.ease;
        // final tween = Tween(begin: begin, end: end);
        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return FadeTransition(
          opacity: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  testCoding(BuildContext context) {
    var getMgr = Manager.getInst();
    // dev.log('ttttt get data ====== $getMgr');
    Manager.getInst()?.setContext(context);
    BuildContext? context2 = Manager.getInst()?.mainContext;
    // dev.log('ttttt get data2 ====== $context2');

    // compute test ------------------------------------------------
    dev.log('ttttt print ====== 1');
    compute(sum, 100000).then((res) {
      dev.log('ttttt calc sum ====== $res');
    });
    dev.log('ttttt print ====== 2');
  }
}



/***
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
    var isCheck = Manager.getInst()?.mainContext == context;
    dev.log('isCheck ====== $isCheck');

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
          // IconButton(onPressed: _pushSaved, icon: const Icon(Icons.list)),
          IconButton(onPressed: _pushSaved, icon: const Icon(Icons.favorite)),
          IconButton(
            icon: Icon(Icons.data_usage),
            onPressed: () {
              Navigator.of(context).pushNamed("/data");
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {},
          ),
        ],
      ),

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
 */

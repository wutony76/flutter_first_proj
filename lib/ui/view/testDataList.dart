import 'dart:convert';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';

import '../../core/conn.dart';
import '../../core/dataModel.dart';
import '../../core/manager.dart';
import '../../core/static.dart';
import '../actions/controller.dart';
import '../components/baseDialog.dart';
import '../components/baseScaffold.dart';
import '../components/utils.dart';

/**
 * 
 *  Test use post show data to this view.
*/
class DataView extends StatefulWidget {
  const DataView({super.key});

  @override
  State<DataView> createState() => _DataViewState();
}

class _DataViewState extends State<DataView> {
  List<DataInfo> listData = [];
  late BuildContext _thisContext;

  @override
  void initState() {
    super.initState();
    // test code
    /**
    // test http get conn no callback.
    ConnServ().get(url: 'https://jsonplaceholder.typicode.com/posts', index: 1);
    // test http get conn has callback.
    ConnServ().get(
        url: 'https://jsonplaceholder.typicode.com/posts',
        index: 2,
        callback: (String? res) {
          // print('ttt test callback2. $res');
          if (res == null) return;
          var jsonData = jsonDecode(res);

          // listData
          for (var item in jsonData) {
            listData.add(DataInfo(
              id: item['id'],
              userId: item['userId'],
              title: item['title'],
              body: item['body'],
            ));
          }

          setState(() {
            listData;
          });
        });
    */

    ConnServ()
        .get(url: 'https://jsonplaceholder.typicode.com/posts')
        .then((res) {
      if (res == null) return;

      // res data type dynamic.
      for (var item in res) {
        listData.add(DataInfo(
          id: item['id'],
          userId: item['userId'],
          title: item['title'],
          body: item['body'],
        ));
      }

      // get post add data.
      String key = "post_dataAdd";
      var getData = Cache.getData(key);
      dev.log('>>> $getData', name: 'Cache');
      if (getData != null) {
        for (var item in getData.values) {
          listData.add(item);
        }
      }

      setState(() {
        listData;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Manager.getInst()!.setContext(context);
    _thisContext = context;

    final Iterable<ListTile> _tiles = listData.map((DataInfo item) {
      String defaultData = '';
      return ListTile(
        title: Text(item.title ?? defaultData),
        subtitle: Text(item.body ?? defaultData),
        dense: true,
        trailing: Wrap(
          children: <Widget>[
            IconButton(
              onPressed: () {
                pressedEdit(item);
              },
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () {
                String postId = item.id.toString();
                String postTitle = item.title ?? '';
                BaseDialog dialog = BaseDialog(_thisContext);
                dialog.confirmBox('確定要刪除 $postTitle 嗎?', () {
                  String postUrl =
                      'https://jsonplaceholder.typicode.com/posts/$postId';
                  ConnServ()
                      .post(
                    url: postUrl,
                  )
                      .then(() {
                    dialog.close();
                  });
                });
              },
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
        onTap: () {
          goDetailPage(_thisContext, DetailPage(dataInfo: item));
        },
      );
    });
    final List<Widget> divided =
        ListTile.divideTiles(context: context, tiles: _tiles).toList();

    // return BaseScaffold(context)
    //     .defaultScaffold('Test add data.', thisView(divided));
    return FutureBuilder(builder: (context, snapshot) {
      bool isToken = checkNoToken(context);
      if (isToken) return const ChangeLoginPage();
      return BaseScaffold(context)
          .defaultScaffold('Test add data.', thisView(divided));
    });
  }

  Scaffold thisView(List<Widget> divided) {
    return Scaffold(
      appBar: BaseScaffold(_thisContext).defalutBar('Test show api data.'),
      body: ListView(children: divided),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Pressed.goPath(_thisContext, R.add),
      ),
    );
  }

  pressedEdit(DataInfo item) {
    String show = item.title ?? '';
    print('pressedEdit >>> $show');
    BaseDialog(_thisContext).editBox(item);
  }
}

/** 顯示內容頁 */
class DetailPage extends StatelessWidget {
  late BuildContext _thisContext;
  String defaultData = "NONE";
  final DataInfo dataInfo;
  DetailPage({Key? key, required this.dataInfo}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    _thisContext = context;
    // return Text(dataInfo.title ?? defaultData);
    return BaseScaffold(context)
        .defaultScaffold('Test add data.', thisView(dataInfo));
    // return BaseScaffold(context).testScaffold(content);
  }

  Scaffold thisView(DataInfo dataInfo) {
    String bodyContent = dataInfo.body ?? defaultData;
    bodyContent = 'CONTENT:  ' + bodyContent;
    return Scaffold(
      appBar: BaseScaffold(_thisContext)
          .normalBar(dataInfo.title ?? defaultData, () {
        Pressed.goPath(_thisContext, R.data);
      }),
      body: BaseScaffold(_thisContext).testContent(bodyContent, () {
        Pressed.goPath(_thisContext, R.data);
      }),
    );
  }
}

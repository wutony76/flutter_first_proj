import 'dart:convert';
import 'package:flutter/material.dart';

import '../../core/conn.dart';
import '../../core/dataModel.dart';
import '../../core/static.dart';
import '../actions/controller.dart';

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
      // res data type dynamic.
      for (var item in res) {
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
  }

  @override
  Widget build(BuildContext context) {
    _thisContext = context;

    final Iterable<ListTile> _tiles = listData.map((DataInfo item) {
      String defaultData = '';
      return new ListTile(
        title: Text(item.title ?? defaultData),
        subtitle: Text(item.body ?? defaultData),
        dense: true,
        trailing: Wrap(
          children: <Widget>[
            IconButton(
              onPressed: () {
                // post.delete(index.toString());
                // setState(() {
                //   _posts.removeAt(index);
                // });
              },
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () {
                // post.delete(index.toString());
                // setState(() {
                //   _posts.removeAt(index);
                // });
              },
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      );
    });
    final List<Widget> divided =
        ListTile.divideTiles(context: context, tiles: _tiles).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Test show api data.'),
      ),
      body: new ListView(children: divided),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Pressed.goPath(_thisContext, R.add),
      ),
    );
  }
}

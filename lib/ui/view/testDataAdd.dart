import 'package:flutter/widgets.dart';
import 'package:test2/ui/components/baseScaffold.dart';

class AddView extends StatefulWidget {
  const AddView({super.key});

  @override
  State<AddView> createState() => _AddViewState();
}

class _AddViewState extends State<AddView> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // return Text('can start add. data.');
    return new BaseScaffold(context).defaultScaffold('Test add data.');
  }
}

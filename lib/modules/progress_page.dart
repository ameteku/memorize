import 'package:flutter/cupertino.dart';
import 'package:memorize/custom/graph.dart';
import 'package:memorize/routing/app_state.dart';

class ProgressPage extends StatefulWidget {
  final AppState appState;
  const ProgressPage({required this.appState, Key? key}) : super(key: key);

  @override
  _ProgressPageState createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [Graph()],
    );
  }
}

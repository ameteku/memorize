import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memorize/custom/graph.dart';
import 'package:memorize/models/memory.dart';
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
    List<Memory> memorized = widget.appState.memoryAdapter!.collection!.where((element) => element.isMemorized).toList();

    List<Memory> notMemorized = widget.appState.memoryAdapter!.collection!.where((element) => !element.isMemorized).toList();
    return Container(
      child: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Graph(
              memoryAdapter: widget.appState.memoryAdapter!,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: ListView.builder(
                    itemCount: memorized.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(memorized[index].key),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(border: Border(left: BorderSide(color: Colors.black))),
                  width: MediaQuery.of(context).size.width / 2,
                  child: ListView.builder(
                    itemCount: notMemorized.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(notMemorized[index].key),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

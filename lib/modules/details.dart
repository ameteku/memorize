import 'package:flutter/material.dart';
import 'package:memorize/models/graph_data.dart';
import 'package:memorize/models/memory.dart';
import 'package:memorize/modules/cards_page.dart';
import 'package:memorize/routing/app_state.dart';

class DetailPage extends StatefulWidget {
  final AppState appState;
  const DetailPage({required this.appState, Key? key}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
              child: GestureDetector(
            onTap: () {
              widget.appState.memory = widget.appState.memoryAdapter!.collection!.first;
            },
            child: ListTile(
              focusColor: Colors.green,
              title: Text('Quiz'),
            ),
          )),
          Expanded(
            child: GestureDetector(
              onTap: () {
                widget.appState.graphData = GraphData();
              },
              child: ListTile(
                title: Text('View Progress'),
              ),
            ),
          )
        ],
      ),
    );
  }
}

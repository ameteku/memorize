import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:memorize/models/memory_adapter.dart';

class Graph extends StatefulWidget {
  final MemoryAdapter memoryAdapter;
  final int memorizedLength;
  const Graph({required this.memoryAdapter, required this.memorizedLength, Key? key}) : super(key: key);

  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  List<String>? wordsMemorized;
  List<String>? notMemorized;

  void filterMemories() {
    wordsMemorized = widget.memoryAdapter.collection!.where((element) => true).map((e) => e.key).toList();
    notMemorized = widget.memoryAdapter.collection!.where((element) => true).map((e) => e.key).toList();
  }

  @override
  Widget build(BuildContext context) {
    filterMemories();
    return PieChart(
      PieChartData(
          pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
            setState(() {
              // if (pieTouchResponse.touchInput is FlLongPressEnd || pieTouchResponse.touchInput is FlPanEnd) {
              //   touchedIndex = -1;
              // } else {
              //   touchedIndex = pieTouchResponse.touchedSectionIndex;
              // }
            });
          }),
          borderData: FlBorderData(
            show: true,
          ),
          sectionsSpace: 0,
          centerSpaceRadius: 60,
          sections: [
            PieChartSectionData(
                value: (widget.memoryAdapter.collection!.length - widget.memorizedLength).toDouble(),
                color: Colors.red,
                // titlePositionPercentageOffset: 5,
                titleStyle: TextStyle(color: Colors.black),
                title: "Not memorized yet"),
            PieChartSectionData(value: widget.memorizedLength.toDouble(), color: Colors.green, title: "Memorized!")
          ]),
    );
  }
}

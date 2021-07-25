import 'package:flutter/material.dart';
import 'package:memorize/models/graph_data.dart';
import 'package:memorize/routing/app_state.dart';
import 'package:memorize/shared/const.dart';

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
      alignment: Alignment.bottomCenter,
      height: MediaQuery.of(context).size.height * .9,
      child: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: .9),
        children: [
          OptionCard(
            color: Colors.black,
            onTap: () {
              widget.appState.memory = widget.appState.memoryAdapter!.collection!.first;
            },
            body: Text(
              'Quiz',
              style: TextStyle(color: Colors.white, fontSize: Constants.detailPageTextSize),
            ),
          ),
          OptionCard(
              onTap: () {
                widget.appState.graphData = GraphData();
              },
              color: Colors.green,
              body: Text(
                'Progress',
                style: TextStyle(fontSize: Constants.detailPageTextSize),
              )),
          OptionCard(
              onTap: () {
                widget.appState.memoryStatus = MemoryStatus.Edit;
              },
              color: Colors.red,
              body: Text(
                'Edit',
                style: TextStyle(fontSize: Constants.detailPageTextSize),
              )),
          OptionCard(
            color: Colors.black,
            onTap: () {
              // widget.appState.memoryStatus = MemoryStatus.Edit;
              //create a hash of the collection id and call native share function
            },
            body: Text(
              'Share',
              style: TextStyle(color: Colors.white, fontSize: Constants.detailPageTextSize),
            ),
          ),
        ],
      ),
    );
  }
}

class OptionCard extends StatelessWidget {
  const OptionCard({Key? key, required this.onTap, required this.body, required this.color}) : super(key: key);

  final Widget body;
  final Function onTap;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        width: MediaQuery.of(context).size.width * .5,
        child: Card(
          color: color,
          elevation: 3,
          child: Center(child: body),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:memorize/custom/flip_card.dart';
import 'package:memorize/routing/app_state.dart';
import 'package:memorize/models/memory.dart';

class CardsPage extends StatefulWidget {
  final AppState appState;
  const CardsPage({required this.appState, Key? key}) : super(key: key);

  @override
  _CardsPageState createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  ScrollController controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    Memory? _memory = widget.appState.memory;

    return Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            if (_memory != null) ...[
              Container(
                height: MediaQuery.of(context).size.height * .8,
                child: FlipCard(
                  memory: _memory!,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                      onPressed: () {
                        nextCard(true);
                      },
                      child: Text('Got it!')),
                  OutlinedButton(
                      onPressed: () {
                        nextCard(false);
                      },
                      child: Text("Didn't get it :("))
                ],
              )
            ] else ...[
              IconButton(
                onPressed: null,
                icon: Icon(Icons.celebration),
                iconSize: 60,
              ),
              Center(
                  heightFactor: 20,
                  child: Text(
                    'Quiz finished!!!',
                  )),
            ],
          ],
        ));
  }

  void nextCard(bool isCorrect) {
    widget.appState.getNewMemory(isCorrect);
  }
}

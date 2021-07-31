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
  int score = 0;
  int total = 0;

  @override
  void initState() {
    super.initState();
    total = widget.appState.memoryAdapter!.collection!.length;
  }

  @override
  Widget build(BuildContext context) {
    Memory? _memory = widget.appState.memory;
    if (!widget.appState.isEndOfQuiz())
      widget.appState.memoryAdapter!.collection!.forEach((element) {
        if (element.isMemorized) {
          score++;
        }
      });

    return Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            if (!widget.appState.isEndOfQuiz()) ...[
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
                icon: Icon(
                  Icons.celebration,
                  color: Colors.deepPurple,
                ),
                iconSize: 100,
                color: Colors.deepPurple,
              ),
              Center(
                  heightFactor: 20,
                  child: Text(
                    'Quiz finished!!!',
                  )),
              CircularProgressIndicator(
                strokeWidth: 50,
                value: score / total,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                color: Colors.black54,
                backgroundColor: Colors.blue,
              )
            ],
          ],
        ));
  }

  @override
  void dispose() {
    widget.appState.resetQuiz();
    super.dispose();
  }

  void nextCard(bool isCorrect) {
    widget.appState.getNewMemory(isCorrect);
  }
}

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
    Memory _memory = widget.appState.memory ?? Memory(value: 'Nothing yet', key: 'Nothing yet');
    return Container(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        controller: controller,
        itemCount: 2,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * .8,
                child: FlipCard(
                  memory: _memory,
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
            ],
          ),
        ),
      ),
    );
  }

  void nextCard(bool isCorrect) {
    widget.appState.getNewMemory(isCorrect);
  }
}

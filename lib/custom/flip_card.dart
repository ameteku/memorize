import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart' as CustomFlip;
import 'package:memorize/models/memory.dart';

class FlipCard extends StatefulWidget {
  Memory memory;

  FlipCard({required this.memory, Key? key}) : super(key: key);

  @override
  _FlipCardState createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> {
  bool showDetail = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showDetail = !showDetail;
        });
      },
      child: CustomFlip.FlipCard(
        controller: FlipCardController(),
        back: Card(
          child: Center(
            child: Text(widget.memory.key),
          ),
        ),
        front: Card(
          child: Center(
            child: Text(widget.memory.value),
          ),
        ),
      ),
    );
  }
}

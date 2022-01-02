import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memorize/custom/graph.dart';
import 'package:memorize/models/quiz.dart';
import 'package:memorize/repositories/quiz_repo.dart';
import 'package:memorize/routing/app_state.dart';

class ProgressPage extends StatefulWidget {
  final AppState appState;

  const ProgressPage({required this.appState, Key? key}) : super(key: key);

  @override
  _ProgressPageState createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  late final List<Quiz> taken;
  late QuizRepo quizRepo;
  List<String> memorized = [];
  List<String> notMemorized = [];

  @override
  void initState() {
    quizRepo = QuizRepo();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: quizRepo.getAllMemoryQuizzes(widget.appState.currentUser!.id!, widget.appState.memoryAdapter!.id!),
        builder: (context, AsyncSnapshot<List<Quiz>> snapshot) {
          if (snapshot.hasData && snapshot.data!.length != 0) {
            return Container(
              child: ListView(
                children: [
                  Row(
                      children: List.generate(
                          snapshot.data!.length,
                          (index) => IconButton(
                              onPressed: () {
                                setState(() {
                                  Quiz selectedQuiz = snapshot.data![index];
                                  memorized = selectedQuiz.quizResult.entries.where((element) => element.value).map((e) => e.key).toList();
                                  notMemorized =
                                      selectedQuiz.quizResult.entries.where((element) => !element.value).map((e) => e.key).toList();
                                });
                              },
                              icon: Icon(Icons.edit)))),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Graph(
                      memoryAdapter: widget.appState.memoryAdapter!,
                      memorizedLength: memorized.length,
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
                              title: Text(memorized[index]),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(border: Border(left: BorderSide(color: Colors.black))),
                          width: MediaQuery.of(context).size.width / 2,
                          child: ListView.builder(
                            itemCount: notMemorized.length,
                            itemBuilder: (context, index) => ListTile(
                              title: Text(notMemorized[index]),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          } else {
            return Text("Take a quiz to in order to view your results here");
          }
        });
  }
}

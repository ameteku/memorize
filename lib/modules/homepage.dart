import 'package:flutter/material.dart';
import 'package:memorize/models/memory_adapter.dart';
import 'package:memorize/repositories/memory_adapter_repo.dart';
import 'package:memorize/routing/app_state.dart';

//main page has a list of  old topics
//a button to add a new topic,
//on tapping a topic, it takes you to the detail page with 3 options(view progress, take quiz, add new memories
//on take quiz, a flip card + two buttons, on tapping a button, the a new card is displayed,
// at the end of the list of cards, ask user to restart
//
class HomePage extends StatefulWidget {
  final AppState appState;
  const HomePage({required this.appState, Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MemoryAdapterRepo adapterRepo = MemoryAdapterRepo();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MemoryAdapter>>(
        stream: adapterRepo.getAllAdapters(widget.appState.currentUser!.id!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<MemoryAdapter> adapters = snapshot.data!;
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: GridView.count(
                children: [
                  ...adapters.map((e) {
                    MemoryAdapter selectedAdapter = e;
                    return MemoryCollectionCard(selectedAdapter.name!, () {
                      widget.appState.memoryAdapter = selectedAdapter;
                    }, longPress: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          actions: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      adapterRepo.deleteAdapter(selectedAdapter.id!);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.close,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    });
                  }),
                  MemoryCollectionCard("+\n New Collection", () {
                    widget.appState.memoryStatus = MemoryStatus.New;
                  }, color: Colors.blue)
                ],
                crossAxisCount: 2,
              ),
            );
          } else {
            return Center(
              child: Text('Nothing Yet'),
            );
          }
        });
  }

  Widget MemoryCollectionCard(String title, VoidCallback onTouch, {Color color = Colors.white, VoidCallback? longPress}) {
    return GestureDetector(
        onLongPress: longPress ?? () {},
        onTap: onTouch,
        child: Card(
          color: color,
          child: Container(
              height: 40,
              width: 40,
              child: Center(
                  child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25),
              ))),
        ));
  }
}

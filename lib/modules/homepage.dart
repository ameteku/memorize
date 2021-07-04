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
            return ListView.builder(
              itemCount: adapters.length,
              itemBuilder: (context, index) {
                MemoryAdapter selectedAdapters = adapters[index];
                return GestureDetector(
                  onTap: () {
                    widget.appState.memoryAdapter = selectedAdapters;
                  },
                  child: ListTile(
                    title: Text(selectedAdapters.name ?? "French Memory"),
                    leading: Icon(Icons.backup_rounded),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text('Nothing Yet'),
            );
          }
        });
  }
}

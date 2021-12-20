//import 'dart:html';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:memorize/models/memory.dart';
import 'package:memorize/models/memory_adapter.dart';
import 'package:memorize/repositories/memory_adapter_repo.dart';
import 'package:memorize/routing/app_state.dart';

class NewMemoryPage extends StatefulWidget {
  AppState appState;
  NewMemoryPage({required this.appState, Key? key}) : super(key: key);

  @override
  _NewMemoryPageState createState() => _NewMemoryPageState();
}

MemoryAdapterRepo _memoryAdapterRepo = MemoryAdapterRepo();

class _NewMemoryPageState extends State<NewMemoryPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  TextEditingController? titleController;
  FilePickerResult? spreadsheetFile;
  String memoryName = "";

  //index corresponds to the index of memory
  //this has a list of (2 index lists)
  List<List<TextEditingController>> controllers = [];
  List<Widget> memories = [];
  int totalMemories = 1;
  late double width;
  @override
  void initState() {
    super.initState();

    if (widget.appState.memoryStatus == MemoryStatus.Edit) {
      totalMemories = widget.appState.memoryAdapter!.collection!.length;
      for (Memory e in widget.appState.memoryAdapter!.collection!) {
        controllers.add([TextEditingController(text: e.value), TextEditingController(text: e.key)]);
      }
      // memories = widget.appState.memoryAdapter!.collection!.map((e) => newMemoryEntry(memories.length, e: e)).toList();
    }
    titleController = TextEditingController();
    titleController?.text = widget.appState.memoryAdapter?.name ?? memoryName;
  }

  //this creates new pair of controllers, first for the key and second for the value
  // and then adds this pair to the list of pairs created for later disposal
  List<TextEditingController> addController() {
    List<TextEditingController> pair = [];
    pair.add(TextEditingController());
    pair.add(TextEditingController());

    controllers.add(pair);
    return pair;
  }

  @override
  void dispose() {
    for (List<TextEditingController> controllerPair in controllers) {
      for (TextEditingController controller in controllerPair) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * .86,
                  child: TextFormField(
                    controller: titleController,
                    validator: (value) {
                      if (value == null || value == '') {
                        return 'Please enter the Memory title';
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Memory Title',
                      hintText: "eg.French words",
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDatePicker();
                  },
                  icon: Icon(Icons.calendar_today),
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            ...List.generate(totalMemories, (index) {
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 2.0),
                          child: SizedBox(
                            width: width * 0.45,
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'Key',
                              ),
                              controller: controllers[index][0],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: width * 0.4,
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Answer',
                            ),
                            controller: controllers[index][1],
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            controllers.removeAt(index);
                            totalMemories--;
                          });
                        },
                        icon: Icon(
                          Icons.restore_from_trash,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                    onPressed: () {
                      //memories.add(newMemoryEntry(memories.length));
                      print("Added entry: length: ${memories.length}");
                      setState(() {
                        addController();
                        totalMemories++;
                      });
                    },
                    child: Text('Add Entry')),
                OutlinedButton(
                  onPressed: () {
                    //if non are empty save all but if some are empty notify user
                    if (titleController?.text == '') displayEmptyFieldDialog(context);

                    for (var pair in controllers) {
                      if (pair[0].text == '' || pair[1].text == '') {
                        displayEmptyFieldDialog(context);
                        return;
                      }
                    }
                    //after checking then add them all
                    //a new object for each memory has to be created, passed into a new memory adapter object
                    // and upload that memory adapter to firestore and possibly a local json storage
                    List<Memory> allMemories = [];
                    for (var pair in controllers) {
                      Memory temp = Memory(key: pair[0].text, value: pair[1].text);
                      allMemories.add(temp);
                    }
                    //this saves the new adapter
                    if (widget.appState.memoryStatus == MemoryStatus.New) {
                      print('Adding adapter');

                      _memoryAdapterRepo.addAdapter(
                          MemoryAdapter(name: titleController?.text, collection: allMemories, username: widget.appState.currentUser!.id!));
                    } else {
                      print('Updating adapter');
                      widget.appState.memoryAdapter!.collection = allMemories;
                      _memoryAdapterRepo.updateAdapter(widget.appState.memoryAdapter!);
                    }
                    widget.appState.memoryStatus = null;
                  },
                  child: Text('Save'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  showDatePicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Deadline",
          textAlign: TextAlign.center,
        ),
        actions: [
          Column(
            children: [
              InputDatePickerFormField(
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 367)),
                fieldLabelText: 'Pick an estimated time you want to learn this by',
              ),
              Center(
                child: OutlinedButton(
                  onPressed: () {},
                  child: Text("Use Date"),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Future<dynamic> displayEmptyFieldDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Some fields have not been filled, remove them or fill them to save'),
      ),
    );
  }

  Widget newMemoryEntry(int id, {Memory? e}) {
    List<TextEditingController> newEditors = addController();

    if (e != null) {
      newEditors[0].text = e.key;
      newEditors[1].text = e.value;
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 2.0),
                child: SizedBox(
                  width: width * 0.45,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Key',
                    ),
                    controller: newEditors[0],
                  ),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                width: width * 0.4,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Answer',
                  ),
                  controller: newEditors[1],
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                controllers.removeAt(id);
                setState(() {
                  memories.removeAt(id);
                });
              },
              icon: Icon(
                Icons.restore_from_trash,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:memorize/custom/extractData.dart';
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
  String memoryName = 'My New Memory Collection';

  //index corresponds to the index of memory
  //this has a list of (2 index lists)
  List<List<TextEditingController>> controllers = [];
  List<Widget> memories = [];
  late double width;
  @override
  void initState() {
    super.initState();

    titleController = TextEditingController();
    titleController?.text = widget.appState.memoryAdapter!.name ?? memoryName;
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
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    if (widget.appState.memoryStatus == MemoryStatus.Edit && memories.isEmpty) {
      memories = widget.appState.memoryAdapter!.collection!.map((e) => newMemoryEntry(e: e)).toList();
    }
    if (memories.length == 0) {
      //add initial memory entry
      memories.add(newMemoryEntry());
    }
    return SingleChildScrollView(
      child: Container(
          height: MediaQuery.of(context).size.height,
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  validator: (value) {
                    if (value == null || value == '') {
                      return 'Please enter the Memory title';
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Memory Title',
                  ),
                ),
                InputDatePickerFormField(
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 367)),
                  fieldLabelText: 'Pick your Deadline',
                  initialDate: DateTime.now().add(Duration(days: 10)),
                ),
                for (dynamic mem in memories) mem,
                Row(
                  children: [
                    OutlinedButton(
                        onPressed: () {
                          memories.add(newMemoryEntry());
                          print("Added entry: length: ${memories.length}");
                          setState(() {});
                        },
                        child: Text('Add Entry')),
                    OutlinedButton(
                      onPressed: () {
                        //if non are empty save all but if some are empty notify user
                        if (titleController?.text == '') displayEmptyFieldDialog(context);

                        for (var pair in controllers) {
                          if (pair[0].text == '' || pair[1].text == '') {
                            displayEmptyFieldDialog(context);
                            break;
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

                          _memoryAdapterRepo.addAdapter(MemoryAdapter(
                              name: titleController?.text, collection: allMemories, username: widget.appState.currentUser!.id!));
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
          )),
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

  Widget newMemoryEntry({Memory? e}) {
    List<TextEditingController> newEditors = addController();

    if (e != null) {
      newEditors[0].text = e.key;
      newEditors[1].text = e.value;
    }

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: width * 0.45,
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'title',
                ),
                controller: newEditors[0],
              ),
            ),
            SizedBox(
              width: width * 0.4,
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'answer',
                ),
                controller: newEditors[1],
              ),
            ),
            IconButton(
              onPressed: () {},
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

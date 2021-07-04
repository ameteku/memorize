import 'package:flutter/cupertino.dart';
import 'package:memorize/models/graph_data.dart';
import 'package:memorize/models/memory.dart';
import 'package:memorize/models/memory_adapter.dart';
import 'package:memorize/models/user.dart';

class AppState extends ChangeNotifier {
  MemoryAdapter? _memoryAdapter;
  Memory? _memory;
  GraphData? _graphData;
  bool _newMemory = false;
  User? _currentUser;

  set currentUser(User? user) {
    _currentUser = user;
    notifyListeners();
  }

  User? get currentUser => _currentUser;

  MemoryAdapter? get memoryAdapter => _memoryAdapter;
  set memoryAdapter(MemoryAdapter? memoryAdapter) {
    _memoryAdapter = memoryAdapter;
    notifyListeners();
  }

  Memory? get memory => _memory;
  set memory(Memory? mem) {
    _memory = mem;
    notifyListeners();
  }

  GraphData? get graphData => _graphData;
  set graphData(GraphData? graphData) {
    _graphData = graphData;
    notifyListeners();
  }

  bool get newMemoryAdapter => _newMemory;
  set newMemoryAdapter(bool show) {
    _newMemory = show;
    notifyListeners();
  }

  //this updates the current memory and replsces the old memory with
  // a new memory to the memory
  void getNewMemory(bool answer) {
    //update date for
    _memory?.isAnswered = true;
    _memory?.isMemorized = answer;
    _memory = _memoryAdapter?.collection?.firstWhere((element) => element.isAnswered == false);

    if (_memory == null) {
      _memory = _memoryAdapter?.collection?.first;
      notifyListeners();

      //this is resetting th equiz
      _memoryAdapter?.collection?.forEach((element) {
        element.isAnswered = false;
      });
    } else {
      notifyListeners();
    }
  }

  void managePop() {
    if (_graphData != null) {
      print("popping graphData");
      _graphData = null;
      notifyListeners();
      return;
    }

    if (_newMemory == true) {
      _newMemory = false;
      notifyListeners();
      return;
    }

    if (_memory != null) {
      print("popping memory");
      _memory = null;
      notifyListeners();
      return;
    }

    if (_memoryAdapter != null) {
      print("popping adapter");
      _memoryAdapter = null;
      notifyListeners();
      return;
    }
  }
}

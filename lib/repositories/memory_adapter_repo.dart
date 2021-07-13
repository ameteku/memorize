import 'package:memorize/models/memory_adapter.dart';
import 'package:memorize/repositories/base_repo.dart';
import 'package:memorize/models/memory.dart';

class MemoryAdapterRepo {
  String adapterPath = 'adapters';

  //add new adapter
  void addAdapter(MemoryAdapter adapter) {
    print('inside memory repo');
    BaseRepo.firestoreDbInstance().collection(adapterPath).add(adapter.toJson());
  }

  //add memory to adapter collection
  void appendMemories(MemoryAdapter adapter, List<Memory> memories) {
    adapter.addMemories(memories);
    BaseRepo.firestoreDbInstance().collection(adapterPath).doc(adapter.id).update(adapter.toJson());
  }

  // void updateMemory(String adapterId, String memoryId, Memory memory) {
  //   //List<Map<String,dynamic>> mems = memories.map((e) => e.toJson()).toList();
  //   BaseRepo.firestoreDbInstance().collection(adapterPath).doc(adapterId).get().then((value) {
  //     MemoryAdapter mem = MemoryAdapter.fromJson(value.data(), value.id);
  //     mem.collection.remove(memory.key);
  //   })update({'collection': mems});
  // }

  void removeMemory(String adapterId, Memory memory) {
    BaseRepo.firestoreDbInstance().doc(adapterId).get().then((value) {
      MemoryAdapter mem =MemoryAdapter.fromJson(value.data(), value.id)
          ..collection?.remove(memory.key);
      BaseRepo.firestoreDbInstance().doc(adapterId).update(mem.toJson());
    });
  }

  //delete memory
  void deleteAdapter(String id) {
    BaseRepo.firestoreDbInstance().doc(id).delete();
  }

  Stream<List<MemoryAdapter>> getAllAdapters(String userId) {
    // print("In main body of adapter stream");
    return BaseRepo.firestoreDbInstance().collection(adapterPath).where('username', isEqualTo: userId).snapshots().map((event) {
      // print("gotten adapter ${event.docs.first.data().toString()}");
      return event.docs.map((e) {
        // print("In getAllDapters" + e.data().toString());
        return MemoryAdapter.fromJson(e.data(), e.id);
      }).toList();
    });
  }
}

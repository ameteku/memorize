import 'package:memorize/models/memory.dart';
import 'package:json_annotation/json_annotation.dart';

part 'memory_adapter.g.dart';

@JsonSerializable()
class MemoryAdapter {
  String? id;
  String? name;
  List<Memory>? collection;
  String username;
  //GraphData? graphData;

  MemoryAdapter({this.collection, this.name, this.id, required this.username}) {
    //graphData = GraphData(memoryName: name, totalWords: collection?.length);
  }

  void appendMemory(Memory memory) => collection?.add(memory);

  void addMemories(List<Memory> memories) {
    collection?.addAll(memories);
  }

  factory MemoryAdapter.fromJson(Map<String, dynamic>? json, String id) {
    MemoryAdapter temp = _$MemoryAdapterFromJson(json!);
    temp.id = id;
    return temp;
  }

  //remember to call .toJson on collection in generated file after regeneration
  Map<String, dynamic> toJson() {
    return _$MemoryAdapterToJson(this);
  }

  @override
  String toString() {
    return 'MemoryAdapter{collection: $collection, user: $username}';
  }
}

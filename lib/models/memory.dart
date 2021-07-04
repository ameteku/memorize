import 'package:json_annotation/json_annotation.dart';

part 'memory.g.dart';

@JsonSerializable()
class Memory {
  String key;
  String value;
  bool isMemorized = false;
  bool isAnswered = false;

  Memory({required this.key, required this.value});

  Map<String, dynamic> toJson() {
    return _$MemoryToJson(this);
  }

  factory Memory.fromJson(Map<String, dynamic> json) {
    return _$MemoryFromJson(json);
  }

  @override
  String toString() => 'Memory{key : $key, value: $value';
}

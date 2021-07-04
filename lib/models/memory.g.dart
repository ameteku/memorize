// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Memory _$MemoryFromJson(Map<String, dynamic> json) {
  return Memory(
    key: json['key'] as String,
    value: json['value'] as String,
  )
    ..isMemorized = json['isMemorized'] as bool
    ..isAnswered = json['isAnswered'] as bool;
}

Map<String, dynamic> _$MemoryToJson(Memory instance) => <String, dynamic>{
      'key': instance.key,
      'value': instance.value,
      'isMemorized': instance.isMemorized,
      'isAnswered': instance.isAnswered,
    };

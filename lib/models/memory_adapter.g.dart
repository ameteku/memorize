// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory_adapter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemoryAdapter _$MemoryAdapterFromJson(Map<String, dynamic> json) {
  return MemoryAdapter(
    collection: (json['collection'] as List<dynamic>?)
        ?.map((e) => Memory.fromJson(e as Map<String, dynamic>))
        .toList(),
    name: json['name'] as String?,
    id: json['id'] as String?,
    username: json['username'] as String,
  );
}

Map<String, dynamic> _$MemoryAdapterToJson(MemoryAdapter instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'collection': instance.collection,
      'username': instance.username,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    id: json['id'] as String?,
    password: json['password'] as String,
    userName: json['userName'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'password': instance.password,
      'userName': instance.userName,
    };

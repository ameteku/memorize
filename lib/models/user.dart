import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String? id;
  String password;
  String userName;

  User({this.id, required this.password, required this.userName});

  @override
  String toString() {
    // TODO: implement toString
    return 'User{id: $id, passWord: $password, userName: $userName';
  }

  factory User.fromJson(Map<String, dynamic>? json, String id) {
    User temp = _$UserFromJson(json!);
    temp.id = id;
    return temp;
  }

  Map<String, dynamic> toJson() {
    return _$UserToJson(this);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memorize/models/user.dart';

import 'base_repo.dart';

class UserRepo extends BaseRepo {
  String collectionPath = 'User';

  Future<User?> getUser({required String username, required String password}) {
    return BaseRepo.firestoreDbInstance()
        .collection(collectionPath)
        .where('password', isEqualTo: password)
        .where('userName', isEqualTo: username)
        .get()
        .then((value) {
      dynamic temp = value.docs.first;
      if (temp != null) return User.fromJson(temp.data(), temp.id);
    });
  }

  Future<User?> addUser({required String username, required String password}) {
    return BaseRepo.firestoreDbInstance()
        .collection(collectionPath)
        .add(User(password: password, userName: username).toJson())
        .then((value) => value.get().then((value) => User.fromJson(value.data(), value.id)));
  }
}

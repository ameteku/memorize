import 'package:cloud_firestore/cloud_firestore.dart';

class BaseRepo {
  static FirebaseFirestore firestoreDbInstance() => FirebaseFirestore.instance;
}

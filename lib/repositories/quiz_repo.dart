import 'package:memorize/models/quiz.dart';
import 'package:memorize/repositories/base_repo.dart';

class QuizRepo extends BaseRepo {
  String quizPath = 'quizzesTaken';
  String userPath = "User";

  //add new adapter
  void addQuiz(Quiz quiz, String userId) {
    print('inside memory repo');
    BaseRepo.firestoreDbInstance().collection(userPath).doc(userId).collection(quizPath).add(quiz.toJson());
  }

  //add memory to adapter collection
  void updateQuiz(Quiz quiz, String userId) {
    BaseRepo.firestoreDbInstance().collection(userPath).doc(userId).collection(quizPath).doc(quiz.id).update(quiz.toJson());
  }

  // void updateMemory(String adapterId, String memoryId, Memory memory) {
  //   //List<Map<String,dynamic>> mems = memories.map((e) => e.toJson()).toList();
  //   BaseRepo.firestoreDbInstance().collection(adapterPath).doc(adapterId).get().then((value) {
  //     MemoryAdapter mem = MemoryAdapter.fromJson(value.data(), value.id);
  //     mem.collection.remove(memory.key);
  //   })update({'collection': mems});
  // }

  //delete memory
  void deleteQuiz(String quizId) {
    BaseRepo.firestoreDbInstance().collection(quizPath).doc(quizId).delete();
  }

  Stream<List<Quiz>> getAllMemoryQuizzes(String userId, String memoryId) {
    // print("In main body of adapter stream");
    return BaseRepo.firestoreDbInstance()
        .collection(userPath)
        .doc(userId)
        .collection(quizPath)
        .where("memoryId", isEqualTo: memoryId)
        .snapshots()
        .map((event) {
      print("gotten adapter ${event.docs.first.data().toString()}");
      return event.docs.map((e) {
        Quiz? temp;
        try {
          temp = Quiz.fromJson(e.data(), e.id);
        } catch (e, trace) {
          print("error" + e.toString());
        }
        print(temp);
        return temp!;
      }).toList();
    });
  }
}

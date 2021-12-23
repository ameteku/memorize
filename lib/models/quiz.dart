import 'package:json_annotation/json_annotation.dart';

part "quiz.g.dart";

@JsonSerializable()
class Quiz {
  @JsonKey()
  late String id;
  String memoryId;
  Map<int, int> quizResult;
  String takerId;

  Quiz(this.memoryId, this.quizResult, this.takerId);

  factory Quiz.fromJson(Map<String, dynamic> json, String id) {
    return _$QuizFromJson(json)..id = id;
  }

  Map<String, dynamic> toJson() => _$QuizToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part "quiz.g.dart";

@JsonSerializable()
class Quiz {
  @JsonKey(ignore: true)
  String? id;
  String memoryId;
  Map<String, bool> quizResult;
  String takerId;

  Quiz(this.memoryId, this.quizResult, this.takerId);

  factory Quiz.fromJson(Map<String, dynamic> json, String id) {
    return _$QuizFromJson(json)..id = id;
  }

  Map<String, dynamic> toJson() => _$QuizToJson(this);
}

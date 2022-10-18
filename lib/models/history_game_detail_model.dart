import 'dart:convert';

import 'package:acakkata/models/word_language_model.dart';

class HistoryGameDetailModel {
  String? id;
  List<String>? questionWord;
  String? answerWord; // asnwer from player, if timeout value is null
  int? statusAnswer; // 1 => correct; 0 => wrong
  int? remainingTime; // remaining time answer question
  WordLanguageModel?
      correctAnswerByUser; // answer may related (answered by user)
  List<WordLanguageModel>? listWords;

  HistoryGameDetailModel(
      {this.id,
      this.questionWord,
      this.answerWord,
      this.correctAnswerByUser,
      this.listWords,
      this.remainingTime,
      this.statusAnswer});

  String toRawJson() => json.encode(toJson);

  HistoryGameDetailModel.fromJson(Map<String, dynamic> data) {
    id = (data['_id'] ?? data['id'].toString());
    questionWord = json
        .decode(data['questionWord'].toString())
        .map<String>((item) => item.toString())
        .toList();
    answerWord = data['answerWord'];
    correctAnswerByUser =
        WordLanguageModel.fromJson(data['correctAnswerByUser']);
    listWords =
        data['listWords'].map((e) => WordLanguageModel.fromJson(e)).toList();
    remainingTime = data['remainingTime'];
    statusAnswer = data['statusAnswer'];
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "questionWord": json.encode(questionWord),
        "answerWord": answerWord,
        "correctAnswerByUser": correctAnswerByUser!.toJson(),
        "listWords": json.encode(listWords),
        "remainingTime": remainingTime,
        "statusAnswer": statusAnswer
      };
}

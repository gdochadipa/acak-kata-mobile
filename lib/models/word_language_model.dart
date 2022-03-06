import 'dart:convert';

import 'dart:math';

class WordLanguageModel {
  String? id;
  String? word;
  List<String>? word_suffle;
  String? word_hint;

  WordLanguageModel(
      {int? id, String? word, String? word_hint, List<String>? word_suffle});

  String toRawJson() => json.encode(toJson());

  WordLanguageModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    List<String> listSuffle = json['word'].toUpperCase().split("");
    if (listSuffle.length > 0) {
      var randm = Random();
      listSuffle.shuffle(randm);
      word_suffle = listSuffle;
    }
    word = json['word'];
    word_hint = json['meaning'] ?? "kosong";
  }

  Map<String, dynamic> toJson() =>
      {"id": id, "word": word, "word_hint": word_hint};
}

import 'dart:convert';

import 'dart:math';

class WordLanguageModel {
  String? id;
  String? word;
  List<String>? word_suffle;
  String? word_hint;
  int? length_word;

  WordLanguageModel(
      {this.id, this.word, this.word_hint, this.word_suffle, this.length_word});

  String toRawJson() => json.encode(toJson());

  WordLanguageModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    List<String> listSuffle = json['word'].toUpperCase().split("");
    if (listSuffle.isNotEmpty) {
      var randm = Random();
      listSuffle.shuffle(randm);
      word_suffle = listSuffle;
    }
    word = json['word'];
    word_hint = json['meaning'] ?? "kosong";
    length_word = json['length_word'];
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "word": word,
        "meaning": word_hint,
        "length_word": length_word
      };
}

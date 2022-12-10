import 'dart:convert';

import 'dart:math';

class WordLanguageModel {
  String? id;
  String? word;
  List<String>? word_suffle;
  String? word_hint;
  int? length_word;
  int? id_relation;

  WordLanguageModel(
      {this.id,
      this.word,
      this.word_hint,
      this.word_suffle,
      this.length_word,
      this.id_relation});

  String toRawJson() => json.encode(toJson());

  WordLanguageModel.fromJson(Map<String, dynamic> json) {
    id = (json['_id'] ?? json['id'].toString());
    List<String> listSuffle = json['word'].toUpperCase().split("");
    if (listSuffle.isNotEmpty) {
      var randm = Random();
      listSuffle.shuffle(randm);
      word_suffle = listSuffle;
    }
    word = json['word'];
    word_hint = json['meaning'] ?? "kosong";
    length_word = json['length_word'];
    id_relation = json['id_relation'];
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "word": word,
        "meaning": word_hint,
        "length_word": length_word,
        "id_relation": id_relation
      };
}

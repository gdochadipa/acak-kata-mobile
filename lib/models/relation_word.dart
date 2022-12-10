import 'dart:convert';

import 'package:acakkata/models/word_language_model.dart';

class RelationWordModel {
  String? id;
  String? word;
  int? length_word;
  List<String>? letter;
  int? count_word;
  int? language_id;
  List<WordLanguageModel>? listWords;

  RelationWordModel(
      {this.id,
      this.word,
      this.length_word,
      this.letter,
      this.count_word,
      this.language_id});

  String toRawJson() => json.encode(toJson);

  RelationWordModel.fromJson(Map<String, dynamic> data) {
    id = (data['_id'] ?? data['id'].toString());
    word = data['word'];
    length_word = data['length_word'];
    letter = data['word'].toUpperCase().split("");
    count_word = data['count_word'];
    language_id = data['language_id'];
    List<dynamic> words = json.decode(data['word_related']);
    listWords = words.map((e) => WordLanguageModel.fromJson(e)).toList();
    // List<String>
  }

  void wordQuestion(List<dynamic> data) {
    listWords = data
        .map((e) => WordLanguageModel(
            id: e['id'].toString(),
            id_relation: e['id_relation'],
            length_word: e['length_word'],
            word: e['word'],
            word_hint: e['meaning']))
        .toList();
  }

  void wordQuestionList() {}

  Map<String, dynamic> toJson() => {
        "id": id,
        "word": word,
        "length_word": length_word,
        "letter": letter,
        "count_word": count_word,
        "language_id": language_id,
        "list_words": json.encode(listWords)
      };
}

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
    letter = json
        .decode(data['letter'].toString())
        .map<String>((item) => item.toString().toUpperCase())
        .toList();
    count_word = data['count_word'];
    language_id = data['language_id'];
    // List<String>
  }

  RelationWordModel.wordQuestion(
      List<Map<String, dynamic>> data, RelationWordModel relationWordModel) {
    listWords = data.map((e) => WordLanguageModel.fromJson(e)).toList();
  }

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

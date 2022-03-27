import 'package:acakkata/models/user_model.dart';
import 'package:logger/logger.dart';

class LevelModel {
  int? id;
  String? level_name;
  int? level_words;
  int? level_time;
  int? level_question_count;

  LevelModel(
      {this.id,
      this.level_name,
      this.level_words,
      this.level_time,
      this.level_question_count});

  LevelModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    level_name = json['level_name'];
    level_words = json['level_words'];
    level_time = json['level_time'];
    level_question_count = json['level_question_count'];
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'level_name': level_name,
      'level_words': level_words,
      'level_time': level_time,
      'level_question_count': level_question_count
    };
  }
}

class UninitializedLevelModel extends LevelModel {}

import 'package:acakkata/models/user_model.dart';
import 'package:logger/logger.dart';

class LevelModel {
  int? id;
  String? level_name;
  int? level_words;
  int? level_time;
  int? level_question_count;
  String? level_lang_id;
  String? level_lang_code;
  int? is_unlock;
  int? current_score;
  int? target_score;

  LevelModel(
      {this.id,
      this.level_name,
      this.level_words,
      this.level_time,
      this.level_question_count,
      this.level_lang_id,
      this.level_lang_code,
      this.is_unlock,
      this.current_score,
      this.target_score});

  LevelModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    level_name = json['level_name'];
    level_words = json['level_words'];
    level_time = json['level_time'];
    level_question_count = json['level_question_count'];
    level_lang_id = json['level_lang_id'];
    level_lang_code = json['level_lang_code'];
    is_unlock = json['is_unlock'];
    current_score = json['current_score'];
    target_score = json['target_score'];
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'level_name': level_name,
      'level_words': level_words,
      'level_time': level_time,
      'level_question_count': level_question_count,
      'level_lang_id': level_lang_id,
      'level_lang_code': level_lang_code,
      'is_unlock': is_unlock,
      'current_score': current_score,
      'target_score': target_score
    };
  }
}

class UninitializedLevelModel extends LevelModel {}

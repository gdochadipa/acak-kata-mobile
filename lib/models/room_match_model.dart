import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/models/room_match_detail_model.dart';

class RoomMatchModel {
  String? id;
  int? language_id;
  String? room_code;
  String? channel_code;
  int? status_game;
  DateTime? datetime_match;
  int? totalQuestion;
  int? length_word;
  int? time_match;
  int? max_player;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<String>? room_match_detail_id;
  List<RoomMatchDetailModel>? room_match_detail;
  LanguageModel? language;

  RoomMatchModel(
      {this.id,
      this.language_id,
      this.room_code,
      this.channel_code,
      this.status_game,
      this.datetime_match,
      this.totalQuestion,
      this.length_word,
      this.time_match,
      this.max_player,
      this.createdAt,
      this.updatedAt,
      this.room_match_detail_id,
      this.room_match_detail,
      this.language});

  RoomMatchModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];

    language = json['language'] == null || json['language'] == 'null'
        ? UninitializedLanguageModel()
        : LanguageModel.fromJson(json['language']);

    room_code = json['room_code'];
    channel_code = json['channel_code'];
    status_game = int.parse('${json['status_game'] ?? 0}');
    time_match = json['time_match'];
    datetime_match = DateTime.parse(json['datetime_match'].toString());
    totalQuestion = int.parse('${json['total_question'] ?? 0}');
    length_word = json['length_word'];
    max_player = int.parse('${json['max_player'] ?? 0}');
    createdAt = DateTime.parse(json['createdAt'].toString());
    updatedAt = DateTime.parse(json['updatedAt'].toString());
    room_match_detail = json['room_match_detail']
            .map<RoomMatchDetailModel>(
                (match_detail) => RoomMatchDetailModel.fromJson(match_detail))
            .toList() ??
        [];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'language_id': language?.id,
      'language': language,
      'room_code': room_code,
      'channel_code': channel_code,
      'status_game': status_game,
      'time_match': time_match,
      'max_player': max_player,
      'time_start': datetime_match.toString(),
      'room_match_detail':
          room_match_detail!.map((detail) => detail.toJson()).toList(),
      'created_at': createdAt.toString(),
      'updated_at': updatedAt.toString(),
    };
  }
}

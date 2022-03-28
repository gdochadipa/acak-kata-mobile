import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/models/room_match_detail_model.dart';

class RoomMatchModel {
  String? id;
  int? language_id;
  String? room_code;
  String? channel_code;
  int? status_game;
  DateTime? time_start;
  int? totalQuestion;
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
      this.time_start,
      this.totalQuestion,
      this.time_match,
      this.max_player,
      this.createdAt,
      this.updatedAt,
      this.room_match_detail_id,
      this.room_match_detail,
      this.language});

  RoomMatchModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];

    language = json['language_id'] == null || json['language_id'] == 'null'
        ? UninitializedLanguageModel()
        : LanguageModel.fromJson(json['language_id']);
    room_code = json['room_code'];
    channel_code = json['channel_code'];
    status_game = int.parse('${json['status_game'] ?? 0}');
    time_match = int.parse('${json['time_match'] ?? 0}');
    time_start = DateTime.parse('${json['time_start']}');
    totalQuestion = int.parse('${json['total_question'] ?? 0}');
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
      'time_start': time_start.toString(),
      'room_match_detail':
          room_match_detail!.map((detail) => detail.toJson()).toList(),
      'created_at': createdAt.toString(),
      'updated_at': updatedAt.toString(),
    };
  }
}

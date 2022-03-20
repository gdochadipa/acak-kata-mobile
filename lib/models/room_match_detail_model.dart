import 'dart:developer';

import 'package:acakkata/models/user_model.dart';

class RoomMatchDetailModel {
  String? id;
  String? player_id;
  int? is_host;
  int? score;
  int? is_ready;
  int? status_player;
  UserModel? player;

  RoomMatchDetailModel(this.id, this.player_id, this.is_host, this.score,
      this.is_ready, this.status_player, this.player);

  RoomMatchDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    score = int.parse('${json['score'] ?? 0}');
    status_player = json['status_player'];
    is_host = json['is_host'];
    is_ready = json['is_ready'];
    status_player = json['status_player'];
    if (json['player_id'] is String) {
      log('is String');
      player_id = json['player_id'];
      player = player = json['player'].isEmpty
          ? UninitializedUserModel()
          : UserModel.fromJson(json['player']);
    } else {
      player = json['player_id'].isEmpty
          ? UninitializedUserModel()
          : UserModel.fromJson(json['player_id']);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'score': score,
      'player_id': player?.id,
      'player': player!.toJson(),
      'is_host': is_host,
      'is_ready': is_ready,
      'status_player': status_player
    };
  }
}

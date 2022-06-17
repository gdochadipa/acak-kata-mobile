
import 'package:acakkata/models/user_model.dart';

class RoomMatchDetailModel {
  String? id;
  String? player_id;
  int? is_host;
  int? score;

  ///
  /// 0 is not ready
  /// 1 is ready
  ///
  int? is_ready;

  ///
  /// 0 is not ready
  /// 1 is ready but not receive question
  /// 2 is receive question
  /// 3 is game done
  /// 4 is player out from room
  ///
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
    player_id = json['player_id'];
    player = json['player'].isEmpty
        ? UninitializedUserModel()
        : UserModel.fromJson(json['player']);
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'score': score,
      'player_id': player?.id,
      'player': player!.toJson(),
      'is_host': is_host,
      'is_ready': is_ready,
      'status_player': status_player
    };
  }
}

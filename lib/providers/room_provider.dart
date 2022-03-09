import 'package:acakkata/models/room_match_model.dart';
import 'package:flutter/material.dart';

class RoomProvider with ChangeNotifier {
  RoomMatchModel? _roomMatch;
  RoomMatchModel? get roomMatch => _roomMatch;
}

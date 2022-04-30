import 'dart:developer';

import 'package:acakkata/models/room_match_detail_model.dart';
import 'package:acakkata/models/room_match_model.dart';
import 'package:acakkata/models/word_language_model.dart';
import 'package:acakkata/service/room_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoomProvider with ChangeNotifier {
  RoomMatchModel? _roomMatch;
  RoomMatchModel? get roomMatch => _roomMatch;

  List<RoomMatchDetailModel>? get listRoommatchDet =>
      _roomMatch!.room_match_detail;

  late int _numberCountDown;
  late int _totalQuestion;
  late int _maxPlayer;

  List<WordLanguageModel>? _listQuestion;
  List<WordLanguageModel>? get listQuestion => _listQuestion;

  List<int>? _queueQuestion;
  List<int>? get queueQuestion => _queueQuestion;

  int get numberCountDown => _numberCountDown;
  int get totalQuestion => _totalQuestion;
  int get maxPlayer => _maxPlayer;

  set roomMatch(RoomMatchModel? roomMatch) {
    _roomMatch = roomMatch;
    notifyListeners();
  }

  Future<bool> createRoom(
      {String? language_code,
      int? max_player,
      int? time_watch,
      int? total_question,
      DateTime? datetime_match,
      int? level}) async {
    try {
      _maxPlayer = max_player ?? 2;
      _numberCountDown = time_watch ?? 15;
      _totalQuestion = total_question ?? 15;
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString('token');
      RoomMatchModel roomMatchModel = await RoomService().createRoom(
          language_code!,
          time_watch!,
          max_player!,
          total_question!,
          token!,
          datetime_match!,
          level!);
      _roomMatch = roomMatchModel;

      return true;
    } catch (e) {
      throw Exception(e);
      return false;
    }
  }

  Future<bool> findRoomWithCode(String? language_id, String? room_code) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString('token');
      RoomMatchModel roomMatchModel = await RoomService()
          .findRoomWithCode(language_id!, token!, room_code!);
      _roomMatch = roomMatchModel;
      return true;
    } catch (e) {
      throw Exception(e);
      return false;
    }
  }

  Future<bool> checkingRoomWithCode(
      String? language_id, String? room_code) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString('token');
      RoomMatchModel roomMatchModel = await RoomService()
          .findRoomWithCode(language_id!, token!, room_code!);
      _roomMatch = roomMatchModel;
      return true;
    } catch (e) {
      throw Exception(e);
      return false;
    }
  }

  Future<bool> confirmGame(String? room_id) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString('token');
      bool isConfirm = await RoomService().confirmGame(token!, room_id!);

      return isConfirm;
    } catch (e) {
      return false;
    }
  }

  Future<bool> cancelGameFromRoom(String? room_id) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString('token');
      bool isCancel = await RoomService().cancelGameFromRoom(token!, room_id!);

      return isCancel;
    } catch (e) {
      return false;
    }
  }

  Future<bool> getPackageQuestion(
      String? language_code, String? channel_code) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString('token');
      List<WordLanguageModel> listQuestion = await RoomService()
          .getPackageQuestion(
              token!, language_code!, roomMatch!.totalQuestion!, channel_code!);
      _listQuestion = listQuestion;
      return true;
    } catch (e) {
      return false;
    }
  }

  bool updateRoomDetail(RoomMatchDetailModel? roomMatchDetailModel) {
    if (_roomMatch!.max_player! > _roomMatch!.room_match_detail!.length) {
      print(_roomMatch!.room_match_detail!.length);
      List<RoomMatchDetailModel> detail = roomMatch!.room_match_detail!
          .where(
              (detail) => detail.id!.contains(roomMatchDetailModel!.id ?? ''))
          .toList();
      if (detail.length == 0) {
        _roomMatch!.room_match_detail!.add(roomMatchDetailModel!);
        return true;
      } else {
        print("Player sudah bergabung sebelumnya");
        return false;
      }
    } else {
      print("Room sudah penuh");
      return false;
    }
  }

  updateStatusPlayer(String? roomDetailId, bool? status) {
    if (status == true) {
      List<RoomMatchDetailModel> detail = roomMatch!.room_match_detail!
          .where((detail) => detail.id!.contains(roomDetailId ?? ''))
          .toList();
      if (detail.length == 1) {
        roomMatch!.room_match_detail!
            .where((detail) => detail.id!.contains(roomDetailId ?? ''))
            .first
            .is_ready = 1;
      }
    }
  }

  bool checkAllAreReady() {
    if (_roomMatch!.max_player! == _roomMatch!.room_match_detail!.length) {
      List<RoomMatchDetailModel> detail = roomMatch!.room_match_detail!
          .where((detail) => detail.is_ready == 0)
          .toList();
      if (detail.length == 0) {
        return true;
      }
      return false;
    }
    return false;
  }
}

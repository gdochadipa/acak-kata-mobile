import 'dart:developer';
import 'dart:math';

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

  bool _isGetQuestion = false;
  bool get isGetQuestion => _isGetQuestion;

  set isGetQuestion(bool isGet) {
    _isGetQuestion = isGet;
  }

  set roomMatch(RoomMatchModel? roomMatch) {
    _roomMatch = roomMatch;
    notifyListeners();
  }

  Future<void> setQuestionList(List<WordLanguageModel>? question) async {
    _listQuestion = question;
    if (_listQuestion != null) {
      _queueQuestion = [for (var i = 0; i < _listQuestion!.length; i++) i];
    }

    var rand = Random();
    // for (var i = _queueQuestion!.length - 1; i > 0; i--) {
    //   var n = rand.nextInt(i + 1);
    //   var temp = _queueQuestion![i];
    //   _queueQuestion![i] = _queueQuestion![n];
    //   _queueQuestion![n] = temp;
    // }
    for (var i = _queueQuestion!.length - 1; i > 0; i--) {
      var n = rand.nextInt(i + 1);
      var temp = _listQuestion![i];
      _listQuestion![i] = _listQuestion![n];
      _listQuestion![n] = temp;
    }
    // notifyListeners();
  }

  Future<bool> createRoom(
      {String? language_code,
      int? max_player,
      int? time_watch,
      int? total_question,
      DateTime? datetime_match,
      int? length_word,
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
          level!,
          length_word!);
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
      throw Exception(e);
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
      throw Exception(e);
      return false;
    }
  }

  Future<bool> getPackageQuestion(
      String? language_code, String? channel_code) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString('token');

      List<WordLanguageModel> listQuestion = await RoomService()
          .getPackageQuestion(token!, language_code!, roomMatch!.totalQuestion!,
              channel_code!, roomMatch!.length_word!);
      _listQuestion = listQuestion;
      return true;
    } catch (e, trace) {
      throw Exception(e);
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

  updateStatusPlayer(
      {required String? roomDetailId,
      required int? status,
      required int? isReady}) async {
    roomMatch!.room_match_detail!
        .where((detail) => detail.id!.contains(roomDetailId ?? ''))
        .first
        .is_ready = 1;

    roomMatch!.room_match_detail!
        .where((detail) => detail.id!.contains(roomDetailId ?? ''))
        .first
        .status_player = status;
  }

  updateStatusGame(String? roomId, int? statusGame) async {
    if (_roomMatch!.id == roomId) {
      _roomMatch!.status_game = statusGame;
    }
  }

  RoomMatchDetailModel getRoomMatchDetailByUser(
      {required String? userID, required int? statusPlayer}) {
    roomMatch!.room_match_detail!
        .where((roomMatchDetail) => roomMatchDetail.player_id == userID)
        .first
        .status_player = statusPlayer;

    return roomMatch!.room_match_detail!
        .where((roomMatchDetail) => roomMatchDetail.player_id == userID)
        .first;
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

  bool checkAllAreReceiveQuestion() {
    if (_roomMatch!.max_player! == _roomMatch!.room_match_detail!.length) {
      List<RoomMatchDetailModel> detail = roomMatch!.room_match_detail!
          .where((detail) => detail.status_player == 2)
          .toList();
      if (detail.length == roomMatch!.room_match_detail!.length) {
        return true;
      }
      return false;
    }
    return false;
  }
}

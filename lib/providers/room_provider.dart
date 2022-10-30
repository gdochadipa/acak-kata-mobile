import 'dart:math';

import 'package:acakkata/models/history_game_detail_model.dart';
import 'package:acakkata/models/relation_word.dart';
import 'package:acakkata/models/room_match_detail_model.dart';
import 'package:acakkata/models/room_match_model.dart';
import 'package:acakkata/models/word_language_model.dart';
import 'package:acakkata/service/room_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoomProvider with ChangeNotifier {
  RoomMatchModel? _roomMatch;
  RoomMatchModel? get roomMatch => _roomMatch;

  RoomMatchDetailModel? _roomMatchDetailUser;
  RoomMatchDetailModel? get roomMatchDetailUser => _roomMatchDetailUser;

  List<RoomMatchDetailModel>? get listRoommatchDet =>
      _roomMatch!.room_match_detail;

  late int _numberCountDown;
  late int _totalQuestion;
  late int _maxPlayer;

  List<WordLanguageModel>? _listQuestion;
  List<WordLanguageModel>? get listQuestion => _listQuestion;

  List<RelationWordModel>? _listRelatedQuestion;
  List<RelationWordModel>? get listRelatedQuestion => _listRelatedQuestion;

  List<HistoryGameDetailModel>? _dataHistoryGameDetailList;
  List<HistoryGameDetailModel>? get dataHistoryGameDetailList =>
      _dataHistoryGameDetailList;

  List<int>? _queueQuestion;
  List<int>? get queueQuestion => _queueQuestion;

  int get numberCountDown => _numberCountDown;
  int get totalQuestion => _totalQuestion;
  int get maxPlayer => _maxPlayer;

  bool _isGetQuestion = false;
  bool get isGetQuestion => _isGetQuestion;

  double? resultEndScore;

  set isGetQuestion(bool isGet) {
    _isGetQuestion = isGet;
  }

  set roomMatch(RoomMatchModel? roomMatch) {
    _roomMatch = roomMatch;
    notifyListeners();
  }

  setRuleGame(int? numberCountDown, int? totalQuestion) {
    _numberCountDown = numberCountDown ?? 15;
    _totalQuestion = totalQuestion ?? 15;
  }

  // Future<void> setQuestionList(List<WordLanguageModel>? question) async {
  //   _listQuestion = question;
  //   if (_listQuestion != null) {
  //     _queueQuestion = [for (var i = 0; i < _listQuestion!.length; i++) i];
  //   }

  //   var rand = Random();
  //   for (var i = _queueQuestion!.length - 1; i > 0; i--) {
  //     var n = rand.nextInt(i + 1);
  //     var temp = _listQuestion![i];
  //     _listQuestion![i] = _listQuestion![n];
  //     _listQuestion![n] = temp;
  //   }
  // }

  Future<void> setRelatedQuestionList(List<RelationWordModel>? question) async {
    _listRelatedQuestion = question;
    if (_listRelatedQuestion != null) {
      _queueQuestion = [
        for (var i = 0; i < _listRelatedQuestion!.length; i++) i
      ];
    }

    var rand = Random();
    for (var i = _queueQuestion!.length - 1; i > 0; i--) {
      var n = rand.nextInt(i + 1);
      var temp = _listRelatedQuestion![i];
      _listRelatedQuestion![i] = _listRelatedQuestion![n];
      _listRelatedQuestion![n] = temp;
    }
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

  Future<bool> findRoomWithCode(String? languageId, String? roomCode) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString('token');
      RoomMatchModel roomMatchModel =
          await RoomService().findRoomWithCode(languageId!, token!, roomCode!);
      _roomMatch = roomMatchModel;
      return true;
    } catch (e) {
      throw Exception(e);
      return false;
    }
  }

  Future<bool> checkingRoomWithCode(
      String? languageId, String? roomCode) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString('token');
      RoomMatchModel roomMatchModel =
          await RoomService().findRoomWithCode(languageId!, token!, roomCode!);
      _roomMatch = roomMatchModel;
      return true;
    } catch (e) {
      throw Exception(e);
      return false;
    }
  }

  Future<bool> findRoomMatchID({required String? id}) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString('token');
      RoomMatchModel roomMatchModel =
          await RoomService().findRoomMatchByID(id: id!, token: token!);
      _roomMatch = roomMatchModel;
      return true;
    } catch (e) {
      throw Exception(e);
      return false;
    }
  }

  Future<bool> confirmGame(String? roomId) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString('token');
      bool isConfirm = await RoomService().confirmGame(token!, roomId!);

      return isConfirm;
    } catch (e) {
      throw Exception(e);
      return false;
    }
  }

  Future<bool> cancelGameFromRoom(String? roomId) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString('token');
      bool isCancel = await RoomService().cancelGameFromRoom(token!, roomId!);

      return isCancel;
    } catch (e) {
      throw Exception(e);
      return false;
    }
  }

  Future<bool> getPackageQuestion(
      String? languageCode, String? channelCode) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString('token');

      List<WordLanguageModel> listQuestion = await RoomService()
          .getPackageQuestion(token!, languageCode!, roomMatch!.totalQuestion!,
              channelCode!, roomMatch!.length_word!);
      _listQuestion = listQuestion;
      return true;
    } catch (e) {
      throw Exception(e);
      return false;
    }
  }

  Future<bool> getPackageRelatedQuestion(
      String? languageCode, String? channelCode) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString('token');

      List<RelationWordModel> listRelatedQuestion = await RoomService()
          .getPackageRelatedQuestion(token!, languageCode!, 4, channelCode!, 3);
      _listRelatedQuestion = listRelatedQuestion;

      return true;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> saveSingleHistoryGameDetail(
      {required HistoryGameDetailModel? historyGameDetailModel}) async {
    _dataHistoryGameDetailList!.add(historyGameDetailModel!);
  }

  Future<void> resetSingleHistoryGameDetail() async {
    if (_dataHistoryGameDetailList != null) {
      _dataHistoryGameDetailList!.clear();
    } else {
      _dataHistoryGameDetailList = [];
    }
  }

  Future<void> setSingleHistoryGameDetail() async {
    _dataHistoryGameDetailList = [];
  }

  bool updateRoomDetail(RoomMatchDetailModel? roomMatchDetailModel) {
    if (_roomMatch!.max_player! > _roomMatch!.room_match_detail!.length) {
      // print(_roomMatch!.room_match_detail!.length);
      List<RoomMatchDetailModel> detail = roomMatch!.room_match_detail!
          .where(
              (detail) => detail.id!.contains(roomMatchDetailModel!.id ?? ''))
          .toList();
      if (detail.isEmpty) {
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
      required int? isReady,
      int? score}) async {
    RoomMatchDetailModel detailModel = roomMatch!.room_match_detail!
        .where((detail) => detail.id!.contains(roomDetailId ?? ''))
        .first;
    detailModel.status_player = status;
    detailModel.is_ready = 1;
    detailModel.score = score;

    roomMatch!.room_match_detail![roomMatch!.room_match_detail!
            .indexWhere((detail) => detail.id!.contains(roomDetailId ?? ''))] =
        detailModel;
  }

  updateStatusGame(String? roomId, int? statusGame) async {
    if (_roomMatch!.id == roomId) {
      _roomMatch!.status_game = statusGame;
    }
  }

  RoomMatchDetailModel getAndUpdateStatusPlayerByID(
      {required String? userID, required int? statusPlayer, int? score}) {
    RoomMatchDetailModel detailModel = roomMatch!.room_match_detail!
        .where((roomMatchDetail) => roomMatchDetail.player_id == userID)
        .first;

    detailModel.status_player = statusPlayer;
    detailModel.is_ready = 1;
    detailModel.score = score ?? 0;

    roomMatch!.room_match_detail![roomMatch!.room_match_detail!.indexWhere(
            (roomMatchDetail) => roomMatchDetail.player_id == userID)] =
        detailModel;

    _roomMatchDetailUser = roomMatch!.room_match_detail!
        .where((roomMatchDetail) => roomMatchDetail.player_id == userID)
        .first;
    return roomMatch!.room_match_detail!
        .where((roomMatchDetail) => roomMatchDetail.player_id == userID)
        .first;
  }

  RoomMatchDetailModel? getDetailRoomByID({
    required String? userID,
  }) {
    _roomMatchDetailUser = roomMatch!.room_match_detail!
        .where((roomMatchDetail) => roomMatchDetail.player_id == userID)
        .first;
    return _roomMatchDetailUser;
  }

  bool checkAllAreReady() {
    if (_roomMatch!.max_player! == _roomMatch!.room_match_detail!.length) {
      List<RoomMatchDetailModel> detail = roomMatch!.room_match_detail!
          .where((detail) => detail.is_ready == 0)
          .toList();
      if (detail.isEmpty) {
        return true;
      }
      return false;
    }
    return false;
  }

  bool checkAllAreReceiveQuestion() {
    // if (_roomMatch!.max_player! == _roomMatch!.room_match_detail!.length) {

    // }
    // return false;
    List<RoomMatchDetailModel> detail = roomMatch!.room_match_detail!
        .where((detail) => detail.status_player == 2)
        .toList();
    print(
        "is all have receive status ${detail.length == roomMatch!.room_match_detail!.length}");
    if (detail.length == roomMatch!.room_match_detail!.length) {
      return true;
    }
    return false;
  }

  bool checkAllAreGameDone() {
    List<RoomMatchDetailModel> detail = roomMatch!.room_match_detail!
        .where((detail) => detail.status_player == 3)
        .toList();
    if (detail.length == roomMatch!.room_match_detail!.length) {
      return true;
    }
    return false;
  }

  int checkIsHost({required String? userID}) {
    return roomMatch!.room_match_detail!
            .where((roomMatchDetail) => roomMatchDetail.player_id == userID)
            .first
            .is_host ??
        0;
  }

  bool removePlayerFromRoomMatchDetail({required String player_id}) {
    List<RoomMatchDetailModel> detail = roomMatch!.room_match_detail!
        .where((detail) => detail.player_id!.contains(player_id))
        .toList();
    if (detail.isNotEmpty) {
      roomMatch!.room_match_detail!
          .removeWhere((e) => e.player_id == player_id);
      print("Player ${detail[0].player!.username} has disconnect !");
      return true;
    } else {
      print("Player ${player_id} not found!");
      return false;
    }
  }

  void changeHostRoom(
      {required String host_room_before,
      required String host_room_after,
      required String? userId}) {
    roomMatch!.room_match_detail!
        .where((detail) => detail.id!.contains(host_room_before))
        .first
        .is_host = 0;

    roomMatch!.room_match_detail!
        .where((detail) => detail.id!.contains(host_room_after))
        .first
        .is_host = 1;

    getDetailRoomByID(userID: userId);
  }

  void calculateEndScore(
      {required double percentageScore, required double percentageTime}) {
    resultEndScore =
        ((percentageScore + percentageTime) * 100).round() as double?;
  }
}

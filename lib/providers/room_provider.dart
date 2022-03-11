import 'package:acakkata/models/room_match_model.dart';
import 'package:acakkata/models/word_language_model.dart';
import 'package:acakkata/service/room_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoomProvider with ChangeNotifier {
  RoomMatchModel? _roomMatch;
  RoomMatchModel? get roomMatch => _roomMatch;

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

  Future<bool> createRoom(String? language_id, int? max_player, int? time_watch,
      int? total_question) async {
    try {
      _maxPlayer = max_player ?? 2;
      _numberCountDown = time_watch ?? 15;
      _totalQuestion = total_question ?? 15;
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString('token');
      RoomMatchModel roomMatchModel = await RoomService().createRoom(
          language_id!, time_watch!, max_player!, total_question!, token!);
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
      String? language_id, int? question_num) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString('token');
      List<WordLanguageModel> listQuestion = await RoomService()
          .getPackageQuestion(token!, language_id!, question_num!);
      _listQuestion = listQuestion;
      return true;
    } catch (e) {
      return false;
    }
  }
}

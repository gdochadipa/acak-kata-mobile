import 'package:acakkata/models/room_match_detail_model.dart';
import 'package:acakkata/models/room_match_model.dart';
import 'package:acakkata/service/socket_service.dart';
import 'package:flutter/cupertino.dart';

class SocketProvider with ChangeNotifier {
  SocketService _socketService = SocketService();
  Stream get streamDataSocket => _socketService.eventStream;

  SocketProvider() {
    _socketService = SocketService();
    _socketService.fireSocket();
  }

  restartStream() {
    // _socketService.onResumeStream();
    _socketService = SocketService();
    _socketService.fireSocket();
  }

  pausedStream() {
    // _socketService.pausedStream();
  }

  resumeStream() {
    _socketService.onResumeStream();
  }

  Future<void> socketReceiveFindRoom() async {
    await _socketService.bindEventSearchRoom();
  }

  Future<void> socketReceiveStatusPlayer() async {
    await _socketService.bindReceiveStatusPlayer();
  }

  Future<void> socketReceiveStatusGame() async {
    await _socketService.bindReceiveStatusGame();
  }

  Future<void> socketReceiveQuestion() async {
    await _socketService.bindReceiveQuestion();
  }

  Future<void> socketSendJoinRoom(
      {required String channelCode,
      required String playerCode,
      required String languageCode,
      required RoomMatchDetailModel roomMatchDet}) async {
    _socketService.emitJoinRoom(channelCode, playerCode);
    _socketService.emitSearchRoom(channelCode, languageCode, roomMatchDet);
  }

  Future<void> socketSendQuestion(
      {required String channelCode,
      required String languageCode,
      required String playerId,
      required String question}) async {
    await _socketService.emitSendQuestion(
        channelCode, languageCode, playerId, question);
  }

  Future<void> socketSendStatusPlayer(
      {required String channelCode,
      required RoomMatchDetailModel roomMatchDetailModel,
      int? score}) async {
    await _socketService.emitStatusPlayer(
        channelCode,
        roomMatchDetailModel.id,
        roomMatchDetailModel.is_ready,
        roomMatchDetailModel.status_player,
        roomMatchDetailModel.player!.username,
        score ?? 0);
  }

  Future<void> socketSendStatusGame(
      {required String channelCode, required RoomMatchModel? roomMatch}) async {
    await _socketService.emitStatusGame(
        channelCode, roomMatch!.id, roomMatch.status_game);
  }

  Future<void> socketJoinRoom(
      {required String channelCode, required String playerCode}) async {
    _socketService.emitJoinRoom(channelCode, playerCode);
  }

  Future<void> disconnectService() async {
    await _socketService.disconnect();
    _socketService.disconnectCloseStream();
  }
}

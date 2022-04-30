import 'package:acakkata/models/room_match_detail_model.dart';
import 'package:acakkata/service/socket_service.dart';
import 'package:flutter/cupertino.dart';

class SocketProvider with ChangeNotifier {
  SocketService _socketService = SocketService();
  Stream get streamDataSocket => _socketService.eventStream;

  SocketProvider() {
    _socketService = SocketService();
    _socketService.fireSocket();
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

  Future<void> socketSendJoinRoom(
      {required String channelCode,
      required String playerCode,
      required String languageCode,
      required RoomMatchDetailModel roomMatchDet}) async {
    _socketService.emitJoinRoom(channelCode, playerCode);
    _socketService.emitSearchRoom(channelCode, languageCode, roomMatchDet);
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

import 'package:acakkata/models/room_match_detail_model.dart';
import 'package:acakkata/models/room_match_model.dart';
import 'package:acakkata/service/socket_service.dart';
import 'package:acakkata/setting/persistence/setting_persistence.dart';
import 'package:flutter/cupertino.dart';

class SocketProvider with ChangeNotifier {
  SocketService _socketService = SocketService();
  Stream get streamDataSocket => _socketService.eventStream;
  Stream get setRoomStream => _socketService.setRoomStream;
  Stream get questionStream => _socketService.questionStream;
  Stream get hostExitRoomStream => _socketService.hostExitRoomStream;
  Stream get changeHostStream => _socketService.changeHostStream;
  Stream get userDisconnectStream => _socketService.userDisconnectedStream;
  Stream get statusPlayerStream => _socketService.statusPlayerStream;
  Stream get statusGameStream => _socketService.statusGameStream;
  Stream get startingBySchedulingStream =>
      _socketService.startingByScheduleStream;
  Stream get endingBySchedulingStream => _socketService.endingByScheduleStream;

  bool get isDisconnect => _socketService.socket.disconnected;
  bool get isConnected => _socketService.socket.connected;
  bool get isActive => _socketService.socket.active;
  ValueNotifier<String> baseUrl = ValueNotifier("http://139.59.117.124:3000");
  late final SettingsPersistence _persistence;

  SocketProvider({required SettingsPersistence persistence}) {
    _persistence = persistence;
  }

  Future<void> loadStateFromPersistence() async {
    _persistence.getServerSocket().then((value) {
      baseUrl.value = value;
    });

    _socketService.setUpSocketUrl(socketUrl: baseUrl.value);
  }

  // SocketProvider() {
  //   // _socketService = SocketService();
  //   // _socketService.fireSocket();
  // }

  restartStream() {
    _persistence.getServerSocket().then((value) {
      baseUrl.value = value;
    });
    print("base url" + baseUrl.value);
    // _socketService.onResumeStream();
    _socketService = SocketService();
    _socketService.setUpSocketUrl(socketUrl: baseUrl.value);
    _socketService.fireSocket();
  }

  fireStream() {
    _persistence.getServerSocket().then((value) => baseUrl.value = value);
    _socketService.setUpSocketUrl(socketUrl: baseUrl.value);
    _socketService.fireSocket();
  }

  Future<void> socketEmitJoinRoom(
      {required String channelCode,
      required RoomMatchDetailModel? matchDetail}) async {
    await _socketService.emitJoinRoom(channelCode, matchDetail!.id!);
  }

  pausedStream() {
    // _socketService.pausedStream();
  }

  resumeStream() {
    // _socketService.onResumeStream();
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

  Future<void> socketReceiveUserDisconnect() async {
    await _socketService.bindReceiveUserDisconnect();
  }

  Future<void> socketReceiveStartingGameBySchedule() async {
    await _socketService.bindReceiveStartingGameBySchedule();
  }

  Future<void> socketReceiveExitRoom() async {
    await _socketService.bindReceiveExitRoom();
  }

  Future<void> socketReceiveChangeHost() async {
    await _socketService.bindReceiveChangeHost();
  }

  Future<void> socketReceiveEndingGameBySchedule() async {
    await _socketService.bindReceiveEndingGameBySchedule();
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

  // Future<void> socketJoinRoom(
  //     {required String channelCode, required String playerCode}) async {
  //   _socketService.emitJoinRoom(channelCode, playerCode);
  // }

  Future<void> sendExitRoom(
      {required String channelCode, required String playerId}) async {
    await _socketService.emmitDisconnectRoom(
        channelCode: channelCode, playerId: playerId);
  }

  Future<void> disconnectService() async {
    await _socketService.disconnect();
    _socketService.disconnectCloseStream();
  }

  Future<void> reconnectToGame(
      {required RoomMatchModel? roomMatch,
      required RoomMatchDetailModel? roomMatchDetailModel,
      int? score}) async {
    //join and then update status game
    //actvie when check result game,
    await _socketService.emitJoinRoom(
        roomMatch!.channel_code!, roomMatchDetailModel!.id!);
    await _socketService.emitStatusPlayer(
        roomMatch.channel_code!,
        roomMatchDetailModel.id,
        roomMatchDetailModel.is_ready,
        roomMatchDetailModel.status_player,
        roomMatchDetailModel.player!.username,
        score ?? 0);
  }

  Future<void> bindOnDisconnect() async {
    await _socketService.onDisconnect();
  }

  Future<void> onTest() async {
    await _socketService.onTest();
  }

  Future<void> disconnect() async {
    await _socketService.disconnect();
  }
}

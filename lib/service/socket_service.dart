import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math' hide log;

import 'package:acakkata/models/room_match_detail_model.dart';
import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

const String SOCKET_KEY = '';
const String SOCKET_URL = 'http://139.59.117.124:3000';

class SocketService {
  late IO.Socket socket;

  final StreamController<String> _eventData =
      StreamController<String>.broadcast();
  Sink get _inEventData => _eventData.sink;
  Stream get eventStream => _eventData.stream;

  //set-room
  final StreamController<String> _setRoomBroadcast =
      StreamController<String>.broadcast();
  Stream get setRoomStream => _setRoomBroadcast.stream;

  //broadcast-question
  final StreamController<String> _questionBroadcast =
      StreamController<String>.broadcast();
  Stream get questionStream => _questionBroadcast.stream;

  //host-exit-room
  final StreamController<String> _hostExitRoomBroadcast =
      StreamController<String>.broadcast();
  Stream get hostExitRoomStream => _hostExitRoomBroadcast.stream;

  //change-host
  final StreamController<String> _changeHostBroadcast =
      StreamController<String>.broadcast();
  Stream get changeHostStream => _changeHostBroadcast.stream;

  //user-disconnected
  final StreamController<String> _userDisconnectedBroadcast =
      StreamController<String>.broadcast();
  Stream get userDisconnectedStream => _userDisconnectedBroadcast.stream;

  //broadcast-status-player
  final StreamController<String> _statusPlayerBroadcast =
      StreamController<String>.broadcast();
  Stream get statusPlayerStream => _statusPlayerBroadcast.stream;

  //broadcast-status-game
  final StreamController<String> _statusGameBroadcast =
      StreamController<String>.broadcast();
  Stream get statusGameStream => _statusGameBroadcast.stream;

  //starting-game-by-schedule
  final StreamController<String> _startingByScheduleBroadcast =
      StreamController<String>.broadcast();
  Stream get startingByScheduleStream => _startingByScheduleBroadcast.stream;

  //ending-game-by-schedule
  final StreamController<String> _endingByScheduleBroadcast =
      StreamController<String>.broadcast();
  Stream get endingByScheduleStream => _endingByScheduleBroadcast.stream;

  Logger logger = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );

  int random(int min, int max) {
    return min + Random().nextInt(max - min);
  }

  Future<void> bindEvent(String eventName) async {
    socket.on(eventName, (last) {
      final String? data = last.toString();
      _inEventData.add(data);
    });
  }

  Future<void> bindEventSearchRoom() async {
    socket.on('set-room', (last) {
      final String? data = last.toString();
      _inEventData.add(data);
      _setRoomBroadcast.sink.add(data!);
    });
  }

  /// question => json
  /// language_name => string
  /// player_id=>  string
  ///
  ///
  ///
  /// check room to
  /// check room to
  /// check room to
  Future<void> bindReceiveQuestion() async {
    socket.on('broadcast-question', (last) {
      final String? data = last.toString();
      _inEventData.add(data);
      _questionBroadcast.sink.add(data!);
    });
  }

  Future<void> bindReceiveExitRoom() async {
    socket.on('host-exit-room', (last) {
      final String? data = last.toString();
      print(data);
      _inEventData.add(data);
      _hostExitRoomBroadcast.sink.add(data!);
    });
  }

  Future<void> bindReceiveChangeHost() async {
    socket.on('change-host', (last) {
      final String? data = last.toString();
      _inEventData.add(data);
      _changeHostBroadcast.sink.add(data!);
    });
  }

  Future<void> bindReceiveUserDisconnect() async {
    socket.on('user-disconnected', (last) {
      print(' a user disconnect');
      _inEventData.add(last.toString());
      _userDisconnectedBroadcast.sink.add(last.toString());
    });
  }

  Future<void> emitSearchRoom(String channelCode, String languageCode,
      RoomMatchDetailModel roomMatchDet) async {
    Future.delayed(Duration(milliseconds: random(500, 1500)), () {
      socket.emit(
          'search-room',
          json.encode({
            'channel_code': channelCode,
            'language_code': languageCode,
            'room_detail': roomMatchDet.toJson()
          }));
    });
  }

  Future<void> bindReceiveStatusPlayer() async {
    List<String>? testData = [];
    socket.on('broadcast-status-player', (last) {
      _inEventData.add(last.toString());
      _statusPlayerBroadcast.sink.add(last.toString());
    });
  }

  Future<void> bindReceiveStatusGame() async {
    socket.on('broadcast-status-game', (last) {
      final String? data = last.toString();
      _inEventData.add(data);
      _statusGameBroadcast.sink.add(data!);
    });
  }

  Future<void> bindReceiveStartingGameBySchedule() async {
    socket.on('starting-game-by-schedule', (last) {
      final String? data = last.toString();
      _inEventData.add(data);
      _startingByScheduleBroadcast.sink.add(data!);
    });
  }

  Future<void> bindReceiveEndingGameBySchedule() async {
    socket.on('ending-game-by-schedule', (last) {
      final String? data = last.toString();
      _inEventData.add(data);
      _endingByScheduleBroadcast.sink.add(data!);
    });
  }

  emitJoinRoom(String channelCode, String roomDetailId) {
    socket.emit(
        'join-room',
        json.encode(
            {'channel_code': channelCode, 'room_detail_id': roomDetailId}));
  }

  Future<void> emitStatusPlayer(String channelCode, String? roomDetID,
      int? isReady, int? statusPlayer, String? username, int? score) async {
    log('on status player $roomDetID $isReady, $statusPlayer');
    Future.delayed(Duration(milliseconds: random(500, 1000)), () {
      socket.emit(
          'status-player',
          json.encode({
            'channel_code': channelCode,
            'room_detail_id': roomDetID,
            'is_ready': isReady,
            'status_player': statusPlayer,
            'username': username,
            'score': score
          }));
    });
  }

  emitStatusGame(String channelCode, String? roomID, int? statusGame) {
    log('on status Game  $roomID $statusGame');
    socket.emit(
        'status-game',
        json.encode({
          'channel_code': channelCode,
          'room_id': roomID,
          'status_game': statusGame
        }));
  }

  Future<void> emitSendQuestion(String channelCode, String languageCode,
      String playerId, String question) async {
    print("Kirim soal ke pemain lain");
    socket.emit(
        'send-question',
        json.encode({
          'channel_code': channelCode,
          'language_code': languageCode,
          'player_id': playerId,
          'question': question
        }));
  }

  Future<void> emmitDisconnectRoom(
      {required String channelCode, required String playerId}) async {
    Future.delayed(Duration(milliseconds: random(500, 1000)), () async {
      socket.emit('disconnect-room',
          json.encode({'channel_code': channelCode, 'player_id': playerId}));
    });
    // await disconnect();
  }

  Future<void> disconnect() async {
    if (socket != null) {
      if (socket.connected) {
        socket.disconnect();
        socket.onDisconnect((data) => print("Disconnect"));
      }
    }
  }

  disconnectCloseStream() {
    // _eventData.close();
  }

  Future<void> onDisconnect() async {
    socket.onDisconnect((data) {
      print("Disconnect onDisconnect flutter ${data.toString()}");
    });
  }

  Future<void> onTest() async {
    socket.on('eventName', (data) {
      _eventData.add(data);
      print(" data => ${data.toString()}");
    });
  }

  Future<void> initSocket() async {
    try {
      socket = IO.io(
          SOCKET_URL,
          IO.OptionBuilder()
              .setTransports(['websocket']) // for Flutter or Dart VM
              .build());
      if (socket.disconnected) {
        socket.connect();
      }

      socket.on('connect', (data) {
        print('connected');
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> fireSocket() async {
    await initSocket();
  }
}

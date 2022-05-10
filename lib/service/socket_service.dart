import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math' hide log;

import 'package:acakkata/models/room_match_detail_model.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

const String SOCKET_KEY = '';
const String SOCKET_URL = 'http://10.0.2.2:3000';

class SocketService {
  late IO.Socket socket;

  StreamController<String> _eventData = StreamController<String>.broadcast();
  Sink get _inEventData => _eventData.sink;
  Stream get eventStream => _eventData.stream;
  Logger logger = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );

  pausedStream() {
    // _eventData.onPause;
  }

  onResumeStream() {
    // _eventData = StreamController<String>.broadcast();
    // _eventData.onResume!;
  }

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
    });
  }

/**
 * question => json
 * language_name => string
 * player_id=>  string
 * 
 * check room to 
 */
  Future<void> bindReceiveQuestion() async {
    socket.on('broadcast-question', (last) {
      print("soal diterima");
      final String? data = last.toString();
      _inEventData.add(data);
    });
  }

  Future<void> bindReceiveUserDisconnect() async {
    socket.on('user-disconnected', (last) {
      final String? data = last.toString();
      _inEventData.add(data);
    });
  }

  Future<void> emitSearchRoom(String channelCode, String languageCode,
      RoomMatchDetailModel roomMatchDet) async {
    Future.delayed(Duration(milliseconds: random(500, 1000)), () {
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
      logger.d("on socket service ${last.toString()}");
      _inEventData.add(last.toString());
    });
  }

  Future<void> bindReceiveStatusGame() async {
    socket.on('broadcast-status-game', (last) {
      final String? data = last.toString();
      _inEventData.add(data);
    });
  }

  emitJoinRoom(String channelCode, String player) {
    socket.emit(
        'join-room',
        json.encode(
            {'channel_code': channelCode, 'player_id': 'flutter ${player}'}));
  }

  Future<void> emitStatusPlayer(String channelCode, String? roomDetID,
      int? isReady, int? statusPlayer, String? username, int? score) async {
    log('on status player ${roomDetID} ${isReady}, ${statusPlayer}');
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
    log('on status Game  ${roomID} ${statusGame}');
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
      String channelCode, String languageCode, String playerId) async {
    socket.emit(
        'disconnect-room',
        json.encode({
          'channel_code': channelCode,
          'language_code': languageCode,
          'player_id': playerId
        }));
    disconnect();
  }

  Future<void> disconnect() async {
    if (socket.connected) {
      socket.disconnect();
      socket.onDisconnect((data) => print("Disconnect"));
    }
  }

  disconnectCloseStream() {
    // _eventData.close();
  }

  Future<void> onTest() async {
    socket.on('eventName', (data) {
      // print(data.toString());
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

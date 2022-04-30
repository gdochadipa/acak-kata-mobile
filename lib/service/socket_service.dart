import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:acakkata/models/room_match_detail_model.dart';
import 'package:flutter/services.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

const String SOCKET_KEY = '';
const String SOCKET_URL = 'http://10.0.2.2:3000';

class SocketService {
  late IO.Socket socket;

  StreamController<String> _eventData = StreamController<String>();
  Sink get _inEventData => _eventData.sink;
  Stream get eventStream => _eventData.stream;

  stopStream() {
    _eventData.close();
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

  emitSearchRoom(String channelCode, String languageCode,
      RoomMatchDetailModel roomMatchDet) async {
    socket.emit(
        'search-room',
        json.encode({
          'channel_code': channelCode,
          'language_code': languageCode,
          'room_detail': roomMatchDet.toJson()
        }));
  }

  Future<void> bindReceiveStatusPlayer() async {
    socket.on('broadcast-status-player', (last) {
      final String? data = last.toString();
      _inEventData.add(data);
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

  emitStatusPlayer(
      String channel_code, RoomMatchDetailModel? roomMatchDet, bool is_ready) {
    log('on status player ${roomMatchDet!.id} ${is_ready}');
    socket.emit(
        'status-player',
        json.encode({
          'channel_code': channel_code,
          'room_detail_id': roomMatchDet.id,
          'status': is_ready
        }));
  }

  Future<void> emitSendQuestion(String channelCode, String languageCode,
      String playerId, Map<String, dynamic> question) async {
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
      _eventData.close();
    }
  }

  disconnectCloseStream() {
    _eventData.close();
  }

  Future<void> onTest() async {
    socket.on('eventName', (data) {
      print(data.toString());
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

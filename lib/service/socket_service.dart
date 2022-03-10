import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

const String SOCKET_KEY = '';
const String SOCKET_URL = 'http://10.0.2.2:3000';

class SocketService {
  late IO.Socket socket;

  StreamController<String> _eventData = StreamController<String>();
  Sink get _inEventData => _eventData.sink;
  Stream get eventStream => _eventData.stream;

  Future<void> bindEvent(String eventName) async {
    socket.on(eventName, (last) {
      final String? data = last!.data;
      _inEventData.add(data);
    });
  }

  Future<void> bindEventConnectRoom() async {
    socket.on('connect-to-room', (last) {
      final String? data = last!.data;
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
      final String? data = last!.data;
      _inEventData.add(data);
    });
  }

  Future<void> bindReceiveUserDisconnect() async {
    socket.on('user-disconnected', (last) {
      final String? data = last!.data;
      _inEventData.add(data);
    });
  }

  Future<void> emitSearchRoom(
      String channelCode, String languageCode, String playerId) async {
    socket.emit(
        'search-room',
        json.encode({
          'channel_code': channelCode,
          'language_code': languageCode,
          'player_id': playerId
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
    socket.onDisconnect((data) => print("Disconnect"));
  }

  Future<void> onConnect() async {
    socket.onConnect((_) {
      print("socket on connected: ${socket.connected}");
    });
  }

  Future<void> onTest() async {
    socket.emit('test', json.encode({'test': 'tes123'}));
  }

  Future<void> initSocket() async {
    try {
      socket = IO.io(
          SOCKET_URL,
          IO.OptionBuilder()
              .setTransports(['websocket']) // for Flutter or Dart VM
              .build());

      socket.connect();
    } catch (e) {
      print(e);
    }
  }

  Future<void> fireSocket() async {
    await initSocket();
    await onConnect();
  }
}

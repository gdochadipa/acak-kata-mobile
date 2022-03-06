import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

const String SOCKET_KEY = '';
const String SOCKET_URL = '';

class SocketService {
  late IO.Socket socket;

  StreamController<String> _eventData = StreamController<String>();
  Sink get _inEventData => _eventData.sink;
  Stream get eventStream => _eventData.stream;

  void bindEvent(String eventName) {
    socket.on(eventName, (last) {
      final String? data = last!.data;
      _inEventData.add(data);
    });
  }

  void bindEventConnectRoom() {
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
  void bindReceiveQuestion() {
    socket.on('broadcast-question', (last) {
      final String? data = last!.data;
      _inEventData.add(data);
    });
  }

  void bindReceiveUserDisconnect() {
    socket.on('user-disconnected', (last) {
      final String? data = last!.data;
      _inEventData.add(data);
    });
  }

  void emitSearchRoom(
      String channelCode, String languageCode, String playerId) {
    socket.emit(
        'search-room',
        json.encode({
          'channel_code': channelCode,
          'language_code': languageCode,
          'player_id': playerId
        }));
  }

  void emitSendQuestion(String channelCode, String languageCode,
      String playerId, Map<String, dynamic> question) {
    socket.emit(
        'send-question',
        json.encode({
          'channel_code': channelCode,
          'language_code': languageCode,
          'player_id': playerId,
          'question': question
        }));
  }

  void emmitDisconnectRoom(
      String channelCode, String languageCode, String playerId) {
    socket.emit(
        'disconnect-room',
        json.encode({
          'channel_code': channelCode,
          'language_code': languageCode,
          'player_id': playerId
        }));
    disconnect();
  }

  void disconnect() {
    socket.onDisconnect((data) => print("Disconnect"));
  }

  void onConnect() {
    socket.onConnect((_) => {print("connect")});
  }

  Future<void> initSocket() async {
    try {
      socket = IO.io('http://localhost:3000',
          IO.OptionBuilder().setTransports(['websocket']).build());
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> fireSocket() async {
    await initSocket();
    onConnect();
  }
}

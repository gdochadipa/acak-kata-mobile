import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

const String SOCKET_KEY = '';
const String SOCKET_URL = 'http://10.0.2.2:3000';

class CobaEchoSocket {
  late IO.Socket socket;

  StreamController<String> _eventData = StreamController<String>();
  Sink get _inEventData => _eventData.sink;
  Stream get eventStream => _eventData.stream;

  Future<void> initSocket() async {
    socket = IO.io(
        SOCKET_URL,
        IO.OptionBuilder()
            .disableAutoConnect()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .build());
  }

  Future<void> fireSocket(String roomId) async {
    socket = IO.io(
        SOCKET_URL,
        IO.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect()
            .setExtraHeaders({'foo': 'bar'})
            .build());

    socket.connect();
    socket.on("eventName", (data) {
      print("eventName");
      socket.emit('test', "{data:data213}");
      print(data);
      _eventData.sink.add(data);
    });
    socket.onConnect((_) {
      print("running socket");

      // socket.on('connect-to-room', (data) {
      //   print("running socket");
      //   socket.emit('test', "{data:data213}");
      //   print(data);
      // });

      socket.onError((data) {
        log('onError', error: data);
      });
    });
    socket.onDisconnect((_) => {print('disconnect')});
  }
}

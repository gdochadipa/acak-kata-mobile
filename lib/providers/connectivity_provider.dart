import 'package:acakkata/service/connectivity_service.dart';
import 'package:flutter/material.dart';

class ConnectivityProvider with ChangeNotifier {
  final ConnectivityService _connectivityService = ConnectivityService.instance;
  Stream get streamConnectivity => _connectivityService.myStream;

  ConnectivityProvider() {
    _connectivityService.initialise();
  }

  initialService() {
    _connectivityService.initialise();
  }
}

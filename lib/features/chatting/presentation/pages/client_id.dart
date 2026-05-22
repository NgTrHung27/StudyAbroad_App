import 'package:flutter/material.dart';

class ClientIdProvider with ChangeNotifier {
  String _clientId = '';

  String get clientId => _clientId;

  void setClientId(String clientId) {
    _clientId = clientId;
    notifyListeners();
  }
}

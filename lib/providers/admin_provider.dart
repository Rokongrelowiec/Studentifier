import 'package:flutter/material.dart';

class AdminProvider extends ChangeNotifier {
  bool _isAdmin = false;

  get adminPermission => _isAdmin;

  changePermission(bool admin) async {
    _isAdmin = admin;
    notifyListeners();
  }
}

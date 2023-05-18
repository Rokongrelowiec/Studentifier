import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminProvider extends ChangeNotifier {
  bool isAdmin = false;

  get adminPermission {
    return isAdmin;
  }

  changePermission(bool admin) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setBool('isAdmin', admin);
    isAdmin = admin;
    notifyListeners();
  }
}

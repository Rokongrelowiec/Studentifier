import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class AdminProvider extends ChangeNotifier {
  bool _isAdmin = false;

  get adminPermission => _isAdmin;

  changePermission(bool admin) async {
    // final SharedPreferences _prefs = await SharedPreferences.getInstance();
    // await _prefs.setBool('isAdmin', admin);
    _isAdmin = admin;
    notifyListeners();
  }

  // initialize() async {
  //   final SharedPreferences _prefs = await SharedPreferences.getInstance();
  //
  //   _isAdmin = _prefs.getBool('isAdmin') ?? false;
  //   notifyListeners();
  // }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class AvatarProvider extends ChangeNotifier {
  String? _avatarImg;

  String? get avatarImg => _avatarImg;

  Future<void> saveImagePath(String imagePath) async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/image.txt');
    await file.writeAsString(imagePath);
    _avatarImg = imagePath;
    notifyListeners();
  }

  Future<void> loadImagePath() async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/image.txt');
    if (file.existsSync()) {
      _avatarImg = await file.readAsString();
      notifyListeners();
    }
  }
}

import 'package:flutter/material.dart';

class NowPlayingProvider extends ChangeNotifier {
  bool isPlaying = false;

  void updatePlayingState(bool state) {
    isPlaying = state;
    notifyListeners();
  }
}

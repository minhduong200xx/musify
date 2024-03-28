import 'package:flutter/material.dart';

class FollowProvider extends ChangeNotifier {
  bool _isFollowing =
      true; // Đặt giá trị ban đầu là true để bắt đầu với việc "flow"

  bool get isFollowing => _isFollowing;

  void toggleFollow() {
    _isFollowing = !_isFollowing;
    notifyListeners();
  }
}

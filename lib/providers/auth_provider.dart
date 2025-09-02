import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/prefs_helper.dart';

class AuthProvider extends ChangeNotifier {
  String? _username;
  int _avatarIndex = 0;
  bool _isAuthenticated = false;

  String? get username => _username;
  int get avatarIndex => _avatarIndex;
  bool get isAuthenticated => _isAuthenticated;

  IconData get currentAvatar => _avatars[_avatarIndex];

  static const List<IconData> _avatars = [
    FontAwesomeIcons.userAstronaut,
    FontAwesomeIcons.userNinja,
    FontAwesomeIcons.userSecret,
  ];

  Future<void> load() async {
    final data = await PrefsHelper.loadAuth();
    if (data != null) {
      _username = data['username'];
      _avatarIndex = data['avatarIndex'] ?? 0;
      _isAuthenticated = data['isAuthenticated'] ?? false;
      notifyListeners();
    }
  }

  Future<void> login(String username, int avatarIndex) async {
    _username = username;
    _avatarIndex = avatarIndex;
    _isAuthenticated = true;
    await PrefsHelper.saveAuth({
      'username': _username,
      'avatarIndex': _avatarIndex,
      'isAuthenticated': _isAuthenticated,
    });
    notifyListeners();
  }

  Future<void> continueAsGuest() async {
    _username = 'Guest';
    _avatarIndex = 0;
    _isAuthenticated = true;
    await PrefsHelper.saveAuth({
      'username': _username,
      'avatarIndex': _avatarIndex,
      'isAuthenticated': _isAuthenticated,
    });
    notifyListeners();
  }

  Future<void> logout() async {
    _username = null;
    _avatarIndex = 0;
    _isAuthenticated = false;
    await PrefsHelper.saveAuth({
      'username': _username,
      'avatarIndex': _avatarIndex,
      'isAuthenticated': _isAuthenticated,
    });
    notifyListeners();
  }
}





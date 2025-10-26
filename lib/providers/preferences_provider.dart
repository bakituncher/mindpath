import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesProvider with ChangeNotifier {
  static const String _keyDarkMode = 'dark_mode';
  static const String _keyNotifications = 'notifications_enabled';
  static const String _keyVoiceGender = 'voice_gender';
  static const String _keyVolume = 'volume';
  static const String _keyFirstLaunch = 'first_launch';

  late SharedPreferences _prefs;
  bool _isInitialized = false;

  // Settings
  bool _darkMode = false;
  bool _notificationsEnabled = true;
  String _voiceGender = 'female';
  double _volume = 0.7;
  bool _isFirstLaunch = true;

  // Getters
  bool get darkMode => _darkMode;
  bool get notificationsEnabled => _notificationsEnabled;
  String get voiceGender => _voiceGender;
  double get volume => _volume;
  bool get isFirstLaunch => _isFirstLaunch;
  bool get isInitialized => _isInitialized;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _loadPreferences();
    _isInitialized = true;
    notifyListeners();
  }

  void _loadPreferences() {
    _darkMode = _prefs.getBool(_keyDarkMode) ?? false;
    _notificationsEnabled = _prefs.getBool(_keyNotifications) ?? true;
    _voiceGender = _prefs.getString(_keyVoiceGender) ?? 'female';
    _volume = _prefs.getDouble(_keyVolume) ?? 0.7;
    _isFirstLaunch = _prefs.getBool(_keyFirstLaunch) ?? true;
  }

  Future<void> setDarkMode(bool value) async {
    _darkMode = value;
    await _prefs.setBool(_keyDarkMode, value);
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool value) async {
    _notificationsEnabled = value;
    await _prefs.setBool(_keyNotifications, value);
    notifyListeners();
  }

  Future<void> setVoiceGender(String value) async {
    _voiceGender = value;
    await _prefs.setString(_keyVoiceGender, value);
    notifyListeners();
  }

  Future<void> setVolume(double value) async {
    _volume = value;
    await _prefs.setDouble(_keyVolume, value);
    notifyListeners();
  }

  Future<void> completeFirstLaunch() async {
    _isFirstLaunch = false;
    await _prefs.setBool(_keyFirstLaunch, false);
    notifyListeners();
  }

  Future<void> resetAll() async {
    await _prefs.clear();
    _loadPreferences();
    notifyListeners();
  }
}


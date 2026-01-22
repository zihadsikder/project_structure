import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import '../utils/logging/logger.dart';

class AuthService {
  static const String _tokenKey = 'token';
  static const String _roleKey = 'UserRole';
  static const String _guestModeKey = 'isGuestMode';
  static const String _uidKey = "userID";

  static late SharedPreferences _preferences;
  static String? _token;
  static String? _userRole;
  static String? _uid;
  static bool _isGuestMode = false;

  /// Initialize SharedPreferences (call this during app startup)
  static Future<void> init() async {
    try {
      _preferences = await SharedPreferences.getInstance();
      _token = _preferences.getString(_tokenKey);
      _userRole = _preferences.getString(_roleKey);
      AppLoggerHelper.info(
        'AuthService Initialized: Token exists = ${hasToken()}',
      );
    } catch (e) {
      AppLoggerHelper.error('Error initializing AuthService', e);
    }
  }

  /// Check if a token exists in local storage
  static bool hasToken() {
    return _token != null && _token!.isNotEmpty;
  }

  /// Guest mode methods
  static bool get isGuestMode => _isGuestMode;

  static Future<void> setGuestMode(bool value) async {
    try {
      if (_preferences == null) await init();
      await _preferences!.setBool(_guestModeKey, value);
      _isGuestMode = value;
      log('Guest mode set to: $value');
    } catch (e) {
      log('Error setting guest mode: $e');
    }
  }
  static Future<void> saveUID(String uid) async {
    try {
      if (_preferences == null) await init();
      await _preferences!.setString(_uidKey, uid);
      _uid = uid;
      log("Saved UID: $uid");
    } catch (e) {
      log('Error saving UID: $e', level: 1000, error: e);
    }
  }


  static Future<void> clearGuestMode() async {
    try {
      if (_preferences == null) await init();
      await _preferences!.remove(_guestModeKey);
      _isGuestMode = false;
    } catch (e) {
      log('Error clearing guest mode: $e');
    }
  }
  /// Save the token to local storage
  static Future<void> saveToken(String token) async {
    try {
      await _preferences.setString(_tokenKey, token);
      _token = token;
      AppLoggerHelper.info('Token saved successfully');
    } catch (e) {
      AppLoggerHelper.error('Error saving token', e);
    }
  }

  /// Save the user role to local storage
  static Future<void> saveRole(String role) async {
    try {
      await _preferences.setString(_roleKey, role);
      _userRole = role;
      AppLoggerHelper.info('User Role saved: $role');
    } catch (e) {
      AppLoggerHelper.error('Error saving role', e);
    }
  }

  /// Clear authentication data (for logout or clearing auth data)
  static Future<void> logoutUser() async {
    try {
      await _preferences.clear();
      _token = null;
      _userRole = null;
      AppLoggerHelper.info('User logged out successfully');
      await goToLogin();
    } catch (e) {
      AppLoggerHelper.error('Error during logout', e);
    }
  }

  /// Navigate to the login screen
  static Future<void> goToLogin() async {
    // Navigate to login screen using your routing system (e.g., Get.offAllNamed('/login'))
    AppLoggerHelper.info('Redirecting to Login Screen...');
  }

  /// Getters
  static String? get token => _token;
  static String? get role => _userRole;

  /// Session check
  static bool get isAuthenticated => hasToken();
}

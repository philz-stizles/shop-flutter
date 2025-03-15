import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthUserKeys {
  static const storeKey = 'userData';
  static const userId = 'userId';
  static const token = 'token';
  static const expiryDate = 'expiryDate';
}

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _userId;
  DateTime? _expiryDate;
  Timer? _authTimer;
  var isLoading = false;
  final _baseUrl = dotenv.get('FIREBASE_AUTH_BASE_URL');
  final _apiKey = dotenv.get('FIREBASE_API_KEY');

  bool get isAuthenticated => token != null;

  String? get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now())) {
      return _token;
    }

    return null;
  }

  String? get userId => _userId;

  Future<void> signup({required String email, required String password}) async {
    try {
      final url = '$_baseUrl:signUp?key=$_apiKey';
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      final responseBody = json.decode(response.body);
      if (responseBody['error'] != null) {
        throw HttpException(responseBody['error']['message']);
      }
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      final url = '$_baseUrl:signInWithPassword?key=$_apiKey';
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      final responseBody = json.decode(response.body);

      if (responseBody['error'] != null) {
        throw HttpException(responseBody['error']['message']);
      }

      _token = responseBody['idToken'];
      _userId = responseBody['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseBody['expiresIn'])));

      // Obtain shared preferences.
      final prefs = await SharedPreferences.getInstance();

      _setAutoLogoutTimer();

      final userDataString = json.encode({
        AuthUserKeys.token: _token,
        AuthUserKeys.userId: _userId,
        AuthUserKeys.expiryDate: _expiryDate?.toIso8601String(),
      });
      await prefs.setString(AuthUserKeys.storeKey, userDataString);

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;

    if (_authTimer != null) {
      _authTimer?.cancel();
    }

    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(AuthUserKeys.storeKey)) {
      await prefs.remove(AuthUserKeys.storeKey);
    }

    notifyListeners();
  }

  void _setAutoLogoutTimer() {
    if (_authTimer != null) {
      _authTimer?.cancel();
      _authTimer = null;
    }
    // if (_expiryDate != null) {
    final secondsToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: secondsToExpiry), logout);
    // } else {
    //   await logout();
    // }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(AuthUserKeys.storeKey)) {
      return false;
    }

    final userDataString = prefs.getString(AuthUserKeys.storeKey);
    if (userDataString == null) {
      return false;
    }

    final userData = json.decode(userDataString) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(userData[AuthUserKeys.expiryDate]);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = userData[AuthUserKeys.token];
    _userId = userData[AuthUserKeys.userId];
    _expiryDate = expiryDate;
    notifyListeners();

    _setAutoLogoutTimer();

    return true;
  }
}

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../model/user.dart';

class AuthViewModel extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  Future<void> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("${dotenv.get('SERVER_URL')}/token/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _user = User(
          email: email,
          accessToken: data['access'],
          refreshToken: data['refresh']);
      notifyListeners();
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<void> refreshToken() async {
    if (_user == null) return;

    final response =
        await http.post(Uri.parse("${dotenv.get("SERVER_URL")}/refresh/"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{'refresh': _user!.refreshToken}));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _user = User(
          email: _user!.email,
          accessToken: data['access'],
          refreshToken: data['refresh']);
      notifyListeners();
    } else {
      throw Exception('Failed to refresh token');
    }
  }
}

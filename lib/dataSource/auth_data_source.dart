import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

abstract class AuthDataSource {
  Future<bool> signIn(String email, String password);

  Future<bool> refreshToken();
}

class AuthDataSourceImpl implements AuthDataSource {
  final _storage = const FlutterSecureStorage();

  @override
  Future<bool> signIn(String email, String password) async {
    final response = await http.post(
      Uri.parse("${dotenv.get('SERVER_URL')}/token/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _storage.write(key: 'accessToken', value: data['access']);
      _storage.write(key: 'refreshToken', value: data['refresh']);
      return true;
    } else {
      throw Exception('Failed to Sign in');
    }
  }

  @override
  Future<bool> refreshToken() async {
    String? refreshToken = await _storage.read(key: 'refreshToken');
    if (refreshToken == null) {
      throw Exception("Refresh token not found");
    }
    final response =
        await http.post(Uri.parse("${dotenv.get("SERVER_URL")}/refresh/"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{'refresh': refreshToken}));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _storage.write(key: 'accessToken', value: data['access']);
      return true;
    } else {
      throw Exception('Failed to refresh token');
    }
  }
}

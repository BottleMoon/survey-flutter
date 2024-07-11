import 'package:flutter/cupertino.dart';
import 'package:survey/repository/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  AuthRepository _repository;

  AuthViewModel(this._repository);

  bool isSignIn = false;

  Future<void> signIn(String email, String password) async {
    bool success = await _repository.signIn(email, password);
    try {
      if (success) {
        isSignIn = true;
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> signOut() async {
    isSignIn = false;
    notifyListeners();
  }

  Future<void> refreshToken() async {
    bool success = await _repository.refreshToken();
  }
}

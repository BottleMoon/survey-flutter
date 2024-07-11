import 'package:survey/dataSource/auth_data_source.dart';

class AuthRepository {
  final AuthDataSource _dataSource;

  AuthRepository(this._dataSource);

  Future<bool> signIn(String email, String password) async {
    return await _dataSource.signIn(email, password);
  }

  Future<bool> refreshToken() async {
    return await _dataSource.refreshToken();
  }
}

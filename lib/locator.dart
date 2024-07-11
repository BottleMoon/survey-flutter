import 'package:get_it/get_it.dart';
import 'package:survey/dataSource/auth_data_source.dart';
import 'package:survey/repository/auth_repository.dart';
import 'package:survey/viewModel/auth_view_model.dart';

final getIt = GetIt.instance;

void setUp() {
  getIt.registerSingleton<AuthDataSource>(AuthDataSourceImpl());
  getIt.registerSingleton<AuthRepository>(
      AuthRepository(getIt<AuthDataSource>()));
  getIt
      .registerSingleton<AuthViewModel>(AuthViewModel(getIt<AuthRepository>()));
}

import 'package:get_it/get_it.dart';
import 'package:survey/dataSource/auth_data_source.dart';
import 'package:survey/dataSource/survey_data_source.dart';
import 'package:survey/repository/SurveyRepository.dart';
import 'package:survey/repository/auth_repository.dart';
import 'package:survey/viewModel/auth_view_model.dart';
import 'package:survey/viewModel/survey_view_model.dart';

final getIt = GetIt.instance;

void setUp() {
  // Auth
  getIt.registerSingleton<AuthDataSource>(AuthDataSourceImpl());
  getIt.registerSingleton<AuthRepository>(
      AuthRepository(getIt<AuthDataSource>()));
  getIt
      .registerSingleton<AuthViewModel>(AuthViewModel(getIt<AuthRepository>()));

  //Survey
  getIt.registerSingleton<SurveyDataSource>(SurveyDataSourceImpl());
  getIt.registerSingleton<SurveyRepository>(
      SurveyRepository(getIt<SurveyDataSource>()));
  getIt.registerSingleton(SurveyViewModel(getIt<SurveyRepository>()));
}

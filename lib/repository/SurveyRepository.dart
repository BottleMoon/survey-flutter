import 'package:survey/dataSource/survey_data_source.dart';
import 'package:survey/model/survey_list_item.dart';

import '../model/survey_detail.dart';

class SurveyRepository {
  final SurveyDataSource _surveyDataSource;

  SurveyRepository(this._surveyDataSource);

  Future<List<SurveyListItem>> getSurveyList() async {
    return await _surveyDataSource.getSurveyList();
  }

  Future<SurveyDetail> getSurveyDetail(int surveyId) async {
    return await _surveyDataSource.getSurveyDetail(surveyId);
  }

  Future<bool> submitSurvey(int surveyId, Map<int, dynamic> request) async {
    return await _surveyDataSource.submitSurvey(surveyId, request);
  }

  Future<bool> isSurveyAvailable(int surveyId) async {
    return await _surveyDataSource.isSurveyAvailable(surveyId);
  }
}

import 'package:survey/dataSource/survey_data_source.dart';
import 'package:survey/model/survey_list_item.dart';

class SurveyRepository {
  final SurveyDataSource _surveyDataSource;

  SurveyRepository(this._surveyDataSource);

  Future<List<SurveyListItem>> getSurveyList() async {
    return await _surveyDataSource.getSurveyList();
  }
}

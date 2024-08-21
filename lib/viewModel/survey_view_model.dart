import 'package:flutter/foundation.dart';
import 'package:survey/model/survey_list_item.dart';
import 'package:survey/repository/SurveyRepository.dart';

import '../model/survey_detail.dart';

class SurveyViewModel extends ChangeNotifier {
  final SurveyRepository _surveyRepository;

  List<SurveyListItem> items = [];
  late SurveyDetail surveyDetail;

  SurveyViewModel(this._surveyRepository);

  Future<void> getSurveyList() async {
    items += await _surveyRepository.getSurveyList();
    notifyListeners();
  }

  Future<void> getSurveyDetail(int surveyId) async {
    surveyDetail = await _surveyRepository.getSurveyDetail(surveyId);
    notifyListeners();
  }
}

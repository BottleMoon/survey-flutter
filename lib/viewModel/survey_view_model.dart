import 'package:flutter/foundation.dart';
import 'package:survey/model/survey_list_item.dart';
import 'package:survey/repository/SurveyRepository.dart';

class SurveyViewModel extends ChangeNotifier {
  final SurveyRepository _surveyRepository;

  List<SurveyListItem> items = [];

  SurveyViewModel(this._surveyRepository);

  void getSurveyList() async {
    items += await _surveyRepository.getSurveyList();
    notifyListeners();
  }
}

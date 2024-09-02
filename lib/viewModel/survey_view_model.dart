import 'package:flutter/foundation.dart';
import 'package:survey/model/survey_list_item.dart';
import 'package:survey/repository/SurveyRepository.dart';

import '../model/survey_detail.dart';

class SurveyViewModel extends ChangeNotifier {
  final SurveyRepository _surveyRepository;
  List<SurveyListItem> items = [];
  SurveyDetail? _currentSurvey;
  Map<int, dynamic> _responses = {};
  int _currentPage = 0;
  static const int _questionsPerPage = 10;
  int? _highlightedQuestionId;

  int? get highlightedQuestionId => _highlightedQuestionId;

  SurveyDetail? get currentSurvey => _currentSurvey;

  Map<int, dynamic> get responses => _responses;

  int get currentPage => _currentPage;

  int get totalPages =>
      (_currentSurvey?.questions.length ?? 0) ~/ _questionsPerPage + 1;

  SurveyViewModel(this._surveyRepository);

  List<Question> get currentPageQuestions {
    if (_currentSurvey == null) return [];
    int start = _currentPage * _questionsPerPage;
    int end = (start + _questionsPerPage < _currentSurvey!.questions.length)
        ? start + _questionsPerPage
        : _currentSurvey!.questions.length;
    return _currentSurvey!.questions.sublist(start, end);
  }

  Future<void> getSurveyList() async {
    items += await _surveyRepository.getSurveyList();
    notifyListeners();
  }

  Future<void> setCurrentSurvey(int surveyId) async {
    _currentSurvey = await _surveyRepository.getSurveyDetail(surveyId);
    print(_currentSurvey.toString());
    notifyListeners();
  }

  void setResponse(int questionId, dynamic response) {
    _responses[questionId] = response;
    notifyListeners();
  }

  bool isCompleted() {
    return _currentSurvey?.questions
            .every((q) => _responses.containsKey(q.id)) ??
        false;
  }

  bool isCurrentPageCompleted() {
    return currentPageQuestions.every((q) => _responses.containsKey(q.id));
  }

  bool isAllCompleted() {
    return _currentSurvey?.questions
            .every((q) => _responses.containsKey(q.id)) ??
        false;
  }

  void nextPage() {
    if (_currentPage < totalPages - 1) {
      _currentPage++;
      notifyListeners();
    }
  }

  void previousPage() {
    if (_currentPage > 0) {
      _currentPage--;
      notifyListeners();
    }
  }

  void highlightQuestion(int questionId) {
    _highlightedQuestionId = questionId;
    notifyListeners();
  }

  int? getFirstUnansweredQuestionId() {
    for (var question in currentPageQuestions) {
      if (!_responses.containsKey(question.id)) {
        return question.id;
      }
    }
    return null;
  }

  Future<bool> submitSurvey() async {
    print('Submitting survey responses: $_responses');
    try {
      await _surveyRepository.submitSurvey(_currentSurvey!.id, _responses);
      _currentSurvey = null;
      _responses.clear();
      _currentPage = 0;
      notifyListeners();
      return true;
    } catch (e) {
      print("Failed to submit survey: $e");
      return false;
    }
  }

  Future<bool> isSurveyAvailable(int surveyId) async {
    return await _surveyRepository.isSurveyAvailable(surveyId);
  }
}

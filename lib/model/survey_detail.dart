class SurveyDetail {
  int id;
  String title;
  String description;
  DateTime createdAt;
  List<Question> questions;

  SurveyDetail(
      this.id, this.title, this.description, this.createdAt, this.questions);

  factory SurveyDetail.fromJson(Map<String, dynamic> json) {
    return SurveyDetail(
      json['id'],
      json['title'],
      json['main_description'],
      DateTime.parse(json['created_at']),
      (json['questions'] as List<dynamic>)
          .map((question) => Question.fromJson(question))
          .toList(),
    );
  }
}

class Question {
  int id;
  String text;
  QuestionType questionType;
  List<Choice> choices;

  Question(this.id, this.text, this.questionType, this.choices);

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      json['id'],
      json['text'],
      getQuestionType(json['question_type']),
      (json['choices'] as List<dynamic>)
          .map((choice) => Choice.fromJson(choice))
          .toList(),
    );
  }
}

class Choice {
  int id;
  String text;

  Choice(this.id, this.text);

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      json['id'],
      json['text'],
    );
  }
}

enum QuestionType { CHOICE, TEXT_RESPONSE }

QuestionType getQuestionType(String s) {
  switch (s) {
    case 'CHOICE':
      return QuestionType.CHOICE;
    case 'TEXT_RESPONSE':
      return QuestionType.TEXT_RESPONSE;
    default:
      throw ArgumentError('Unknown question type: $s');
  }
}

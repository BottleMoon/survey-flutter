class SurveyDetail {
  int id;
  String title;
  String description;
  DateTime createdAt;

  SurveyDetail(this.id, this.title, this.description, this.createdAt);

  factory SurveyDetail.fromJson(Map<String, dynamic> json) {
    return SurveyDetail(json['id'], json['title'], json['main_description'],
        DateTime.parse(json['created_at']));
  }
}

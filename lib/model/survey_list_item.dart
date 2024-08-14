class SurveyListItem {
  int id;
  String title;
  String small_description;

  SurveyListItem(this.id, this.title, this.small_description);

  factory SurveyListItem.fromJson(Map<String, dynamic> json) {
    return SurveyListItem(json['id'], json['title'], json['small_description']);
  }
}

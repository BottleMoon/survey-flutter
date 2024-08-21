import 'package:flutter/material.dart';
import 'package:survey/model/survey_detail.dart';

class SurveyDetailView extends StatelessWidget {
  final SurveyDetail surveyDetail;

  const SurveyDetailView({super.key, required this.surveyDetail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(surveyDetail.title)),
      body: Column(
        children: [
          Text(surveyDetail.description),
          Text(surveyDetail.createdAt.toString()),
          ElevatedButton(onPressed: () => {}, child: Text("설문조사 시작"))
        ],
      ),
    );
  }
}

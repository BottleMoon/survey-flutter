import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:survey/viewModel/survey_view_model.dart';

class SurveyListView extends StatefulWidget {
  const SurveyListView({super.key});

  @override
  State<SurveyListView> createState() => _SurveyListViewState();
}

class _SurveyListViewState extends State<SurveyListView> {
  late ScrollController _scrollController;
  late double _scrollPosition;

  _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {}
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var surveyViewModel = Provider.of<SurveyViewModel>(context);

    if (surveyViewModel.items.isEmpty) {
      surveyViewModel.getSurveyList();
    }

    ScrollController _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        surveyViewModel.getSurveyList();
      }
    });

    return Column(
      children: [
        Expanded(
            child: ListView.builder(
                controller: _scrollController,
                itemCount: surveyViewModel.items.length,
                itemBuilder: (context, index) {
                  final item = surveyViewModel.items[index];
                  return Container(
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                          title: Text(item.title),
                          subtitle: Text(item.small_description),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              // 테두리 모양 설정
                              side: BorderSide(color: Colors.black, width: 1)),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10)));
                }))
      ],
    );
  }
}

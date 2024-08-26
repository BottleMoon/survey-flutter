import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:survey/view/survey_detail_view.dart';
import 'package:survey/viewModel/survey_view_model.dart';

class SurveyListView extends StatefulWidget {
  const SurveyListView({super.key});

  @override
  State<SurveyListView> createState() => _SurveyListViewState();
}

class _SurveyListViewState extends State<SurveyListView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      Provider.of<SurveyViewModel>(context, listen: false).getSurveyList();
    }
  }

  @override
  Widget build(BuildContext context) {
    var surveyViewModel = Provider.of<SurveyViewModel>(context);

    if (surveyViewModel.items.isEmpty) {
      surveyViewModel.getSurveyList();
    }

    return Container(
      color: Colors.grey[100],
      child: ListView.builder(
        controller: _scrollController,
        itemCount: surveyViewModel.items.length,
        itemBuilder: (context, index) {
          final item = surveyViewModel.items[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              onTap: () => _tileOnTapped(item.id, surveyViewModel, context),
              contentPadding: EdgeInsets.all(16),
              title: Text(
                item.title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  item.small_description,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue),
            ),
          );
        },
      ),
    );
  }

  void _tileOnTapped(
      int id, SurveyViewModel viewModel, BuildContext context) async {
    await viewModel.getSurveyDetail(id);
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
          SurveyDetailView(surveyDetail: viewModel.surveyDetail),
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:survey/view/survey_view.dart';
import 'package:survey/viewModel/survey_view_model.dart';

class SurveyDetailView extends StatelessWidget {
  const SurveyDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = Provider.of<SurveyViewModel>((context));
    if (viewModel.currentSurvey == null) {
      return CircularProgressIndicator();
    }

    _startSurveyOnPressed() async {
      if (await viewModel.isSurveyAvailable(viewModel.currentSurvey!.id)) {
        //TODO: 참가 실패 알림
      } else {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SurveyView(),
        ));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("surveys", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[100],
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        viewModel.currentSurvey!.title,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        viewModel.currentSurvey!.description,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Created at: ${DateFormat('dd/MM/yyyy, hh:mm:ss a').format(viewModel.currentSurvey!.createdAt)}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _startSurveyOnPressed,
                        child: Text('Start Survey',
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

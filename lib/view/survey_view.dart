// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../model/survey_detail.dart';
// import '../viewModel/survey_view_model.dart';
//
// // Widget (updated)
// class SurveyView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Survey'),
//         backgroundColor: Colors.blue,
//       ),
//       body: Consumer<SurveyViewModel>(
//         builder: (context, viewModel, child) {
//           if (viewModel.currentSurvey == null) {
//             return Center(child: CircularProgressIndicator());
//           }
//
//           return Column(
//             children: [
//               Expanded(
//                 child: SingleChildScrollView(
//                   padding: EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         viewModel.currentSurvey!.title,
//                         style: TextStyle(
//                             fontSize: 24, fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(height: 16),
//                       Text(
//                         viewModel.currentSurvey!.description,
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       SizedBox(height: 24),
//                       ...viewModel.currentPageQuestions.map((question) =>
//                           _buildQuestionWidget(context, question, viewModel)),
//                     ],
//                   ),
//                 ),
//               ),
//               _buildNavigationButtons(context, viewModel),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildQuestionWidget(
//       BuildContext context, Question question, SurveyViewModel viewModel) {
//     return Card(
//       margin: EdgeInsets.only(bottom: 16),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               question.text,
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 16),
//             if (question.questionType == QuestionType.CHOICE)
//               ...question.choices.map(
//                 (choice) => RadioListTile<int>(
//                   title: Text(choice.text),
//                   value: choice.id,
//                   groupValue: viewModel.responses[question.id],
//                   onChanged: (value) =>
//                       viewModel.setResponse(question.id, value),
//                 ),
//               )
//             else if (question.questionType == QuestionType.TEXT_RESPONSE)
//               TextFormField(
//                 decoration: InputDecoration(
//                   hintText: 'Enter your answer here',
//                   border: OutlineInputBorder(),
//                 ),
//                 onChanged: (value) => viewModel.setResponse(question.id, value),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildNavigationButtons(
//       BuildContext context, SurveyViewModel viewModel) {
//     return Container(
//       padding: EdgeInsets.all(16),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           if (viewModel.currentPage > 0)
//             ElevatedButton(
//               onPressed: viewModel.previousPage,
//               child: Text('Previous'),
//             )
//           else
//             SizedBox(width: 0),
//           Text('Page ${viewModel.currentPage + 1} of ${viewModel.totalPages}'),
//           if (viewModel.currentPage < viewModel.totalPages - 1)
//             ElevatedButton(
//               onPressed: viewModel.isCurrentPageCompleted()
//                   ? viewModel.nextPage
//                   : null,
//               child: Text('Next'),
//             )
//           else
//             ElevatedButton(
//               onPressed: viewModel.isAllCompleted()
//                   ? () {
//                       viewModel.submitSurvey();
//                       Navigator.pop(context);
//                     }
//                   : null,
//               child: Text('Submit Survey'),
//             ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/survey_detail.dart';
import '../viewModel/survey_view_model.dart';

class SurveyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Survey'),
        backgroundColor: Colors.blue,
      ),
      body: Consumer<SurveyViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.currentSurvey == null) {
            return Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        viewModel.currentSurvey!.title,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      Text(
                        viewModel.currentSurvey!.description,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 24),
                      ...viewModel.currentPageQuestions.map((question) =>
                          _buildQuestionWidget(context, question, viewModel)),
                    ],
                  ),
                ),
              ),
              _buildNavigationButtons(context, viewModel),
            ],
          );
        },
      ),
    );
  }

  Widget _buildQuestionWidget(
      BuildContext context, Question question, SurveyViewModel viewModel) {
    bool isHighlighted = viewModel.highlightedQuestionId == question.id;
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      color: isHighlighted ? Colors.yellow.shade100 : null,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.text,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            if (question.questionType == QuestionType.CHOICE)
              ...question.choices.map(
                (choice) => RadioListTile<int>(
                  title: Text(choice.text),
                  value: choice.id,
                  groupValue: viewModel.responses[question.id],
                  onChanged: (value) =>
                      viewModel.setResponse(question.id, value),
                ),
              )
            else if (question.questionType == QuestionType.TEXT_RESPONSE)
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Enter your answer here',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => viewModel.setResponse(question.id, value),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons(
      BuildContext context, SurveyViewModel viewModel) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (viewModel.currentPage > 0)
            ElevatedButton(
              onPressed: viewModel.previousPage,
              child: Text('Previous'),
            )
          else
            SizedBox(width: 0),
          Text('Page ${viewModel.currentPage + 1} of ${viewModel.totalPages}'),
          if (viewModel.currentPage < viewModel.totalPages - 1)
            ElevatedButton(
              onPressed: () => _handleNextPage(context, viewModel),
              child: Text('Next'),
            )
          else
            ElevatedButton(
              onPressed: () => _handleSubmit(context, viewModel),
              child: Text('Submit Survey'),
            ),
        ],
      ),
    );
  }

  void _handleNextPage(BuildContext context, SurveyViewModel viewModel) {
    int? unansweredQuestionId = viewModel.getFirstUnansweredQuestionId();
    if (unansweredQuestionId != null) {
      viewModel.highlightQuestion(unansweredQuestionId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Please answer all questions before proceeding.')),
      );
    } else {
      viewModel.nextPage();
    }
  }

  void _handleSubmit(BuildContext context, SurveyViewModel viewModel) async {
    int? unansweredQuestionId = viewModel.getFirstUnansweredQuestionId();
    if (unansweredQuestionId != null) {
      viewModel.highlightQuestion(unansweredQuestionId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Please answer all questions before submitting.')),
      );
    } else {
      bool success = await viewModel.submitSurvey();
      if (success) {
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content:
                  Text('Your survey response has been successfully submitted.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit survey. Please try again.')),
        );
      }
    }
  }
}

import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:survey/model/survey_list_item.dart';

import '../model/survey_detail.dart';

abstract class SurveyDataSource {
  Future<List<SurveyListItem>> getSurveyList();

  Future<SurveyDetail> getSurveyDetail(int surveyId);
}

class SurveyDataSourceImpl implements SurveyDataSource {
  static String next = "";
  static String? _accessToken = null;

  Future<void> _readAccessToken() async {
    final _storage = const FlutterSecureStorage();
    _accessToken = await _storage.read(key: "accessToken");
    if (_accessToken == null) {
      throw Exception("AccessToken not exist");
    }
  }

  @override
  Future<List<SurveyListItem>> getSurveyList() async {
    // TODO: implement getSurveyList

    await _readAccessToken();

    Uri _requestUrl;
    if (next == "") {
      _requestUrl = Uri.parse(dotenv.get("SURVEY_API_URL"));
    } else {
      _requestUrl = Uri.parse(next);
    }

    http.Response response = await http
        .get(_requestUrl, headers: {"authorization": "Bearer $_accessToken"});

    if (response.statusCode == 200) {
      Map<String, dynamic> body = json.decode(response.body);
      List<dynamic> data = body["results"];
      next = body["next"];
      List<SurveyListItem> items =
          data.map((dynamic item) => SurveyListItem.fromJson(item)).toList();
      return items;
    } else {
      throw Exception("failed load survey list");
    }
  }

  @override
  Future<SurveyDetail> getSurveyDetail(int surveyId) async {
    // TODO: implement getSurveyDetail
    await _readAccessToken();

    var response = await http.get(
        Uri.parse("${dotenv.get("SURVEY_API_URL")}/$surveyId"),
        headers: {"authorization": "Bearer $_accessToken"});
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data);
      return SurveyDetail.fromJson(data);
    } else {
      throw Exception("failed load survey id: $surveyId");
    }
  }
}

class SurveyDataSourceTestImpl implements SurveyDataSource {
  List<SurveyListItem> _testList() {
    List<SurveyListItem> surveys = [];
    for (int i = 1; i < 50; i++) {
      surveys.add(SurveyListItem(i, "title$i", "description$i"));
    }
    return surveys;
  }

  @override
  Future<List<SurveyListItem>> getSurveyList() {
    return Future(() {
      return _testList();
    });
  }

  @override
  Future<SurveyDetail> getSurveyDetail(int surveyId) {
    // TODO: implement getSurveyDetail
    throw UnimplementedError();
  }
}

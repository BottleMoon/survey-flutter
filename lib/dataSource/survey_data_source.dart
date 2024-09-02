import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:survey/model/survey_list_item.dart';

import '../model/survey_detail.dart';

abstract class SurveyDataSource {
  Future<List<SurveyListItem>> getSurveyList();

  Future<SurveyDetail> getSurveyDetail(int surveyId);

  Future<bool> submitSurvey(int surveyId, Map<int, dynamic> request);

  Future<bool> isSurveyAvailable(int surveyId);
}

class SurveyDataSourceImpl implements SurveyDataSource {
  static String next = "";
  static String? _accessToken = null;
  static bool isEnd = false;

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

    if (isEnd) {
      throw Exception("no more data");
    }

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
      Map<String, dynamic> body = json.decode(utf8.decode(response.bodyBytes));
      List<dynamic> data = body["results"];
      if (body["next"] != null) {
        next = body["next"];
      } else {
        isEnd = true;
      }
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
      var data = json.decode(utf8.decode(response.bodyBytes));
      print(data);
      return SurveyDetail.fromJson(data);
    } else {
      throw Exception("failed load survey id: $surveyId");
    }
  }

  @override
  Future<bool> submitSurvey(int surveyId, Map<int, dynamic> request) async {
    await _readAccessToken();

    // 딕셔너리를 리스트로 변환
    List<Map<String, dynamic>> formattedRequest = request.entries
        .map((entry) => {"question_id": entry.key, "answer": entry.value})
        .toList();

    var response = await http.post(
      Uri.parse("${dotenv.get("SURVEY_API_URL")}/$surveyId/responses/"),
      headers: {
        "Authorization": "Bearer $_accessToken",
        "Content-Type": "application/json"
      },
      body: json.encode(formattedRequest),
    );

    if (response.statusCode != 201) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Future<bool> isSurveyAvailable(int surveyId) async {
    var response = await http.get(Uri.parse(
        "${dotenv.get("SURVEY_API_URL")}/$surveyId/check-availability/"));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}

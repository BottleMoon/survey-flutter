import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:survey/model/survey_list_item.dart';

abstract class SurveyDataSource {
  Future<List<SurveyListItem>> getSurveyList();
}

class SurveyDataSourceImpl implements SurveyDataSource {
  static String next = "";

  @override
  Future<List<SurveyListItem>> getSurveyList() async {
    // TODO: implement getSurveyList
    final _storage = const FlutterSecureStorage();
    Uri _requestUrl;
    if (next == "") {
      _requestUrl = Uri.parse(dotenv.get("SURVEY_LIST_GET_URL"));
    } else {
      _requestUrl = Uri.parse(next);
    }

    String? _accessToken = await _storage.read(key: "accessToken");
    print(_accessToken);
    if (_accessToken == null) {
      throw Exception("accessToken not exist");
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
}

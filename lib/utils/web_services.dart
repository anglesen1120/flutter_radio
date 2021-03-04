import 'dart:convert';
import 'package:flutter_radio/model/base_model.dart';
import 'package:http/http.dart' as http;

class WebServices {
  Future<BaseModel> getData(String url, BaseModel baseModel) async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      baseModel.fromJson(json.decode(response.body));
      return baseModel;
    } else {
      throw Exception('Failed to load data!');
    }
  }
}

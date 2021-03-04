import 'package:flutter_radio/model/base_model.dart';
import 'package:flutter_radio/model/db_model.dart';

class RadioAPIModel extends BaseModel {
  List<RadioModel> data;
  RadioAPIModel({
    this.data,
  });

  @override
  fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    this.data = (json["Data"] as List)
        .map(
          (i) => RadioModel.fromJson(i),
        )
        .toList();
  }
}

class RadioModel extends DBBaseModel {
  static String table = 'radios';

  final int id;
  final String radioName;
  final String radioURL;
  final String radioDesc;
  final String radioWebsite;
  final String radioPic;
  final bool isBookmarked;

  RadioModel(
      {this.id,
      this.radioName,
      this.radioURL,
      this.radioDesc,
      this.radioWebsite,
      this.radioPic,
      this.isBookmarked});

  factory RadioModel.fromJson(Map<String, dynamic> json) {
    return RadioModel(
        id: json["ID"],
        radioName: json["RadioName"],
        radioURL: json["RadioURL"],
        radioDesc: json["RadioDesc"],
        radioPic: json["RadioPic"],
        radioWebsite: json["RadioURL"],
        isBookmarked: false);
  }

  static RadioModel fromMap(Map<String, dynamic> map) {
    return RadioModel(
        id: map["id"],
        radioName: map["radioName"],
        radioDesc: map["radioDesc"],
        radioPic: map["radioPic"],
        radioURL: map["radioURL"],
        radioWebsite: map["radioWebsite"],
        isBookmarked: map["isFavourite"] == 1 ? true : false);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'radioName': radioName,
      'radioURL': radioURL,
      'radioDesc': radioDesc,
      'radioPic': radioPic,
      'radioWebsite': radioWebsite
    };

    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}

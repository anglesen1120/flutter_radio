import 'package:flutter_radio/model/radio.dart';
import 'package:flutter_radio/utils/config.dart';
import 'package:flutter_radio/utils/db_services.dart';
import 'package:flutter_radio/utils/web_services.dart';

class DBDownloadServices {
  static Future<bool> isLocalDBAvailable() async {
    await DatabaseServices.init();
    List<Map<String, dynamic>> _result =
        await DatabaseServices.query(RadioModel.table);
    return _result.length == 0 ? false : true;
  }

  static Future<RadioAPIModel> fetchAllRadios() async {
    final serviceResponse =
        await WebServices().getData(Config.apiURL, new RadioAPIModel());
    return serviceResponse;
  }

  static Future<List<RadioModel>> fetchLocalDB({
    String searchQuery = "",
    bool isFavouriteOnly = false,
  }) async {
    if (!await isLocalDBAvailable()) {
      // HTTP Call to fetch JSON Data
      RadioAPIModel radioAPIModel = await fetchAllRadios();

      //Check for data length
      if (radioAPIModel.data.length > 0) {
        //Init DB
        await DatabaseServices.init();

        //ForEach api Data and Save in Local DB
        radioAPIModel.data.forEach((RadioModel radioModel) {
          DatabaseServices.insert(RadioModel.table, radioModel);
        });
      }
    }
    String rawQuery = "";
    if (!isFavouriteOnly) {
      rawQuery =
          "SELECT radios.id, radioName, radioURL, radioURL, radioDesc, radioWebsite, radioPic,"
          "isFavourite FROM radios LEFT JOIN radios_bookmarks ON radios_bookmarks.id = radios.id ";

      if (searchQuery.trim() != "") {
        rawQuery = rawQuery +
            " WHERE radioName LIKE '%$searchQuery%' OR radioDesc LIKE '%$searchQuery%' ";
      }
    } else {
      rawQuery =
          "SELECT radios.id, radioName, radioURL, radioURL, radioDesc, radioWebsite, radioPic,"
          "isFavourite FROM radios INNER JOIN radios_bookmarks ON radios_bookmarks.id = radios.id "
          "WHERE isFavourite = 1 ";

      if (searchQuery.trim() != "") {
        rawQuery = rawQuery +
            " AND radioName LIKE '%$searchQuery%' OR radioDesc LIKE '%$searchQuery%' ";
      }
    }
    List<Map<String, dynamic>> _results =
        await DatabaseServices.rawQuery(rawQuery);

    List<RadioModel> radioModel = new List<RadioModel>();
    radioModel = _results.map((item) => RadioModel.fromMap(item)).toList();
    return radioModel;
  }
}

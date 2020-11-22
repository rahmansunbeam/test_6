import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:flutter/services.dart';

class CsvToMapConverter {
  CsvToListConverter converter;
  CsvToMapConverter(
      {String fieldDelimiter = defaultFieldDelimiter,
      String textDelimiter = defaultTextDelimiter,
      String textEndDelimiter,
      String eol = defaultEol,
      CsvSettingsDetector csvSettingsDetector,
      bool shouldParseNumbers,
      bool allowInvalid}) {
    converter = CsvToListConverter(
        fieldDelimiter: fieldDelimiter,
        textDelimiter: textDelimiter,
        textEndDelimiter: textEndDelimiter,
        eol: eol,
        csvSettingsDetector: csvSettingsDetector,
        shouldParseNumbers: shouldParseNumbers,
        allowInvalid: allowInvalid);
  }
  List<Map<String, dynamic>> convert(String csv) {
    List<List<dynamic>> list = converter.convert(csv);
    List legend = list[0];
    List<Map<String, dynamic>> maps = [];
    list.sublist(1).forEach((List l) {
      Map<String, dynamic> map = {};
      for (int i = 0; i < legend.length; i++) {
        map.putIfAbsent('${legend[i]}', () => l[i]);
      }
      maps.add(map);
    });
    return maps;
  }
}

Future<List<Map>> loadAsset() async {
  var myData = await rootBundle.loadString("assets/wordlist.csv");
  List<Map<String, dynamic>> csvTable = CsvToMapConverter().convert(myData);

  // Create list of items for each row
  List<Map> data = [];

  csvTable.forEach((value) {
    data.add(value);
  });
  return data;
}

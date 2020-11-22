import 'package:shared_preferences/shared_preferences.dart';

// set system theme to system memory
Future<bool> getThemeFromMemory() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool value = prefs.getBool('themekey') ?? false;
  return value;
}

Future<void> setThemeToMemory(bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('themekey', value);
}

// set favourite list to memory _favouriteItemListFull
Future<List<bool>> getFavListFromMemory() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> val = prefs.getStringList('favouriteList') ?? List<String>();
  List<bool> value = val.map((e) => e == 'true' ? true : false).toList();
  return value;
}

Future<void> setFavListToMemory(List<bool> value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList('favouriteList', value.map((i) => i.toString()).toList());
}

// set favourite list to memory _favouriteItemListFull
Future<List<int>> getFavWordsFromMemory() async {
  List<int> value = [];
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> stringValue = prefs.getStringList('favWordList');
  if (stringValue != null) value = stringValue.map(int.parse).toList();
  return value;
}

Future<void> setFavWordsToMemory(List value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList('favWordList', value.map((i) => i.toString()).toList());
}

// remove all user data
removeAllUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // remove favourite list
  prefs.remove("favouriteList");
  // remove words
  prefs.remove("favWordList");
}

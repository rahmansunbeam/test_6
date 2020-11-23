import 'package:flutter/material.dart';

Widget dialogboxForWordset(final context, final bool darkThemeChosen,
    final List listOfButtonsForWordset, List _aList, dynamic _wordIdx) {
  return AlertDialog(
    backgroundColor: darkThemeChosen ? Colors.grey[700] : Colors.white,
    title: Text(
      "choose a set",
      style: TextStyle(color: darkThemeChosen ? Colors.white : Colors.grey[700]),
    ),
    titlePadding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
        vertical: MediaQuery.of(context).size.width * 0.04),
    contentPadding: EdgeInsets.all(0),
    content: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        children: [renderListOfButtonsForWordset(listOfButtonsForWordset)]),
    actions: <Widget>[
      new FlatButton(
          child: new Text(
            "Clear",
            style: TextStyle(color: darkThemeChosen ? Colors.white : Colors.blue),
          ),
          onPressed: () => {_aList.clear(), _wordIdx = null}
          // setState(() {
          //   _listOfWordset.clear();
          //   _currentWordsetIdx = null;
          // });
          ),
      new FlatButton(
        child: new Text("Close",
            style: TextStyle(color: darkThemeChosen ? Colors.white : Colors.blue)),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ],
  );
}

Widget renderListOfButtonsForWordset(List<Widget> _item) {
  List<Widget> list = List<Widget>();
  for (var i = 0; i < _item.length; i++) {
    if (_item[i] != null) {
      list.add(_item[i]);
    }
  }
  return Wrap(children: list, alignment: WrapAlignment.start);
}

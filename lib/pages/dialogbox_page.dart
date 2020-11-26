import 'package:flutter/material.dart';

class DialogboxForWordset extends StatefulWidget {
  final bool darkThemeChosen;
  final List listOfButtonsForWordset;
  final callback;

  const DialogboxForWordset(
      {Key key, this.darkThemeChosen, this.listOfButtonsForWordset, this.callback})
      : super(key: key);

  @override
  _DialogboxForWordsetState createState() => _DialogboxForWordsetState();
}

class _DialogboxForWordsetState extends State<DialogboxForWordset> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: widget.darkThemeChosen ? Colors.grey[700] : Colors.white,
      title: Text(
        "choose a set",
        style: TextStyle(color: widget.darkThemeChosen ? Colors.white : Colors.grey[700]),
      ),
      titlePadding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
          vertical: MediaQuery.of(context).size.width * 0.04),
      contentPadding: EdgeInsets.all(0),
      content: Wrap(
          alignment: WrapAlignment.spaceEvenly,
          children: [renderListOfButtonsForWordset(widget.listOfButtonsForWordset)]),
      actions: <Widget>[
        new FlatButton(
          child: new Text(
            "Clear",
            style: TextStyle(color: widget.darkThemeChosen ? Colors.white : Colors.blue),
          ),
          onPressed: () {
            widget?.callback();
          },
        ),
        new FlatButton(
          child: new Text("Close",
              style:
                  TextStyle(color: widget.darkThemeChosen ? Colors.white : Colors.blue)),
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
}

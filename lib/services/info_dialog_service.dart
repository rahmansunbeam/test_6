import 'package:flutter/material.dart';

class InfoDialogbox extends StatelessWidget {
  final bool darkThemeChosen;
  const InfoDialogbox({Key key, this.darkThemeChosen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: darkThemeChosen ? Colors.grey[700] : Colors.white,
      title: Text(
        "Thanks for using this app",
        style: TextStyle(color: darkThemeChosen ? Colors.white : Colors.grey[700]),
      ),
      content: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        children: [
          Text(
              'This flashcard app is just a small experiment during my GRE endeavor and hope that helps you. Please send me your comments and suggestions at info@clubgis.net',
              style: TextStyle(color: darkThemeChosen ? Colors.white : Colors.black)),
          Divider(
            color: darkThemeChosen ? Colors.white : Colors.grey[700],
            thickness: 1,
          ),
          Text('Thanks to Greg from GregMat.com for letting me use this wordlist',
              style: TextStyle(
                  color: darkThemeChosen ? Colors.amber : Colors.grey[700],
                  fontStyle: FontStyle.italic)),
        ],
      ),
      actions: [
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
}

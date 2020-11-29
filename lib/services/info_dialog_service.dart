import 'package:flutter/material.dart';

class InfoDialogbox extends StatelessWidget {
  final bool darkThemeChosen;
  const InfoDialogbox({Key key, this.darkThemeChosen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: darkThemeChosen ? Colors.grey[700] : Colors.white,
      title: Text(
        "Thank you",
        style:
            TextStyle(color: darkThemeChosen ? Colors.white : Colors.grey[700]),
      ),
      content: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        children: [
          Text(
          'This flashcard app is just a small experiment which I hope you\'d like. Please send me your suggestions at info@clubgis.net',
          style:
            TextStyle(color: darkThemeChosen ? Colors.white : Colors.black)),
          
          Divider(color: darkThemeChosen ? Colors.white : Colors.grey[700], thickness: 1,),
          Text('Thanks to Greg at GregMat.com for letting me use his wordlist. This list is awesome !', 
          style:
            TextStyle(color: darkThemeChosen ? Colors.yellow : Colors.grey[700])),
        ],
      ),
      actions: [
        new FlatButton(
          child: new Text("Close",
              style: TextStyle(
                  color: darkThemeChosen ? Colors.white : Colors.blue)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

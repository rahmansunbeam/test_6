import 'package:flutter/material.dart';

class InfoDialogbox extends StatelessWidget {
  final bool darkThemeChosen;
  const InfoDialogbox({Key key, this.darkThemeChosen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: darkThemeChosen ? Colors.grey[700] : Colors.white,
      title: RichText(
        text: TextSpan(children: [
          TextSpan(
              text: 'Just Another Flashcard App',
              style: TextStyle(
                  fontSize: 14.0 * MediaQuery.textScaleFactorOf(context),
                  fontFamily: 'Roboto Slab',
                  color: darkThemeChosen ? Colors.white : Colors.grey[700])),
          WidgetSpan(
            child: Transform.translate(
              offset: const Offset(2, -6),
              child: Text(
                'v1.0.4',
                textScaleFactor: 0.6,
                style: TextStyle(
                    fontFamily: 'Roboto Slab',
                    color: darkThemeChosen ? Colors.white : Colors.grey[700]),
              ),
            ),
          )
        ]),
      ),
      content: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        children: [
          Text(
              'Thank you for using this app. This app is just a small experiment during my GRE endeavor and hope that helps you. Please send me your comments and suggestions at info@clubgis.net.',
              style: TextStyle(
                  fontSize: 13.0 * MediaQuery.textScaleFactorOf(context),
                  color: darkThemeChosen ? Colors.white : Colors.black)),
          Divider(
            color: darkThemeChosen ? Colors.white : Colors.grey[700],
            thickness: 1,
          ),
          Text('Thanks to Greg from GregMat.com for letting me use this wordlist',
              style: TextStyle(
                  color: darkThemeChosen ? Colors.amber : Colors.grey[700],
                  fontSize: 13.0 * MediaQuery.textScaleFactorOf(context),
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

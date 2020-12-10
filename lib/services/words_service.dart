import 'package:flutter/material.dart';

class WordsToRender extends StatefulWidget {
  final List listOfWordset;
  final bool listSelected;
  final bool darkThemeChosen;
  final data;
  final index;

  const WordsToRender(
      {Key key,
      this.listOfWordset,
      this.listSelected,
      this.darkThemeChosen,
      this.data,
      this.index})
      : super(key: key);

  @override
  _WordsToRenderState createState() => _WordsToRenderState();
}

class _WordsToRenderState extends State<WordsToRender> {
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _synonymsAndAntonyms(_height, _width),
          _wordMeanings(_height, _width),
          _words(_height, _width),
          _progressBar()
        ],
      ),
    );
  }

  // Antonyms and synonyms chips are processed
  Widget _listOfWordsToMakeChips(List<String> _item, Color _bgColor) {
    double _width = MediaQuery.of(context).size.width;
    List<Widget> list = [];
    for (var i = 0; i < _item.length; i++) {
      if (_item[i] != 'N/A' && _item[i] != '') {
        list.add(Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: _bgColor, borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Text(_item[i],
                style: TextStyle(
                  fontSize: (_width < 375)
                      ? 11.0 * MediaQuery.textScaleFactorOf(context)
                      : (_width >= 375 && _width < 600)
                          ? 12.0 * MediaQuery.textScaleFactorOf(context)
                          : 14.0 * MediaQuery.textScaleFactorOf(context),
                )),
          ),
        ));
      }
    }
    return Wrap(runSpacing: -16, spacing: 2, children: list);
  }

  Widget _synonymsAndAntonyms(double _height, double _width) {
    return Container(
      constraints:
          BoxConstraints(maxHeight: double.infinity, minHeight: _height / 100 * 15),
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _listOfWordsToMakeChips(
                  widget.listSelected
                      ? widget.listOfWordset[0][widget.index]['ANTONYMS'].split('| ')
                      : widget.data[widget.index]['ANTONYMS'].split('| '),
                  Colors.amber),
              _listOfWordsToMakeChips(
                  widget.listSelected
                      ? widget.listOfWordset[0][widget.index]['SYNONYMS'].split('| ')
                      : widget.data[widget.index]['SYNONYMS'].split('| '),
                  Colors.tealAccent),
            ],
          )),
    );
  }

  Widget _wordMeanings(double _height, double _width) {
    return Container(
      alignment: Alignment.bottomLeft,
      constraints:
          BoxConstraints(maxHeight: _height / 100 * 7, minHeight: _height / 100 * 6),
      child: Scrollbar(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Text(
            widget.listSelected
                ? widget.listOfWordset[0][widget.index]['MEANINGS']
                : widget.data[widget.index]['MEANINGS'],
            style: TextStyle(
                color: widget.darkThemeChosen ? Colors.white : Colors.black,
                fontSize: (_width < 375)
                    ? 13.0 * MediaQuery.textScaleFactorOf(context)
                    : (_width >= 375 && _width < 600)
                        ? 14.0 * MediaQuery.textScaleFactorOf(context)
                        : 16.0 * MediaQuery.textScaleFactorOf(context)),
          ),
        ),
      ),
    );
  }

  Widget _words(double _height, double _width) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: const EdgeInsets.only(top: 4.0),
        alignment: Alignment.centerLeft,
        constraints:
            BoxConstraints(maxHeight: double.infinity, minHeight: _height / 100 * 5),
        child: Text(
          widget.listSelected
              ? widget.listOfWordset[0][widget.index]['WORDS']
              : widget.data[widget.index]['WORDS'],
          style: TextStyle(
              color: widget.darkThemeChosen ? Colors.white : Colors.grey[700],
              fontFamily: 'Roboto Slab',
              fontSize: (_width < 375)
                  ? 20.0 * MediaQuery.textScaleFactorOf(context)
                  : (_width >= 375 && _width < 600)
                      ? 22.0 * MediaQuery.textScaleFactorOf(context)
                      : 30.0 * MediaQuery.textScaleFactorOf(context)),
        ),
      ),
    );
  }

  Widget _progressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Container(
        height: 3.5,
        alignment: Alignment.center,
        child: LinearProgressIndicator(
          value: (widget.listSelected
              ? widget.listOfWordset[0].indexOf(widget.listOfWordset[0][widget.index]) /
                  100 *
                  3.5
              : widget.data.indexOf(widget.data[widget.index]) / 100 * 0.12),
        ),
      ),
    );
  }
}

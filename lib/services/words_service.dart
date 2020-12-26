import 'package:flutter/material.dart';

class WordsToRender extends StatefulWidget {
  final List listOfWordset;
  final bool listSelected;
  final bool darkThemeChosen;
  final data;
  final index;

  const WordsToRender(
      {Key key, this.listOfWordset, this.listSelected, this.darkThemeChosen, this.data, this.index})
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
          _synonymsAndAntonyms(_height),
          _wordMeanings(_height, _width),
          _words(_height, _width),
          _progressBar()
        ],
      ),
    );
  }

  Widget _containerForChips(String _listItem, Color _bgColor) {
    double _width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      decoration:
          BoxDecoration(color: _bgColor, borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Text(_listItem,
          style: TextStyle(
            fontSize: (_width < 375)
                ? 11.0 * MediaQuery.textScaleFactorOf(context)
                : (_width >= 375 && _width < 600)
                    ? 12.0 * MediaQuery.textScaleFactorOf(context)
                    : 14.0 * MediaQuery.textScaleFactorOf(context),
          )),
    );
  }

  // Antonyms and synonyms chips are processed
  Widget _listOfWordChips(List<String> _item, Color _bgColor) {
    List<Widget> _list = [];
    for (var i = 0; i < _item.length; i++) {
      if (_item[i] != 'N/A' && _item[i] != '') {
        _list.add(_containerForChips(_item[i], _bgColor));
      }
    }
    return Wrap(runSpacing: -16, spacing: 2, children: _list);

    // return SizedBox(
    //   height: 40,
    //   child: ListView.builder(
    //       shrinkWrap: true,
    //       scrollDirection: Axis.horizontal,
    //       physics: NeverScrollableScrollPhysics(),
    //       itemCount: _item.length,
    //       itemBuilder: (context, index) {
    //         if (_item[index] != 'N/A' && _item[index] != '') {
    //           return Padding(
    //             padding: const EdgeInsets.only(right: 2.0),
    //             child: _containerForChips(_item[index], _bgColor),
    //           );
    //         }
    //       }),
    // );
  }

  Widget _synonymsAndAntonyms(double _height) {
    Widget _antonyms = _listOfWordChips(
        widget.listSelected
            ? widget.listOfWordset[0][widget.index]['ANTONYMS'].split('| ')
            : widget.data[widget.index]['ANTONYMS'].split('| '),
        Colors.amber);

    Widget _synonyms = _listOfWordChips(
        widget.listSelected
            ? widget.listOfWordset[0][widget.index]['SYNONYMS'].split('| ')
            : widget.data[widget.index]['SYNONYMS'].split('| '),
        Colors.tealAccent);

    return Container(
      constraints: BoxConstraints(maxHeight: double.infinity, minHeight: _height / 100 * 15),
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [_antonyms, _synonyms],
          )),
    );
  }

  Widget _wordMeanings(double _height, double _width) {
    return Container(
      alignment: Alignment.bottomLeft,
      constraints: BoxConstraints(
          maxHeight: (_width < 380)
              ? _height / 100 * 7
              : (_width >= 380 && _width < 600)
                  ? _height / 100 * 8
                  : _height / 100 * 9,
          minHeight: _height / 100 * 6),
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
        constraints: BoxConstraints(maxHeight: double.infinity, minHeight: _height / 100 * 5),
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
                      : 26.0 * MediaQuery.textScaleFactorOf(context)),
        ),
      ),
    );
  }

  Widget _progressBar() {
    return Container(
      alignment: Alignment.center,
      height: 3.5,
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: LinearProgressIndicator(
        value: (widget.listSelected
            ? widget.listOfWordset[0].indexOf(widget.listOfWordset[0][widget.index]) / 100 * 3.5
            : widget.data.indexOf(widget.data[widget.index]) / 100 * 0.12),
      ),
    );
  }
}

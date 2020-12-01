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
          Container(
            constraints: BoxConstraints(
                maxHeight: double.infinity, minHeight: _height / 100 * 12),
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    listOfWordsToMakeChips(
                        widget.listSelected
                            ? widget.listOfWordset[0][widget.index]['ANTONYMS']
                                .split('| ')
                            : widget.data[widget.index]['ANTONYMS'].split('| '),
                        Colors.amber),
                    listOfWordsToMakeChips(
                        widget.listSelected
                            ? widget.listOfWordset[0][widget.index]['SYNONYMS']
                                .split('| ')
                            : widget.data[widget.index]['SYNONYMS'].split('| '),
                        Colors.tealAccent),
                  ],
                )),
          ),
          Container(
            constraints: BoxConstraints(
                maxHeight: double.infinity, minHeight: _height / 100 * 6),
            alignment: Alignment.bottomLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Text(
                widget.listSelected
                    ? widget.listOfWordset[0][widget.index]['MEANINGS']
                    : widget.data[widget.index]['MEANINGS'],
                style: TextStyle(
                    color: widget.darkThemeChosen ? Colors.white : Colors.black,
                    fontSize: (_width < 350)
                        ? 12.0 * MediaQuery.textScaleFactorOf(context)
                        : (_width >= 350 && _width < 600)
                            ? 13.0 * MediaQuery.textScaleFactorOf(context)
                            : 14.0 * MediaQuery.textScaleFactorOf(context)),
              ),
            ),
          ),
          Container(
            constraints: BoxConstraints(
                maxHeight: double.infinity, minHeight: _height / 100 * 7),
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                widget.listSelected
                    ? widget.listOfWordset[0][widget.index]['WORDS']
                    : widget.data[widget.index]['WORDS'],
                style: TextStyle(
                    color: widget.darkThemeChosen
                        ? Colors.white
                        : Colors.grey[700],
                    fontFamily: 'Roboto Slab',
                    fontSize: (_width < 350)
                        ? 22.0 * MediaQuery.textScaleFactorOf(context)
                        : (_width >= 350 && _width < 600)
                            ? 25.0 * MediaQuery.textScaleFactorOf(context)
                            : 30.0 * MediaQuery.textScaleFactorOf(context)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Container(
              height: 3.5,
              alignment: Alignment.center,
              child: LinearProgressIndicator(
                value: (widget.listSelected
                    ? widget.listOfWordset[0]
                            .indexOf(widget.listOfWordset[0][widget.index]) /
                        100 *
                        3.5
                    : widget.data.indexOf(widget.data[widget.index]) /
                        100 *
                        0.12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Antonyms and synonyms chips are processed
  Widget listOfWordsToMakeChips(List<String> _item, Color _bgColor) {
    double _width = MediaQuery.of(context).size.width;
    List<Widget> list = List<Widget>();
    for (var i = 0; i < _item.length; i++) {
      if (_item[i] != 'N/A' && _item[i] != '') {
        list.add(Chip(
            label: Text(_item[i],
                style: TextStyle(
                  fontSize: (_width < 350)
                      ? 11.0 * MediaQuery.textScaleFactorOf(context)
                      : (_width >= 350 && _width < 600)
                          ? 12.0 * MediaQuery.textScaleFactorOf(context)
                          : 13.0 * MediaQuery.textScaleFactorOf(context),
                )),
            backgroundColor: _bgColor));
      }
    }
    return Wrap(runSpacing: -16, spacing: 2, children: list);
  }
}

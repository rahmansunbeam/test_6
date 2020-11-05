import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';
import 'package:test_6/services/load_asset.dart';
import 'dart:math';

class WordHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new WordHome(),
    );
  }
}

class WordHome extends StatefulWidget {
  @override
  _WordHomeState createState() => _WordHomeState();
}

class _WordHomeState extends State<WordHome> with TickerProviderStateMixin {
  int _cardIndex = 0;
  ScrollController _scrollController;
  Color _currentColor = Color.fromRGBO(231, 129, 109, 1.0);

  List<FloatingActionButton> _listOfButtonsForWordset = new List<FloatingActionButton>();
  List _listOfWordset = [];
  dynamic _currentWordsetIdx;
  bool _favIconPressed = false;
  int _favCardIdx;
  int _favWordIdx;
  List _favWordList = [];

  AnimationController _animationController;
  ColorTween _colorTween;
  CurvedAnimation _curvedAnimation;

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height / 100;
    return new Scaffold(
      backgroundColor: _currentColor,
      appBar: new AppBar(
        title: new Text(
          "TODO",
          style: TextStyle(fontSize: 16.0),
        ),
        backgroundColor: _currentColor,
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(Icons.search),
          ),
        ],
        elevation: 0.0,
      ),
      body: new Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64.0, vertical: 32.0),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Icon(
                        Icons.account_circle,
                        size: 45.0,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 12.0),
                      child: Text(
                        "Hi, there.",
                        style: TextStyle(
                            fontSize: 30.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Text(
                      "Looks like feel good.",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      "You have 3 tasks to do today.",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 64.0, vertical: 16.0),
                  child: Text(
                    "TODAY : JUL 21, 2018",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                // Wordset choosing
                Container(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: FloatingActionButton.extended(
                      onPressed: _showDialogForWordSet,
                      label: _currentWordsetIdx != null
                          ? Text('Wordset #${_currentWordsetIdx + 1}')
                          : Text('Wordset')),
                )),
                // Start of a card with list
                Container(
                  height: _height * 44,
                  child: buildFutureBuilder(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // TODO: create a widget from this
  FutureBuilder<List<Map>> buildFutureBuilder() {
    return FutureBuilder(
        future: loadAsset(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // this condition is important
          if (snapshot.data == null) {
            return Center(
              child: Text('loading data'),
            );
          } else {
            Iterable<List<dynamic>> _snapshotItems = partition(snapshot.data, 30);
            _listOfButtonsForWordset.clear();

            for (var i = 0; i < _snapshotItems.length; i++) {
              _listOfButtonsForWordset
                  .add(buildFloatingActionButtonsForWordset(_snapshotItems, i));
            }
            return _listviewBuilder(snapshot);
          }
        });
  }

  // Button to show wordset
  FloatingActionButton buildFloatingActionButtonsForWordset(
      Iterable<List> _snapshotItems, int i) {
    return new FloatingActionButton(
        onPressed: () {
          _buildFabForWordset(_snapshotItems, i);
        },
        mini: true,
        child: Text((i + 1).toString()));
  }

  void _buildFabForWordset(Iterable<List> _snapshotItems, int i) {
    return setState(() {
      _listOfWordset.clear();
      _listOfWordset.add(_snapshotItems.elementAt(i));
      _currentWordsetIdx = i;
    });
  }

  Widget _listviewBuilder(AsyncSnapshot snapshot) {
    if (_currentWordsetIdx != null) {
      return listViewForWordlist(snapshot, true);
    } else {
      return listViewForWordlist(snapshot, false);
    }
  }

  ListView listViewForWordlist(AsyncSnapshot snapshot, bool _curentList) {
    return ListView.builder(
      key: _curentList ? ObjectKey(_listOfWordset[0][0]) : null,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _curentList ? _listOfWordset[0].length : snapshot.data.length,
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return gestureDetector(snapshot, index);
      },
    );
  }

  // Antonyms and synonyms chips are processed
  Widget listOfWordsToMakeChips(List<String> _item, Color _txtColor, Color _bgColor) {
    List<Widget> list = List<Widget>();
    for (var i = 0; i < _item.length; i++) {
      if (_item[i] != 'N/A') {
        list.add(Container(
          child: Chip(
              label: Text(_item[i],
                  style: TextStyle(
                      fontSize: 12.0 * MediaQuery.textScaleFactorOf(context),
                      color: _txtColor)),
              backgroundColor: _bgColor),
        ));
      }
    }
    return Wrap(runSpacing: -14, spacing: 2, children: list);
  }

  Column wordsToRender(AsyncSnapshot snapshot, int index, bool _listSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    listOfWordsToMakeChips(
                        _listSelected
                            ? _listOfWordset[0][index]['ANTONYMS'].split('| ')
                            : snapshot.data[index]['ANTONYMS'].split('| '),
                        Colors.black,
                        Colors.pink[100]),
                    listOfWordsToMakeChips(
                        _listSelected
                            ? _listOfWordset[0][index]['SYNONYMS'].split('| ')
                            : snapshot.data[index]['SYNONYMS'].split('| '),
                        Colors.black,
                        Colors.teal[100]),
                  ],
                )),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Container(
            height: MediaQuery.of(context).size.height / 100 * 7,
            alignment: Alignment.bottomLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Text(
                _listSelected
                    ? _listOfWordset[0][index]['MEANINGS']
                    : snapshot.data[index]['MEANINGS'],
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.0 * MediaQuery.textScaleFactorOf(context)),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Text(
            _listSelected
                ? _listOfWordset[0][index]['WORDS']
                : snapshot.data[index]['WORDS'],
            style: TextStyle(
                color: Colors.grey[700],
                fontFamily: 'Roboto Slab',
                fontSize: 28.0 * MediaQuery.textScaleFactorOf(context)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: LinearProgressIndicator(
            value: (_listSelected
                ? _listOfWordset[0].indexOf(_listOfWordset[0][index]) / 100 * 3.5
                : snapshot.data.indexOf(snapshot.data[index]) / 100 * 0.12),
          ),
        ),
      ],
    );
  }

  // Widget to show which wordset to appear on acreem
  Widget wordsetToRenderOnCards(AsyncSnapshot snapshot, int index) {
    // double _fontSize = MediaQuery.textScaleFactorOf(context);
    if (_currentWordsetIdx != null) {
      return wordsToRender(snapshot, index, true);
    } else {
      return wordsToRender(snapshot, index, false);
    }
  }

  Card cardForWords(AsyncSnapshot snapshot, int index) {
    return Card(
      child: Container(
        width: MediaQuery.of(context).size.width / 100 * 60,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // Icon(
                  //   cardsList[index].icon,
                  //   color: appColors[index],
                  // ),
                  IconButton(
                      icon: Icon(Icons.lightbulb),
                      color: _favCardIdx == index ? Colors.pink : Colors.grey,
                      onPressed: () {
                        _favCardIdx = index;
                      }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: wordsetToRenderOnCards(snapshot, index),
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    );
  }

  Widget gestureDetector(AsyncSnapshot snapshot, int index) {
    Color _randomRolor = Color(Random().nextInt(0xffffffff)).withAlpha(0xff);

    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: cardForWords(snapshot, index),
      ),
      onHorizontalDragEnd: (details) {
        _animationController =
            AnimationController(vsync: this, duration: Duration(milliseconds: 500));
        _curvedAnimation =
            CurvedAnimation(parent: _animationController, curve: Curves.fastOutSlowIn);
        _animationController.addListener(() {
          setState(() {
            _currentColor = _colorTween.evaluate(_curvedAnimation);
          });
        });

        if (details.velocity.pixelsPerSecond.dx > 0) {
          if (_cardIndex > 0) {
            _cardIndex--;
            _colorTween = ColorTween(begin: _currentColor, end: _randomRolor);
          }
        } else {
          if (_cardIndex < snapshot.data.length) {
            _cardIndex++;
            _colorTween = ColorTween(begin: _currentColor, end: _randomRolor);
          }
        }
        setState(() {
          _scrollController.animateTo((_cardIndex) * 256.0,
              duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
        });
        _colorTween.animate(_curvedAnimation);
        _animationController.forward();
      },
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

  void _showDialogForWordSet() {
    double size = MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("choose a set"),
          titlePadding: EdgeInsets.fromLTRB(size / 18, size / 18, size / 18, size / 27),
          insetPadding: EdgeInsets.symmetric(horizontal: size / 9),
          contentPadding: EdgeInsets.symmetric(horizontal: size / 27),
          content:
              Wrap(children: [renderListOfButtonsForWordset(_listOfButtonsForWordset)]),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Clear"),
              onPressed: () {
                setState(() {
                  _listOfWordset.clear();
                  _currentWordsetIdx = null;
                });
              },
            ),
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

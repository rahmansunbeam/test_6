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
  Color _currentColor = Color.fromRGBO(231, 129, 109, 1.0);

  PageController _pageController = PageController();

  List<FloatingActionButton> _listOfButtonsForWordset =
      new List<FloatingActionButton>();
  List _listOfWordset = [];
  dynamic _currentWordIdx;
  dynamic _currentWordsetIdx;

  List<bool> _favouriteItemList = [];
  List<bool> _favouriteWordList = [];

  AnimationController _animationController;
  ColorTween _colorTween;
  CurvedAnimation _curvedAnimation;

  @override
  void initState() {
    super.initState();
    _pageController = new PageController();
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
      body: SafeArea(
        top: true,
        bottom: true,
        minimum: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 65.0, vertical: 32.0),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 12.0),
                      child: Text(
                        "Hi, there.",
                        style: TextStyle(
                            fontSize:
                                26.0 * MediaQuery.textScaleFactorOf(context),
                            color: Colors.white),
                      ),
                    ),
                    Text(
                      "Let's learn some words today",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Wordset choosing button
                  Container(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
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
            ),
          ],
        ),
      ),
    );
  }

  // Future builder to load the data and create the wordset button list
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
            Iterable<List<dynamic>> _snapshotItems =
                partition(snapshot.data, 30);
            _listOfButtonsForWordset.clear();

            // Populating favourite list for cards
            // if (_currentWordsetIdx != null) {
            //   if (_favouriteItemList.length < _snapshotItems.length) {
            //     _favouriteItemList.clear();
            //     List.generate(_snapshotItems.length,
            //         (i) => _favouriteItemList.add(false));
            //   }
            // } 
            // else {
              if (_favouriteItemList.length < snapshot.data.length) {
                _favouriteItemList.clear();
                List.generate(
                    snapshot.data.length, (i) => _favouriteItemList.add(false));
                List.generate(
                    snapshot.data.length, (i) => _favouriteWordList.add(false));
              }
            // }

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
      return pageViewForWordlist(snapshot, true);
    } else {
      return pageViewForWordlist(snapshot, false);
    }
  }

  PageView pageViewForWordlist(AsyncSnapshot snapshot, bool _curentList) {
    if (MediaQuery.of(context).size.width < 400) {
      _pageController = PageController(viewportFraction: 1.0);
    } else {
      _pageController = PageController(viewportFraction: 0.7);
    }
    return PageView.builder(
      key: _curentList ? ObjectKey(_listOfWordset[0][0]) : null,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _curentList ? _listOfWordset[0].length : snapshot.data.length,
      controller: _pageController,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return gestureDetector(snapshot, index);
      },
    );
  }

  // Antonyms and synonyms chips are processed
  Widget listOfWordsToMakeChips(List<String> _item, Color _bgColor) {
    List<Widget> list = List<Widget>();
    for (var i = 0; i < _item.length; i++) {
      if (_item[i] != 'N/A') {
        list.add(Chip(
            label: Text(_item[i],
                style: TextStyle(
                  fontSize: 12.0 * MediaQuery.textScaleFactorOf(context),
                )),
            backgroundColor: _bgColor));
      }
    }
    return Wrap(runSpacing: -16, spacing: 2, children: list);
  }

  // Render words inside the card
  Column wordsToRender(AsyncSnapshot snapshot, int index, bool _listSelected) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                        Colors.pink[100]),
                    listOfWordsToMakeChips(
                        _listSelected
                            ? _listOfWordset[0][index]['SYNONYMS'].split('| ')
                            : snapshot.data[index]['SYNONYMS'].split('| '),
                        Colors.teal[100]),
                  ],
                )),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                    fontSize: 14.0 * MediaQuery.textScaleFactorOf(context)),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Container(
            height: MediaQuery.of(context).size.height / 100 * 6,
            alignment: Alignment.bottomLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                _listSelected
                    ? _listOfWordset[0][index]['WORDS']
                    : snapshot.data[index]['WORDS'],
                style: TextStyle(
                    color: Colors.grey[700],
                    fontFamily: 'Roboto Slab',
                    fontSize: 24.0 * MediaQuery.textScaleFactorOf(context)),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Container(
            height: MediaQuery.of(context).size.height / 100 * 0.5,
            alignment: Alignment.center,
            child: LinearProgressIndicator(
              value: (_listSelected
                  ? _listOfWordset[0].indexOf(_listOfWordset[0][index]) /
                      100 *
                      3.5
                  : snapshot.data.indexOf(snapshot.data[index]) / 100 * 0.12),
            ),
          ),
        ),
      ],
    );
  }

  // Widget to appear items on the card
  Widget wordsetToRenderOnCards(AsyncSnapshot snapshot, int index) {
    if (_currentWordsetIdx != null) {
      return wordsToRender(snapshot, index, true);
    } else {
      return wordsToRender(snapshot, index, false);
    }
  }

  Card cardForWords(AsyncSnapshot snapshot, int index) {
    return Card(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      _favouriteItemList[index]
                          ? Icons.lightbulb
                          : Icons.lightbulb_outline,
                      color: _favouriteItemList[index]
                          ? Colors.orangeAccent[700]
                          : Colors.grey[700],
                    ),
                  ),
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
        _animationController = AnimationController(
            vsync: this, duration: Duration(milliseconds: 500));
        _curvedAnimation = CurvedAnimation(
            parent: _animationController, curve: Curves.fastOutSlowIn);
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
          _pageController.animateTo((_cardIndex) * 256.0,
              duration: Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn);
        });
        _colorTween.animate(_curvedAnimation);
        _animationController.forward();
      },
      onDoubleTap: () {
        setState(() {
          _favouriteItemList[index] = !_favouriteItemList[index];
        });

        if (_currentWordsetIdx != null) {
          _currentWordIdx = _listOfWordset[0][index]['#'];
        } else {
          _currentWordIdx = snapshot.data[index]['#'];
        }

        if (_favouriteItemList[index]) {
          _favouriteWordList[_currentWordIdx - 1] = true;
        } else {
          _favouriteWordList[_currentWordIdx - 1] = false;
        }

        print(_favouriteWordList.where((item) => item == true).length);
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "choose a set",
            style: TextStyle(color: Colors.grey[700]),
          ),
          titlePadding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
              vertical: MediaQuery.of(context).size.width * 0.04),
          contentPadding: EdgeInsets.all(0),
          content: Wrap(alignment: WrapAlignment.spaceEvenly, children: [
            renderListOfButtonsForWordset(_listOfButtonsForWordset)
          ]),
          actions: <Widget>[
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

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
  Future<List<Map>> _loadAsset;
  int _cardIndex = 0;
  Color _currentColor = Color.fromRGBO(231, 129, 109, 1.0);

  PageController _pageController = PageController();

  List<FloatingActionButton> _listOfButtonsForWordset = new List<FloatingActionButton>();
  List _listOfWordset = [];
  dynamic _currentWordIdx;
  dynamic _currentWordsetIdx;

  List<bool> _favouriteItemListFull = [];
  Iterable<List<bool>> _favouriteItemListSet = [];
  List _favouriteWordList = [];

  AnimationController _animationController;
  ColorTween _colorTween;
  CurvedAnimation _curvedAnimation;

  @override
  void initState() {
    super.initState();
    _loadAsset = loadAsset();
    _pageController = new PageController();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height / 100;
    return new Scaffold(
      backgroundColor: _currentColor,
      appBar: new AppBar(
        // title: new Text(
        //   "TODO",
        //   style: TextStyle(fontSize: 16.0),
        // ),
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
        minimum: const EdgeInsets.only(bottom: 3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 65.0),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 12.0),
                      child: Text(
                        "Hi, there.",
                        style: TextStyle(
                            fontSize: 26.0 * MediaQuery.textScaleFactorOf(context),
                            color: Colors.white),
                      ),
                    ),
                    Text(
                      "Let's learn some words today",
                      style: TextStyle(
                          fontSize: 14.0 * MediaQuery.textScaleFactorOf(context),
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 65.0),
                  child: Text(
                    _favouriteWordList.length != null && _favouriteWordList.length != 0
                        ? _favouriteWordList.length == 1
                            ? '${_favouriteWordList.length} word learned'
                            : '${_favouriteWordList.length} words learned'
                        : '',
                    style: TextStyle(
                        fontSize: 16.0 * MediaQuery.textScaleFactorOf(context),
                        color: Colors.white),
                  ),
                ),
              ],
            ),
            Container(
              height: _height * 62,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  // Wordset choosing button
                  Container(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: FloatingActionButton.extended(
                        onPressed: _showDialogForWordSet,
                        label: _currentWordsetIdx != null
                            ? Text('Wordset #${_currentWordsetIdx + 1}')
                            : Text('Wordset')),
                  )),
                  // Start of a card with list
                  Container(
                    height: _height * 45,
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
        future: _loadAsset,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // this condition is important
          if (snapshot.data == null) {
            return Center(
              child: Text('loading data'),
            );
          } else {
            _populateFabOfWordset(snapshot.data);
            return _pageviewBuilder(snapshot.data);
          }
        });
  }

  // Populate button list
  void _populateFabOfWordset(List<Map> data) {
    // Populating favourite list for cards
    if (_favouriteItemListFull.length < data.length) {
      List.generate(data.length, (i) => _favouriteItemListFull.add(false));
      _favouriteItemListSet = partition(_favouriteItemListFull, 30).toList();
    }

    // Populating buttons for wordset
    Iterable<List> _dataItems = partition(data, 30);

    if (_listOfButtonsForWordset.length < _dataItems.length) {
      for (var i = 0; i < _dataItems.length; i++) {
        _listOfButtonsForWordset.add(buildFabForWordset(_dataItems, i));
      }
    }
  }

  // Create each button to show wordset
  FloatingActionButton buildFabForWordset(Iterable<List> _dataItems, int i) {
    return new FloatingActionButton(
        onPressed: () {
          setState(() {
            _listOfWordset.clear();
            _listOfWordset.add(_dataItems.elementAt(i));
            _currentWordsetIdx = i;
          });
        },
        mini: true,
        child: Text((i + 1).toString()));
  }

  Widget _pageviewBuilder(List<Map> data) {
    if (_currentWordsetIdx != null) {
      return pageViewForWordlist(data, true);
    } else {
      return pageViewForWordlist(data, false);
    }
  }

  PageView pageViewForWordlist(List<Map> data, bool _curentList) {
    if (MediaQuery.of(context).size.width < 400) {
      _pageController = PageController(viewportFraction: 1.0);
    } else {
      _pageController = PageController(viewportFraction: 0.7);
    }
    return PageView.builder(
      key: _curentList ? ObjectKey(_listOfWordset[0][0]) : null,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _curentList ? _listOfWordset[0].length : data.length,
      controller: _pageController,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return gestureDetector(data, index);
      },
    );
  }

  // Antonyms and synonyms chips are processed
  Widget listOfWordsToMakeChips(List<String> _item, Color _bgColor) {
    double _width = MediaQuery.of(context).size.width;
    List<Widget> list = List<Widget>();
    for (var i = 0; i < _item.length; i++) {
      if (_item[i] != 'N/A') {
        list.add(Chip(
            label: Text(_item[i],
                style: TextStyle(
                  fontSize: (_width < 400)
                      ? 11.0 * MediaQuery.textScaleFactorOf(context)
                      : (_width >= 400 && _width < 600)
                          ? 13.0 * MediaQuery.textScaleFactorOf(context)
                          : 14.0 * MediaQuery.textScaleFactorOf(context),
                )),
            backgroundColor: _bgColor));
      }
    }
    return Wrap(runSpacing: -16, spacing: 2, children: list);
  }

  // Render words inside the card
  Column wordsToRender(List<Map> data, int index, bool _listSelected) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            height: (_width < 400)
                ? _height / 100 * 12
                : (_width >= 400 && _width < 600)
                    ? _height / 100 * 14
                    : _height / 100 * 15,
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    listOfWordsToMakeChips(
                        _listSelected
                            ? _listOfWordset[0][index]['ANTONYMS'].split('| ')
                            : data[index]['ANTONYMS'].split('| '),
                        Colors.pink[100]),
                    listOfWordsToMakeChips(
                        _listSelected
                            ? _listOfWordset[0][index]['SYNONYMS'].split('| ')
                            : data[index]['SYNONYMS'].split('| '),
                        Colors.teal[100]),
                  ],
                )),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            height: (_width < 400)
                ? _height / 100 * 8
                : (_width >= 400 && _width < 600)
                    ? _height / 100 * 7
                    : _height / 100 * 9,
            alignment: Alignment.bottomLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Text(
                _listSelected
                    ? _listOfWordset[0][index]['MEANINGS']
                    : data[index]['MEANINGS'],
                style: TextStyle(
                    color: Colors.black,
                    fontSize: (_width < 400)
                        ? 11.0 * MediaQuery.textScaleFactorOf(context)
                        : (_width >= 400 && _width < 600)
                            ? 15.0 * MediaQuery.textScaleFactorOf(context)
                            : 18.0 * MediaQuery.textScaleFactorOf(context)),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Container(
            height: (_width < 400)
                ? _height / 100 * 6
                : (_width >= 400 && _width < 600)
                    ? _height / 100 * 7
                    : _height / 100 * 9,
            alignment: Alignment.bottomLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                _listSelected ? _listOfWordset[0][index]['WORDS'] : data[index]['WORDS'],
                style: TextStyle(
                    color: Colors.grey[700],
                    fontFamily: 'Roboto Slab',
                    fontSize: (_width < 400)
                        ? 20.0 * MediaQuery.textScaleFactorOf(context)
                        : (_width >= 400 && _width < 600)
                            ? 27.0 * MediaQuery.textScaleFactorOf(context)
                            : 32.0 * MediaQuery.textScaleFactorOf(context)),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Container(
            height: _height / 100 * 0.5,
            alignment: Alignment.center,
            child: LinearProgressIndicator(
              value: (_listSelected
                  ? _listOfWordset[0].indexOf(_listOfWordset[0][index]) / 100 * 3.5
                  : data.indexOf(data[index]) / 100 * 0.12),
            ),
          ),
        ),
      ],
    );
  }

  // Widget to appear items on the card
  Widget wordsetToRenderOnCards(List<Map> data, int index) {
    if (_currentWordsetIdx != null) {
      return wordsToRender(data, index, true);
    } else {
      return wordsToRender(data, index, false);
    }
  }

  Icon _favouriteIcon(List<Map> data, int index) {
    if (_currentWordsetIdx != null) {
      return _favouriteItemListSet.elementAt(_currentWordsetIdx)[index]
          ? Icon(Icons.lightbulb, color: Colors.orange[700])
          : Icon(Icons.lightbulb_outline, color: Colors.grey[700]);
    } else {
      return _favouriteItemListFull[index]
          ? Icon(Icons.lightbulb, color: Colors.orange[700])
          : Icon(Icons.lightbulb_outline, color: Colors.grey[700]);
    }
  }

  Card cardForWords(List<Map> data, int index) {
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
                    child: _favouriteIcon(data, index),

                    // _favouriteItemList[index]
                    //     ? Icons.lightbulb
                    //     : Icons.lightbulb_outline,
                    // color: _favouriteItemList[index]
                    //     ? Colors.orangeAccent[700]
                    //     : Colors.grey[700],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: wordsetToRenderOnCards(data, index),
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    );
  }

  Widget gestureDetector(List<Map> data, int index) {
    return GestureDetector(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: cardForWords(data, index),
        ),
        onHorizontalDragEnd: (details) {
          return _gestureChangeBgColorMode(data, index, details);
        },
        onLongPress: () {
          return _gestureAddFavourite(data, index);
        });
  }

  dynamic _gestureChangeBgColorMode(List<Map> data, int index, DragEndDetails details) {
    Color _randomRolor = Color(Random().nextInt(0xffffffff)).withAlpha(0xff);

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
      if (_cardIndex < data.length) {
        _cardIndex++;
        _colorTween = ColorTween(begin: _currentColor, end: _randomRolor);
      }
    }
    setState(() {
      _pageController.animateTo((_cardIndex) * 256.0,
          duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
    });
    _colorTween.animate(_curvedAnimation);
    _animationController.forward();
  }

  dynamic _gestureAddFavourite(List<Map> data, int index) {
    setState(() {
      if (_currentWordsetIdx != null) {
        _favouriteItemListSet.elementAt(_currentWordsetIdx)[index] =
            !_favouriteItemListSet.elementAt(_currentWordsetIdx)[index];
      } else {
        _favouriteItemListFull[index] = !_favouriteItemListFull[index];
      }
    });

    if (_currentWordsetIdx != null) {
      _currentWordIdx = _listOfWordset[0][index]['#'];
    } else {
      _currentWordIdx = data[index]['#'];
    }

    if (_favouriteWordList.contains(_currentWordIdx)) {
      _favouriteWordList.remove(_currentWordIdx);
    } else {
      _favouriteWordList.add(_currentWordIdx);
    }

    print(_favouriteWordList);
    print(index);
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
          content: Wrap(
              alignment: WrapAlignment.spaceEvenly,
              children: [renderListOfButtonsForWordset(_listOfButtonsForWordset)]),
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

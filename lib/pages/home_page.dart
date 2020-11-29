import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:test_6/pages/dialogbox_page.dart';
import 'package:test_6/pages/words_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_6/services/shared_pref_service.dart';
import 'package:test_6/services/load_asset_service.dart';
import 'package:test_6/services/custom_icon_service.dart';
import 'dart:math';

class WordHomePage extends StatefulWidget {
  @override
  _WordHomePageState createState() => _WordHomePageState();
}

class _WordHomePageState extends State<WordHomePage>
    with TickerProviderStateMixin {
  Future<List<Map>> _loadAsset;
  PageController _pageController;

  int _cardIndex = 0;
  AnimationController _animationController;
  ColorTween _colorTween;
  CurvedAnimation _curvedAnimation;

  Color _backgroundColor;
  bool _darkThemeChosen;

  List<FloatingActionButton> _listOfButtonsForWordset =
      new List<FloatingActionButton>();
  List _listOfWordset = [];
  dynamic _currentWordIdx;
  dynamic _currentWordsetIdx;

  List<bool> _favouriteItemListFull = [];
  Iterable<List<bool>> _favouriteItemListSet = [];
  List _favouriteWordList = [];

  @override
  void initState() {
    super.initState();
    _loadAsset = loadAsset();
    _pageController = new PageController();

    // get theme from memory
    // TODO - Make _darkThemeChosen load data from shre pref
    // SharedPreferences.getInstance().then((value) =>
    //     setState(() => _darkThemeChosen = value.getBool('themekey')));
    getThemeFromMemory().then((value) => setState(() => _darkThemeChosen = value));
    _backgroundColor = _darkThemeChosen ? Colors.black : Colors.teal[700];
  }

  // dark theme toggle button method
  void _darkModeToggle() {
    setState(() {
      _darkThemeChosen = !_darkThemeChosen;
    });
    setThemeToMemory(_darkThemeChosen);
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height / 100;

    // getting favourite word list from memory
    getFavWordsFromMemory().then((value) {
      _favouriteWordList = value;
    });

    // main ui Scaffold
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: _darkThemeChosen ? Colors.black : _backgroundColor,
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: IconButton(
              onPressed: _darkModeToggle,
              icon: _darkThemeChosen
                  ? Icon(CustomIcon.moon)
                  : Icon(CustomIcon.sunny),
              splashRadius: 20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              onPressed: () {},
              icon: Icon(CustomIcon.info),
              splashRadius: 20,
            ),
          ),
        ],
        elevation: 0.0,
      ),
      body: ColoredBox(
        color: _darkThemeChosen ? Colors.black : _backgroundColor,
        child: SafeArea(
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
                        padding:
                            const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 12.0),
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
                        style: TextStyle(
                            fontSize:
                                14.0 * MediaQuery.textScaleFactorOf(context),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          _favouriteWordList.length != null &&
                                  _favouriteWordList.length != 0
                              ? _favouriteWordList.length == 1
                                  ? '${_favouriteWordList.length} word learned'
                                  : '${_favouriteWordList.length} words learned'
                              : '',
                          style: TextStyle(
                              fontSize:
                                  16.0 * MediaQuery.textScaleFactorOf(context),
                              color: Colors.white),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete_forever_rounded,
                            color: Colors.white,
                            size: _favouriteWordList.length != null &&
                                    _favouriteWordList.length != 0
                                ? 16.0 * MediaQuery.textScaleFactorOf(context)
                                : 0,
                          ),
                          onPressed: () {
                            setState(() {
                              _favouriteItemListFull.clear();
                              _favouriteWordList.clear();
                              _currentWordsetIdx = null;
                              removeAllUserData();
                            });
                          },
                        ),
                      ],
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: FloatingActionButton.extended(
                          onPressed: () => showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return DialogboxForWordset(
                                    darkThemeChosen: _darkThemeChosen,
                                    listOfButtonsForWordset:
                                        _listOfButtonsForWordset,
                                    callback: () {
                                      setState(() {
                                        _favouriteWordList.clear();
                                        _currentWordsetIdx = null;
                                      });
                                    });
                              }),
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
              child: SpinKitThreeBounce(
                color: Colors.white,
              ),
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
    }

    // get _favouriteItemListFull from memory
    getFavListFromMemory().then((value) {
      if (value.length > 0) {
        setState(() {
          _favouriteItemListFull = value;
        });
      }
      _favouriteItemListSet = partition(_favouriteItemListFull, 30).toList();
    });

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
    if (MediaQuery.of(context).size.width < 350) {
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

  Widget wordsetToRenderOnCards(List<Map> data, int index) {
    if (_currentWordsetIdx != null) {
      return WordsToRender(
        darkThemeChosen: _darkThemeChosen,
        listOfWordset: _listOfWordset,
        data: data,
        index: index,
        listSelected: true,
      );
    } else {
      return WordsToRender(
        darkThemeChosen: _darkThemeChosen,
        listOfWordset: _listOfWordset,
        data: data,
        index: index,
        listSelected: false,
      );
    }
  }

  Icon _favouriteIcon(List<Map> data, int index) {
    Icon _iconInactive = Icon(Icons.lightbulb, color: Colors.orange[700]);
    Icon _iconActive = Icon(Icons.lightbulb_outline, color: Colors.orange[700]);

    if (_currentWordsetIdx != null) {
      return _favouriteItemListSet.elementAt(_currentWordsetIdx)[index]
          ? _iconInactive
          : _iconActive;
    }
    return _favouriteItemListFull[index] ? _iconInactive : _iconActive;
  }

  Card cardForWords(List<Map> data, int index) {
    return Card(
      elevation: 3.5,
      color: _darkThemeChosen ? Colors.grey[700] : Colors.white,
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

  dynamic _gestureChangeBgColorMode(
      List<Map> data, int index, DragEndDetails details) {
    Color _randomColor = Color(Random().nextInt(0xffffffff)).withAlpha(0xff);

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    _curvedAnimation = CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn);

    _animationController.addListener(() {
      setState(() {
        _backgroundColor = _colorTween.evaluate(_curvedAnimation);
      });
    });

    if (details.velocity.pixelsPerSecond.dx > 0) {
      if (_cardIndex > 0) {
        _cardIndex--;
        _colorTween = ColorTween(begin: _backgroundColor, end: _randomColor);
      }
    } else {
      if (_cardIndex < data.length) {
        _cardIndex++;
        _colorTween = ColorTween(begin: _backgroundColor, end: _randomColor);
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
    List _tempList = partition(data, 30).toList();
    int _activeSet;
    int _activeSetIdx;

    _currentWordsetIdx != null
        ? _currentWordIdx = _listOfWordset[0][index]['#']
        : _currentWordIdx = data[index]['#'];

    _favouriteWordList.contains(_currentWordIdx)
        ? _favouriteWordList.remove(_currentWordIdx)
        : _favouriteWordList.add(_currentWordIdx);

    setState(() {
      // find the position of the item within the _favouriteItemListSet
      _tempList.forEach((element) {
        return element.forEach((e) {
          if (e['#'] == _currentWordIdx) {
            _activeSet = _tempList.indexOf(element);
            _activeSetIdx = element.indexOf(e);
          }
        });
      });

      // set the favourite words among wordsets
      if (_currentWordsetIdx != null) {
        _favouriteItemListSet.elementAt(_currentWordsetIdx)[index] =
            _favouriteWordList.contains(_currentWordIdx) ? true : false;
        _favouriteItemListFull[_currentWordIdx - 1] =
            _favouriteWordList.contains(_currentWordIdx) ? true : false;
      } else {
        _favouriteItemListFull[index] =
            _favouriteWordList.contains(_currentWordIdx) ? true : false;
        _favouriteItemListSet.elementAt(_activeSet)[_activeSetIdx] =
            _favouriteWordList.contains(_currentWordIdx) ? true : false;
      }
    });
    // save _favouriteItemListFull to the memory
    setFavListToMemory(_favouriteItemListFull);
    // save favourite word list to memory
    if (_favouriteWordList != null) setFavWordsToMemory(_favouriteWordList);
  }
}

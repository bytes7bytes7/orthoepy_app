import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_accent_app/const.dart';
import 'package:flutter_accent_app/services.dart';
import 'package:flutter_accent_app/screens/components/edit_alert_dialog.dart';

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({
    Key key,
    @required this.words,
    @required this.stream,
    @required this.streamController,
  }) : super(key: key);

  final Map<String, int> words;
  final Stream stream;
  final StreamController streamController;

  @override
  _DictionaryScreenState createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen>
    with TickerProviderStateMixin {

  Stream scrollStream;
  StreamController<double> scrollStreamController;
  ScrollController listViewController;
  TextEditingController textEditingController;
  String searchWord;
  Map<String, int> _words;
  Map<String, int> searchMap;
  Set<String> selectedWords;
  bool selectAll;
  bool checkAll;
  bool loading;
  bool started;
  List<String> wordsKeys;

  initWords() async {
    loading = true;
    Future.delayed(const Duration(milliseconds: 500), () {
      loading = false;
      widget.streamController.add(_words.length);
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    listViewController.dispose();
    scrollStreamController.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    started = true;
    checkAll = false;
    searchWord = '';
    searchMap = {};
    selectedWords = {};
    _words = widget.words;
    wordsKeys = _words.keys.toList();
    textEditingController = TextEditingController();
    listViewController = ScrollController();
    scrollStreamController = StreamController<double>();
    scrollStream = scrollStreamController.stream;
    scrollStreamController.add(1);
    initWords();
  }

  bool check() {
    if (_words != null && _words.length > 10) {
      if (listViewController.hasClients) {
        if (listViewController.position.pixels > 200) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (notificationInfo) {
        if (notificationInfo is ScrollNotification) {
          scrollStreamController.add(notificationInfo.metrics.pixels);
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: selectedWords.isEmpty
              ? Text(
                  'Словарь',
                  style: Theme.of(context).textTheme.headline1,
                )
              : SizedBox.shrink(),
          leading: selectAll != null
              ? IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () async {
                    setState(() {
                      selectAll = null;
                      selectedWords.clear();
                      widget.streamController.add(-1);
                    });
                  },
                )
              : IconButton(
                  icon: Icon(Icons.arrow_back_ios_rounded),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
          actions: [
            selectAll != null
                ? Row(
                    children: [
                      Text(
                        'Все:',
                        style: Theme.of(context)
                            .textTheme
                            .headline1
                            .copyWith(fontSize: 18.0),
                      ),
                      Theme(
                        data: Theme.of(context).copyWith(
                            unselectedWidgetColor:
                                Theme.of(context).backgroundColor),
                        child: Checkbox(
                          value: selectAll,
                          onChanged: (value) {
                            setState(() {
                              selectAll = value;
                              if (value) {
                                if (searchMap.isNotEmpty) {
                                  selectedWords.addAll(searchMap.keys);
                                } else {
                                  selectedWords.addAll(_words.keys);
                                }
                              } else {
                                String first = selectedWords.first;
                                selectedWords.clear();
                                selectedWords.add(first);
                              }
                            });
                          },
                          activeColor: Theme.of(context).focusColor,
                        ),
                      ),
                      Text(
                        'Актив:',
                        style: Theme.of(context)
                            .textTheme
                            .headline1
                            .copyWith(fontSize: 18.0),
                      ),
                      Theme(
                        data: Theme.of(context).copyWith(
                            unselectedWidgetColor:
                                Theme.of(context).backgroundColor),
                        child: Checkbox(
                          value: checkAll,
                          onChanged: (value) async {
                            setState(() {
                              checkAll = value;
                              List<String> lst = selectedWords.toList();
                              lst.forEach((e) {
                                if ((_words[e] != 1) == value) {
                                  _words[e] = value ? 1 : 0;
                                }
                              });
                              setState(() {});
                              writeStringFile(wordsToString(_words));
                            });
                          },
                          activeColor: Theme.of(context).focusColor,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_outline),
                        onPressed: () async {
                          _words.removeWhere(
                              (key, value) => selectedWords.contains(key));
                          if (searchMap.isNotEmpty) {
                            searchMap.removeWhere(
                                (key, value) => selectedWords.contains(key));
                          }
                          setState(() {
                            selectAll = null;
                            selectedWords.clear();
                            widget.streamController.add(-1);
                          });
                          writeStringFile(wordsToString(_words));
                        },
                      ),
                    ],
                  )
                : SizedBox.shrink(),
          ],
        ),
        floatingActionButton: StreamBuilder(
            stream: scrollStream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (check()) {
                return FloatingActionButton(
                  tooltip: 'Вверх',
                  elevation: 4.0,
                  onPressed: () {
                    listViewController
                        .jumpTo(listViewController.position.minScrollExtent);
                  },
                  child: Icon(
                    Icons.keyboard_arrow_up,
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                );
              } else {
                return SizedBox.shrink();
              }
            }),
        body: Column(
          children: [
            buildSearchPanel(appendFile),
            StreamBuilder<int>(
              stream: widget.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data == -1) {
                  started = false;
                  searchMap.clear();
                  if (searchWord.length > 0) {
                    wordsKeys = _words.keys.toList();
                    for (int i = 0; i < wordsKeys.length; i++) {
                      if (wordsKeys[i]
                          .toLowerCase()
                          .contains(searchWord.toLowerCase())) {
                        searchMap[wordsKeys[i]] = _words[wordsKeys[i]];
                      }
                    }
                    wordsKeys = searchMap.keys.toList();
                  } else {
                    if (_words.isNotEmpty)
                      wordsKeys = _words.keys.toList();
                    else
                      wordsKeys.clear();
                  }
                } else if (snapshot.data == 0) {
                  print('data = 0');
                  _words.clear();
                  wordsKeys.clear();
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                }
                if (loading && started) {
                  return Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor),
                      ),
                    ),
                  );
                } else if (_words.isEmpty ||
                    (_words.isNotEmpty &&
                        searchMap.isEmpty &&
                        searchWord.length > 0)) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        'Список пуст!',
                        style: Theme.of(context).textTheme.headline1.copyWith(
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                    ),
                  );
                } else {
                  return Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      controller: listViewController,
                      physics: AlwaysScrollableScrollPhysics(),
                      children: [
                        Column(
                          children: searchMap.isEmpty
                              ? List.generate(
                                  _words.length,
                                  (index) {
                                    bool isSelected = false;
                                    if (selectedWords.length > 0) {
                                      if (selectedWords
                                          .contains(wordsKeys[index])) {
                                        isSelected = true;
                                      }
                                    }
                                    return buildButton(
                                      wordsKeys[index],
                                      _words[wordsKeys[index]] == 1,
                                      () {
                                        _showEditDialog(context, replaceFile,
                                            kEditTitle, wordsKeys[index]);
                                      },
                                      isSelected,
                                    );
                                  },
                                )
                              : List.generate(
                                  searchMap.length,
                                  (index) {
                                    bool isSelected = false;
                                    if (selectedWords.length > 0) {
                                      if (selectedWords
                                          .contains(wordsKeys[index])) {
                                        isSelected = true;
                                      }
                                    }
                                    return buildButton(
                                      wordsKeys[index],
                                      searchMap[wordsKeys[index]] == 1,
                                      () {
                                        _showEditDialog(context, replaceFile,
                                            kEditTitle, wordsKeys[index]);
                                      },
                                      isSelected,
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget buildSearchPanel(Function editFunction) {
    // TODO: remove lags (maybe with BLoC)

    return Container(
      margin: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.search,
              size: 28.0,
              color: Theme.of(context).textTheme.headline1.color,
            ),
          ),
          Expanded(
            child: TextField(
              controller: textEditingController,
              onChanged: (value) async {
                searchWord = textEditingController.text;
                widget.streamController.add(-1);
              },
              cursorColor: Theme.of(context).focusColor,
              cursorWidth: 3.0,
              style: Theme.of(context)
                  .textTheme
                  .headline1
                  .copyWith(fontSize: 16.0),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Поиск...',
                hintStyle: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(fontSize: 16.0),
              ),
            ),
          ),
          GestureDetector(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.add,
                size: 28.0,
                color: Theme.of(context).textTheme.headline1.color,
              ),
            ),
            onTap: () {
              _showEditDialog(context, editFunction, kCreateTitle, null);
            },
          ),
        ],
      ),
    );
  }

  Widget buildButton(
      String text, bool isActive, Function onPressed, bool isSelected) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 45.0,
      ),
      child: Material(
        color: isSelected || selectedWords.contains(text)
            ? Theme.of(context).focusColor
            : Theme.of(context).backgroundColor,
        child: InkWell(
          onTap: () {
            if (selectedWords.length == 1 && selectedWords.contains(text)) {
              setState(() {
                selectAll = null;
                selectedWords.clear();
              });
            } else if (selectedWords.length > 0 &&
                !selectedWords.contains(text)) {
              setState(() {
                selectedWords.add(text);
              });
            } else if (selectedWords.length > 0 &&
                selectedWords.contains(text)) {
              setState(() {
                selectedWords.remove(text);
              });
            } else {
              onPressed();
            }
          },
          onLongPress: () {
            setState(() {
              selectAll = false;
              selectedWords.add(text);
            });
          },
          focusColor: Colors.transparent,
          splashColor: Theme.of(context).focusColor,
          highlightColor: Colors.transparent,
          child: Container(
            decoration: ShapeDecoration(
              shape: BeveledRectangleBorder(
                side: BorderSide(
                  color: Theme.of(context).buttonColor,
                  width: 0.5,
                ),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            alignment: Alignment.center,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      unselectedWidgetColor:
                          isSelected || selectedWords.contains(text)
                              ? Theme.of(context).backgroundColor
                              : Theme.of(context).buttonColor,
                    ),
                    child: Checkbox(
                      value: isActive,
                      onChanged: (value) async {
                        _words[text] = value ? 1 : 0;
                        switchFile(text, value ? 1 : 0);
                        widget.streamController.add(-1);
                      },
                      activeColor: isSelected || selectedWords.contains(text)
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).focusColor,
                    ),
                  ),
                ),
                Flexible(
                  flex: 5,
                  fit: FlexFit.tight,
                  child: Text(
                    text,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(color: Theme.of(context).primaryColor),
                  ),
                ),
                Spacer(),
                Flexible(
                  flex: 1,
                  child: Icon(
                    Icons.edit,
                    color: isSelected || selectedWords.contains(text)
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).focusColor,
                  ),
                ),
                SizedBox(width: 5.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context, Function editFunction,
      String title, String initialWord) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return EditAlertDialog(
          words: _words,
          title: title,
          initialWord: initialWord,
          editFunction: editFunction,
          streamController: widget.streamController,
        );
      },
    );
  }
}

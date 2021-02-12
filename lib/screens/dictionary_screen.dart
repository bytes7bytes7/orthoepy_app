import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_accent_app/const.dart';
import 'package:flutter_accent_app/screens/components/quiz_outlined_button.dart';
import 'package:flutter_accent_app/services.dart';

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({
    Key key,
    @required this.stream,
    @required this.streamController,
  }) : super(key: key);

  final Stream stream;
  final StreamController streamController;

  @override
  _DictionaryScreenState createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen>
    with TickerProviderStateMixin {
  //TODO: add refresh function (pull down and refresh)
  AnimationController animationController;
  Animation animation;
  Stream scrollStream;
  StreamController<double> scrollStreamController;
  ScrollController listViewController;
  TextEditingController textEditingController;
  String searchWord = '';
  Map<String, int> map;
  bool loading;
  bool started;

  initWords() async {
    loading = true;
    Map<dynamic, dynamic> m = await readFile().then((map) {
      List<String> result = map.keys.toList();
      Map<String, int> part = {};
      result.forEach((element) {
        if (element.toLowerCase().contains(searchWord.toLowerCase()))
          part.putIfAbsent(element, () => map[element]);
      });
      if (part.keys.length == 0) {
        print('empty');
        return Future.delayed(const Duration(milliseconds: 500), () {
          loading = false;
          widget.streamController.add(0);
          return {};
        });
      }
      return Future.delayed(const Duration(milliseconds: 500), () {
        loading = false;
        widget.streamController.add(part.length);
        return part;
      });
    }).catchError((error) {
      print(error.toString());
      return Future.delayed(const Duration(milliseconds: 500), () {
        print('READ ERROR');
        loading = false;
        widget.streamController.add(-1);
        return {};
      });
    });
    (m.length == 0) ? map = {} : map = m;
  }

  @override
  void dispose() {
    textEditingController.dispose();
    listViewController.dispose();
    scrollStreamController.close();
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    started = true;
    textEditingController = TextEditingController();
    listViewController = ScrollController();
    scrollStreamController = StreamController<double>();
    scrollStream = scrollStreamController.stream;
    scrollStreamController.add(0.0);
    animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(animationController)
      ..addListener(() {
        setState(() {});
      });
    initWords();
  }

  bool check() {
    if (map != null && map.length > 10) {
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
          title: Text(
            'Словарь',
            style: Theme.of(context).textTheme.headline1,
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
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
                    initWords();
                    started = false;
                  } else if (snapshot.data == 0) {
                    map = {};
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
                  } else if (map == null || map.length == 0) {
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
                            children: List.generate(
                              map.length,
                              (index) {
                                List<String> keys = map.keys.toList();
                                return QuizOutlinedButton(
                                  index: index,
                                  text: keys[index],
                                  isActive: map[keys[index]] == 1,
                                  onPressed: () {
                                    _showEditDialog(context, replaceFile,
                                        kEditTitle, keys[index]);
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }

  void search() async {
    widget.streamController.add(-1);
  }

  Widget buildSearchPanel(Function editFunction) {
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
              onChanged: (value) {
                setState(() {
                  searchWord = textEditingController.text;
                  search();
                });
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

  Future<void> _showEditDialog(BuildContext context, Function editFunction,
      String title, String initialWord) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return EditAlertDialog(
          title: title,
          initialWord: initialWord,
          editFunction: editFunction,
          streamController: widget.streamController,
        );
      },
    );
  }
}

class EditAlertDialog extends StatefulWidget {
  const EditAlertDialog({
    Key key,
    @required this.title,
    @required this.initialWord,
    @required this.editFunction,
    @required this.streamController,
  }) : super(key: key);

  final String title;
  final String initialWord;
  final Function editFunction;
  final StreamController streamController;

  @override
  _EditAlertDialogState createState() => _EditAlertDialogState();
}

class _EditAlertDialogState extends State<EditAlertDialog> {
  TextEditingController _textController;
  bool _validate = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialWord);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(
          widget.title,
          style: Theme.of(context).textTheme.headline1.copyWith(
                color: Theme.of(context).primaryColor,
                fontSize: Theme.of(context).textTheme.bodyText1.fontSize,
              ),
        ),
      ),
      content: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: TextField(
            cursorColor: Theme.of(context).focusColor,
            cursorWidth: 3.0,
            controller: _textController,
            style: Theme.of(context).textTheme.headline1.copyWith(
                  fontSize: Theme.of(context).textTheme.bodyText1.fontSize,
                ),
            decoration: InputDecoration(
              suffixIcon: Icon(
                _validate ? Icons.error_outline_outlined : null,
                color: Theme.of(context).backgroundColor,
              ),
              border: InputBorder.none,
              hintText: 'Новое слово',
              hintStyle: Theme.of(context).textTheme.headline1.copyWith(
                    fontSize: Theme.of(context).textTheme.bodyText1.fontSize,
                  ),
            ),
          ),
        ),
      ),
      actions: [
        if (widget.title == kEditTitle)
          RaisedButton(
            color: Theme.of(context).primaryColor,
            child: Text(
              'Удалить',
              style: Theme.of(context).textTheme.headline1.copyWith(
                    fontSize: Theme.of(context).textTheme.bodyText1.fontSize,
                  ),
            ),
            onPressed: () async {
              await widget.editFunction(widget.initialWord, '');
              _validate = false;
              print('delete');
              widget.streamController.add(-1);
              Navigator.pop(context);
            },
          ),
        RaisedButton(
          color: Theme.of(context).primaryColor,
          child: Text(
            'Ок',
            style: Theme.of(context).textTheme.headline1.copyWith(
                  fontSize: Theme.of(context).textTheme.bodyText1.fontSize,
                ),
          ),
          onPressed: () async {
            String newWord = _textController.text;
            int ok = 0;
            for (int i = 0; i < newWord.length; i++) {
              if (kLetters.contains(newWord[i])) {
                ok = 1;
                break;
              }
            }
            if (ok == 1) {
              for (int i = 0; i < newWord.length; i++) {
                if (kNotVowels.toUpperCase().contains(newWord[i])) {
                  ok = 1;
                  break;
                } else {
                  ok = 2;
                }
              }
            }
            int bigVowels = 0;
            for (int i = 0; i < newWord.length; i++) {
              if (kVowels.toUpperCase().contains(newWord[i])) {
                bigVowels++;
                if (bigVowels > 1) {
                  bigVowels = 0;
                  break;
                }
              }
            }
            if (bigVowels == 1 && ok == 2) {
              Map<String, int> map = await readFile();
              List<String> keys = map.keys.toList();
              if (keys.contains(newWord)) {
                setState(() {
                  print('Word has already existed');
                  _validate = true;
                });
              } else {
                _validate = false;
                if (widget.title == kEditTitle) {
                  await widget.editFunction(widget.initialWord, newWord);
                } else {
                  await widget.editFunction(newWord, 1);
                }
                print(newWord);
                print('create/edit');
                widget.streamController.add(-1);
                Navigator.pop(context);
              }
            } else {
              setState(() {
                print('Not valid');
                _validate = true;
              });
            }
          },
        ),
      ],
    );
  }
}

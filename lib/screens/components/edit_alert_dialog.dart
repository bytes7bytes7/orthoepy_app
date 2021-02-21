import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_accent_app/const.dart';
import 'package:flutter_accent_app/services.dart';

class EditAlertDialog extends StatefulWidget {
  const EditAlertDialog({
    Key key,
    @required this.words,
    @required this.title,
    @required this.initialWord,
    @required this.editFunction,
    @required this.streamController,
  }) : super(key: key);

  final Map<String, int> words;
  final String title;
  final String initialWord;
  final Function editFunction;
  final StreamController streamController;

  @override
  _EditAlertDialogState createState() => _EditAlertDialogState();
}

class _EditAlertDialogState extends State<EditAlertDialog> {
  Map<String, int>_words;
  TextEditingController _textController;
  bool _validate = false;

  @override
  void initState() {
    super.initState();
    _words=widget.words;
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
              print('delete');
              _validate = false;
              _words.remove(widget.initialWord);
              widget.streamController.add(-1);
              widget.editFunction(widget.initialWord, '');
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
              List<String> keys = _words.keys.toList();
              if (keys.contains(newWord)) {
                setState(() {
                  print('Word has already existed');
                  _validate = true;
                });
              } else {
                _validate = false;
                if (widget.title == kEditTitle) {

                  _words[newWord]=_words[widget.initialWord];
                  _words.remove(widget.initialWord);
                  await sortWords(_words);
                  Map<String, int> newMap = await readFile();
                  _words.clear();
                  _words.addAll(newMap);

                  widget.editFunction(widget.initialWord, newWord);
                } else {

                  _words.addAll({newWord:1});
                  await sortWords(_words);
                  Map<String, int> newMap = await readFile();
                  _words.clear();
                  _words.addAll(newMap);

                  widget.editFunction(newWord, 1);
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

import 'package:flutter/material.dart';
import 'package:flutter_accent_app/const.dart';
import 'package:flutter_accent_app/screens/components/quiz_outlined_button.dart';
import 'package:flutter_accent_app/services.dart';

class DictionaryScreen extends StatefulWidget {
  @override
  _DictionaryScreenState createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  //TODO: add refresh function (pull down and refresh)
  TextEditingController textEditingController;
  String searchWord = '';

  Future<List<String>> getWords() async {
    return await readFile().then((value) {
      List<String> lst = value.split('\n');
      List<String> part = [];
      lst.forEach((element) {
        if (element.toLowerCase().contains(searchWord.toLowerCase()))
          part.add(element);
      });
      return part;
    }).catchError((error) {
      print(error.toString());
      return [''];
    });
  }

  update() {
    setState(() {});
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: FutureBuilder<List<String>>(
        future: getWords(),
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          List<String> lst = [];
          if (snapshot.hasData) {
            lst = snapshot.data;
          } else if (snapshot.hasError) {
            print(snapshot.error.toString());
          }
          return ListView(
            children: [
              Column(
                children: List.generate(lst.length + 1, (index) {
                  if (index == 0)
                    return buildSearchPanel(update,appendFile);
                  else
                    return QuizOutlinedButton(
                      index: index - 1,
                      //stream: stream,
                      //streamController: streamController,
                      text: lst[index - 1],
                      // selectedColor: rightAnswer == accentList[i]
                      //     ? Theme.of(context).primaryColor
                      //     : Theme.of(context).errorColor,
                      onPressed: () {
                        _showEditDialog(
                            context, update,replaceFile, 'Править', lst[index - 1]);
                      },
                    );
                }),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildSearchPanel(Function update,Function editFunction) {
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
              onChanged: (value) {
                setState(() {
                  searchWord = textEditingController.text;
                });
              },
              cursorColor: Theme.of(context).focusColor,
              cursorWidth: 3.0,
              controller: textEditingController,
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
              _showEditDialog(context, update,editFunction, 'Создать', null);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context, Function update,Function editFunction,
      String title, String initialWord) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return EditAlertDialog(
          title: title,
          initialWord: initialWord,
          update: update,
          editFunction: editFunction,
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
    @required this.update,
    @required this.editFunction,
  }) : super(key: key);

  final String title;
  final String initialWord;
  final Function update;
  final Function editFunction;

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
        RaisedButton(
          color: Theme.of(context).primaryColor,
          child: Text(
            'Ок',
            style: Theme.of(context).textTheme.headline1.copyWith(
                  fontSize: Theme.of(context).textTheme.bodyText1.fontSize,
                ),
          ),
          onPressed: () {
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
              _validate = false;
              if(widget.title=='Править'){
                widget.editFunction(widget.initialWord,newWord);
              }else{
                widget.editFunction(newWord);
              }
              widget.update();
              Navigator.pop(context);
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

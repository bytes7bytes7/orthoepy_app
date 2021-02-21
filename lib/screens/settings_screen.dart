import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_accent_app/screens/components/custom_outlined_button.dart';
import 'package:flutter_accent_app/screens/dictionary_screen.dart';
import 'package:flutter_accent_app/services.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    Key key,
    @required this.words,
  }) : super(key: key);

  final Map<String, int> words;

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  //TODO: add CheckBox to manually move to next word or to move by timer
  //TODO: add SnackBar
  //TODO: add dark theme

  Map<String, int> _words;
  Stream stream;
  StreamController<int> streamController;

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    streamController = StreamController<int>.broadcast();
    stream = streamController.stream;
    _words=widget.words;
  }

  getData() async {
     //_words = await readFile();
    List<String> keys = _words.keys.toList();
    if (keys.length == 0) {
      print('empty keys');
      streamController.add(0);
    } else {
      streamController.add(keys.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Настройки',
          style: Theme.of(context).textTheme.headline1,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          StreamBuilder<int>(
            stream: stream,
            builder: (context, snapshot) {
              int count = _words.length;
              if (snapshot.hasData) {
                //
              } else if (snapshot.hasError) {
                print(snapshot.error.toString());
              }
              return ListView(
                shrinkWrap: true,
                children: [
                  SizedBox(height: 30.0),
                  buildSettingsContainer(
                    context,
                    'Всего слов: ' + count.toString(),
                  ),
                ],
              );
            },
          ),
          CustomOutlinedButton(
            text: 'Сбросить настройки',
            onPressed: () async {
              await createDictionary();
              setState(() {
                getData();
              });
            },
          ),
          CustomOutlinedButton(
            text: 'Очистить словарь',
            onPressed: () async {
              writeFile('', 1);
              setState(() {
                _words.clear();
              });
            },
          ),
        ],
      ),
    );
  }

  GestureDetector buildSettingsContainer(BuildContext context, String text) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => DictionaryScreen(
              words: _words ,
              stream: stream,
              streamController: streamController,
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: Theme.of(context).focusColor,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Row(
          children: [
            Text(text, style: Theme.of(context).textTheme.bodyText1),
            Spacer(),
            Icon(
              Icons.edit_outlined,
              color: Theme.of(context).textTheme.bodyText1.color,
            ),
          ],
        ),
      ),
    );
  }
}

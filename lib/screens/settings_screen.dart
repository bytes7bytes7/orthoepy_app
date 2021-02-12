import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_accent_app/screens/components/quiz_outlined_button.dart';
import 'package:flutter_accent_app/screens/dictionary_screen.dart';
import 'package:flutter_accent_app/services.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
    getData();
  }

  getData() async {
    Map<String, int> words = await readFile();
    List<String> keys = words.keys.toList();
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
              int count = 0;
              if (snapshot.hasData) {
                count = snapshot.data;
              } else if (snapshot.hasError) {
                print(snapshot.error.toString());
              }
              return ListView(
                shrinkWrap: true,
                children: [
                  SizedBox(height: 30.0),
                  buildSettingsContainer(
                      context, 'Всего слов: ' + count.toString()),
                ],
              );
            },
          ),
          QuizOutlinedButton(
            text: 'Сбросить настройки',
            onPressed: () {
              setState(() {
                createDictionary();
                getData();
              });
            },
          ),
          QuizOutlinedButton(
            text: 'Очистить словарь',
            onPressed: () {
              setState(() {
                writeFile('',1);
                getData();
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
                stream: stream, streamController: streamController),
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

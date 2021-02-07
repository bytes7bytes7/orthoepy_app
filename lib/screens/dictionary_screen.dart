import 'package:flutter/material.dart';

class DictionaryScreen extends StatefulWidget {
  @override
  _DictionaryScreenState createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {

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
      body: Center(
        child: Text(
          'Скоро...',
          style: Theme.of(context).textTheme.headline1.copyWith(color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }
}

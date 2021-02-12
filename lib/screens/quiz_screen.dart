import 'package:flutter/material.dart';
import 'package:flutter_accent_app/const.dart';
import 'package:flutter_accent_app/screens/components/quiz_button_panel.dart';
import 'package:flutter_accent_app/services.dart';
import 'dart:math';
import 'dart:async';

class QuizScreen extends StatefulWidget {
  QuizScreen({
    Key key,
    @required this.screenTitle,
    @required this.isRandom,
  }) : super(key: key);

  final String screenTitle;
  final bool isRandom;

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  String word = '', rightAnswer;
  List<String> accentList = [];
  int currentIndex = 0, now = 0;
  String all;
  int delta = 0;

  Future<String> getNext() async {
    int tmp;
    Map<String, int> map = await readFile();
    List<String> keys = map.keys.toList();
    do {
      if (widget.isRandom) {
        var rng = Random();
        while (true) {
          tmp = rng.nextInt(map.length);
          if (tmp != currentIndex) {
            currentIndex = tmp;
            break;
          }
        }
      } else {
        currentIndex++;
      }
      if (currentIndex >= map.length) {
        currentIndex = 0;
      }
    } while (map[keys[currentIndex]] == 0);
    now += 1;
    all = widget.isRandom ? kInfinity : (map.length - delta).toString();
    return keys[currentIndex];
  }

  initDelta() async {
    Map<String, int> map = await readFile();
    map.forEach((key, value) {
      if (value == 0) delta++;
    });
    print('delta init');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    all = widget.isRandom ? kInfinity : '0';
    if (!widget.isRandom) {
      initDelta();
    }
  }

  @override
  Widget build(BuildContext context) {
    const double iconSize = 25.0;
    const double containerSize = 120.0;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.screenTitle,
          style: Theme.of(context).textTheme.headline1,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<String>(
        future: getNext(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            word = snapshot.data;
            accentList = shuffleAccent(word);
            rightAnswer = accentList[0];
            accentList.shuffle();
          } else if (snapshot.hasError) {
            print(snapshot.error.toString());
            word = '';
          } else {
            word = '';
          }
          return Container(
            child: Column(
              children: [
                SizedBox(height: 40.0),
                buildWordContainer(word.toLowerCase(), word, now.toString(),
                    all, containerSize, iconSize, size, context),
                QuizButtonPanel(
                  accentList: accentList,
                  rightIndex: accentList.indexOf(rightAnswer),
                  onPressed: () {
                    Future.delayed(const Duration(seconds: 2), () {
                      setState(() {});
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Stack buildWordContainer(
      String word,
      String rightAnswer,
      String now,
      String all,
      double containerSize,
      double iconSize,
      Size size,
      BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          height: containerSize + iconSize,
          width: double.infinity,
          color: Colors.transparent,
        ),
        Positioned(
          top: iconSize / 2,
          child: Container(
            height: containerSize,
            width: 0.9 * size.width,
            margin: const EdgeInsets.symmetric(horizontal: 30.0),
            decoration: BoxDecoration(
              color: Theme.of(context).focusColor,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Center(
              child: Text(
                word,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ),
        ),
        Positioned(
          top: 0.0,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 5.0,
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              now + '/' + all,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: GestureDetector(
            onTap: () {
              _showHintDialog(rightAnswer);
            },
            child: Container(
              //subtract this padding size from the size of Icon below
              padding: const EdgeInsets.all(2.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.circular(iconSize),
              ),
              child: Icon(
                Icons.help_outline_outlined,
                color: Theme.of(context).buttonColor,
                size: iconSize - 2.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showHintDialog(String hint) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('Подсказка')),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[Center(child: Text(hint))],
            ),
          ),
        );
      },
    );
  }
}

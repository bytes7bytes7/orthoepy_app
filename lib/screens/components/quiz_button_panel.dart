import 'dart:async';

import 'package:flutter/material.dart';

class QuizButtonPanel extends StatefulWidget {
  const QuizButtonPanel({
    Key key,
    @required this.accentList,
    @required this.rightIndex,
    @required this.streamController,
    @required this.stream,
    @required this.onPressed,
  }) : super(key: key);

  final List<String> accentList;
  final int rightIndex;
  final StreamController streamController;
  final Stream stream;
  final Function onPressed;

  @override
  _QuizButtonPanelState createState() => _QuizButtonPanelState();
}

class _QuizButtonPanelState extends State<QuizButtonPanel> {
  // wrong and right
  List<int> answers = [-1, -1];

  @override
  Widget build(BuildContext context) {
    if (widget.rightIndex != answers[1]) answers = [-1, -1];
    return Expanded(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: List.generate(
            widget.accentList.length,
            (index) => buildButton(
              widget.accentList[index],
              index,
              (answers[0] == index)
                  ? Theme.of(context).errorColor
                  : (answers[1] == index)
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).backgroundColor,
              (answers[0] == index)
                  ? Theme.of(context).backgroundColor
                  : (answers[1] == index)
                      ? Theme.of(context).backgroundColor
                      : Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButton(String text, int index, Color bgColor, Color ftColor) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 45.0,
      ),
      child: DecoratedBox(
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          color: bgColor,
        ),
        child: OutlinedButton(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.resolveWith(
                (states) => Theme.of(context).focusColor),
            backgroundColor: MaterialStateProperty.resolveWith(
                (states) => Colors.transparent),
            shape: MaterialStateProperty.resolveWith(
              (states) => RoundedRectangleBorder(
                side: BorderSide(
                  color: Theme.of(context).buttonColor,
                ),
              ),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            alignment: Alignment.center,
            width: double.infinity,
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style:
                  Theme.of(context).textTheme.button.copyWith(color: ftColor),
            ),
          ),
          onPressed: () {
            if (answers[0] == answers[1]) {
              if (widget.streamController != null) {
                print('add');
                widget.streamController.add(index);
              }
              setState(() {
                if (index == widget.rightIndex)
                  answers = [-1, widget.rightIndex];
                else
                  answers = [index, widget.rightIndex];
              });
              widget.onPressed();
            }
          },
        ),
      ),
    );
  }
}

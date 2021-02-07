import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class QuizOutlinedButton extends StatefulWidget {
  QuizOutlinedButton({
    Key key,
    @required this.text,
    @required this.onPressed,
    this.index,
    this.rightIndex,
    this.selectedColor,
    this.stream,
    this.streamController,
  }) : super(key: key);

  final String text;
  final Function onPressed;
  final int index;
  final int rightIndex;
  final Color selectedColor;
  final Stream stream;
  final StreamController streamController;

  @override
  _QuizOutlinedButtonState createState() => _QuizOutlinedButtonState();
}

class _QuizOutlinedButtonState extends State<QuizOutlinedButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 45.0,
      ),
      child: StreamBuilder<int>(
        stream: widget.stream,
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          Color backgroundColor = Theme.of(context).backgroundColor;
          Color fontColor = Theme.of(context).textTheme.button.color;
          if (snapshot.hasData) {
            if ((widget.index == widget.rightIndex || snapshot.data == widget.index) && snapshot.data != -1) {
              //print(widget.index.toString()+' : '+snapshot.data.toString());
              backgroundColor = widget.selectedColor;
              fontColor = Theme.of(context).backgroundColor;
            }
          } else if (snapshot.hasError) {
            print(snapshot.error.toString());
          }
          return DecoratedBox(
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              color: backgroundColor,
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
                // borderSide: BorderSide(
                //   color: Theme.of(context).buttonColor,
                // ),
                // fade when you hold the button
                // highlightColor: Colors.transparent,
                // animated circle when you hold the button
                // splashColor: Theme.of(context).focusColor,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                alignment: Alignment.center,
                width: double.infinity,
                child: Text(
                  widget.text,
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .copyWith(color: fontColor),
                ),
              ),
              onPressed: () {
                if (widget.streamController != null) {
                  widget.streamController.add(widget.index);
                }
                widget.onPressed();
              },
            ),
          );
        },
      ),
    );
  }
}

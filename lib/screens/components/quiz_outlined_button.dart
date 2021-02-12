import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_accent_app/services.dart';

class QuizOutlinedButton extends StatefulWidget {
  QuizOutlinedButton({
    Key key,
    @required this.text,
    @required this.onPressed,
    this.isActive,
    this.index,
    this.rightIndex,
    this.selectedColor,
    this.stream,
    this.streamController,
    this.activityStream,
    this.activityStreamController,
  }) : super(key: key);

  final String text;
  final Function onPressed;
  final bool isActive;
  final int index;
  final int rightIndex;
  final Color selectedColor;
  final Stream stream;
  final StreamController streamController;
  final Stream activityStream;
  final StreamController activityStreamController;

  @override
  _QuizOutlinedButtonState createState() => _QuizOutlinedButtonState();
}

class _QuizOutlinedButtonState extends State<QuizOutlinedButton> {
  bool _isActive;

  bool activate() {
    bool a;
    widget.activityStream.listen((event) {
      a = event;
    });
    return a;
  }

  @override
  void initState() {
    super.initState();
    if (widget.isActive != null) {
      (widget.isActive) ? _isActive = true : _isActive = false;
    }
  }

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
            if ((widget.index == widget.rightIndex ||
                    snapshot.data == widget.index) &&
                snapshot.data != -1) {
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
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                alignment: Alignment.center,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    (widget.isActive != null)
                        ? Flexible(
                            flex: 1,
                            child: Checkbox(
                              value: _isActive,
                              onChanged: (value) {
                                setState(() {
                                  _isActive = value;
                                  switchFile(widget.text);
                                });
                              },
                              activeColor: Theme.of(context).focusColor,
                            ),
                          )
                        : SizedBox.shrink(),
                    Flexible(
                      flex: 5,
                      fit: (widget.isActive != null)
                          ? FlexFit.tight
                          : FlexFit.loose,
                      child: Text(
                        widget.text,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .button
                            .copyWith(color: fontColor),
                      ),
                    ),
                    (widget.isActive != null) ? Spacer() : SizedBox.shrink(),
                    (widget.isActive != null)
                        ? Flexible(
                            flex: 1,
                            child: Icon(
                              Icons.edit,
                              color: Theme.of(context).focusColor,
                            ),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
              onPressed: () {
                if (widget.streamController != null) {
                  print('add');
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

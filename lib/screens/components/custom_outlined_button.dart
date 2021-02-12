import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_accent_app/services.dart';

class CustomOutlinedButton extends StatefulWidget {
  CustomOutlinedButton({
    Key key,
    @required this.text,
    @required this.onPressed,
    this.isActive,
  }) : super(key: key);

  final String text;
  final Function onPressed;
  final bool isActive;

  @override
  _CustomOutlinedButtonState createState() => _CustomOutlinedButtonState();
}

class _CustomOutlinedButtonState extends State<CustomOutlinedButton> {
  bool _isActive;

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
      child: DecoratedBox(
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          color: Theme.of(context).backgroundColor,
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
                  fit:
                      (widget.isActive != null) ? FlexFit.tight : FlexFit.loose,
                  child: Text(
                    widget.text,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .button,
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
            widget.onPressed();
          },
        ),
      ),
    );
  }
}

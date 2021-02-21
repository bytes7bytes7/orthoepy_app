import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatefulWidget {
  CustomOutlinedButton({
    Key key,
    @required this.text,
    @required this.onPressed,
  }) : super(key: key);

  final String text;
  final Function onPressed;

  @override
  _CustomOutlinedButtonState createState() => _CustomOutlinedButtonState();
}

class _CustomOutlinedButtonState extends State<CustomOutlinedButton> {
  String _text;

  @override
  void initState() {
    super.initState();
    _text = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    if (_text != widget.text) {
      print('change text');
      _text = widget.text;
    }
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 45.0,
      ),
      child: Material(
        child: InkWell(
          onTap: () {
            widget.onPressed();
          },
          focusColor: Colors.transparent,
          splashColor: Theme.of(context).focusColor,
          highlightColor: Colors.transparent,
          child: Container(
            decoration: ShapeDecoration(
              shape: BeveledRectangleBorder(
                side: BorderSide(
                  color: Theme.of(context).buttonColor,
                  width: 0.5,
                ),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            alignment: Alignment.center,
            width: double.infinity,
            child: Text(
              widget.text,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.button,
            ),
          ),
        ),
      ),
    );
  }
}

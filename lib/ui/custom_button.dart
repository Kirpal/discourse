import 'package:flutter/material.dart';

/// A white button with black border and text
class CustomButton extends StatelessWidget {
  final String text;
  final Function() onPressed;

  CustomButton({@required this.text, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.black,
          width: 4,
        ),
      ),
      child: FlatButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        height: 50,
      ),
    );
  }
}

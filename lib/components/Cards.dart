import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// ignore: must_be_immutable
class NewCards extends StatelessWidget {
  NewCards(
      {@required this.text, @required this.color, @required this.newMethod});
  final String text;
  final Color color;
  final Function newMethod;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
            onPressed: newMethod,
            minWidth: 200.0,
            height: 42.0,
            child: Text(
              text,
              style: TextStyle(color: Colors.white),
            )),
      ),
    );
  }
}

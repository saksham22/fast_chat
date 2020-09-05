import 'package:flutter/material.dart';
class RoundedButton extends StatelessWidget {
  RoundedButton({this.name, this.func, this.colour});

  final String name;
  final Function func;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        elevation: 5.0,
        child: MaterialButton(
          onPressed: func,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            name,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
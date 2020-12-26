import 'package:flutter/material.dart';

class MinimalPageHeading extends StatelessWidget {
  final String heading;

  const MinimalPageHeading({Key key, @required this.heading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Text(
        heading,
        style: TextStyle(fontSize: 30),
      ),
    );
  }
}

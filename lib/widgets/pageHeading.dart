import 'package:flutter/material.dart';

class PageHeading extends StatelessWidget {
  final String heading;

  PageHeading(this.heading);

  double width, height;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 30,
        horizontal: 16,
      ),
      child: Text(
        heading,
        style: TextStyle(
            fontSize: (36 / (678 * 360)) * height * width,
            color: Colors.grey[500],
            fontWeight: FontWeight.w300,
            letterSpacing: 1),
      ),
    );
  }
}

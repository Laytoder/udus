import 'package:flutter/material.dart';

showLocating(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return Center(
        child: CircleAvatar(
          radius: 103,
          backgroundColor: Color(0xff0083b0),
          child: CircleAvatar(
            radius: 100,
            backgroundImage: AssetImage('assets/locating_anim.gif'),
          ),
        ),
      );
    },
  );
}

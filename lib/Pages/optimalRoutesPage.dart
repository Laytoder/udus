import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../AppState.dart';

class OptimalRoutesPage extends StatefulWidget {
  AppState appState;

  OptimalRoutesPage({
    @required this.appState,
  });

  @override
  _OptimalRoutesPage createState() => _OptimalRoutesPage();
}

class _OptimalRoutesPage extends State<OptimalRoutesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffE0E5EC),
        body: Column(children: [
          SizedBox(height: 60),
          Text(
            "asd",
            style: TextStyle(
                color: Colors.black,
                fontSize: 28,
                decoration: TextDecoration.none),
          ),
          SizedBox(height: 20),
        ])
    );
  }
}

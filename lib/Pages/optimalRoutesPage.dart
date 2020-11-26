import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../AppState.dart';
import 'package:frute/models/tripRoute.dart';

class OptimalRoutesPage extends StatefulWidget {
  AppState appState;
  List<TripRoute> optimalTripRoutes;

  OptimalRoutesPage({
    @required this.appState,
    @required this.optimalTripRoutes,
  });

  @override
  _OptimalRoutesPage createState() => _OptimalRoutesPage();
}

class _OptimalRoutesPage extends State<OptimalRoutesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE0E5EC),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Neumorphic(
            margin: EdgeInsets.only(
              left: 10.0,
              right: 10.0,
              top: 10.0,
            ),
            style: NeumorphicStyle(
              shape: NeumorphicShape.concave,
              boxShape: NeumorphicBoxShape.roundRect(
                BorderRadius.circular(15.0),
              ),
              depth: 3,
              lightSource: LightSource.topLeft,
              border: NeumorphicBorder(
                color: Colors.white,
                width: 0.5,
              ),
              color: Color(0xffE0E5EC),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10.0,
              ),
              child: ListTile(
                leading: Wrap(
                  direction: Axis.vertical,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(3.0),
                      child: Text('#Suggestion ${index + 1}'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(3.0),
                      child:
                          Text('Rs. ${widget.optimalTripRoutes[index].price}'),
                    ),
                  ],
                ),
                trailing: Wrap(
                  direction: Axis.vertical,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(3.0),
                      child: Text('${(widget.optimalTripRoutes[index].duration / 60).round()} mins'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(3.0),
                      child:
                          Text('Show more..'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

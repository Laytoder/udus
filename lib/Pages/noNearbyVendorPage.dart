import 'package:flutter/material.dart';
import 'package:frute/AppState.dart';
import 'package:frute/Pages/homebuilder.dart';
import 'package:frute/config/colors.dart';
import 'package:frute/config/borderRadius.dart';

class NoNearbyVendorPage extends StatelessWidget {
  AppState appState;

  NoNearbyVendorPage(this.appState);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: 120,
              left: 50,
              right: 50,
              bottom: 0,
            ),
            child: Center(
              child: Image.asset('assets/novendor.png'),
            ),
          ),
          Text(
            'Oops!',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 3,
          ),
          Text(
            'There are no vendors nearby',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 30,
          ),
          GestureDetector(
            child: Container(
              height: 30,
              width: 100,
              decoration: BoxDecoration(
                color: UdusColors.primaryColor,
                borderRadius: UdusBorderRadius.large,
              ),
              child: Center(
                child: Row(
                  //direction: Axis.horizontal,
                  //alignment: WrapAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.location_on,
                      //color: Colors.black,
                      color: Colors.black,
                      size: 18,
                    ),
                    Text(
                      'Edit Location',
                      style: TextStyle(
                        //color: Colors.black,
                        color: Colors.black,
                        fontSize: 10,
                      ),
                    ),
                    SizedBox(
                      width: 3,
                    ),
                  ],
                ),
              ),
            ),
            onTap: () async {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeBuilder(
                    appState,
                    state: 'edit',
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

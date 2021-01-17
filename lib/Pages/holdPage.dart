import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:frute/AppState.dart';
import 'package:frute/Pages/billHistory.dart';
import 'package:frute/Pages/profilePage.dart';
import 'package:frute/assets/my_flutter_app_icons.dart';
import 'package:frute/helpers/directionApiHelper.dart';
import 'package:frute/helpers/messageGetters.dart';
import 'package:frute/helpers/messagingHelper.dart';
import 'package:frute/routes/fadeRoute.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'map.dart' as map;

class HoldPage extends StatelessWidget {
  String eta, vendorName;
  AppState appState;
  MessagingHelper messagingHelper = MessagingHelper();
  SharedPreferences preferences;
  double height, width;
  PageController globalController = PageController(initialPage: 1);

  HoldPage({
    @required this.eta,
    @required this.vendorName,
    @required this.appState,
    @required this.preferences,
  });

  launchOnReply(BuildContext context) async {
    appState.messages = StreamController();
    Map<String, dynamic> reply = await getReply(appState);
    DirectionApiHelper directionApiHelper = DirectionApiHelper();
    appState.pendingTrip.state = 'ongoing';
    GeoCoord destination = GeoCoord.fromJson(reply['destination']);
    GeoCoord origin = GeoCoord.fromJson(reply['origin']);
    appState.pendingTrip.origin = origin;
    appState.pendingTrip.destination = destination;
    await directionApiHelper.populateData(origin, destination);
    appState.pendingTrip.directionApiHelper = directionApiHelper;
    preferences.setString(
      'directionsApiHelper',
      jsonEncode(directionApiHelper.toJson()),
    );
    Navigator.pushReplacement(
      context,
      FadeRoute(
        page: map.Map(
          directionApiHelper: directionApiHelper,
          appState: appState,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    launchOnReply(context);
    return PageView(
      allowImplicitScrolling: false,
      physics: NeverScrollableScrollPhysics(),
      controller: globalController,
      children: <Widget>[
        ProfilePage(
          controller: globalController,
          appState: appState,
        ),
        WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            backgroundColor: Color(0xffE0E5EC),
            body: Stack(
              children: <Widget>[
                Center(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: Container(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0, left: 15),
                        child: Image.asset('assets/waiting_animation.gif'),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'HOLD ON! $vendorName is on another Trip',
                        style: TextStyle(
                          color: Color(0xff58616e),
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'It may take approx. $eta to start your trip',
                        style: TextStyle(
                          color: Color(0xff58616e),
                          fontSize: 12,
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: (40 / 678) * height,
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 10,
                        ),
                        IconButton(
                          icon: NeumorphicIcon(
                            MyFlutterApp.user,
                            style: NeumorphicStyle(
                              shape: NeumorphicShape.convex,
                              depth: 3,
                              lightSource: LightSource.topLeft,
                              intensity: 0.68,
                              border: NeumorphicBorder(
                                color: Colors.white,
                                width: 0.5,
                              ),
                              shadowDarkColor: Color(0xffA3B1C6),
                              shadowLightColor: Colors.white,
                              color: Color(0xffAFBBCA),
                            ),
                            size: 28,
                          ),
                          onPressed: () {
                            globalController.animateToPage(
                              0,
                              duration: Duration(milliseconds: 1000),
                              curve: Curves.fastLinearToSlowEaseIn,
                            );
                          },
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        IconButton(
                          icon: NeumorphicIcon(
                            Icons.shopping_basket,
                            style: NeumorphicStyle(
                              shape: NeumorphicShape.convex,
                              depth: 3,
                              lightSource: LightSource.topLeft,
                              intensity: 0.68,
                              border: NeumorphicBorder(
                                color: Colors.white,
                                width: 0.5,
                              ),
                              shadowDarkColor: Color(0xffA3B1C6),
                              shadowLightColor: Colors.white,
                              color: Color(0xffAFBBCA),
                            ),
                            size: 32,
                          ),
                          onPressed: () {
                            globalController.animateToPage(
                              2,
                              duration: Duration(milliseconds: 1000),
                              curve: Curves.fastLinearToSlowEaseIn,
                            );
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        /*BillHistory(
          //globalController,
          appState,
          preferences,
        ),*/
      ],
    );
  }
}

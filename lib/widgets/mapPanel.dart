import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:frute/AppState.dart';
import 'package:frute/helpers/directionApiHelper.dart';
import 'package:frute/helpers/pidHelper.dart';
import 'package:frute/models/vendorInfo.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:frute/assets/my_flutter_app_icons.dart';

class MapPanel extends StatefulWidget {
  VendorInfo currentVendor;
  PIDHelper pidHelper;
  DirectionApiHelper directionApiHelper;
  StreamSubscription locationSubscription;
  AppState appState;
  double width, height;
  PageController globalController;
  MapPanel({
    @required this.currentVendor,
    @required this.pidHelper,
    @required this.directionApiHelper,
    @required this.locationSubscription,
    @required this.appState,
    @required this.width,
    @required this.height,
    @required this.globalController,
  });

  @override
  _MapPanelState createState() => _MapPanelState();
}

class _MapPanelState extends State<MapPanel>
    with SingleTickerProviderStateMixin {
  double width, height, dragStartValue;
  AnimationController upperPanelController;

  getInitialDistance() {
    int dist = widget.directionApiHelper.distance.value;
    String dispDist;
    if (dist < 1000) {
      dispDist = '$dist meters';
    } else {
      dist = (dist / 1000).round();
      dispDist = '$dist km';
    }
    return dispDist;
  }

  getInitialETA() {
    int eta = widget.directionApiHelper.duration.value;
    String dispEta;
    if (eta < 60) {
      dispEta = '$eta secs';
    } else {
      eta = (eta / 60).round();
      dispEta = '$eta mins';
    }
    return dispEta;
  }

  @override
  void initState() {
    super.initState();
    upperPanelController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300))
      ..addListener(() {
        setState(() {});
      });

    upperPanelController.value = 0.0;
  }

  onDrag(BuildContext context, DragUpdateDetails details) {
    RenderBox box = context.findRenderObject();
    Offset offset = box.globalToLocal(details.globalPosition);
    double value = (offset.dy) / widget.height;

    if (value > 0.4) {
      if (!(value > dragStartValue && upperPanelController.value == 0))
        upperPanelController.value = 1 - value;
    }
  }

  onDragStart(DragStartDetails details, BuildContext context) {
    RenderBox box = context.findRenderObject();
    Offset offset = box.globalToLocal(details.globalPosition);
    double value = (offset.dy) / widget.height;
    dragStartValue = value;
  }

  onDragEnd() {
    if (upperPanelController.value > 0.5) {
      upperPanelController.animateTo(0.8,
          duration: Duration(milliseconds: 300), curve: Curves.fastOutSlowIn);
    } else {
      upperPanelController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.fastOutSlowIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Container(
      width: widget.width,
      height: widget.height,
      child: GestureDetector(
        onVerticalDragStart: (DragStartDetails details) {
          onDragStart(details, context);
        },
        onVerticalDragUpdate: (DragUpdateDetails details) {
          onDrag(context, details);
        },
        onVerticalDragEnd: (_) {
          onDragEnd();
        },
        child: Column(
          children: <Widget>[
            Flexible(
              child: FractionallySizedBox(
                widthFactor: 1.0,
                heightFactor: 1.0 - upperPanelController.value,
                child: Container(
                  child: Card(
                    color: Color(0xffE0E5EC),
                    margin: EdgeInsets.only(left: 0, right: 0, top: 0),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(50),
                        bottomLeft: Radius.circular(50),
                      ),
                    ),
                    child: SingleChildScrollView(
                      reverse: true,
                      physics: NeverScrollableScrollPhysics(),
                      child: Stack(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Container(
                                //flex: 7,
                                width: widget.width,
                                height: widget.height * 0.7,
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 40,
                                      ),
                                      Text(
                                        'Track your vendor',
                                        style: TextStyle(
                                          fontFamily: 'Ubuntu',
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey[500],
                                          fontSize: 18,
                                        ),
                                      ),
                                      CachedNetworkImage(
                                        imageUrl: widget.currentVendor.imageUrl,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          margin: EdgeInsets.only(
                                            top: (20 / 678) * height,
                                            bottom: (10 / 678) * height,
                                          ),
                                          width: width * 0.2,
                                          height: width * 0.2,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                      Text(
                                        widget.currentVendor.name,
                                        style: TextStyle(
                                          fontFamily: 'Ubuntu',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                //flex: 3,
                                width: widget.width,
                                height: widget.height * 0.3,
                                child: Stack(
                                  children: <Widget>[
                                    Row(
                                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        /*Neumorphic(
                                          style: NeumorphicStyle(
                                            boxShape:
                                                NeumorphicBoxShape.roundRect(
                                              BorderRadius.only(
                                                bottomLeft: Radius.circular(60),
                                                bottomRight:
                                                    Radius.circular(50),
                                                topRight: Radius.circular(50),
                                                topLeft: Radius.circular(10),
                                              ),
                                            ),
                                            color: Color(0xffE0E5EC),
                                            depth: 3,
                                            shape: NeumorphicShape.flat,
                                          ),
                                          child: Container(
                                            width: 100,
                                            height: 100,
                                            margin: EdgeInsets.only(
                                              bottom: 10,
                                              left: 10,
                                              right: 0,
                                            ),
                                            child: Center(
                                              child: Wrap(
                                                direction: Axis.vertical,
                                                children: <Widget>[
                                                  Text(
                                                    'Distance',
                                                    style: TextStyle(
                                                        fontSize:
                                                            (height * 14) /
                                                                678),
                                                  ),
                                                  StreamBuilder(
                                                    stream: widget.pidHelper
                                                        .getDistStream(),
                                                    initialData:
                                                        getInitialDistance(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        return Text(
                                                          snapshot.data,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize:
                                                                  (height *
                                                                          12) /
                                                                      678),
                                                        );
                                                      } else {
                                                        return CircularProgressIndicator();
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              color: Color(0xfff6f6f6),
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(60),
                                                bottomRight:
                                                    Radius.circular(50),
                                                topRight: Radius.circular(50),
                                                topLeft: Radius.circular(10),
                                              ),
                                            ),
                                          ),
                                        ),*/
                                        Container(
                                          width: 100,
                                          height: 100,
                                          margin: EdgeInsets.only(
                                            bottom: 10,
                                            left: 10,
                                            right: 0,
                                          ),
                                          //color: Color(0xffE0E5EC),
                                          child: Neumorphic(
                                            style: NeumorphicStyle(
                                              boxShape:
                                                  NeumorphicBoxShape.roundRect(
                                                BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(60),
                                                  bottomRight:
                                                      Radius.circular(50),
                                                  topRight: Radius.circular(50),
                                                  topLeft: Radius.circular(10),
                                                ),
                                              ),
                                              color: Color(0xffE0E5EC),
                                              depth: 3,
                                              shape: NeumorphicShape.flat,
                                            ),
                                            child: Center(
                                              child: Wrap(
                                                direction: Axis.vertical,
                                                children: <Widget>[
                                                  Text(
                                                    'Distance',
                                                    style: TextStyle(
                                                        fontSize:
                                                            (height * 14) /
                                                                678),
                                                  ),
                                                  StreamBuilder(
                                                    stream: widget.pidHelper
                                                        .getDistStream(),
                                                    initialData:
                                                        getInitialDistance(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        return Text(
                                                          snapshot.data,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize:
                                                                  (height *
                                                                          12) /
                                                                      678),
                                                        );
                                                      } else {
                                                        return CircularProgressIndicator();
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color: Color(0xffE0E5EC),
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(60),
                                              bottomRight: Radius.circular(50),
                                              topRight: Radius.circular(50),
                                              topLeft: Radius.circular(10),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(),
                                        ),
                                        Container(
                                          width: 100,
                                          height: 100,
                                          margin: EdgeInsets.only(
                                            bottom: 10,
                                            left: 0,
                                            right: 10,
                                          ),
                                          child: Neumorphic(
                                            style: NeumorphicStyle(
                                              boxShape:
                                                  NeumorphicBoxShape.roundRect(
                                                BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(60),
                                                  bottomLeft:
                                                      Radius.circular(50),
                                                  topLeft: Radius.circular(50),
                                                  topRight: Radius.circular(10),
                                                ),
                                              ),
                                              color: Color(0xffE0E5EC),
                                              depth: 3,
                                              shape: NeumorphicShape.flat,
                                            ),
                                            child: Center(
                                              child: Wrap(
                                                direction: Axis.vertical,
                                                children: <Widget>[
                                                  Text(
                                                    'ETA',
                                                    style: TextStyle(
                                                        fontSize:
                                                            (height * 14) /
                                                                678),
                                                  ),
                                                  StreamBuilder(
                                                    stream: widget.pidHelper
                                                        .getEtaStream(),
                                                    initialData:
                                                        getInitialETA(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        return Text(
                                                          snapshot.data,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize:
                                                                  (height *
                                                                          12) /
                                                                      678),
                                                        );
                                                      } else {
                                                        return CircularProgressIndicator();
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color: Color(0xffE0E5EC),
                                            borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(60),
                                              bottomLeft: Radius.circular(50),
                                              topLeft: Radius.circular(50),
                                              topRight: Radius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      /*child: FloatingActionButton(
                                        onPressed: () {
                                          UrlLauncher.launch(
                                              'tel:${widget.currentVendor.phoneNumber}');
                                        },
                                        child: Icon(
                                          Icons.call,
                                          color: Color(0xff25D366),
                                        ),
                                        backgroundColor: Colors.white,
                                      ),*/
                                      child: GestureDetector(
                                        child: Neumorphic(
                                          margin: EdgeInsets.only(
                                            bottom: 30.0,
                                          ),
                                          style: NeumorphicStyle(
                                            boxShape:
                                                NeumorphicBoxShape.circle(),
                                            shape: NeumorphicShape.flat,
                                            depth: 3,
                                            color: Color(0xffE0E5EC),
                                          ),
                                          child: Container(
                                            height: (50 / 678) * height,
                                            width: (50 / 678) * height,
                                            margin: EdgeInsets.only(
                                                //bottom: 10.0,
                                                ),
                                            child: Icon(
                                              Icons.phone,
                                              color: Color.fromRGBO(
                                                  35, 205, 99, 1.0),
                                              size: (20 / 678) * height,
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          UrlLauncher.launch(
                                              'tel:${widget.currentVendor.phoneNumber}');
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
                                      widget.globalController.animateToPage(
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
                                      widget.globalController.animateToPage(
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
                              /*Expanded(
                                child: Container(),
                              ),*/
                              SizedBox(
                                height: widget.height * 0.62,
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(),
                                  ),
                                  Container(
                                    height: 7,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30.0),
                                      color: Color(0xffAFBBCA),
                                    ),
                                    child: Neumorphic(
                                      style: NeumorphicStyle(
                                        boxShape: NeumorphicBoxShape.roundRect(
                                          BorderRadius.circular(30.0),
                                        ),
                                        color: Color(0xffAFBBCA),
                                        depth: -3,
                                        shape: NeumorphicShape.flat,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(),
                                  )
                                ],
                              ),
                            ],
                          ),
                          /*Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              margin: EdgeInsets.only(
                                top: 30,
                              ),
                              child: IconButton(
                                icon: Container(
                                  child: SvgPicture.asset(
                                    'assets/home.svg',
                                    height: 25,
                                    width: 25,
                                    color: Color(0xff58f8f8f),
                                  ),
                                ),
                                onPressed: () async {
                                  widget.appState.active = false;
                                  widget.appState.messages = StreamController();
                                  //carController.dispose();
                                  await widget.locationSubscription.cancel();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          HomeBuilder(widget.appState),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),*/
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

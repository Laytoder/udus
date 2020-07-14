import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frute/AppState.dart';
import 'package:frute/Pages/homePage.dart';
import 'package:frute/Pages/homebuilder.dart';
import 'package:frute/helpers/directionApiHelper.dart';
import 'package:frute/helpers/pidHelper.dart';
import 'package:frute/models/vendorInfo.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class MapPanel extends StatefulWidget {
  VendorInfo currentVendor;
  PIDHelper pidHelper;
  DirectionApiHelper directionApiHelper;
  StreamSubscription locationSubscription;
  AppState appState;
  double width, height;
  MapPanel({
    @required this.currentVendor,
    @required this.pidHelper,
    @required this.directionApiHelper,
    @required this.locationSubscription,
    @required this.appState,
    @required this.width,
    @required this.height,
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
                                      CachedNetworkImage(
                                        //imageUrl: currentVendor.imageUrl,
                                        imageUrl:
                                            'https://c8.alamy.com/comp/EJ2D70/portrait-of-an-indian-old-man-a-street-vendor-sell-street-food-in-EJ2D70.jpg',
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          margin: EdgeInsets.only(
                                            top: (50 / 678) * height,
                                            bottom: (15 / 678) * height,
                                          ),
                                          width: width * 0.25,
                                          height: width * 0.25,
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
                                        Container(
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
                                                          (height * 14) / 678),
                                                ),
                                                StreamBuilder(
                                                  stream: widget.pidHelper
                                                      .getDistStream(),
                                                  initialData:
                                                      getInitialDistance(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData) {
                                                      return Text(
                                                        snapshot.data,
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize:
                                                                (height * 12) /
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
                                          child: Center(
                                            child: Wrap(
                                              direction: Axis.vertical,
                                              children: <Widget>[
                                                Text(
                                                  'ETA',
                                                  style: TextStyle(
                                                      fontSize:
                                                          (height * 14) / 678),
                                                ),
                                                StreamBuilder(
                                                  stream: widget.pidHelper
                                                      .getEtaStream(),
                                                  initialData: getInitialETA(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData) {
                                                      return Text(
                                                        snapshot.data,
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize:
                                                                (height * 12) /
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
                                      child: FloatingActionButton(
                                        onPressed: () {
                                          UrlLauncher.launch(
                                              'tel:${widget.currentVendor.phoneNumber}');
                                        },
                                        child: Icon(
                                          Icons.call,
                                          color: Color(0xff25D366),
                                        ),
                                        backgroundColor: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Align(
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
                          ),
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

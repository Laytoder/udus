import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frute/Animations/FadeAnimations.dart';
import 'package:frute/AppState.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:frute/Pages/billHistory.dart';
import 'package:frute/Pages/profilePage.dart';
import 'package:frute/Pages/vendorInfoPage.dart';
import 'package:frute/helpers/directionApiHelper.dart';
import 'package:frute/helpers/messagingHelper.dart';
import 'package:frute/models/vendorInfo.dart';
import 'package:frute/routes/fadeRoute.dart';
import 'package:frute/widgets/dualButton.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:frute/Pages/map.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frute/models/trip.dart';
import 'holdPage.dart';
import 'package:frute/helpers/messageGetters.dart';
import 'package:simple_animations/simple_animations.dart';

class HomePage extends StatefulWidget {
  AppState appState;
  int initialPage;
  Function refreshVendors;
  HomePage(this.appState, this.refreshVendors, {this.initialPage = 1});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  AppState appState;
  double width, height;
  String currVendorToken, currVendorId;
  VendorInfo currentVendorInfo;
  MessagingHelper messagingHelper = MessagingHelper();
  DirectionApiHelper directionApiHelper = DirectionApiHelper();
  bool locating = false;
  AnimationController controller;
  Animation animation;
  PageController pageController = PageController();
  PageController globalController;
  SharedPreferences preferences;
  @override
  void initState() {
    super.initState();
    appState = widget.appState;
    String key = appState.userId[0];
    VendorInfo vendor = appState.vendors[key];
    currentVendorInfo = vendor;
    currVendorToken = vendor.token;
    currVendorId = key;
    globalController = PageController(initialPage: widget.initialPage);
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return PageView(
      allowImplicitScrolling: false,
      physics: NeverScrollableScrollPhysics(),
      controller: globalController,
      children: <Widget>[
        ProfilePage(
          controller: globalController,
          appState: widget.appState,
        ),
        WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            backgroundColor: Color(0xfff6f7fb),
            //backgroundColor: Colors.amberAccent,
            body: Stack(
              children: <Widget>[
                PageView(
                  allowImplicitScrolling: false,
                  controller: pageController,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    RefreshIndicator(
                      backgroundColor: Color.fromRGBO(35, 205, 99, 1.0),
                      color: Colors.white,
                      displacement: 100,
                      onRefresh: () async {
                        return (await widget.refreshVendors());
                      },
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: (90 / 678) * height,
                            ),
                            CarouselSlider.builder(
                              itemCount: appState.userId.length,
                              itemBuilder: (context, index) {
                                String key = appState.userId[index];
                                VendorInfo vendor = appState.vendors[key];
                                return VendorInfoPage(vendor);
                              },
                              options: CarouselOptions(
                                autoPlay: false,
                                enableInfiniteScroll: true,
                                height: height * 0.75,
                                enlargeCenterPage: true,
                                onPageChanged: (index, _) {
                                  String key = appState.userId[index];
                                  VendorInfo vendor = appState.vendors[key];
                                  currentVendorInfo = vendor;
                                  currVendorToken = vendor.token;
                                  currVendorId = key;
                                },
                              ),
                            ),
                            Container(
                              width: width,
                              height: (50 / 678) * height,
                              margin: EdgeInsets.only(
                                left: (40 / 360) * width,
                                right: (40 / 360) * width,
                              ),
                              child: FadeAnimation(
                                  1,
                                  RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          (80 / 678) * height),
                                    ),
                                    padding: EdgeInsets.all(0.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [
                                          Color.fromRGBO(35, 205, 99, 1),
                                          Color.fromRGBO(35, 205, 99, 0.6)
                                        ]),
                                        borderRadius: BorderRadius.circular(
                                            (80 / 678) * height),
                                      ),
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Contact Vendor',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: (20 / 678) * height,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                    onPressed: () async {
                                      //appState.pendingTrip != null
                                      if (appState.pendingTrip != null &&
                                          appState.pendingTrip.state !=
                                              'requested') {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          (10 / 678) * height)),
                                              title: Text(
                                                'Sorry, you can only call one vendor at a time',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: (14 / 678) * height,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      } else {
                                        setState(() => locating = true);
                                        controller.forward();
                                        Trip trip = Trip(
                                          state: 'requested',
                                          vendorId: currVendorId,
                                        );
                                        appState.pendingTrip = trip;
                                        preferences = await SharedPreferences
                                            .getInstance();
                                        preferences.setString(
                                            'pendingTripVendorId',
                                            currVendorId);
                                        //send message to vendor
                                        await messagingHelper.sendMessage(
                                          currVendorToken,
                                          appState.messagingToken,
                                          appState.userLocation,
                                          appState.clientName,
                                          appState.phoneNumber,
                                        );
                                        appState.active = true;
                                        var reply = await getReply(appState);
                                        String state = reply['state'];
                                        switch (state) {
                                          case 'rejected':
                                            appState.pendingTrip = null;
                                            preferences.setString(
                                                'pendingTripVendorId', null);
                                            await controller.reverse();
                                            setState(() => locating = false);
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              (10 / 678) *
                                                                  height)),
                                                  title: Text(
                                                    'Sorry, the vendor denied call',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize:
                                                          (14 / 678) * height,
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                            appState.active = false;
                                            break;
                                          case 'hold':
                                            appState.pendingTrip.state = 'hold';
                                            appState.pendingTrip.eta =
                                                reply['eta'];
                                            await controller.reverse();
                                            setState(() => locating = false);
                                            Navigator.pushReplacement(
                                              context,
                                              FadeRoute(
                                                page: HoldPage(
                                                  vendorName: 'Ramu Kaka',
                                                  eta: reply['eta'],
                                                  appState: appState,
                                                  preferences: preferences,
                                                ),
                                              ),
                                            );
                                            //setState(() => locating = false);
                                            break;
                                          case 'ongoing':
                                            appState.pendingTrip.state =
                                                'ongoing';
                                            GeoCoord destination =
                                                GeoCoord.fromJson(
                                                    reply['destination']);
                                            GeoCoord origin = GeoCoord.fromJson(
                                                reply['origin']);
                                            appState.pendingTrip.origin =
                                                origin;
                                            appState.pendingTrip.destination =
                                                destination;
                                            await directionApiHelper
                                                .populateData(
                                                    origin, destination);
                                            appState.pendingTrip
                                                    .directionApiHelper =
                                                directionApiHelper;
                                            preferences.setString(
                                              'directionsApiHelper',
                                              jsonEncode(
                                                  directionApiHelper.toJson()),
                                            );
                                            await controller.reverse();
                                            setState(() => locating = false);
                                            Navigator.pushReplacement(
                                              context,
                                              FadeRoute(
                                                page: Map(
                                                  directionApiHelper:
                                                      directionApiHelper,
                                                  appState: appState,
                                                ),
                                              ),
                                            );
                                            break;
                                        }
                                      }
                                    },
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        height: 200,
                        width: 200,
                        child: FadeAnimation(
                          1,
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                            ),
                            elevation: 15,
                            shadowColor: Color.fromRGBO(35, 205, 99, 0.2),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: (80 / 678) * height,
                                  ),
                                ),
                                Text(
                                  'Coming Soon',
                                  style: TextStyle(
                                    fontSize: (30 / 678) * height,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
                        IconButton(
                          icon: Container(
                            child: SvgPicture.asset(
                              'assets/user.svg',
                              height: (25 / 678) * height,
                              width: (25 / 678) * height,
                              //color: Color(0xff58f8f8f),
                              color: Color.fromRGBO(35, 205, 99, 1.0),
                            ),
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
                        DualButton(
                          height: (40 / 678) * height,
                          width: width * 0.4,
                          textSize: (14 / 678) * height,
                          //can keep padding without scale
                          padding: (3 / 678) * height,
                          //maybe radius as well
                          radius: (80 / 678) * height,
                          onDropInClicked: () {
                            pageController.animateToPage(
                              1,
                              duration: Duration(milliseconds: 2000),
                              curve: Curves.fastLinearToSlowEaseIn,
                            );
                          },
                          onNowClicked: () {
                            pageController.animateToPage(
                              0,
                              duration: Duration(milliseconds: 2000),
                              curve: Curves.fastLinearToSlowEaseIn,
                            );
                          },
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        IconButton(
                          icon: Container(
                            child: SvgPicture.asset(
                              'assets/bill.svg',
                              height: (25 / 678) * height,
                              width: (25 / 678) * height,
                              //color: Color(0xff58f8f8f),
                              color: Color.fromRGBO(35, 205, 99, 1.0),
                            ),
                          ),
                          onPressed: () {
                            globalController.animateToPage(
                              2,
                              duration: Duration(milliseconds: 1000),
                              curve: Curves.fastLinearToSlowEaseIn,
                            );
                          },
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
                locating
                    ? FadeTransition(
                        opacity: animation,
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 2,
                            sigmaY: 2,
                          ),
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.9)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                ScaleTransition(
                                  scale: animation,
                                  child: CircleAvatar(
                                    radius: (103 / 678) * height,
                                    backgroundColor: Color(0xff0083b0),
                                    child: CircleAvatar(
                                      radius: (100 / 678) * height,
                                      backgroundImage: AssetImage(
                                          'assets/locating_anim.gif'),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: (40 / 678) * height),
                                  child: Text(
                                    'Contacting Your Vendor..',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: (20 / 678) * height,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : SizedBox(
                        child: Container(),
                        width: 0,
                        height: 0,
                      ),
              ],
            ),
          ),
        ),
        BillHistory(globalController, appState, preferences),
      ],
    );
  }
}

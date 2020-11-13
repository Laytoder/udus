import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frute/AppState.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:frute/Pages/billHistory.dart';
import 'package:frute/Pages/profilePage.dart';
import 'package:frute/Pages/vendorInfoPage.dart';
import 'package:frute/helpers/directionApiHelper.dart';
import 'package:frute/helpers/messagingHelper.dart';
import 'package:frute/homePage/homepageupdated.dart';
import 'package:frute/models/order.dart';
import 'package:frute/models/vendorInfo.dart';
import 'package:frute/routes/fadeRoute.dart';
import 'package:frute/widgets/dualButton.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:frute/Pages/map.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frute/models/trip.dart';
import 'package:slider_button/slider_button.dart';
import 'cartPage.dart';
import 'holdPage.dart';
import 'package:frute/helpers/messageGetters.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:frute/assets/my_flutter_app_icons.dart';
import 'package:frute/helpers/confirmationDialog.dart';

class HomePage extends StatefulWidget {
  AppState appState;
  int initialPage;
  Function refreshVendors;

  HomePage(this.appState, this.refreshVendors, {this.initialPage = 1});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
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
  bool isIncomingTripManaged = false;

  @override
  void initState() {
    super.initState();
    appState = widget.appState;
    String key = appState.pendingTrip != null
        ? appState.pendingTrip.vendorId
        : appState.userId[0];
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

  manageIncomingTrip(BuildContext context, setState) async {
    preferences = await SharedPreferences.getInstance();
    String state = appState.pendingTrip.state;
    switch (state) {
      case 'requested':
        manageTrip(context, true, setState);
        break;
      case 'rejected':
        appState.pendingTrip = null;
        preferences.setString('pendingTripVendorId', null);
        preferences.setString('pendingTripVendorInfo', null);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular((10 / 678) * height)),
              title: Text(
                'Sorry, the vendor denied call',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: (14 / 678) * height,
                ),
              ),
            );
          },
        );
        appState.active = false;
        break;
    }
  }

  manageTrip(BuildContext context, bool isMessageSent, setState) async {
    setState(() => locating = true);
    controller.forward();
    if (preferences == null) {
      preferences = await SharedPreferences.getInstance();
    }
    if (!isMessageSent) {
      Trip trip = Trip(
        state: 'requested',
        vendorId: currVendorId,
      );
      appState.pendingTrip = trip;
      preferences.setString('pendingTripVendorId', currVendorId);
      preferences.setString(
        'pendingTripVendorInfo',
        jsonEncode(
          currentVendorInfo.toJson(),
        ),
      );
      //send message to vendor
      /*await messagingHelper.sendMessage(
        currVendorToken,
        appState.messagingToken,
        appState.userLocation,
        appState.clientName,
        appState.phoneNumber,
      );*/
    }
    appState.active = true;
    appState.messages = StreamController();
    bool gotReply = false;
    Future.delayed(
      Duration(seconds: 40),
      () {
        print('ran got reply $gotReply');
        if (!gotReply) {
          appState.messages.add(<String, dynamic>{
            'state': 'unanswered',
          });
        }
      },
    );
    var reply = await getReply(appState);
    gotReply = true;
    String state = reply['state'];
    switch (state) {
      case 'unanswered':
        appState.pendingTrip = null;
        preferences.setString('pendingTripVendorId', null);
        preferences.setString('pendingTripVendorInfo', null);
        await controller.reverse();
        setState(() => locating = false);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular((10 / 678) * height)),
              title: Text(
                'Sorry, the vendor didn\'t respond',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: (14 / 678) * height,
                ),
              ),
            );
          },
        );
        appState.active = false;
        break;
      case 'rejected':
        appState.pendingTrip = null;
        preferences.setString('pendingTripVendorId', null);
        preferences.setString('pendingTripVendorInfo', null);
        await controller.reverse();
        setState(() => locating = false);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular((10 / 678) * height)),
              title: Text(
                'Sorry, the vendor denied call',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: (14 / 678) * height,
                ),
              ),
            );
          },
        );
        appState.active = false;
        break;
      case 'hold':
        appState.pendingTrip.state = 'hold';
        appState.pendingTrip.eta = reply['eta'];
        await controller.reverse();
        setState(() => locating = false);
        //appState.active = true;
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
        await controller.reverse();
        setState(() => locating = false);
        //appState.active = true;
        Navigator.pushReplacement(
          context,
          FadeRoute(
            page: Map(
              directionApiHelper: directionApiHelper,
              appState: appState,
            ),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    if (!isIncomingTripManaged) {
      if (appState.pendingTrip != null) {
        print('setting post frame callback');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          manageIncomingTrip(context, setState);
        });
      }
    }
    isIncomingTripManaged = true;
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
            resizeToAvoidBottomInset: false,
            backgroundColor: Color(0xffE0E5EC),
            extendBodyBehindAppBar: true,
            //backgroundColor: Colors.white,
            //backgroundColor: Colors.amberAccent,
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              //physics: NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  Stack(
                    overflow: Overflow.visible,
                    children: <Widget>[
                      Container(
                        height: 1500,
                        width: width,
                        //margin: EdgeInsets.all(10.0),
                        child: PageView(
                          allowImplicitScrolling: false,
                          controller: pageController,
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          children: <Widget>[
                            HomePageUpdated(
                              appState: widget.appState,
                            ),
                            Stack(
                              children: <Widget>[
                                CarouselSlider.builder(
                                  itemCount: appState.userId.length,
                                  itemBuilder: (context, index) {
                                    String key = appState.userId[index];
                                    VendorInfo vendor = appState.vendors[key];
                                    return VendorInfoPage(
                                      vendor,
                                      widget.appState,
                                    );
                                  },
                                  options: CarouselOptions(
                                    autoPlay: false,
                                    enableInfiniteScroll: true,
                                    height: height * 0.94,
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
                                Align(
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: height * 0.9,
                                      ),
                                      SliderButton(
                                        width: width * 0.77,
                                        height: height * 0.08,
                                        child: Container(
                                          height: height * 0.077,
                                          width: height * 0.077,
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black,
                                                blurRadius: 4,
                                              ),
                                            ],
                                            color:
                                                Color.fromRGBO(35, 205, 99, 1),
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                          child: Neumorphic(
                                            style: NeumorphicStyle(
                                              boxShape:
                                                  NeumorphicBoxShape.roundRect(
                                                BorderRadius.circular(100),
                                              ),
                                              border: NeumorphicBorder(
                                                width: 0.5,
                                              ),
                                              shadowLightColor:
                                                  Colors.transparent,
                                              shape: NeumorphicShape.concave,
                                              color: Color.fromRGBO(
                                                  35, 205, 99, 1),
                                              depth: 20,
                                            ),
                                            child: Center(
                                              child: Container(
                                                child: SvgPicture.asset(
                                                  'assets/truck.svg',
                                                  height: 32.5,
                                                  width: 32.5,
                                                  color: Color.fromRGBO(
                                                      13, 47, 61, 1),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        vibrationFlag: false,
                                        action: () async {
                                          bool surity =
                                              await getSurity(context);
                                          if (surity) {
                                            Order order = currentVendorInfo
                                                .createOrder(appState);
                                            await appState.serviceHelper
                                                .createNewOrder(
                                                    order, currVendorId);
                                            //send message to client
                                            appState.messagingHelper
                                                .sendMessage(order);
                                          }
                                        },
                                        dismissible: false,
                                        buttonSize: height * 0.077,
                                        startPercent: 1,
                                        baseColor:
                                            Color.fromRGBO(13, 47, 61, 1),
                                        backgroundColor: Color(0xffE0E5EC),
                                        highlightedColor:
                                            Color.fromRGBO(35, 205, 99, 1),
                                        label: Text(
                                          "Slide to Request Vendor",
                                          style: TextStyle(
                                              fontFamily: 'Ubuntu',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: height,
                        width: width,
                        child: Column(
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
                                DualButton(
                                  height: (35 / 678) * height,
                                  width: width * 0.4,
                                  textSize: (12 / 678) * height,
                                  padding: (1 / 678) * height,
                                  radius: (80 / 678) * height,
                                  onDropInClicked: () {
                                    pageController.animateToPage(
                                      1,
                                      duration: Duration(milliseconds: 2000),
                                      curve: Curves.fastLinearToSlowEaseIn,
                                    );
                                  },
                                  onNowClicked: () async {
                                    await pageController.animateToPage(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      ScaleTransition(
                                        scale: animation,
                                        child: CircleAvatar(
                                          radius: (103 / 678) * height,
                                          backgroundColor:
                                              Color.fromRGBO(35, 205, 99, 1),
                                          child: CircleAvatar(
                                            radius: (100 / 678) * height,
                                            backgroundImage: AssetImage(
                                                'assets/locating_anim.gif'),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: (40 / 678) * height),
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
                  /*SizedBox(
                    height: 300,
                  ),*/
                ],
              ),
            ),
            floatingActionButton:
                widget.appState.order.purchasedVegetables.isNotEmpty
                    ? FloatingActionButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CartPage(appState: appState)));
                        },
                        backgroundColor: Colors.green,
                      )
                    : null,
          ),
        ),
        BillHistory(globalController, appState, preferences),
      ],
    );
  }
}

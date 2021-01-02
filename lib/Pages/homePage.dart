import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:frute/AppState.dart';
import 'package:frute/Pages/map.dart';
import 'package:frute/Pages/ProfilePage2/ProfilePage.dart';
import 'package:frute/helpers/directionApiHelper.dart';
import 'package:frute/helpers/messageGetters.dart';
import 'package:frute/helpers/messagingHelper.dart';
import 'package:frute/models/trip.dart';
import 'package:frute/models/vendorInfo.dart';
import 'package:frute/routes/fadeRoute.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frute/Pages/Homepage2/Homepage2.dart';
import 'package:frute/config/colors.dart';

import 'cartPage.dart';
import 'holdPage.dart';

import 'package:frute/Pages/billhistory.dart';

class HomePage extends StatefulWidget {
  final AppState appState;
  final int initialPage;
  final Function refreshVendors;

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
  bool isNowCurrentTab = false;
  final GlobalKey homePageUpdatedKey = GlobalKey();
  final GlobalKey cartPageKey = GlobalKey();
  double screenHeight = 1500;

  final navigationItems = [
    {
      'icon': Icons.home_outlined,
      'activeIcon': Icons.home_sharp,
      'label': "Home"
    },
    {
      'icon': Icons.shopping_cart_outlined,
      'activeIcon': Icons.shopping_cart_sharp,
      'label': "Cart"
    },
    {
      'icon': Icons.receipt_long_outlined,
      'activeIcon': Icons.receipt_long,
      'label': "Bills"
    },
    {
      'icon': Icons.account_circle_outlined,
      'activeIcon': Icons.account_circle_sharp,
      'label': "Profile"
    },
  ];

  int _selectedNavItem = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedNavItem = index;
    });
  }

  buildView(int index) {
    if (index == 0)
      return HomePage2(
        key: homePageUpdatedKey,
        onAddedToCart: () => setState(() {}),
        appState: widget.appState,
      );

    if (index == 1) return CartPage(appState: widget.appState);
    if (index == 2) return Center(child: Text("Bill page"));

    if (index == 3)
      return ProfilePage(
        controller: globalController,
        appState: widget.appState,
      );

    return Center(child: Text("Something went wrong"));
  }

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
    WidgetsBinding.instance.addPostFrameCallback((_) => updateScreenHeight());
  }

  updateScreenHeight() {
    RenderBox homePageBox =
        homePageUpdatedKey.currentContext.findRenderObject();
    Size size = homePageBox.size;
    print(size.height);
    setState(() => screenHeight = size.height);
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xffEAEAEA),
      extendBodyBehindAppBar: true,
      //backgroundColor: Colors.white,
      //backgroundColor: Colors.amberAccent,
      body: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          buildView(_selectedNavItem),
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
                      decoration:
                          BoxDecoration(color: Colors.black.withOpacity(0.9)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ScaleTransition(
                            scale: animation,
                            child: CircleAvatar(
                              radius: (103 / 678) * height,
                              backgroundColor: Color.fromRGBO(35, 205, 99, 1),
                              child: CircleAvatar(
                                radius: (100 / 678) * height,
                                backgroundImage:
                                    AssetImage('assets/locating_anim.gif'),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: (40 / 678) * height),
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
              : SizedBox(),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: navigationItems
              .map((navItem) => BottomNavigationBarItem(
                  icon: Icon(navItem[
                      navigationItems.indexOf(navItem) == _selectedNavItem
                          ? 'activeIcon'
                          : 'icon']),
                  label: navItem['label']))
              .toList(),
          currentIndex: _selectedNavItem,
          onTap: _onItemTapped,
          selectedItemColor: UdusColors.primaryColor,
          unselectedItemColor: Colors.black,
          showUnselectedLabels: true,
          selectedFontSize: 12,
          elevation: 0,
          iconSize: 22,
        ),
      ),
    );
  }
}

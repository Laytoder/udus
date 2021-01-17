import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:frute/AppState.dart';
import 'package:frute/Pages/ProfilePage2/ProfilePage.dart';
import 'package:frute/Pages/Homepage2/Homepage2.dart';
import 'package:frute/config/colors.dart';

import 'cartPage.dart';

import 'package:frute/Pages/BillPage2/billPage.dart';
import 'package:badges/badges.dart';
import 'package:frute/Pages/noNearbyVendorPage.dart';

class HomePage extends StatefulWidget {
  final AppState appState;
  final bool noNearbyVendor;

  HomePage(this.appState, {this.noNearbyVendor = false});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  AppState appState;
  double width, height;
  final GlobalKey homePageUpdatedKey = GlobalKey();
  final GlobalKey cartPageKey = GlobalKey();

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
    if (index == 0 && widget.noNearbyVendor)
      return NoNearbyVendorPage(widget.appState);

    if (index == 0)
      return HomePage2(
        key: homePageUpdatedKey,
        onAddedToCart: () => setState(() {}),
        appState: widget.appState,
      );

    if (index == 1) return CartPage(appState: widget.appState);
    if (index == 2) return BillPage(appState: widget.appState);

    if (index == 3)
      return ProfilePage(
        //controller: globalController,
        appState: widget.appState,
      );

    return Center(child: Text("Something went wrong"));
  }

  @override
  void initState() {
    super.initState();
    appState = widget.appState;
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xffEAEAEA),
        extendBodyBehindAppBar: true,
        //backgroundColor: Colors.white,
        //backgroundColor: Colors.amberAccent,
        body: buildView(_selectedNavItem),
        bottomNavigationBar: Container(
          color: Colors.white,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: navigationItems
                .map(
                  (navItem) => BottomNavigationBarItem(
                      icon: Badge(
                        showBadge: (appState.order.length > 0) &&
                            (navItem['label'] == 'Cart') &&
                            (_selectedNavItem != 1),
                        badgeColor: UdusColors.primaryColor,
                        badgeContent: Text(appState.order.length.toString()),
                        child: Icon(navItem[
                            navigationItems.indexOf(navItem) == _selectedNavItem
                                ? 'activeIcon'
                                : 'icon']),
                      ),
                      label: navItem['label']),
                )
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
      ),
    );
  }
}

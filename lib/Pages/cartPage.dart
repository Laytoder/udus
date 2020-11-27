import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:frute/Pages/cartScreen.dart';
import 'package:frute/helpers/confirmationDialog.dart';
import 'package:frute/helpers/optimalTripRouteFinder.dart';
import 'package:frute/models/tripRoute.dart';
import 'package:frute/Pages/optimalRoutesPage.dart';
import 'package:frute/models/vendorInfo.dart';
import 'package:frute/widgets/inputModal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../AppState.dart';

class CartPage extends StatefulWidget {
  AppState appState;

  CartPage({
    @required this.appState,
  });

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double height;

  double width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xffE0E5EC),
      appBar: AppBar(
        backgroundColor: Color(0xffE0E5EC),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          iconSize: 30.0,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Cart'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          (10 / 411) * width,
          (10 / 820) * height,
          (10 / 411) * width,
          (10 / 820) * height,
        ),
        child: SingleChildScrollView(
          child: Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.start,
            spacing: 5,
            runSpacing: 20,
            children: [
              Cart_Tiles(),
              Cart_Tiles(),
              Cart_Tiles(),
              Cart_Tiles(),
              Cart_Tiles(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (await getSurity(context)) {
            //use only a list vendors instead of hashmap in
            //homepage also
            //(it is technically not required
            //consumes space on the other can be removed)
            List<VendorInfo> vendors = [];
            for (String userId in widget.appState.userId) {
              vendors.add(widget.appState.vendors[userId]);
            }

            OptimalTripRoutesFinder finder = OptimalTripRoutesFinder(
              homeLocation: GeoPoint(
                widget.appState.userLocation.latitude,
                widget.appState.userLocation.longitude,
              ),
              order: widget.appState.order,
              vendors: vendors,
            );

            dynamic optimalRoute = await finder.getOptimalTripRoute();

            if (optimalRoute == OptimalTripRoutesFinder.NO_OPTIMAL_ORDER)
              print('NO OPTIMAL ORDER..................................');
            else {
              print(optimalRoute.toJson());

              print('computed route................................');
            }

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CartScreen(),
              ),
            );

            /*Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => OptimalRoutesPage(
                  appState: widget.appState,
                  optimalTripRoutes: optimalRoutes,
                ),
              ),
            );*/

            /*dynamic jsonOptimalRoutes = [];

            for (TripRoute optimalRoute in optimalRoutes) {
              jsonOptimalRoutes.add(optimalRoute.toJson()['duration']);
            }

            print(jsonOptimalRoutes);

            print('routed computed................................');*/
          }
          /*Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    OptimalRoutesPage(appState: widget.appState),
              ),
            );*/
        },
        child: Icon(Icons.shopping_bag_outlined),
      ),
    );
  }
}

class Cart_Tiles extends StatefulWidget {
  @override
  _Cart_TilesState createState() => _Cart_TilesState();
}

class _Cart_TilesState extends State<Cart_Tiles> {
  double height;

  double width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Neumorphic(
      style: NeumorphicStyle(
        shape: NeumorphicShape.concave,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
        depth: 8,
        lightSource: LightSource.topLeft,
        color: Color(0xffE0E5EC),
      ),
      child: Container(
        height: (180 / 820) * height,
        width: (190 / 411) * width,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: (100 / 820) * height,
                  width: (100 / 411) * width,
                  child: Neumorphic(
                    style: NeumorphicStyle(
                      depth: -4,
                    ),
                    child: Image.asset('assets/tomato.jpg'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: (10 / 411) * width),
                ),
                Text(
                  'Tomato',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: (10 / 820) * height),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('500 g'),
                Padding(
                  padding: EdgeInsets.only(left: (25 / 411) * width),
                ),
                Neumorphic(
                  child: IconButton(
                      icon: Icon(Icons.cancel_outlined), onPressed: () {}),
                ),
                Padding(
                  padding: EdgeInsets.only(left: (10 / 411) * width),
                ),
                Neumorphic(
                  child: IconButton(
                    icon: Icon(Icons.edit_outlined),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('Select your Quantity'),
                          actions: [
                            TextButton(
                              child: Text(
                                'CONFIRM',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 16,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                          content: Wrap(
                            direction: Axis.horizontal,
                            alignment: WrapAlignment.start,
                            spacing: 10,
                            runSpacing: 20,
                            children: [
                              QuantityDialog(),
                              QuantityDialog(),
                              QuantityDialog(),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class QuantityDialog extends StatefulWidget {
  @override
  _QuantityDialogState createState() => _QuantityDialogState();
}

class _QuantityDialogState extends State<QuantityDialog> {
  double height;

  double width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Container(
      child: Neumorphic(
        style: NeumorphicStyle(
          shape: NeumorphicShape.convex,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
          depth: 8,
          lightSource: LightSource.topLeft,
          color: Color(0xffE0E5EC),
        ),
        child: Container(
          height: (50 / 820) * height,
          width: (60 / 411) * width,
          child: Center(
            child: Text('250 g'),
          ),
        ),
      ),
    );
  }
}

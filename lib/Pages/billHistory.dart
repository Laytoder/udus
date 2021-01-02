import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:frute/AppState.dart';
import 'package:frute/Pages/billPage.dart';
import 'package:frute/assets/my_flutter_app_icons.dart';
import 'package:frute/models/bill.dart';
import 'package:frute/models/vegetable.dart';
import 'package:frute/widgets/pageHeading.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BillHistory extends StatefulWidget {
  final PageController controller;
  final AppState appState;
  final SharedPreferences preferences;

  BillHistory(this.controller, this.appState, this.preferences);

  @override
  _BillHistoryState createState() => _BillHistoryState();
}

class _BillHistoryState extends State<BillHistory> {
  List<Vegetable> purchasedVegetables = [];
  double total = 0.0, height, width;
  String date = '';
  PageController controller = PageController();

  Future<List<dynamic>> fetchBills() async {
    print('fetching bills');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<dynamic> jsonbills = preferences.getStringList('bills');
    print('this is jsonbills $jsonbills');
    List<dynamic> bills = [];
    /*print('this is pending trip ${widget.appState.pendingTrip}');
    if (widget.appState.pendingTrip != null) {
      print('pendingTrip is not null');
      bills.add(widget.appState.pendingTrip);
    }*/
    if (jsonbills != null) {
      for (dynamic jsonbill in jsonbills) {
        bills.add(Bill.fromJson(jsonDecode(jsonbill)));
      }
    }
    print('this is bills $bills');
    return bills;
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return PageView(
      allowImplicitScrolling: false,
      onPageChanged: (i) {
        if (i == 1) {
          setState(() {});
        }
      },
      physics: NeverScrollableScrollPhysics(),
      controller: controller,
      children: <Widget>[
        WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            backgroundColor: Color(0xffE0E5EC),
            body: Column(
              children: <Widget>[
                SizedBox(
                  height: (40 / 678) * height,
                ),
                Stack(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(),
                        ),
                        IconButton(
                          /*icon: Container(
                            child: SvgPicture.asset(
                              'assets/bill.svg',
                              height: (100 / 678) * height,
                              width: (100 / 678) * height,
                              color: Color(0xff25d366),
                            ),
                          ),*/
                          icon: NeumorphicIcon(
                            Icons.shopping_basket,
                            style: NeumorphicStyle(
                              shape: NeumorphicShape.convex,
                              //depth: 30,
                              depth: 3,
                              lightSource: LightSource.topLeft,
                              //shadowLightColor: Color(0xffF6F7FA),
                              //shadowDarkColor: Colors.transparent,
                              intensity: 0.68,
                              border: NeumorphicBorder(
                                color: Colors.white,
                                width: 0.5,
                              ),
                              shadowDarkColor: Color(0xffA3B1C6),
                              shadowLightColor: Colors.white,
                              color: Color.fromRGBO(35, 205, 99, 1.0),
                            ),
                            size: (40 / 678) * height,
                          ),
                          onPressed: null,
                        ),
                        Expanded(
                          child: Container(),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: (10 / 360) * width,
                        ),
                        IconButton(
                          /*icon: Container(
                            child: SvgPicture.asset(
                              'assets/home.svg',
                              height: (25 / 678) * height,
                              width: (25 / 678) * height,
                              color: Color(0xff58f8f8f),
                            ),
                          ),*/
                          icon: NeumorphicIcon(
                            MyFlutterApp.home,
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
                            size: 26,
                          ),
                          onPressed: () {
                            widget.controller.animateToPage(
                              1,
                              duration: Duration(milliseconds: 1000),
                              curve: Curves.fastLinearToSlowEaseIn,
                            );
                          },
                        ),
                      ],
                    )
                  ],
                ),
                PageHeading('Bills'),
                Expanded(
                  child: FutureBuilder(
                    future: fetchBills(),
                    builder: (context, snapshot) {
                      print(snapshot.data);
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.data == null ||
                            snapshot.data.length == 0) {
                          return Center(
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Container(),
                                ),
                                Container(
                                  child: Image(
                                    image: AssetImage('assets/nobill.png'),
                                    height: 200,
                                    width: 200,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 30,
                                  ),
                                  child: Text(
                                    'No Bills On Record!',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Color(0xff8c8c8c),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 7,
                                  child: Container(),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return Neumorphic(
                                margin: EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  bottom: 20,
                                ),
                                style: NeumorphicStyle(
                                  boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.circular(15),
                                  ),
                                  color: Color(0xffE0E5EC),
                                  depth: 3,
                                  border: NeumorphicBorder(
                                    color: Colors.white,
                                    width: 0.5,
                                  ),
                                  shape: NeumorphicShape.flat,
                                ),
                                child: Container(
                                  //elevation: 5.0,
                                  /*margin: EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                    bottom: 20,
                                  ),*/
                                  /*shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),*/
                                  color: Color(0xffE0E5EC),
                                  child: ListTile(
                                    title: Text(
                                      'Total : \u20B9${snapshot.data[index].total}',
                                      style: TextStyle(
                                        fontFamily: 'Ubuntu',
                                        fontSize: (16 / 678) * height,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Date : ' +
                                          DateFormat('dd-MM-yyyy')
                                              .format(snapshot.data[index].date)
                                              .toString(),
                                      style: TextStyle(
                                        fontFamily: 'Ubuntu',
                                        fontWeight: FontWeight.w400,
                                        fontSize: (14 / 678) * height,
                                      ),
                                    ),
                                    /*trailing: FloatingActionButton(
                                      heroTag: null,
                                      onPressed: () {
                                        purchasedVegetables = snapshot
                                            .data[index].purchasedVegetables;
                                        total = snapshot.data[index].total;
                                        print(purchasedVegetables[0].name);
                                        date = DateFormat('yyyy-MM-dd')
                                            .format(snapshot.data[index].date)
                                            .toString();
                                        controller.animateToPage(
                                          1,
                                          duration:
                                              Duration(milliseconds: 1000),
                                          curve: Curves.fastLinearToSlowEaseIn,
                                        );
                                      },
                                      child: Icon(
                                        Icons.arrow_forward,
                                        size: (24 / 678) * height,
                                      ),
                                      elevation: 0,
                                    ),*/
                                    trailing: GestureDetector(
                                      child: Neumorphic(
                                        style: NeumorphicStyle(
                                          boxShape: NeumorphicBoxShape.circle(),
                                          shape: NeumorphicShape.flat,
                                          depth: 3,
                                          /*border: NeumorphicBorder(
                                          color: Colors.white,
                                          width: 0.2,
                                        ),*/
                                          color: Color(0xffE0E5EC),
                                        ),
                                        child: Container(
                                          height: (50 / 678) * height,
                                          width: (50 / 678) * height,
                                          child: Icon(
                                            Icons.arrow_forward,
                                            color: Color.fromRGBO(
                                                35, 205, 99, 1.0),
                                            size: (24 / 678) * height,
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        purchasedVegetables = snapshot
                                            .data[index].purchasedVegetables;
                                        total = snapshot.data[index].total;
                                        print(purchasedVegetables[0].name);
                                        date = DateFormat('dd-MM-yyyy')
                                            .format(snapshot.data[index].date)
                                            .toString();
                                        controller.animateToPage(
                                          1,
                                          duration:
                                              Duration(milliseconds: 1000),
                                          curve: Curves.fastLinearToSlowEaseIn,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        BillPage(
          state: 'View',
          vegetables: purchasedVegetables,
          total: total,
          date: date,
          appState: widget.appState,
          controller: controller,
        ),
      ],
    );
  }
}

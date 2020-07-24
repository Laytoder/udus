import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frute/AppState.dart';
import 'package:frute/Pages/billPage.dart';
import 'package:frute/Pages/holdPage.dart';
import 'package:frute/helpers/directionApiHelper.dart';
import 'package:frute/models/bill.dart';
import 'package:frute/models/trip.dart';
import 'package:frute/models/vegetable.dart';
import 'package:frute/widgets/pageHeading.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:frute/Pages/map.dart' as map;

class BillHistory extends StatefulWidget {
  PageController controller;
  AppState appState;
  SharedPreferences preferences;
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
                          icon: Container(
                            child: SvgPicture.asset(
                              'assets/bill.svg',
                              height: (100 / 678) * height,
                              width: (100 / 678) * height,
                              color: Color(0xff25d366),
                            ),
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
                          icon: Container(
                            child: SvgPicture.asset(
                              'assets/home.svg',
                              height: (25 / 678) * height,
                              width: (25 / 678) * height,
                              color: Color(0xff58f8f8f),
                            ),
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
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.data == null ||
                            snapshot.data.length == 0) {
                          return Center(
                            child: Text(
                              'No Bills in History',
                              style: TextStyle(
                                fontFamily: 'Ubuntu',
                                fontSize: (14 / 678) * height,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          );
                        } else {
                          return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              /*if (index == 0 && (snapshot.data[0] is Trip)) {
                                return Card(
                                  //elevation: 5.0,
                                  margin: EdgeInsets.only(
                                    left: (10 / 360) * width,
                                    right: (10 / 360) * width,
                                    bottom: (20 / 678) * height,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        (15 / 678) * height),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      'Pending Trip',
                                      style: TextStyle(
                                        fontFamily: 'Ubuntu',
                                        fontSize: (14 / 678) * height,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    trailing: FloatingActionButton(
                                      heroTag: null,
                                      onPressed: () {
                                        String state = snapshot.data[0].state;
                                        switch (state) {
                                          case 'hold':
                                            String eta = snapshot.data[0].eta;
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => HoldPage(
                                                    eta: eta,
                                                    vendorName: 'Ramu Kaka',
                                                    appState: widget.appState,
                                                    preferences:
                                                        widget.preferences),
                                              ),
                                            );
                                            break;

                                          case 'ongoing':
                                            GeoCoord origin =
                                                snapshot.data[0].origin;
                                            GeoCoord destination =
                                                snapshot.data[0].destination;
                                            if (snapshot.data[0]
                                                    .directionApiHelper ==
                                                null) {
                                              DirectionApiHelper
                                                  directionApiHelper =
                                                  DirectionApiHelper();
                                              directionApiHelper.populateData(
                                                  origin, destination);
                                              snapshot.data[0]
                                                      .directionApiHelper =
                                                  directionApiHelper;
                                              widget.preferences.setString(
                                                  'directionsApiHelper',
                                                  jsonEncode(directionApiHelper
                                                      .toJson()));
                                            }
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => map.Map(
                                                  appState: widget.appState,
                                                  directionApiHelper: snapshot
                                                      .data[0]
                                                      .directionApiHelper,
                                                ),
                                              ),
                                            );
                                            break;

                                          case 'verification':
                                            Bill bill = snapshot
                                                .data[0].verificationBill;
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => BillPage(
                                                  state: 'Verification',
                                                  total: bill.total,
                                                  vegetables:
                                                      bill.purchasedVegetables,
                                                  //date: bill.date,
                                                  appState: widget.appState,
                                                ),
                                              ),
                                            );
                                            break;
                                        }
                                      },
                                      child: Icon(
                                        Icons.arrow_forward,
                                        size: (24 / 678) * height,
                                      ),
                                      elevation: 0,
                                    ),
                                  ),
                                );
                              } else*/
                                return Card(
                                  //elevation: 5.0,
                                  margin: EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                    bottom: 20,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      'Total : ${snapshot.data[index].total}',
                                      style: TextStyle(
                                        fontFamily: 'Ubuntu',
                                        fontSize: (16 / 678) * height,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Date : ' +
                                          DateFormat('yyyy-MM-dd')
                                              .format(snapshot.data[index].date)
                                              .toString(),
                                      style: TextStyle(
                                        fontFamily: 'Ubuntu',
                                        fontWeight: FontWeight.w400,
                                        fontSize: (14 / 678) * height,
                                      ),
                                    ),
                                    trailing: FloatingActionButton(
                                      heroTag: null,
                                      onPressed: () {
                                        /*setState(() {
                                      purchasedVegetables = snapshot
                                          .data[index].purchasedVegetables;
                                      total = snapshot.data[index].total;
                                      date = DateFormat('yyyy-MM-dd')
                                          .format(snapshot.data[index].date)
                                          .toString();
                                    });*/
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

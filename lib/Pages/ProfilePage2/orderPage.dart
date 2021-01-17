import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frute/AppState.dart';
import 'package:frute/models/bill.dart';
import 'package:frute/models/vegetable.dart';

import 'package:frute/widgets/PageHeading.dart';
import 'package:frute/config/borderRadius.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderPage extends StatefulWidget {
  AppState appState;

  OrderPage({
    Key key,
    @required this.appState,
  }) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  double height;

  double width;

  Future<List<dynamic>> fetchBills() async {
    print('fetching bills');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<dynamic> jsonbills = preferences.getStringList('bills');
    print('this is jsonbills $jsonbills');
    List<dynamic> bills = [];
    if (jsonbills != null) {
      for (dynamic jsonbill in jsonbills) {
        bills.add(Bill.fromJson(jsonDecode(jsonbill)));
      }
    }
    print('this is bills $bills');
    return bills;
  }

  Widget buildBillBody(double height) {
    return FutureBuilder(
      future: fetchBills(),
      builder: (context, snapshot) {
        print(snapshot.data);
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == null || snapshot.data.length == 0) {
            return Center(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: height * 0.1,
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
                      'No Current Orders!',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xff8c8c8c),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return Container(
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
                    trailing: GestureDetector(
                      child: Container(
                        height: (50 / 678) * height,
                        width: (50 / 678) * height,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Color.fromRGBO(35, 205, 99, 1.0),
                          size: (24 / 678) * height,
                        ),
                      ),
                      onTap: () {},
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
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  PageHeading("Orders"),
                  buildBillBody(height),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 8,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

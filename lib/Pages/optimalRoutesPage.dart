import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../AppState.dart';
import 'package:frute/models/tripRoute.dart';
import 'package:frute/widgets/MinimalPageHeading.dart';
import 'package:slider_button/slider_button.dart';
import 'package:frute/config/borderRadius.dart';

class OptimalRoutesPage extends StatefulWidget {
  TripRoute optimalTripRoute;

  OptimalRoutesPage({
    @required this.optimalTripRoute,
  });

  @override
  _OptimalRoutesPage createState() => _OptimalRoutesPage();
}

class _OptimalRoutesPage extends State<OptimalRoutesPage> {
  double bottomSheetHeight = 100;

  Widget buildOptimalRoutesPageBody(double height, double width) {
    return Expanded(
      //width: width,
      //height: height - 317,
      child: ListView.separated(
        separatorBuilder: (context, index) => Divider(),
        itemCount: widget.optimalTripRoute.orderList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(
                widget.optimalTripRoute.orderList[index].imageUrl,
              ),
              radius: 25,
            ),
            title: Text(
              widget.optimalTripRoute.orderList[index].name,
              style: TextStyle(
                color: Colors.black,
                //fontSize: 20,
                fontFamily: 'Ubuntu',
              ),
            ),
            subtitle: Text(
              '${widget.optimalTripRoute.orderList[index].dispPrice} * ${widget.optimalTripRoute.orderList[index].dispQuantity} = ₹${widget.optimalTripRoute.orderList[index].price}',
              style: TextStyle(
                //fontWeight: FontWeight.bold,
                //fontSize: 15,
                fontFamily: 'Ubuntu',
              ),
            ),
            trailing: Text(
              '₹${widget.optimalTripRoute.orderList[index].price}',
              style: TextStyle(
                //fontWeight: FontWeight.bold,
                //fontSize: 20,
                fontFamily: 'Ubuntu',
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: width,
                  height: 80,
                  margin: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: UdusBorderRadius.small,
                  ),
                  child: Center(
                    /*padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 40),*/
                    child: Text(
                      'Your Bill',
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                buildOptimalRoutesPageBody(height, width),
                Container(
                  //height: 203,
                  //width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Product Cost',
                              style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: 'Ubuntu',
                              ),
                            ),
                            Text(
                              '₹${widget.optimalTripRoute.price}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                                fontFamily: 'Ubuntu',
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Delivery Cost',
                              style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: 'Ubuntu',
                              ),
                            ),
                            Text(
                              '\₹20',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                                fontFamily: 'Ubuntu',
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          height: 1.5,
                          color: Colors.grey[600],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Cost',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Ubuntu',
                              ),
                            ),
                            Text(
                              '₹${widget.optimalTripRoute.price + 20}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Ubuntu',
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SliderButton(
                          //width: width * 0.9,
                          //height: height * 0.08,
                          width: 360 * 0.9,
                          height: 678 * 0.08,
                          child: Container(
                            //height: height * 0.0764,
                            //width: height * 0.13,
                            height: 678 * 0.0764,
                            width: 678 * 0.13,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 4,
                                ),
                              ],
                              color: Color.fromRGBO(35, 205, 99, 1),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Neumorphic(
                              style: NeumorphicStyle(
                                boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(100),
                                ),
                                border: NeumorphicBorder(
                                  width: 0.5,
                                ),
                                shadowLightColor: Colors.transparent,
                                shape: NeumorphicShape.concave,
                                color: Color.fromRGBO(35, 205, 99, 1),
                                depth: 20,
                              ),
                              child: Center(
                                child: Container(
                                  /*child: SvgPicture.asset(
                          'assets/truck.svg',
                          height: 32.5,
                          width: 32.5,
                          color: Color.fromRGBO(13, 47, 61, 1),
                        ),*/
                                  child: Icon(
                                    Icons.check,
                                    size: 32.5,
                                    color: Color.fromRGBO(13, 47, 61, 1),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          vibrationFlag: false,
                          action: () async {
                            /*bool surity = await getSurity(context);
                  if (surity) {
                    Order order = currentVendorInfo.createOrder(appState);
                    await appState.serviceHelper
                        .createNewOrder(order, currVendorId);
                    //send message to client
                    appState.messagingHelper.sendMessage(order);
                  }*/
                          },
                          dismissible: false,
                          //buttonSize: height * 0.077,
                          buttonSize: 678 * 0.077,
                          startPercent: 1,
                          baseColor: Color.fromRGBO(13, 47, 61, 1),
                          backgroundColor: Colors.grey[100],
                          highlightedColor: Color.fromRGBO(35, 205, 99, 1),
                          label: Text(
                            "Slide to Confirm Order",
                            style: TextStyle(
                              fontFamily: 'Ubuntu',
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 16.0, left: 30),
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  iconSize: 28,
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          )
        ],
      ),
      //bottomSheet: ,
    );
  }
}

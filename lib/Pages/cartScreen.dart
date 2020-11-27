import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:slider_button/slider_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frute/widgets/pageHeading.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double height, width;

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
        /*title: Text(
          'Your Bill',
          style: TextStyle(
            color: Colors.grey[600],
            //fontWeight: FontWeight.bold,
            fontSize: 24.0,
            fontFamily: 'Ubuntu',
          ),
        ),*/
        title: PageHeading('Your Bill'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          /*if (index < currentUser.cart.length) {
            Cart cart = currentUser.cart[index];
            return _buildCartItem(cart);
          }
          return SizedBox(
            height: 300.0,
          );
        },
        itemCount: currentUser.cart.length + 1,*/
          return ListTile(
            leading: Neumorphic(
              style: NeumorphicStyle(
                shape: NeumorphicShape.convex,
                depth: 1,
                lightSource: LightSource.topLeft,
                intensity: 0.68,
                border: NeumorphicBorder(
                  color: Colors.white,
                  width: (0.5 / 360) * width,
                ),
                shadowDarkColor: Color(0xffA3B1C6),
                shadowLightColor: Colors.white,
                color: Color(0xffAFBBCA),
              ),
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/potato.jpg'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            title: Text(
              'hello',
              style: TextStyle(
                color: Colors.black,
                fontSize: (20 / 678) * height,
                fontFamily: 'Ubuntu',
              ),
            ),
            subtitle: Text(
              'hello',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: (15 / 678) * height,
                fontFamily: 'Ubuntu',
              ),
            ),
            trailing: Text(
              'hello',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: (20 / 678) * height,
                fontFamily: 'Ubuntu',
              ),
            ),
          );
        },
      ),
      bottomSheet: Container(
        height: 240.0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xffE0E5EC),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.0),
            topRight: Radius.circular(40.0),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black26, offset: Offset(0, -1), blurRadius: 20.0)
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Product Cost',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Ubuntu',
                    ),
                  ),
                  Text(
                    'hello',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
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
                      fontSize: 20.0,
                      fontFamily: 'Ubuntu',
                    ),
                  ),
                  Text(
                    '\$20',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
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
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Ubuntu',
                    ),
                  ),
                  Text(
                    'hello',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30.0,
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
                //width: width * 0.77,
                //height: height * 0.08,
                width: width * 0.9,
                height: height * 0.08,
                child: Container(
                  height: height * 0.0764,
                  width: height * 0.13,
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
                buttonSize: height * 0.077,
                startPercent: 1,
                baseColor: Color.fromRGBO(13, 47, 61, 1),
                backgroundColor: Color(0xffE0E5EC),
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
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:frute/AppState.dart';
import 'package:frute/Pages/billPage.dart';
import 'package:frute/helpers/messageGetters.dart';
import 'package:frute/models/bill.dart';
import 'package:frute/models/vegetable.dart';
import 'package:frute/models/vendorInfo.dart';
import 'package:frute/widgets/neumorphicCurvePath.dart';

class VendorPage extends StatefulWidget {
  VendorInfo vendor;
  AppState appState;

  VendorPage(this.vendor, this.appState);
  @override
  _VendorPageState createState() => _VendorPageState();
}

class _VendorPageState extends State<VendorPage> {
  double height;

  double width;

  waitForReplyAndLaunch(BuildContext context) async {
    widget.appState.messages = StreamController();
    var messageMap = await getReply(widget.appState);
    List<dynamic> jsonVegetables = messageMap['purchasedVegetables'];
    List<Vegetable> purchasedVegetables = [];
    for (dynamic jsonVegetable in jsonVegetables) {
      Vegetable vegetable = Vegetable.fromJson(jsonVegetable);
      purchasedVegetables.add(vegetable);
    }
    double total = messageMap['total'];
    widget.appState.pendingTrip.state = 'verification';
    widget.appState.pendingTrip.verificationBill =
        Bill(purchasedVegetables, total, DateTime.now());
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BillPage(
          state: 'Verification',
          vegetables: purchasedVegetables,
          total: total,
          appState: widget.appState,
        ),
      ),
    );
  }

  selectImageType(String link) {
    if (link.startsWith('https'))
      return NetworkImage(link);
    else
      return AssetImage(link);
  }

  @override
  Widget build(BuildContext context) {
    waitForReplyAndLaunch(context);
    height = MediaQuery.of(context).size.height;
    print(height);
    width = MediaQuery.of(context).size.width;
    print(width);
    return Scaffold(
      backgroundColor: Color(0xffE0E5EC),
      body: Container(
        height: (700 / 667) * height,
        width: (700 / 375) * width,
        child: Padding(
          padding: EdgeInsets.only(
              top: (0 / 667) * height,
              bottom: (0 / 667) * height,
              right: (0 / 375) * width,
              left: (0 / 375) * width),
          child: Neumorphic(
            /*child: ListView(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  shadowColor: Colors.transparent,
                  child: ClipPath(
                    clipper: WaveClipperTwo(flip: true),
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/BG.png'))),
                      height: 250,
                      //color: Colors.white54,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                                bottom: (40 / 667),
                              ) *
                              height,
                          child: CircleAvatar(
                            child: Padding(
                              padding: const EdgeInsets.only(top: (140 / 667)) *
                                  height,
                              child: Text(
                                widget.vendor.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      ((20 / (667.0 * 375))) * height * width,
                                ),
                              ),
                            ),
                            radius: ((80 / (667.0 * 375))) * height * width,
                            backgroundImage: NetworkImage(
                              widget.vendor.imageUrl,
                            ),
                            backgroundColor: Colors.green,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: (10 / 667) * height,
                      bottom: (10 / 667) * height,
                      right: (10 / 375) * width,
                      left: (10 / 375) * width),
                  child: Neumorphic(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: (10 / 667) * height,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: ((30 / (667.0 * 375))) * height * width,
                          backgroundImage: NetworkImage(
                              'https://pngdrive.com/wp-content/uploads/edd/2019/07/Tomato-1.40-MB-2683-x-3000.jpg'),
                          backgroundColor: Colors.transparent,
                        ),
                        title: Text('Tomato'),
                        trailing: Text('₹35/Kg'),
                        subtitle: Text('Avl Qty: 55 Kg'),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: (10 / 667) * height,
                      bottom: (10 / 667) * height,
                      right: (10 / 375) * width,
                      left: (10 / 375) * width),
                  child: Neumorphic(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: (10 / 667) * height,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: ((30 / (667.0 * 375))) * height * width,
                          backgroundImage: NetworkImage(
                              'https://pngdrive.com/wp-content/uploads/edd/2019/07/Tomato-1.40-MB-2683-x-3000.jpg'),
                          backgroundColor: Colors.transparent,
                        ),
                        title: Text('Tomato'),
                        trailing: Text('₹35/Kg'),
                        subtitle: Text('Avl Qty: 55 Kg'),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: (10 / 667) * height,
                      bottom: (10 / 667) * height,
                      right: (10 / 375) * width,
                      left: (10 / 375) * width),
                  child: Neumorphic(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: (10 / 667) * height,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: ((30 / (667.0 * 375))) * height * width,
                          backgroundImage: NetworkImage(
                              'https://pngdrive.com/wp-content/uploads/edd/2019/07/Tomato-1.40-MB-2683-x-3000.jpg'),
                          backgroundColor: Colors.transparent,
                        ),
                        title: Text('Tomato'),
                        trailing: Text('₹35/Kg'),
                        subtitle: Text('Avl Qty: 55 Kg'),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: (10 / 667) * height,
                      bottom: (10 / 667) * height,
                      right: (10 / 375) * width,
                      left: (10 / 375) * width),
                  child: Neumorphic(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: (10 / 667) * height,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: ((30 / (667.0 * 375))) * height * width,
                          backgroundImage: NetworkImage(
                              'https://pngdrive.com/wp-content/uploads/edd/2019/07/Tomato-1.40-MB-2683-x-3000.jpg'),
                          backgroundColor: Colors.transparent,
                        ),
                        title: Text('Tomato'),
                        trailing: Text('₹35/Kg'),
                        subtitle: Text('Avl Qty: 55 Kg'),
                      ),
                    ),
                  ),
                ),
              ],
            ),*/
            child: ListView.builder(
              itemCount: (widget.vendor.vegetables.length + 1),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: 50,
                    ),
                    child: Column(
                      children: <Widget>[
                        Material(
                          //color: Colors.transparent,
                          shadowColor: Colors.black,
                          color: Color(0xffE0E5EC),
                          child: Neumorphic(
                            style: NeumorphicStyle(
                              boxShape: NeumorphicBoxShape.path(
                                NeumorphicCurvePath(),
                              ),
                              border: NeumorphicBorder(
                                color: Colors.white,
                                width: 2,
                              ),
                              depth: 8,
                              shape: NeumorphicShape.convex,
                            ),
                            child: ClipPath(
                              clipper: OvalBottomBorderClipper(),
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      'assets/BG.png',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                height: (150 / 667) * height,
                                //color: Colors.white54,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                          bottom: (40 / 667),
                                        ) *
                                        height,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 20,
                                        ),
                                        CircleAvatar(
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                      top: (140 / 667)) *
                                                  height),
                                          radius: ((50 / (667.0 * 375))) *
                                              height *
                                              width,
                                          backgroundImage: NetworkImage(
                                            widget.vendor.imageUrl,
                                          ),
                                          backgroundColor: Colors.green,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: (20 / 678) * height,
                        ),
                        Text(
                          'Choose from ${widget.vendor.name}\'s Catalogue',
                          style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Padding(
                    padding: EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                      right: 10,
                      left: 10,
                    ),
                    child: Neumorphic(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: selectImageType(
                                widget.vendor.vegetables[index - 1].imageUrl),
                            backgroundColor: Colors.transparent,
                          ),
                          title: Text(widget.vendor.vegetables[index - 1].name),
                          trailing: Text(
                            '\u20B9' +
                                widget.vendor.vegetables[index - 1].price
                                    .toString() +
                                '/kg',
                          ),
                          subtitle: Text(
                            'Avl Qty : ' +
                                widget.vendor.vegetables[index - 1].quantity
                                    .toString() +
                                'kg',
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

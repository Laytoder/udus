import 'package:flutter/material.dart';
import 'package:frute/AppState.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:frute/Pages/vendorInfoPage.dart';
import 'package:frute/helpers/directionApiHelper.dart';
import 'package:frute/helpers/messagingHelper.dart';
import 'package:frute/models/vendorInfo.dart';
import 'package:frute/widgets/dualButton.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:frute/Pages/map.dart';

class HomePage extends StatefulWidget {
  AppState appState;
  HomePage(this.appState);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AppState appState;
  String currVendorToken, currVendorId;
  MessagingHelper messagingHelper = MessagingHelper();
  DirectionApiHelper directionApiHelper = DirectionApiHelper();
  @override
  void initState() {
    super.initState();
    appState = widget.appState;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.dashboard),
                onPressed: null,
              ),
              Expanded(
                child: Container(),
              ),
              DualButton(),
              Expanded(
                child: Container(),
              ),
              IconButton(
                icon: Icon(Icons.kitchen),
                onPressed: null,
              ),
            ],
          ),
          CarouselSlider.builder(
            itemCount: appState.userId.length,
            itemBuilder: (context, index) {
              String key = appState.userId[index];
              VendorInfo vendor = appState.verdors[key];
              currVendorToken = vendor.token;
              currVendorId = key;
              print('check if token changed $currVendorToken');
              return VendorInfoPage(vendor);
            },
            options: CarouselOptions(
              autoPlay: false,
              enableInfiniteScroll: true,
              height: MediaQuery.of(context).size.height * 0.6,
              enlargeCenterPage: true,
            ),
          ),
          RaisedButton(
            child: Text(
              'Submit',
              style: TextStyle(color: Colors.amber, fontSize: 20),
            ),
            color: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            onPressed: () async {
              //send message to vendor
              await messagingHelper.sendMessage(currVendorToken, appState.messagingToken,
                  appState.userLocation, appState.clientName);
              dynamic reply = await messagingHelper.getReply();
              print(reply);
              if (reply == '') {
                print('vendor denied call');
              } else {
                print(reply);
                print(reply['lon']);
                print(reply['lat']);
                //get the path using google maps api
                GeoCoord destination = widget.appState.userLocation;
                GeoCoord origin = GeoCoord(reply['lat'], reply['lon']);
                await directionApiHelper.populateData(origin, destination);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Map(
                        directionApiHelper, currVendorId, messagingHelper, appState),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

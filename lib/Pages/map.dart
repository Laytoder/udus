import 'dart:async';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frute/AppState.dart';
import 'package:frute/Pages/billPage.dart';
import 'package:frute/Pages/homePage.dart';
import 'package:frute/helpers/messagingHelper.dart';
import 'package:frute/helpers/nearbyVendorQueryHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frute/helpers/directionApiHelper.dart';
import 'package:frute/models/bill.dart';
import 'package:frute/models/vegetable.dart';
import 'package:frute/models/vendorInfo.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as Math;
import 'package:angles/angles.dart';
import 'package:frute/helpers/pidHelper.dart';
import 'package:frute/helpers/messageGetters.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class Map extends StatefulWidget {
  DirectionApiHelper directionApiHelper;
  AppState appState;
  Map({
    @required this.directionApiHelper,
    @required this.appState,
  });
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> with SingleTickerProviderStateMixin {
  GoogleMapController _controller;
  MessagingHelper messagingHelper = MessagingHelper();
  String vendorId;
  Uint8List markerImg;
  Marker marker;
  LatLng currentPos;
  static AnimationController carController;
  List<LatLng> polyLineList;
  static Duration interval;
  StreamSubscription locationSubscription;
  NearbyVendorQueryHelper vendorQueryHelper = NearbyVendorQueryHelper();
  PIDHelper pidHelper;
  bool carAnimStarted = false;
  VendorInfo currentVendor;
  double width, height;

  intitMarkerImg() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load('assets/car_icon.png');
    markerImg = byteData.buffer.asUint8List();
  }

  getInitialDistance() {
    int dist = widget.directionApiHelper.distance.value;
    String dispDist;
    if (dist < 1000) {
      dispDist = '$dist meters';
    } else {
      dist = (dist / 1000).round();
      dispDist = '$dist km';
    }
    return dispDist;
  }

  getInitialETA() {
    int eta = widget.directionApiHelper.duration.value;
    String dispEta;
    if (eta < 60) {
      dispEta = '$eta secs';
    } else {
      eta = (eta / 60).round();
      dispEta = '$eta mins';
    }
    return dispEta;
  }

  updateMarkerImg(LatLng newPos) {
    setState(() {
      marker = Marker(
        markerId: MarkerId('erickshaw'),
        position: newPos,
        rotation: getBearing(currentPos, newPos),
        draggable: false,
        flat: true,
        anchor: Offset(0.5, 0.5),
        icon: BitmapDescriptor.fromBytes(markerImg),
      );
      currentPos = newPos;
    });
  }

  double getBearing(LatLng begin, LatLng end) {
    double lat = (begin.latitude - end.latitude).abs();
    double lng = (begin.longitude - end.longitude).abs();

    if (begin.latitude < end.latitude && begin.longitude < end.longitude)
      return (Angle.fromRadians(Math.atan(lng / lat)).degrees);
    else if (begin.latitude >= end.latitude && begin.longitude < end.longitude)
      return ((90 - Angle.fromRadians(Math.atan(lng / lat)).degrees) + 90);
    else if (begin.latitude >= end.latitude && begin.longitude >= end.longitude)
      return (Angle.fromRadians(Math.atan(lng / lat)).degrees + 180);
    else if (begin.latitude < end.latitude && begin.longitude >= end.longitude)
      return ((90 - Angle.fromRadians(Math.atan(lng / lat)).degrees) + 270);
    return -1;
  }

  startCarAnim(LatLng startPos) async {
    carAnimStarted = true;
    locationSubscription.resume();
    await intitMarkerImg();
    int index, next;
    int startIndex = pidHelper.getStartIndex(startPos);
    currentPos = polyLineList[startIndex];

    index = startIndex;
    next = startIndex + 1;

    LatLng startPosition = polyLineList[index],
        endPosition = polyLineList[next];
    Animation<double> anim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(carController);
    anim
      ..addListener(() {
        double v = anim.value;

        if (v == 1) {
          if (index < polyLineList.length - 1) {
            index++;
            next = index + 1;
          }
          if (index < polyLineList.length - 1) {
            startPosition = polyLineList[index];
            endPosition = polyLineList[next];
          }
          if (index == polyLineList.length - 1) {
            carController.stop();
            locationSubscription.cancel();
            return;
          }
          carController.reset();
          carController.forward();
          return;
        }
        double lng =
            v * endPosition.longitude + (1 - v) * startPosition.longitude;
        double lat =
            v * endPosition.latitude + (1 - v) * startPosition.latitude;
        LatLng newPos = new LatLng(lat, lng);
        updateMarkerImg(newPos);
      });
    carController.forward();
  }

  startListeningToLiveDataAndStartCarAnim() {
    locationSubscription =
        vendorQueryHelper.getVendorLocationStream(vendorId).listen((newPos) {
      if (!carAnimStarted) {
        locationSubscription.pause();
        startCarAnim(newPos);
      } else {
        updateInterval(newPos);
      }
    });
  }

  updateInterval(LatLng pos) {
    double intervalmilli = pidHelper.getUpdatedDuration(
        pos, currentPos, interval.inMilliseconds.toDouble());
    interval = Duration(milliseconds: intervalmilli.toInt());
    print('this is updated interval ${intervalmilli.toInt()}');
    print(carController.isAnimating);
    if (carController.duration.inMilliseconds != intervalmilli.toInt()) {
      double stopVal = carController.value;
      carController.stop();
      carController.duration = interval;
      carController.value = stopVal;
      carController.forward();
    }
    print('this is carcontroller duration ${carController.duration}');
  }

  @override
  void dispose() {
    super.dispose();
    carController.dispose();
    locationSubscription?.cancel();
    pidHelper.dispose();
  }

  @override
  void initState() {
    super.initState();

    carAnimStarted = false;
    vendorId = widget.appState.pendingTrip.vendorId;
    currentVendor = widget.appState.vendors[vendorId];

    polyLineList = widget.directionApiHelper.points;
    pidHelper = PIDHelper(polyLineList, widget.directionApiHelper.steps);
    interval = Duration(milliseconds: 3000);
    carController = AnimationController(
      vsync: this,
      duration: interval,
    );
    startListeningToLiveDataAndStartCarAnim();
    waitForReplyAndLaunch();
  }

  waitForReplyAndLaunch() async {
    var messageMap = await getReply(widget.appState);
    List<dynamic> jsonVegetables = messageMap['vegetables'];
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

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        /*appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: Container(
              child: SvgPicture.asset(
                'assets/home.svg',
                height: 25,
                width: 25,
                color: Color(0xff58f8f8f),
              ),
            ),
            onPressed: () async {
              widget.appState.active = false;
              widget.appState.messages = StreamController();
              //carController.dispose();
              await locationSubscription.cancel();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(widget.appState),
                ),
              );
            },
          ),
        ),*/
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Container(),
                ),
                Expanded(
                  flex: 8,
                  child: GoogleMap(
                    myLocationEnabled: true,
                    compassEnabled: false,
                    mapToolbarEnabled: false,
                    trafficEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: widget.directionApiHelper.initCamera,
                      zoom: 17,
                      //bearing: 30,
                      //tilt: 45,
                    ),
                    //cameraTargetBounds:
                    //CameraTargetBounds(widget.directionApiHelper.bounds),
                    onMapCreated: (GoogleMapController controller) {
                      _controller = controller;
                      CameraUpdate u2 = CameraUpdate.newLatLngBounds(
                          widget.directionApiHelper.bounds, 50);
                      _controller.animateCamera(u2);
                    },
                    mapType: MapType.normal,
                    markers: Set<Marker>.of(marker == null ? [] : [marker]),
                    polylines: Set<Polyline>.of([
                      Polyline(
                        polylineId: PolylineId('poly'),
                        color: Colors.grey,
                        width: 5,
                        points: polyLineList,
                        jointType: JointType.round,
                        startCap: Cap.squareCap,
                        endCap: Cap.squareCap,
                      )
                    ]),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Card(
                    margin: EdgeInsets.only(left: 0, right: 0, top: 0),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(50),
                        bottomLeft: Radius.circular(50),
                      ),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Expanded(
                              flex: 7,
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Column(
                                  children: <Widget>[
                                    CachedNetworkImage(
                                      //imageUrl: currentVendor.imageUrl,
                                      imageUrl:
                                          'https://c8.alamy.com/comp/EJ2D70/portrait-of-an-indian-old-man-a-street-vendor-sell-street-food-in-EJ2D70.jpg',
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        margin: EdgeInsets.only(
                                          top: (50 / 678) * height,
                                          bottom: (15 / 678) * height,
                                        ),
                                        width: width * 0.25,
                                        height: width * 0.25,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                    Text(
                                      currentVendor.name,
                                      style: TextStyle(
                                        fontFamily: 'Ubuntu',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Stack(
                                /*mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,*/
                                children: <Widget>[
                                  Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: 100,
                                          height: 100,
                                          /*padding: EdgeInsets.only(
                                            bottom: 10,
                                            top: 10,
                                            left: 20,
                                            right: 20,
                                          ),*/
                                          margin: EdgeInsets.only(
                                            bottom: 10,
                                            left: 10,
                                            right: 0,
                                          ),
                                          child: Center(
                                            child: Wrap(
                                              direction: Axis.vertical,
                                              children: <Widget>[
                                                Text(
                                                  'Distance',
                                                  style: TextStyle(
                                                      fontSize:
                                                          (height * 14) / 678),
                                                ),
                                                StreamBuilder(
                                                  stream:
                                                      pidHelper.getDistStream(),
                                                  initialData:
                                                      getInitialDistance(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData) {
                                                      return Text(
                                                        snapshot.data,
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize:
                                                                (height * 12) /
                                                                    678),
                                                      );
                                                    } else {
                                                      return CircularProgressIndicator();
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color: Color(0xfff6f6f6),
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(60),
                                              bottomRight: Radius.circular(50),
                                              topRight: Radius.circular(50),
                                              topLeft: Radius.circular(10),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(),
                                        ),
                                        Container(
                                          width: 100,
                                          height: 100,
                                          //width: double.infinity,
                                          //height: double.infinity,
                                          /*padding: EdgeInsets.only(
                                            bottom: 10,
                                            top: 10,
                                            left: 20,
                                            right: 20,
                                          ),*/
                                          margin: EdgeInsets.only(
                                            bottom: 10,
                                            left: 0,
                                            right: 10,
                                          ),
                                          child: Center(
                                            child: Wrap(
                                              direction: Axis.vertical,
                                              children: <Widget>[
                                                Text(
                                                  'ETA',
                                                  style: TextStyle(
                                                      fontSize:
                                                          (height * 14) / 678),
                                                ),
                                                StreamBuilder(
                                                  stream:
                                                      pidHelper.getEtaStream(),
                                                  initialData: getInitialETA(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData) {
                                                      return Text(
                                                        snapshot.data,
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize:
                                                                (height * 12) /
                                                                    678),
                                                      );
                                                    } else {
                                                      return CircularProgressIndicator();
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color: Color(0xfff6f6f6),
                                            borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(60),
                                              bottomLeft: Radius.circular(50),
                                              topLeft: Radius.circular(50),
                                              topRight: Radius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: FloatingActionButton(
                                      onPressed: () {
                                        UrlLauncher.launch(
                                            'tel:${currentVendor.phoneNumber}');
                                      },
                                      child: Icon(
                                        Icons.call,
                                        color: Color(0xff25D366),
                                      ),
                                      backgroundColor: Colors.white,
                                      //backgroundColor: Color(0xfff6f6f6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: EdgeInsets.only(
                              top: 30,
                            ),
                            child: IconButton(
                              icon: Container(
                                child: SvgPicture.asset(
                                  'assets/home.svg',
                                  height: 25,
                                  width: 25,
                                  color: Color(0xff58f8f8f),
                                ),
                              ),
                              onPressed: () async {
                                widget.appState.active = false;
                                widget.appState.messages = StreamController();
                                //carController.dispose();
                                await locationSubscription.cancel();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        HomePage(widget.appState),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(),
                  flex: 6,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/*

*/

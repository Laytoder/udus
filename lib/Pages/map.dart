import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
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
import 'package:frute/models/trip.dart';
import 'package:frute/models/vegetable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as Math;
import 'package:angles/angles.dart';
import 'package:frute/helpers/pidHelper.dart';
import 'package:frute/helpers/messageGetters.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  intitMarkerImg() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load('assets/car_icon.png');
    markerImg = byteData.buffer.asUint8List();
  }

  updateMarkerImg(LatLng newPos) {
    setState(() {
      marker = Marker(
        markerId: MarkerId('home'),
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

  /*startCarAnimation(Animation<double> anim) async {
    await intitMarkerImg();
    int index = -1, next;
    Timer.periodic(Duration(milliseconds: 3000), (timer) {
      LatLng startPosition, endPosition;
      if (index < polyLineList.length - 1) {
        index++;
        next = index + 1;
      }
      if (index < polyLineList.length - 1) {
        startPosition = polyLineList[index];
        endPosition = polyLineList[next];
      }
      anim..removeListener(() {});
      carController.reset();
      if (index == polyLineList.length - 2) timer.cancel();
      anim
        ..addListener(() {
          double v = anim.value;
          double lng =
              v * endPosition.longitude + (1 - v) * startPosition.longitude;
          double lat =
              v * endPosition.latitude + (1 - v) * startPosition.latitude;
          LatLng newPos = new LatLng(lat, lng);
          updateMarkerImg(newPos);
        });
      carController.forward();
    });
  }*/

  /*carAnimListener(Animation<double> anim) {
    double v = anim.value;
    if (v > 1) {
      if (index < polyLineList.length - 1) {
        index++;
        next = index + 1;
      }
      if (index < polyLineList.length - 1) {
        startPosition = polyLineList[index];
        endPosition = polyLineList[next];
      }
    }
  }*/

  startCarAnim() async {
    await intitMarkerImg();
    int index = 0, next = 1;
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

  startListeningToLiveData() {
    locationSubscription =
        vendorQueryHelper.getVendorLocationStream(vendorId).listen((newPos) {
      updateInterval(newPos);
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
  }

  @override
  void initState() {
    super.initState();

    vendorId = widget.appState.pendingTrip.vendorId;

    polyLineList = widget.directionApiHelper.points;
    pidHelper = PIDHelper(polyLineList, widget.directionApiHelper.steps);
    currentPos = polyLineList[0];
    interval = Duration(milliseconds: 3000);
    carController = AnimationController(
      vsync: this,
      duration: interval,
    );
    /*Animation<double> anim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(carController);*/
    startListeningToLiveData();
    startCarAnim();
    /*messagingHelper
        .startMessagingService(context, vendorId, widget.appState);*/
    waitForReplyAndLaunch();
    //startCarAnimation(anim);
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
    /*List<Trip> pendingTrips = widget.appState.pendingTrips;
    List<String> jsonTrips = [];
    for (Trip trip in pendingTrips) {
      if (trip.vendorId == messageMap['id']) {
        trip.state = messageMap['state'];
        trip.verificationBill =
            Bill(purchasedVegetables, total, DateTime.now());
      }
      jsonTrips.add(jsonEncode(trip.toJson()));
    }
    preferences.setStringList('pendingTrips', jsonTrips);*/
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BillPage(
          state: 'Verification',
          vegetables: purchasedVegetables,
          total: total,
          //vendorId: messageMap['id'],
          appState: widget.appState,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
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
        ),
        body: GoogleMap(
          myLocationEnabled: true,
          compassEnabled: true,
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
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frute/AppState.dart';
import 'package:frute/Pages/homebuilder.dart';
import 'package:frute/models/vendorInfo.dart';
import 'package:frute/tokens/googleMapsApiKey.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:frute/Animations/FadeAnimations.dart';

class VendorInfoPage extends StatelessWidget {
  VendorInfo vendor;
  AppState appState;
  String state;
  VendorInfoPage(this.vendor, this.appState);

  selectImageType(String link) {
    if (link.startsWith('https'))
      return NetworkImage(link);
    else
      return AssetImage(link);
  }

  double height, width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.only(
          top: (16 / 678) * height, bottom: (16 / 678) * height),
      child: FadeAnimation(
        0.2,
        Neumorphic(
          margin: EdgeInsets.only(
            top: (80 / 678) * height,
            bottom: (30 / 678) * height,
          ),
          style: NeumorphicStyle(
            depth: 4,
            border: NeumorphicBorder(color: Colors.white, width: 3),
            boxShape: NeumorphicBoxShape.roundRect(
              BorderRadius.circular((24 / 678) * height),
            ),
            shape: NeumorphicShape.convex,
            lightSource: LightSource.topLeft,
            //shadowDarkColor: Colors.grey[400],
            shadowDarkColor: Color(0xffA3B1C6),
            shadowLightColor: Colors.white,
            //shadowDarkColorEmboss: Colors.grey[400],
            intensity: 1.0,
            //color: Color(0xffE9F2F9),
            //color: Colors.white,
            //color: Color(0xffE9F2F9),
            color: Color(0xffE0E5EC),
          ),
          /*child: Card(
            //elevation: (7 / 678) * height,
            //shadowColor: Color.fromRGBO(35, 205, 99, 0.7),
            //shadowColor: Color.fromRGBO(13, 47, 61, 1),
            //color: Colors.white,
            //color: Color(0xffE9F2F9),
            /*shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular((24 / 678) * height),
            ),*/
            child: ,
          ),*/
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular((24 / 678) * height),
                        //color: Color(0xffdd4f41),
                        image: DecorationImage(
                          image: AssetImage('assets/BG-img.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      /*child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular((24 / 678) * height),
                        child: SvgPicture.asset(
                          'assets/mapBack.svg',
                          fit: BoxFit.cover,
                        ),
                      ),*/
                    ),
                  ),
                  Expanded(
                    flex: 12,
                    child: ListView.builder(
                      itemCount: vendor.vegetables.length,
                      itemBuilder: (context, index) {
                        return Neumorphic(
                          margin: EdgeInsets.only(
                            left: 10.0,
                            right: 10.0,
                            top: 10.0,
                          ),
                          style: NeumorphicStyle(
                            shape: NeumorphicShape.concave,
                            boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.circular(15.0),
                            ),
                            depth: 3,
                            lightSource: LightSource.topLeft,
                            border: NeumorphicBorder(
                              color: Colors.white,
                              width: 0.5,
                            ),
                            //color: Colors.white,
                            color: Color(0xffE0E5EC),
                          ),
                          child: Container(
                            //color: Colors.amber,
                            /*margin: EdgeInsets.only(
                              left: 10.0,
                              right: 10.0,
                              top: 10.0,
                            ),*/
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              //color: Colors.amber,
                            ),
                            child: ListTile(
                              dense: true,
                              /*contentPadding: EdgeInsets.only(
                                bottom: 0,
                              ),*/
                              //selected: true,
                              leading: Container(
                                height: (40 / 678) * height,
                                width: (40 / 678) * height,
                                child: CircleAvatar(
                                  backgroundImage: selectImageType(
                                      vendor.vegetables[index].imageUrl),
                                  radius: (10 / 678) * height,
                                ),
                              ),
                              title: Wrap(
                                direction: Axis.horizontal,
                                children: <Widget>[
                                  Text(
                                    vendor.vegetables[index].name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: (14 / 678) * height,
                                    ),
                                  ),
                                ],
                              ),
                              /*subtitle: Text(
                              'Avl Qty : ' +
                                  vendor.vegetables[index].quantity.toString() +
                                  'kg',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: (10 / 678) * height,
                              ),
                            ),
                            trailing: Text(
                              '\u20B9' +
                                  vendor.vegetables[index].price.toString() +
                                  '/kg',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: (12 / 678) * height,
                              ),
                            ),*/
                              subtitle: Text(
                                '\u20B9' +
                                    vendor.vegetables[index].price.toString() +
                                    '/kg',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: (12 / 678) * height,
                                ),
                              ),
                              trailing: Icon(
                                Icons.add_box,
                                color: Colors.blue[600],
                                size: 23,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: Stack(
                      //direction: Axis.vertical,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topCenter,
                          child: CachedNetworkImage(
                            imageUrl: vendor.imageUrl,
                            imageBuilder: (context, imageProvider) => Container(
                              margin: EdgeInsets.only(
                                top: (40 / 678) * height,
                                bottom: (5 / 678) * height,
                              ),
                              width: width * 0.20,
                              height: width * 0.20,
                              child: CircularProfileAvatar(
                                vendor.imageUrl,
                                radius: 100,
                                backgroundColor: Colors.green,
                                borderColor: Colors.white,
                                elevation: 0.0,
                                foregroundColor: Colors.brown.withOpacity(0.5),
                                borderWidth: 1,
                                cacheImage: true,
                                /*child: CachedNetworkImage(
                                  imageUrl: vendor.imageUrl,
                                  
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),*/
                              ),
                            ),
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: (115 / 678) * height,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: Colors.grey,
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        //blurRadius: 15.0,
                                        offset: Offset(0.0, 5.0))
                                  ],
                                ),
                                child: CircleAvatar(
                                  /*backgroundColor:
                                        Color.fromRGBO(13, 47, 61, 0.4),*/
                                  backgroundColor: Colors.grey[100],
                                  radius: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: (5 / 678) * height,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 24,
                        child: Container(),
                      ),
                      Expanded(
                        flex: 52,
                        child: Card(
                          elevation: 5,
                          //shadowColor: Color.fromRGBO(35, 205, 99, 0.1),
                          shadowColor: Color.fromRGBO(13, 47, 61, 1),
                          color: Colors.grey[100],
                          //color: Color.fromRGBO(160, 214, 180, 1.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              (15 / 678) * height,
                            ),
                          ),
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: (10 / 360) * width,
                              ),
                              SvgPicture.asset(
                                'assets/medal.svg',
                                height: (25 / 678) * height,
                                width: (25 / 678) * height,
                                //color: Color(0xff58f8f8f),
                                //color: Color.fromRGBO(35, 205, 99, 1.0),
                                //color: Color.fromRGBO(13, 47, 61, 1),
                              ),
                              Stack(
                                //mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: (13 / 360) * width,
                                        top: (5 / 678) * height,
                                        right: (10 / 360) * width,
                                        bottom: (1.5 / 678) * height,
                                      ),
                                      child: Text(
                                        vendor.name
                                                .substring(0, 1)
                                                .toUpperCase() +
                                            vendor.name.substring(1),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: (11 / 678) * height,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Container(
                                      margin: EdgeInsets.only(
                                        left: (11 / 360) * width,
                                        bottom: (5 / 678) * height,
                                        right: (10 / 360) * width,
                                        top: (20 / 678) * height,
                                      ),
                                      child: RatingBar.readOnly(
                                        initialRating: 5,
                                        filledIcon: Icons.star,
                                        emptyIcon: Icons.star_border,
                                        filledColor: Colors.amber,
                                        size: (12 / 678) * height,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 24,
                        child: Container(),
                      ),
                    ],
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: width * 0.30,
                  margin: EdgeInsets.only(
                    top: (10 / 360) * width,
                    left: (10 / 360) * width,
                  ),
                  height: (30 / 678) * height,
                  child: GestureDetector(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          (15 / 678) * height,
                        ),
                      ),
                      elevation: 5.0,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 40,
                            child: Container(),
                          ),
                          Icon(
                            Icons.location_on,
                            //color: Colors.black,
                            color: Color.fromRGBO(58, 124, 236, 1.0),
                            size: (18 / 678) * height,
                          ),
                          Text(
                            'Edit Location',
                            style: TextStyle(
                              //color: Colors.black,
                              color: Color.fromRGBO(58, 124, 236, 1.0),
                              fontSize: (10 / 678) * height,
                            ),
                          ),
                          Expanded(
                            flex: 60,
                            child: Container(),
                          ),
                        ],
                      ),
                    ),
                    onTap: () async {
                      /*LocationResult locationResult =
                            await showLocationPicker(
                          context,
                          gmapsApiKey,
                          appBarColor: Colors.white,
                          myLocationButtonEnabled: true,
                          automaticallyImplyLeading: true,
                          automaticallyAnimateToCurrentLocation: true,
                        );
                        if (locationResult != null) {
                          double lat = locationResult.latLng.latitude;
                          double lon = locationResult.latLng.longitude;
                          GeoCoord newLoc = GeoCoord(lat, lon);
                          appState.userLocation = newLoc;
                        }*/
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeBuilder(
                            appState,
                            state: 'edit',
                          ),
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
    );
  }
}

/* 

*/

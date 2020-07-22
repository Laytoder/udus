import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
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
          Card(
            elevation: (7 / 678) * height,
            //shadowColor: Color.fromRGBO(35, 205, 99, 0.7),
            shadowColor: Color.fromRGBO(13, 47, 61, 1),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular((24 / 678) * height),
            ),
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
                            fit: BoxFit.fill,
                          ),
                        ),
                        /*child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular((24 / 678) * height),
                          child: GoogleMap(
                            scrollGesturesEnabled: false,
                            myLocationEnabled: false,
                            compassEnabled: false,
                            mapToolbarEnabled: false,
                            trafficEnabled: false,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(vendor.coords.latitude,
                                  vendor.coords.longitude),
                              zoom: 17,
                            ),
                            onMapCreated: (GoogleMapController controller) {},
                            mapType: MapType.normal,
                          ),
                        ),*/
                      ),
                    ),
                    Expanded(
                      flex: 10,
                      child: ListView.builder(
                        itemCount: vendor.vegetables.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            dense: true,
                            /*contentPadding: EdgeInsets.only(
                              bottom: 0,
                            ),*/
                            //selected: true,
                            leading: Container(
                              height: (40 / 678) * height,
                              width: (40 / 360) * width,
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
                            subtitle: Text(
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
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                margin: EdgeInsets.only(
                                  top: (50 / 678) * height,
                                  bottom: (5 / 678) * height,
                                ),
                                width: width * 0.15,
                                height: width * 0.15,
                                child: CircularProfileAvatar(
                                  vendor.imageUrl,
                                  radius: 100,
                                  backgroundColor: Colors.green,
                                  borderColor: Colors.white,
                                  elevation: 0.0,
                                  foregroundColor:
                                      Colors.brown.withOpacity(0.5),
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
                                  height: (105 / 678) * height,
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
                      height: (30 / 678) * height,
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
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.topCenter,
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
                                              vendor.name.substring(1) +
                                              ', 16',
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
                                      alignment: Alignment.topLeft,
                                      child: Container(
                                        margin: EdgeInsets.only(
                                          left: (0 / 360) * width,
                                          bottom: (5 / 678) * height,
                                          right: (10 / 360) * width,
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
          )),
    );
  }
}

/* 

*/

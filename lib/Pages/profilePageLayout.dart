import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:frute/AppState.dart';
import 'package:frute/helpers/sourceAndImageFetcherDialog.dart';
import 'package:frute/tokens/googleMapsApiKey.dart';
import 'package:frute/widgets/pageHeading.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePageLayout extends StatefulWidget {
  AnimationController editPhoneController, editNameController;
  Function() onNamePressed, onPhonePressed;
  AppState appState;
  ProfilePageLayout({
    @required this.editNameController,
    @required this.editPhoneController,
    @required this.onNamePressed,
    @required this.onPhonePressed,
    @required this.appState,
  });
  @override
  _ProfilePageLayoutState createState() => _ProfilePageLayoutState();
}

class _ProfilePageLayoutState extends State<ProfilePageLayout>
    with SingleTickerProviderStateMixin {
  File imageFile;
  double height, width;

  @override
  void initState() {
    super.initState();

    if (widget.appState.image != null) imageFile = File(widget.appState.image);
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: height * 0.87,
      child: Column(
        children: <Widget>[
          PageHeading('Profile'),
          Expanded(
            flex: 3,
            child: Center(
              child: Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.grey[100],
                    radius: (50 / 678) * height,
                    backgroundImage:
                        imageFile != null ? FileImage(imageFile) : null,
                    child: imageFile == null
                        ? Icon(
                            Icons.person,
                            size: (40 / 678) * height,
                            color: Colors.grey[500],
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: (15 / 640) * height),
            child: Text(
              widget.appState.clientName,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: (20 / (640 * 360)) * height * width,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: (5 / 640) * height),
            child: Text(
              widget.appState.phoneNumber,
              style: TextStyle(
                fontWeight: FontWeight.w100,
                fontSize: (12 / (640 * 360)) * height * width,
              ),
            ),
          ),
          Expanded(
            flex: 12,
            child: Stack(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: (30 / 360) * width,
                    ),
                    Column(
                      children: <Widget>[
                        FloatingActionButton(
                          heroTag: null,
                          mini: true,
                          onPressed: () async {
                            widget.onNamePressed();
                            widget.editNameController.forward();
                          },
                          child: Icon(
                            Icons.edit,
                            color: Color(0xff0D2F3D),
                            size: (24 / 678) * height,
                          ),
                        ),
                        Text(
                          'Edit Name',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w400,
                            fontSize: (12 / 678) * height,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Column(
                      children: <Widget>[
                        FloatingActionButton(
                          heroTag: null,
                          mini: true,
                          onPressed: () {
                            widget.onPhonePressed();
                            widget.editPhoneController.forward();
                          },
                          child: Icon(
                            Icons.phone,
                            color: Color(0xff0D2F3D),
                            size: (24 / 678) * height,
                          ),
                        ),
                        Text(
                          'Edit Number',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w400,
                            fontSize: (12 / 678) * height,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: (29 / 360) * width,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        SizedBox(
                          height: (50 / 678) * height,
                        ),
                        GestureDetector(
                          child: CircleAvatar(
                            backgroundColor: Color(0xff0D2F3D),
                            radius: (24 / 678) * height,
                            child: Icon(
                              Icons.camera_alt,
                              size: (24 / 678) * height,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () async {
                            File imageFile =
                                await alertForSourceAndGetImage(context);
                            if (imageFile == null) return;
                            setState(() => this.imageFile = imageFile);
                            String cache = imageFile.path;
                            Directory directory =
                                await getApplicationDocumentsDirectory();
                            String path = directory.path;
                            String fileName = cache.substring(
                                cache.lastIndexOf('/') + 1, cache.length - 1);
                            File saved =
                                await File(cache).copy('$path/' + fileName);
                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            preferences.setString('image', saved.path);
                            widget.appState.image = saved.path;
                          },
                        ),
                        /*Container(
                          alignment: Alignment.center,
                          width: 10,
                          height: 10,
                          margin: EdgeInsets.only(top: 50, left: 50, right: 50),
                          child: FlutterSlider(
                            values: [300],
                            max: 500,
                            min: 0,
                            onDragging: (handlerIndex, lowerValue, upperValue) {
                              //_lowerValue = lowerValue;
                              //_upperValue = upperValue;
                              setState(() {});
                            },
                          ),
                        ),*/
                        SizedBox(
                          height: (3 / 678) * height,
                        ),
                        Text(
                          'Edit Picture',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w400,
                            fontSize: (12 / 678) * height,
                          ),
                        ),
                      ],
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

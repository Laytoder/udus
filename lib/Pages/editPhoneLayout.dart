import 'package:flutter/material.dart';
import 'package:frute/AppState.dart';
import 'package:frute/widgets/pageHeading.dart';
import 'phoneNumPage.dart';

class EditPhoneLayout extends StatefulWidget {
  AppState appState;
  EditPhoneLayout({@required this.appState});

  @override
  _EditPhoneLayoutState createState() => _EditPhoneLayoutState();
}

class _EditPhoneLayoutState extends State<EditPhoneLayout> {
  double height, width;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      height: height * 0.87,
      child: Column(
        children: <Widget>[
          PageHeading('Edit Number'),
          Expanded(
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                      left: (20 / 360) * width,
                      right: (20 / 360) * width,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(
                        (30 / 678) * height,
                      ),
                    ),
                    child: ListTile(
                      title: Text(
                        'Current Phone Number',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: (16 / 678) * height,
                        ),
                      ),
                      subtitle: Text(
                        widget.appState.phoneNumber,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: (14 / 678) * height,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: (30 / 678) * height,
                  ),
                  Text('Will Need Verification'),
                  SizedBox(
                    height: (20 / 678) * height,
                  ),
                  RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PhoneNumPage(
                            widget.appState,
                            state: 'update',
                          ),
                        ),
                      );
                    },
                    child: Text('Continue'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        (80 / 678) * height,
                      ),
                    ),
                    color: Color(0xff25d368),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:frute/AppState.dart';
import 'package:frute/widgets/pageHeading.dart';

import 'package:frute/Pages/phoneNumPage.dart';
import 'package:frute/config/colors.dart';
import 'package:frute/config/borderRadius.dart';

class EditPhone extends StatefulWidget {
  final AppState appState;

  EditPhone({@required this.appState});

  @override
  _EditPhoneState createState() => _EditPhoneState();
}

class _EditPhoneState extends State<EditPhone> {
  //double height, width;

  @override
  Widget build(BuildContext context) {
    //width = MediaQuery.of(context).size.width;
    //height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 8,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SafeArea(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                PageHeading('Edit Number'),
                Expanded(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                            left: 20,
                            right: 20,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(
                              30,
                            ),
                            border: Border.all(
                              color: UdusColors.primaryColor,
                            ),
                          ),
                          child: ListTile(
                            title: Text(
                              'Current Phone Number',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              widget.appState.phoneNumber,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text('This Will Require Verification'),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
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
                          child: Container(
                            height: 30,
                            width: 100,
                            decoration: BoxDecoration(
                              color: UdusColors.primaryColor,
                              borderRadius: UdusBorderRadius.large,
                            ),
                            child: Center(
                              child: Text(
                                'Continue',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
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
        ],
      ),
    );
  }
}

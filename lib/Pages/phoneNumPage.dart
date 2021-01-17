import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:frute/AppState.dart';
import 'package:frute/widgets/pageHeading.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frute/config/borderRadius.dart';

import 'otpPage.dart';

class PhoneNumPage extends StatefulWidget {
  AppState appState;
  String state;

  PhoneNumPage(this.appState, {this.state = 'normal'});

  @override
  _PhoneNumPageState createState() => _PhoneNumPageState();
}

class _PhoneNumPageState extends State<PhoneNumPage> {
  PhoneNumber currentNumber = PhoneNumber(isoCode: 'IN');
  TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  SharedPreferences preferences;
  double height, width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: 20,
              left: 10,
            ),
            child: PageHeading('Will need to call you so...'),
          ),
          Expanded(
            flex: 4,
            child: Container(),
          ),
          Container(
            width: (320 / 360) * width,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: UdusBorderRadius.large,
            ),
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 10,
              bottom: 10,
            ),
            child: Form(
              key: formKey,
              child: InternationalPhoneNumberInput(
                onInputChanged: (PhoneNumber number) {
                  currentNumber = number;
                },
                inputBorder: InputBorder.none,
                autoFocus: true,
                countries: ['IN', 'US'],
                initialValue: currentNumber,
                errorMessage: 'Please enter a valid phone number',
                countrySelectorScrollControlled: true,
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                ignoreBlank: false,
                autoValidate: false,
                selectorTextStyle: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Ubuntu',
                    fontWeight: FontWeight.w400,
                    fontSize: 14),
                textFieldController: controller,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            margin: EdgeInsets.only(
              left: 40,
              right: 40,
              bottom: 20,
            ),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(80),
              ),
              padding: EdgeInsets.all(0.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(35, 205, 99, 1),
                  borderRadius: BorderRadius.all(
                    Radius.circular(80),
                  ),
                ),
                width: width,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Continue',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Ubuntu',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              onPressed: () async {
                if (formKey.currentState.validate()) {
                  formKey.currentState.save();
                  widget.appState.phoneNumber = currentNumber.phoneNumber;
                  if (preferences == null)
                    preferences = await SharedPreferences.getInstance();
                  preferences.setString(
                      'phoneNumber', currentNumber.phoneNumber);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OTPPage(
                        currentNumber.phoneNumber,
                        widget.appState,
                        widget.state,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

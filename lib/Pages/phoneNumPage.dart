import 'package:flutter/material.dart';
import 'package:frute/widgets/pageHeading.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'otpPage.dart';
import 'package:frute/AppState.dart';

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
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: (20 / 678) * height,
              left: (10 / 360) * width,
            ),
            child: PageHeading('Will need to call you so...'),
          ),
          Expanded(
            flex: 4,
            child: Container(),
          ),
          Container(
            margin: EdgeInsets.only(
              left: (20 / 360) * width,
              right: (20 / 360) * width,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular((30 / 678) * height),
            ),
            padding: EdgeInsets.only(
              left: (20 / 360) * width,
              right: (20 / 360) * width,
              top: (10 / 678) * height,
              bottom: (10 / 678) * height,
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
                selectorType: PhoneInputSelectorType.DIALOG,
                ignoreBlank: false,
                autoValidate: false,
                selectorTextStyle: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Ubuntu',
                    fontWeight: FontWeight.w400,
                    fontSize: (14 / 678) * height),
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
            height: (50 / 678) * height,
            margin: EdgeInsets.only(
              left: (40 / 360) * width,
              right: (40 / 360) * width,
              bottom: (20 / 678) * height,
            ),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular((80 / 678) * height),
              ),
              padding: EdgeInsets.all(0.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xff25D366), Color(0xff2ca85b)]),
                  borderRadius: BorderRadius.all(
                    Radius.circular((80 / 678) * height),
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
                      fontSize: (20 / 678) * height,
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

import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'otpPage.dart';
import 'package:frute/AppState.dart';

class PhoneNumPage extends StatefulWidget {
  AppState appState;
  PhoneNumPage(this.appState);
  @override
  _PhoneNumPageState createState() => _PhoneNumPageState();
}

class _PhoneNumPageState extends State<PhoneNumPage> {
  PhoneNumber currentNumber = PhoneNumber(isoCode: 'IN');
  TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String verificationId;
  bool loading = false;

  verifyPhoneNumber(BuildContext context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    await auth.verifyPhoneNumber(
        phoneNumber: currentNumber.phoneNumber,
        timeout: Duration(seconds: 0),
        verificationCompleted: (authCredential) =>
            verificationComplete(authCredential, context),
        verificationFailed: (authException) =>
            verificationFailed(authException, context),
        codeAutoRetrievalTimeout: (verificationId) =>
            codeAutoRetrievalTimeout(verificationId),
        // called when the SMS code is sent
        codeSent: (verificationId, [code]) =>
            smsCodeSent(verificationId, [code]));
  }

  verificationComplete(AuthCredential authCredential, BuildContext context) {
    FirebaseAuth.instance
        .signInWithCredential(authCredential)
        .then((authResult) {
      final snackBar =
          SnackBar(content: Text("Success!!! UUID is: " + authResult.user.uid));
      Scaffold.of(context).showSnackBar(snackBar);
    });
  }

  smsCodeSent(String verificationId, List<int> code) {
    loading = false;
    this.verificationId = verificationId;
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => OTPPage(verificationId, widget.appState)),
    );
  }

  verificationFailed(AuthException authException, BuildContext context) {
    final snackBar = SnackBar(
        content:
            Text("Exception!! message:" + authException.message.toString()));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  codeAutoRetrievalTimeout(String verificationId) {
    this.verificationId = verificationId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Your Phone Number'),
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.black,
              ),
            )
          : Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: Form(
                    key: formKey,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(30.0),
                            child: InternationalPhoneNumberInput(
                              onInputChanged: (PhoneNumber number) {
                                currentNumber = number;
                              },
                              autoFocus: false,
                              countries: ['IN', 'US'],
                              initialValue: currentNumber,
                              errorMessage: 'Please enter a valid phone number',
                              countrySelectorScrollControlled: true,
                              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                              ignoreBlank: false,
                              autoValidate: false,
                              selectorTextStyle: TextStyle(color: Colors.black),
                              textFieldController: controller,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(30.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Name',
                              ),
                              validator: (name) {
                                if (name.isEmpty) return 'Please enter a name';
                              },
                              onSaved: (name) async {
                                widget.appState.clientName = name;
                                SharedPreferences preferences =
                                    await SharedPreferences.getInstance();
                                preferences.setString('clientName', name);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: RaisedButton(
                        child: Text(
                          'Submit',
                          style: TextStyle(color: Colors.amber, fontSize: 20),
                        ),
                        color: Colors.black,
                        onPressed: () {
                          if (formKey.currentState.validate()) {
                            setState(() => loading = true);
                            formKey.currentState.save();
                            verifyPhoneNumber(context);
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

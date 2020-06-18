import 'package:flutter/material.dart';
import 'package:frute/AppState.dart';
import 'package:frute/Pages/homePage.dart';
import 'package:frute/helpers/authService.dart';
import 'package:frute/main.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPPage extends StatefulWidget {
  String verificationId;
  AppState appState;
  OTPPage(this.verificationId, this.appState);
  @override
  _OTPPageState createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  AuthService authService = AuthService();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter OTP'),
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.black,
              ),
            )
          : Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(30),
                  child: PinCodeTextField(
                    length: 6,
                    onChanged: null,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.underline,
                      fieldHeight: 50,
                      fieldWidth: 40,
                    ),
                    backgroundColor: Colors.transparent,
                    enableActiveFill: false,
                    onCompleted: (otp) async {
                      setState(() => loading = true);
                      await authService.signInWithOTP(
                          otp, widget.verificationId);
                      setState(() => loading = false);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePage(widget.appState)),
                      );
                      print('log in successful');
                    },
                    animationType: AnimationType.fade,
                    autoFocus: true,
                    controller: TextEditingController(),
                  ),
                ),
              ],
            ),
    );
  }
}

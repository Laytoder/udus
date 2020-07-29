import 'dart:async';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frute/AppState.dart';
import 'package:frute/Pages/homePage.dart';
import 'package:frute/Pages/homebuilder.dart';
import 'package:frute/helpers/authService.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPPage extends StatefulWidget {
  String phoneNumber;
  AppState appState;
  String state;
  OTPPage(
    this.phoneNumber,
    this.appState,
    this.state,
  );
  @override
  _OTPPageState createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> with SingleTickerProviderStateMixin {
  bool loading = true, invalidState = false, verifyPhoneSingleton = false;
  int forceResendingToken = null;
  AuthService authService = AuthService();
  String verificationId;
  StreamController<ErrorAnimationType> errorController;
  TextEditingController controller = TextEditingController();
  double height, width;
  AnimationController animationController;
  Animation animation;

  verifyPhoneNumber(BuildContext context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    await auth.verifyPhoneNumber(
        phoneNumber: widget.phoneNumber,
        timeout: Duration(seconds: 0),
        verificationCompleted: (authCredential) =>
            verificationComplete(authCredential, context),
        verificationFailed: (authException) =>
            verificationFailed(authException, context),
        codeAutoRetrievalTimeout: (verificationId) =>
            codeAutoRetrievalTimeout(verificationId),
        forceResendingToken: forceResendingToken,
        // called when the SMS code is sent
        codeSent: (verificationId, [code]) =>
            smsCodeSent(verificationId, code));
  }

  verificationComplete(
      AuthCredential authCredential, BuildContext context) async {
    await authService.signIn(authCredential);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeBuilder(widget.appState),
      ),
    );
    setState(() {
      controller.text = '';
      loading = false;
    });
  }

  smsCodeSent(String verificationId, [int resendToken]) {
    this.verificationId = verificationId;
    forceResendingToken = resendToken;
    setState(() {
      controller.text = '';
      loading = false;
    });
  }

  verificationFailed(AuthException authException, BuildContext context) {
    final snackBar = SnackBar(content: Text(authException.message.toString()));
    Scaffold.of(context).showSnackBar(snackBar);
    //verifyPhoneNumber(context);
    print(authException.message);
  }

  codeAutoRetrievalTimeout(String verificationId) {
    this.verificationId = verificationId;
  }

  @override
  void initState() {
    super.initState();
    loading = true;
    errorController = StreamController<ErrorAnimationType>();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(animationController);
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!verifyPhoneSingleton) {
        print('called');
        verifyPhoneSingleton = true;
        verifyPhoneNumber(context);
      }
    });
    return Stack(
      children: <Widget>[
        Scaffold(
          backgroundColor: Color(0xffE0E5EC),
          appBar: AppBar(
            title: invalidState
                ? Text(
                    'Invalid OTP',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: (14 / 678) * height,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Ubuntu',
                    ),
                  )
                : Text(
                    'Enter OTP',
                    style: TextStyle(
                      fontSize: (14 / 678) * height,
                      fontFamily: 'Ubuntu',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
            elevation: 0.0,
          ),
          body: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(
                  (30 / 678) * height,
                ),
                child: PinCodeTextField(
                  textInputType: TextInputType.number,
                  length: 6,
                  onChanged: null,
                  errorAnimationController: errorController,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.underline,
                    fieldHeight: (50 / 678) * height,
                    fieldWidth: (40 / 678) * height,
                    inactiveColor: Colors.black,
                    activeColor: Colors.black,
                    selectedColor: Colors.grey[400],
                  ),
                  autoDisposeControllers: false,
                  backgroundColor: Colors.transparent,
                  enableActiveFill: false,
                  onCompleted: (otp) async {
                    setState(() => loading = true);
                    animationController.forward();
                    print('this is verification id $verificationId');
                    try {
                      AuthResult result =
                          await authService.signInWithOTP(otp, verificationId);
                      if (result.user != null) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeBuilder(widget.appState),
                          ),
                        );
                        setState(() {
                          controller.text = '';
                          loading = false;
                        });
                      } else {
                        setState(() {
                          loading = false;
                          invalidState = true;
                          controller.text = '';
                          errorController.add(ErrorAnimationType.shake);
                        });
                      }
                    } catch (e) {
                      setState(() {
                        loading = false;
                        invalidState = true;
                        controller.text = '';
                        errorController.add(ErrorAnimationType.shake);
                      });
                    }
                    print('log in successful');
                  },
                  animationType: AnimationType.fade,
                  autoFocus: false,
                  controller: controller,
                ),
              ),
              Text(
                'Did not receive the OTP ?',
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontWeight: FontWeight.w400,
                  fontSize: (14 / 678) * height,
                ),
              ),
              SizedBox(
                height: (15 / 678) * height,
              ),
              GestureDetector(
                child: Text(
                  'Resend OTP',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontFamily: 'Ubuntu',
                    fontWeight: FontWeight.w400,
                    fontSize: (14 / 678) * height,
                  ),
                ),
                onTap: () {
                  setState(() => loading = true);
                  animationController.forward();
                  verifyPhoneNumber(context);
                },
              ),
            ],
          ),
        ),
        loading
            ? BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 2,
                  sigmaY: 2,
                ),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration:
                      BoxDecoration(color: Colors.black.withOpacity(0.9)),
                  child: Center(
                    child: CircularProgressIndicator(
                        //backgroundColor: Colors.white,
                        ),
                  ),
                ),
              )
            : SizedBox(
                child: Container(),
                width: 0,
                height: 0,
              ),
      ],
    );
  }
}

/*

*/

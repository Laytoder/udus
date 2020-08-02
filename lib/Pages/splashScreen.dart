import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 500,
      ),
    )..addListener(() {
        setState(() {});
      });
  }

  endSplash() async {
    //animationController.forward();
    await animationController.animateTo(
      1.0,
      duration: Duration(
        milliseconds: 2500,
      ),
      curve: Curves.fastOutSlowIn,
    );
    loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Opacity(
            opacity: 1.0 - animationController.value,
            child: Scaffold(
              body: Center(
                child: Image(
                  image: AssetImage('assets/HL.png'),
                  height: 200,
                  width: 200,
                ),
              ),
            ),
          )
        : SizedBox(
            height: 0,
            width: 0,
            child: Container(),
          );
  }
}

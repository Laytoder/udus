import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  LoadingScreen({Key key}) : super(key: key);

  @override
  LoadingScreenState createState() => LoadingScreenState();
}

class LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 500,
      ),
    )..addListener(() {
        setState(() {});
      });
  }

  endLoading() async {
    //animationController.forward();
    await controller.animateTo(
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
            opacity: 1 - controller.value,
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: Image(
                  height: 200,
                  width: 200,
                  image: AssetImage('assets/loading.gif'),
                ),
              ),
            ),
          )
        : SizedBox(
            height: 0.0,
            width: 0.0,
            child: Container(),
          );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frute/AppState.dart';
import 'package:frute/Pages/editNameLayout.dart';
import 'package:frute/Pages/profilePageLayout.dart';
import 'package:frute/Pages/editPhoneLayout.dart';
import 'package:frute/assets/my_flutter_app_icons.dart';
import 'package:frute/widgets/curvedDecorator.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class ProfilePage extends StatefulWidget {
  PageController controller;
  AppState appState;
  ProfilePage({
    @required this.controller,
    @required this.appState,
  });
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  double curvedLength = 1.0, height, width;

  AnimationController editNameController,
      editPhoneController,
      panelController,
      profileController,
      homeController;
  Animation profileOpacity,
      editNameOpacity,
      editPhoneOpacity,
      panelOpacity,
      homeOpacity;

  String state = 'profile';
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    editNameController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    editNameOpacity = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(editNameController);

    editPhoneController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    editPhoneOpacity = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(editPhoneController);

    homeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    homeOpacity = Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(homeController);

    panelController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    panelOpacity = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(panelController);

    profileController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    profileOpacity = Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(profileController);
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
        //backgroundColor: Color(0xfff6f7fb),
        backgroundColor: Color(0xffE0E5EC),
        body: Stack(
          children: <Widget>[
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              transform: Matrix4.diagonal3Values(1.0, curvedLength, 1.0),
              color: Color(0xffdce1e9),
              child: CurvedDecorator(
                color: Color(0xffE0E5EC),
                radius: MediaQuery.of(context).size.height * 0.75,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: (40 / 678) * height,
                ),
                Stack(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(),
                        ),
                        IconButton(
                          /*icon: Container(
                            child: SvgPicture.asset(
                              'assets/user.svg',
                              height: (60 / 678) * height,
                              width: (60 / 678) * height,
                              color: Color(0xff25d368),
                            ),
                          ),*/
                          icon: NeumorphicIcon(
                            MyFlutterApp.user,
                            style: NeumorphicStyle(
                              shape: NeumorphicShape.convex,
                              //depth: 30,
                              depth: 3,
                              lightSource: LightSource.topLeft,
                              //shadowLightColor: Color(0xffF6F7FA),
                              //shadowDarkColor: Colors.transparent,
                              intensity: 0.68,
                              border: NeumorphicBorder(
                                color: Colors.white,
                                width: 0.5,
                              ),
                              shadowDarkColor: Color(0xffA3B1C6),
                              shadowLightColor: Colors.white,
                              color: Color.fromRGBO(35, 205, 99, 1.0),
                            ),
                            size: (33 / 678) * height,
                          ),
                          onPressed: null,
                        ),
                        Expanded(
                          child: Container(),
                        ),
                      ],
                    ),
                    state != 'profile'
                        ? FadeTransition(
                            opacity: panelOpacity,
                            child: Row(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    Icons.arrow_back,
                                    size: (24 / 678) * height,
                                  ),
                                  onPressed: () {
                                    if (editNameController.value == 1.0)
                                      editNameController.reverse();
                                    if (editNameController.value == 1.0)
                                      editNameController.reverse();
                                    panelController.reverse();
                                    profileController.reverse();
                                    homeController.reverse();
                                    setState(() {
                                      curvedLength = 1.0;
                                      state = 'profile';
                                    });
                                  },
                                ),
                                Expanded(
                                  child: Container(),
                                ),
                                state == 'editName'
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.check,
                                          size: (24 / 678) * height,
                                        ),
                                        onPressed: () {
                                          if (formKey.currentState.validate()) {
                                            formKey.currentState.save();
                                            if (editNameController.value == 1.0)
                                              editNameController.reverse();
                                            if (editNameController.value == 1.0)
                                              editNameController.reverse();
                                            panelController.reverse();
                                            profileController.reverse();
                                            homeController.reverse();
                                            setState(() {
                                              curvedLength = 1.0;
                                              state = 'profile';
                                            });
                                          }
                                        },
                                      )
                                    : SizedBox(
                                        width: 0,
                                        height: 0,
                                        child: Container(),
                                      ),
                                SizedBox(
                                  width: (10 / 360) * width,
                                ),
                              ],
                            ),
                          )
                        : SizedBox(
                            width: 0,
                            height: 0,
                            child: Container(),
                          ),
                    state == 'profile'
                        ? FadeTransition(
                            opacity: homeOpacity,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(),
                                ),
                                IconButton(
                                  /*icon: Container(
                                    child: SvgPicture.asset(
                                      'assets/home.svg',
                                      height: (25 / 678) * height,
                                      width: (25 / 678) * height,
                                      color: Color(0xff58f8f8f),
                                    ),
                                  ),*/
                                  icon: NeumorphicIcon(
                                    MyFlutterApp.home,
                                    style: NeumorphicStyle(
                                      shape: NeumorphicShape.convex,
                                      depth: 3,
                                      lightSource: LightSource.topLeft,
                                      intensity: 0.68,
                                      border: NeumorphicBorder(
                                        color: Colors.white,
                                        width: 0.5,
                                      ),
                                      shadowDarkColor: Color(0xffA3B1C6),
                                      shadowLightColor: Colors.white,
                                      color: Color(0xffAFBBCA),
                                    ),
                                    size: 26,
                                  ),
                                  onPressed: () {
                                    widget.controller.animateToPage(
                                      1,
                                      duration: Duration(milliseconds: 1000),
                                      curve: Curves.fastLinearToSlowEaseIn,
                                    );
                                  },
                                ),
                                SizedBox(
                                  width: (10 / 360) * width,
                                ),
                              ],
                            ),
                          )
                        : SizedBox(
                            width: 0,
                            height: 0,
                            child: Container(),
                          ),
                  ],
                ),
                Stack(
                  children: <Widget>[
                    FadeTransition(
                      opacity: profileOpacity,
                      child: ProfilePageLayout(
                        editNameController: editNameController,
                        editPhoneController: editPhoneController,
                        appState: widget.appState,
                        onNamePressed: () {
                          setState(() => curvedLength = 1.5);
                          panelController.forward();
                          homeController.forward();
                          profileController.forward();
                          state = 'editName';
                        },
                        onPhonePressed: () {
                          setState(() => curvedLength = 1.5);
                          panelController.forward();
                          homeController.forward();
                          profileController.forward();
                          state = 'editPhone';
                        },
                      ),
                    ),
                    state == 'editPhone'
                        ? FadeTransition(
                            opacity: editPhoneOpacity,
                            child: EditPhoneLayout(
                              appState: widget.appState,
                            ),
                          )
                        : SizedBox(
                            child: Container(),
                            width: 0,
                            height: 0,
                          ),
                    state == 'editName'
                        ? FadeTransition(
                            opacity: editNameOpacity,
                            child: EditNameLayout(
                              appState: widget.appState,
                              formKey: formKey,
                            ),
                          )
                        : SizedBox(
                            child: Container(),
                            width: 0,
                            height: 0,
                          ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

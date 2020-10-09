import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:frute/homePage/dualButton.dart';
import 'package:frute/utils/searcher.dart';
import 'inTheSpotlight.dart';
import 'offer_banner_view.dart';
import 'topPicksForYouView.dart';
import 'package:frute/assets/my_flutter_app_icons.dart';

class HomePageUpdated extends StatefulWidget {
  PageController pageController;
  PageController globalController;
  Function() onDropInClicked;
  bool initDualButtonState;
  HomePageUpdated({
    Key key,
    @required this.pageController,
    @required this.globalController,
    @required this.onDropInClicked,
    @required this.initDualButtonState,
  }) : super(key: key);
  @override
  HomePageUpdatedState createState() => HomePageUpdatedState();
}

class HomePageUpdatedState extends State<HomePageUpdated> {
  double height;

  double width;

  bool dropInClicked = false;

  @override
  void initState() {
    super.initState();

    dropInClicked = widget.initDualButtonState;
  }

  setDropInClickedFalse() {
    setState(() => dropInClicked = false);
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return ListView(
      children: [
        dropInClicked
            ? SizedBox(
                height: (43.5 / 640) * height,
              )
            : SizedBox(
                height: (3 / 678) * height,
              ),
        dropInClicked
            ? SizedBox(
                child: Container(),
                width: 0,
                height: 0,
              )
            : Row(
                children: <Widget>[
                  SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    icon: NeumorphicIcon(
                      MyFlutterApp.user,
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
                      size: 28,
                    ),
                    onPressed: () {
                      widget.globalController.animateToPage(
                        0,
                        duration: Duration(milliseconds: 1000),
                        curve: Curves.fastLinearToSlowEaseIn,
                      );
                    },
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  DualButton(
                    height: (35 / 678) * height,
                    width: width * 0.4,
                    textSize: (12 / 678) * height,
                    padding: (1 / 678) * height,
                    radius: (80 / 678) * height,
                    onDropInClicked: () async {
                      widget.onDropInClicked();
                      setState(() => dropInClicked = true);
                      await widget.pageController.animateToPage(
                        1,
                        duration: Duration(milliseconds: 2000),
                        curve: Curves.fastLinearToSlowEaseIn,
                      );
                    },
                    onNowClicked: () {},
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  IconButton(
                    icon: NeumorphicIcon(
                      Icons.shopping_basket,
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
                      size: 32,
                    ),
                    onPressed: () {
                      widget.globalController.animateToPage(
                        2,
                        duration: Duration(milliseconds: 1000),
                        curve: Curves.fastLinearToSlowEaseIn,
                      );
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
        SizedBox(height: (20.0 / 640) * height),
        GestureDetector(
          child: Padding(
            padding: EdgeInsets.only(
                left: (10 / 360) * width, right: (10 / 360) * width),
            child: Neumorphic(
              style: NeumorphicStyle(
                boxShape: NeumorphicBoxShape.roundRect(
                    BorderRadius.circular((15 / (640 * 360)) * height * width)),
                depth: 3,
              ),
              child: Container(
                height: (50 / 640) * height,
                width: (270 / 360) * width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      ((15 / (640 * 360)) * height * width)),
                  color: Color(0xffE0E5EC),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: (3 / 640) * height,
                    bottom: (3 / 640) * height,
                    left: (3 / 360) * width,
                    right: (3 / 360) * width,
                  ),
                  child: Neumorphic(
                    style: NeumorphicStyle(
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(
                              (15 / (640 * 360)) * height * width)),
                      depth: -3,
                      color: Color(0xffE0E5EC),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                        Text(
                          "Fruits and Vegetables",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: (18 / (640 * 360)) * height * width,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          onTap: () async {
            await showSearch(
              context: context,
              delegate: SearchItems(),
            );
          },
        ),
        Padding(
          padding: EdgeInsets.only(
            top: (10 / 640) * height,
            bottom: (10 / 640) * height,
            left: (10 / 360) * width,
            right: (10 / 360) * width,
          ),
          child: OfferBannerView(),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: (0 / 640) * height,
            bottom: (0 / 640) * height,
            left: (5 / 360) * width,
            right: (5 / 360) * width,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              //SafetyBannerView(),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: InkWell(
                  child: Container(
                    height: 150.0,
                    color: Color.fromRGBO(35, 205, 99, 0.8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Vendors',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    .copyWith(color: Colors.white),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'No-contact delivery available',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                        Spacer(),
                        Container(
                          height: 45.0,
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          color: Color.fromRGBO(35, 205, 99, 1),
                          child: Row(
                            children: <Widget>[
                              Text(
                                'View all',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                        color: Colors.white, fontSize: 18.0),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 18.0,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  onTap: () {},
                ),
              ),
              SizedBox(height: (10 / 640) * height),
              TopPicksForYouView(),
              InTheSpotlightView(),
            ],
          ),
        ),
      ],
    );
  }
}

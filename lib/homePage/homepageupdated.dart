import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:frute/AppState.dart';
import 'package:frute/homePage/panelView.dart';
import 'package:frute/homePage/safetyBannerView.dart';
import 'package:frute/models/vegetable.dart';
import 'package:frute/utils/searcher.dart';

import 'filters.dart';
import 'offer_banner_view.dart';

class HomePageUpdated extends StatefulWidget {
  AppState appState;
  Function() onAddedToCart;

  HomePageUpdated({
    Key key,
    @required this.onAddedToCart,
    @required this.appState,
  }) : super(key: key);

  @override
  HomePageUpdatedState createState() => HomePageUpdatedState();
}

class HomePageUpdatedState extends State<HomePageUpdated> {
  double height;

  double width;

  List<Vegetable> topPicks, necessitites, seasonal, other;

  @override
  void initState() {
    super.initState();

    topPicks = getTopPickFilter(widget.appState);
    necessitites = getNecessityFilter(widget.appState);
    seasonal = getSeasonalFilter(widget.appState);
    other = getOtherFilter(widget.appState);
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return ListView(
      shrinkWrap: true,
      primary: false,
      physics: NeverScrollableScrollPhysics(),
      children: [
        SizedBox(height: (70 / 640) * height),
        GestureDetector(
          child: Padding(
            padding: EdgeInsets.only(
                left: (10 / 360) * width, right: (10 / 360) * width),
            child: Neumorphic(
              style: NeumorphicStyle(
                boxShape: NeumorphicBoxShape.roundRect(
                    BorderRadius.circular((50 / (640 * 360)) * height * width)),
                depth: 3,
              ),
              child: Container(
                height: (50 / 640) * height,
                width: (270 / 360) * width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      ((15 / (640 * 360)) * height * width)),
                  color: Color(0xffEAEAEA),
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
                              (50 / (640 * 360)) * height * width)),
                      depth: -2,
                      color: Color(0xffEAEAEA),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: (20 / 411) * width),
                          child: Text(
                            "Search Fruits and Vegetables",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.normal,
                              fontSize: (16 / (640 * 360)) * height * width,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await showSearch(
                              context: context,
                              delegate: SearchItems(
                                avlVegs: widget.appState.avlVegs,
                              ),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                              //left: (25 / 411) * width,
                              right: (5 / 411) * width,
                            ),
                            child: CircleAvatar(
                              backgroundColor: Color(0xff19D660),
                              child: IconButton(
                                icon: Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),
                                onPressed: () {},
                              ),
                            ),
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
              delegate: SearchItems(
                avlVegs: widget.appState.avlVegs,
              ),
            );
          },
        ),
        Padding(
          padding: EdgeInsets.only(
            top: (25 / 640) * height,
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
              /*Padding(
                padding: EdgeInsets.symmetric(vertical: (10 / 820) * height),
                child: SafetyBannerView(),
              ),*/
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: InkWell(
                  child: Container(
                    height: 150.0,
                    color: Color(0xff121C22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Fruits and Veggies',
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
                          color: Color(0xff11181D),
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
              topPicks.length == 0
                  ? SizedBox(
                      height: 0,
                      width: 0,
                      child: Container(),
                    )
                  : PanelView(
                      onPressed: (vegetable) {
                        print('in homePageUpdated() ${vegetable.name}');
                        setState(() {
                          widget.appState.order.add(vegetable);
                        });
                        widget.onAddedToCart();
                      },
                      appState: widget.appState,
                      heading: 'Top Picks',
                      iconData: Icons.thumb_up,
                      foods: topPicks,
                    ),
              necessitites.length == 0
                  ? SizedBox(
                      height: 0,
                      width: 0,
                      child: Container(),
                    )
                  : PanelView(
                      onPressed: (vegetable) {
                        print('in homePageUpdated() ${vegetable.name}');
                        setState(() {
                          widget.appState.order.add(vegetable);
                        });
                        widget.onAddedToCart();
                      },
                      appState: widget.appState,
                      heading: 'Necessities',
                      iconData: Icons.all_inclusive,
                      foods: necessitites,
                    ),
              seasonal.length == 0
                  ? SizedBox(
                      height: 0,
                      width: 0,
                      child: Container(),
                    )
                  : PanelView(
                      onPressed: (vegetable) {
                        print('in homePageUpdated() ${vegetable.name}');
                        setState(() {
                          widget.appState.order.add(vegetable);
                        });
                        widget.onAddedToCart();
                      },
                      appState: widget.appState,
                      heading: 'Seasonals',
                      iconData: Icons.ac_unit,
                      foods: seasonal,
                      circularTabs: true,
                    ),
              other.length == 0
                  ? SizedBox(
                      height: 0,
                      width: 0,
                      child: Container(),
                    )
                  : PanelView(
                      onPressed: (vegetable) {
                        print('in homePageUpdated() ${vegetable.name}');
                        setState(() {
                          widget.appState.order.add(vegetable);
                        });
                        widget.onAddedToCart();
                      },
                      appState: widget.appState,
                      heading: 'Others',
                      iconData: Icons.assignment_turned_in,
                      foods: other,
                      circularTabs: true,
                    ),
            ],
          ),
        ),
      ],
    );
  }
}

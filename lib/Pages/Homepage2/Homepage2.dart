import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:frute/AppState.dart';
import 'package:frute/homePage/panelView.dart';
import 'package:frute/homePage/safetyBannerView.dart';
import 'package:frute/models/vegetable.dart';
import 'package:frute/utils/searcher.dart';

import 'package:frute/homePage/filters.dart';
import 'package:frute/homepage/offer_banner_view.dart';

class HomePage2 extends StatefulWidget {
  AppState appState;
  Function() onAddedToCart;

  HomePage2({
    Key key,
    @required this.onAddedToCart,
    @required this.appState,
  }) : super(key: key);

  @override
  HomePage2State createState() => HomePage2State();
}

class HomePage2State extends State<HomePage2> {
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
        // SizedBox(height: (70 / 640) * height),
        Padding(
          padding: EdgeInsets.all(15),
          child: OfferBannerView(),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
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
                                'Fruits and Vegetables',
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
              SizedBox(height: 20),
              topPicks.length == 0
                  ? SizedBox()
                  : PanelView(
                      onPressed: (vegetable) {
                        print('in HomePage2() ${vegetable.name}');
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
                  ? SizedBox()
                  : PanelView(
                      onPressed: (vegetable) {
                        print('in HomePage2() ${vegetable.name}');
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
                  ? SizedBox()
                  : PanelView(
                      onPressed: (vegetable) {
                        print('in HomePage2() ${vegetable.name}');
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
                  ? SizedBox()
                  : PanelView(
                      onPressed: (vegetable) {
                        print('in HomePage2() ${vegetable.name}');
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

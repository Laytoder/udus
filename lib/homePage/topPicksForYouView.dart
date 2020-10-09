import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'top_picks_food.dart';

class TopPicksForYouView extends StatelessWidget {
  final foods = TopPicksFood.getTopPicksfoods();

  double height;

  double width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(width: (12 / 360) * width),
              //Icon(Icons.thumb_up, size: 20),
              NeumorphicIcon(
                Icons.thumb_up,
                size: (25 / (640 * 360)) * height * width,
                style: NeumorphicStyle(
                  shape: NeumorphicShape.convex,
                  depth: 1,
                  lightSource: LightSource.topLeft,
                  intensity: 0.68,
                  border: NeumorphicBorder(
                    color: Colors.white,
                    width: (0.5 / 360) * width,
                  ),
                  shadowDarkColor: Color(0xffA3B1C6),
                  shadowLightColor: Colors.white,
                  color: Color(0xffAFBBCA),
                ),
              ),
              SizedBox(width: (10 / 360) * width),
              Text(
                'Top Picks For You',
                style: TextStyle(
                  fontSize: (17 / (640 * 360)) * height * width,
                  color: Colors.grey[600],
                ),
              )
            ],
          ),
          SizedBox(height: (10 / 640) * height),
          Container(
            height: (175 / 640) * height,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: foods.length,
              itemBuilder: (context, index) => InkWell(
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.only(
                    top: (10 / 640) * height,
                    bottom: (10 / 640) * height,
                    left: (10 / 360) * width,
                    right: (10 / 360) * width,
                  ),
                  width: (100 / 360) * width,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Neumorphic(
                        style: NeumorphicStyle(
                          depth: 3,
                          lightSource: LightSource.top,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(0),
                            color: Color(0xffE0E5EC),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 2.0,
                              )
                            ],
                          ),
                          child: Image.asset(
                            foods[index].image,
                            width: (100 / 360) * width,
                            height: (100 / 640) * height,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: (10 / 640) * height),
                      Center(
                        child: Text(
                          foods[index].name,
                          style: Theme.of(context).textTheme.subtitle2.copyWith(
                                fontSize: (13 / (640 * 360)) * height * width,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

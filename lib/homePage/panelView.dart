import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:frute/AppState.dart';
import 'package:frute/homePage/panelGridView.dart';
import 'package:frute/models/vegetable.dart';
import 'package:frute/widgets/inputModal.dart';

class PanelView extends StatefulWidget {
  AppState appState;
  String heading;
  IconData iconData;
  bool circularTabs;
  List<Vegetable> foods;
  Function(Vegetable vegetable) onPressed;

  PanelView({
    @required this.appState,
    @required this.heading,
    @required this.iconData,
    @required this.foods,
    @required this.onPressed,
    this.circularTabs = false,
  });

  @override
  _PanelView createState() => _PanelView();
}

class _PanelView extends State<PanelView> {
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
                widget.iconData,
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
                widget.heading,
                style: TextStyle(
                  fontSize: (17 / (640 * 360)) * height * width,
                  color: Colors.grey[600],
                ),
              ),
              Expanded(
                child: Container(),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PanelGridView(
                        title: widget.heading,
                        vegetables: widget.foods,
                        appState: widget.appState,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: (10 / 640) * height),
          Container(
            height: (175 / 640) * height,
            child: ListView.builder(
              shrinkWrap: false,
              scrollDirection: Axis.horizontal,
              itemCount: widget.foods.length,
              itemBuilder: (context, index) => Container(
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
                    InkWell(
                      onTap: () async {
                        double quantity = await showDialog(
                            context: context,
                            builder: (context) {
                              return InputModal();
                            });
                        if (quantity == null) return;
                        /*setState(() {
                          Vegetable vegetable = widget.foods[index];
                          vegetable.quantity = quantity;
                          widget.appState.order.purchasedVegetables
                              .add(vegetable);
                        });*/
                        Vegetable vegetable = widget.foods[index];
                        vegetable.quantity = quantity;
                        widget.onPressed(vegetable);
                      },
                      child: Neumorphic(
                        style: NeumorphicStyle(
                          depth: 3,
                          lightSource: LightSource.top,
                          boxShape: widget.circularTabs
                              ? NeumorphicBoxShape.circle()
                              : NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(10)),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: widget.circularTabs
                                ? null
                                : BorderRadius.circular(0),
                            shape: widget.circularTabs
                                ? BoxShape.circle
                                : BoxShape.rectangle,
                            color: Color(0xffE0E5EC),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 2.0,
                              )
                            ],
                          ),
                          child: Image.asset(
                            widget.foods[index].imageUrl,
                            width: (100 / 360) * width,
                            height: (100 / 640) * height,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: (10 / 640) * height),
                    Center(
                      child: Text(
                        widget.foods[index].name,
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
          )
        ],
      ),
    );
  }
}

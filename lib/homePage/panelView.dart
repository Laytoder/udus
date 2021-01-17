import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:frute/AppState.dart';
import 'package:frute/homePage/panelGridView.dart';
import 'package:frute/models/vegetable.dart';
import 'package:frute/widgets/inputModal.dart';
import 'package:frute/config/borderRadius.dart';

class PanelView extends StatefulWidget {
  final AppState appState;
  final String heading;
  final IconData iconData;
  final bool circularTabs;
  final List<Vegetable> foods;
  final Function(Vegetable vegetable) onPressed;

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
  //double height;
  //double width;

  @override
  Widget build(BuildContext context) {
    //height = MediaQuery.of(context).size.height;
    //width = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(width: 12),
              Icon(widget.iconData),
              SizedBox(width: 10),
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  widget.heading,
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward_outlined),
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
          SizedBox(height: 10),
          Container(
            height: 175,
            child: ListView.builder(
              shrinkWrap: false,
              scrollDirection: Axis.horizontal,
              itemCount: widget.foods.length,
              itemBuilder: (context, index) => Container(
                margin: EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  left: 10,
                  right: 10,
                ),
                width: 100,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        double quantity = await showDialog(
                            context: context,
                            builder: (context) {
                              return InputModal(vegetable: widget.foods[index]);
                            });
                        if (quantity == null) return;
                        Vegetable vegetable = widget.foods[index];
                        vegetable.quantity = quantity;
                        //this only works for kg and g incorporate
                        //piece wise as well
                        //will need to make changes in inputModal
                        //use switch case to manage
                        //because there are also units like /250g
                        if (quantity >= 1) {
                          vegetable.dispQuantity = '$quantity kg';
                        } else {
                          vegetable.dispQuantity = '${quantity * 1000} g';
                        }
                        vegetable.isSelected = true;
                        widget.onPressed(vegetable);
                      },
                      child: Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: widget.circularTabs
                                  ? null
                                  : UdusBorderRadius.small,
                              shape: widget.circularTabs
                                  ? BoxShape.circle
                                  : BoxShape.rectangle,
                              image: DecorationImage(
                                image: AssetImage(widget.foods[index].imageUrl),
                                fit: BoxFit.cover,
                              ),
                              //color: Color(0xffE0E5EC),
                              //color: Colors.grey[100],
                            ),
                            /*child: Image.asset(
                              widget.foods[index].imageUrl,
                              width: (100 / 360) * width,
                              height: (100 / 640) * height,
                              fit: BoxFit.cover,
                            ),*/
                          ),
                          widget.foods[index].isSelected
                              ? Opacity(
                                  opacity: 0.5,
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: widget.circularTabs
                                          ? null
                                          : UdusBorderRadius.small,
                                      shape: widget.circularTabs
                                          ? BoxShape.circle
                                          : BoxShape.rectangle,
                                      color: Colors.black,
                                    ),
                                    child: Center(
                                      child: Text(
                                        widget.foods[index].dispQuantity,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  height: 0,
                                  width: 0,
                                  child: Container(),
                                ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        widget.foods[index].name,
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                              fontSize: 14,
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

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:frute/AppState.dart';
import 'package:frute/homePage/panelGridView.dart';
import 'package:frute/models/vegetable.dart';
import 'package:frute/widgets/inputModal.dart';

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
              Icon(widget.iconData),
              SizedBox(width: (10 / 360) * width),
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  widget.heading,
                  style: TextStyle(
                    fontSize: (17 / (640 * 360)) * height * width,
                    color: Colors.grey[600],
                  ),
                ),
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
                        Vegetable vegetable = widget.foods[index];
                        vegetable.quantity = quantity;
                        widget.onPressed(vegetable);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: widget.circularTabs
                              ? null
                              : BorderRadius.circular(0),
                          shape: widget.circularTabs
                              ? BoxShape.circle
                              : BoxShape.rectangle,
                          color: Color(0xffE0E5EC),
                        ),
                        child: Image.asset(
                          widget.foods[index].imageUrl,
                          width: (100 / 360) * width,
                          height: (100 / 640) * height,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: (10 / 640) * height),
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

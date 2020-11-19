import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class DualButton extends StatefulWidget {
  double height, padding, width, radius, textSize;
  Function() onNowClicked, onDropInClicked;

  DualButton({
    @required this.height,
    @required this.width,
    @required this.padding,
    @required this.radius,
    @required this.onNowClicked,
    @required this.onDropInClicked,
    @required this.textSize,
  });

  @override
  _DualButtonState createState() => _DualButtonState();
}

class _DualButtonState extends State<DualButton>
    with SingleTickerProviderStateMixin {
  var _transformRight;

  var _transformLeft = Matrix4.identity();
  bool _shouldTransformRight = false;
  AnimationController controller;
  Animation<Color> anim1, anim2;

  @override
  void initState() {
    super.initState();
    double value = (widget.width / 2) - (widget.padding);
    /*((widget.height - (2 * widget.padding)) / 2) -
        widget.padding);*/
    _transformRight = Matrix4.identity()..translate(value);
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    )..addListener(() {
        setState(() {});
      });

    anim2 = ColorTween(
      begin: Color.fromRGBO(13, 47, 61, 1),
      end: Colors.white,
    ).animate(controller);

    anim1 = ColorTween(
      begin: Colors.white,
      end: Color.fromRGBO(13, 47, 61, 1),
    ).animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Neumorphic(
          style: NeumorphicStyle(
            shape: NeumorphicShape.concave,
            boxShape: NeumorphicBoxShape.roundRect(
              BorderRadius.circular(widget.radius),
            ),
            depth: -3,
            lightSource: LightSource.topLeft,
            border: NeumorphicBorder(
              color: Colors.white,
              width: 0.5,
            ),
            //color: Colors.white,
            color: Color(0xffE0E5EC),
          ),
          child: Container(
            //height: 50,
            //width: 320,
            height: widget.height,
            width: widget.width,
            decoration: BoxDecoration(
              //color: Color(0xffdd4f41),
              /*gradient:
                LinearGradient(colors: [Color(0xff25D366), Color(0xff2ca85b)]),*/
              //color: Color.fromRGBO(13, 47, 61, 1),
              borderRadius: BorderRadius.circular(widget.radius),
            ),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: AnimatedContainer(
                    /*width: (((widget.width / 2) +
                          ((widget.height - (2 * widget.padding)) / 2) -
                          widget.padding)) -
                      (widget.height - (2 * widget.padding)),*/
                    width: widget.width / 2 - widget.padding,
                    margin: EdgeInsets.only(
                        left: widget.padding, right: widget.padding),
                    height: (widget.height - (2 * widget.padding)),
                    duration: Duration(milliseconds: 200),
                    child: Neumorphic(
                      style: NeumorphicStyle(
                        boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(widget.radius - widget.padding),
                        ),
                        border: NeumorphicBorder(
                          width: 0.5,
                          //color: Colors.white,
                        ),
                        shadowLightColor: Colors.transparent,
                        shape: NeumorphicShape.convex,
                        color: Color.fromRGBO(35, 205, 99, 1),
                        depth: 20,
                      ),
                    ),
                    decoration: BoxDecoration(
                      //color: Color.fromRGBO(13, 47, 61, 1),
                      //color: Colors.cyan,
                      //color: Color(0xff25D366),
                      color: Color.fromRGBO(35, 205, 99, 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 4,
                        ),
                      ],
                      //You can create a variable to unify the
                      //borderRadius for all containers.
                      borderRadius:
                          BorderRadius.circular(widget.radius - widget.padding),
                    ),
                    transform: _shouldTransformRight
                        ? _transformRight
                        : _transformLeft,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: FlatButton(
                        color: Colors.transparent,
                        padding: EdgeInsets.all(0.0),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: () {
                          setState(() {
                            controller.reverse();
                            widget.onNowClicked();
                            _shouldTransformRight = false;
                          });
                        },
                        child: Center(
                          child: Text(
                            'Now',
                            style: TextStyle(
                              //backgroundColor: anim1.value,
                              fontWeight: FontWeight.w400,
                              color: anim1.value,
                              fontSize: widget.textSize,
                            ),
                          ),
                        ),
                      ),
                    ),
                    /*Align(
                    alignment: Alignment.center,
                    /*child: Icon(
                      Icons.shopping_cart,
                      color: Colors.black,
                    ),*/
                    child: Container(
                      width: (widget.height - (2 * widget.padding)),
                      height: (widget.height - (2 * widget.padding)),
                    ),
                  ),*/
                    Expanded(
                      child: FlatButton(
                        onPressed: () {
                          setState(() {
                            controller.forward();
                            widget.onDropInClicked();
                            _shouldTransformRight = true;
                          });
                        },
                        color: Colors.transparent,
                        padding: EdgeInsets.all(0.0),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Center(
                          child: Text(
                            'Drop-In',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: anim2.value,
                              fontSize: widget.textSize,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        onHorizontalDragEnd: (DragEndDetails details) {
          if (details.primaryVelocity > 0) {
            setState(() {
              _shouldTransformRight = true;
              widget.onDropInClicked();
              controller.forward();
            });
          } else if (details.primaryVelocity < 0) {
            setState(() {
              _shouldTransformRight = false;
              widget.onNowClicked();
              controller.reverse();
            });
          }
        });
  }
}

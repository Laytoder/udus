import 'package:flutter/material.dart';

class DualSlideButton extends StatefulWidget {
  final double width;
  final void Function(double value) onDrag;
  final void Function() onDragEnd;

  DualSlideButton({@required this.width, this.onDrag, this.onDragEnd});
  @override
  _DualSlideButtonState createState() => _DualSlideButtonState();
}

class _DualSlideButtonState extends State<DualSlideButton>
    with TickerProviderStateMixin {
  AnimationController _rightController, _leftController;

  @override
  void initState() {
    super.initState();
    _rightController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _leftController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _rightController.value = 0.2;
    _leftController.value = 0.2;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _rightController
        ..addListener(() {
          setState(() {});

          if (widget.onDrag != null) widget.onDrag(_rightController.value);
          if (widget.onDragEnd != null) widget.onDragEnd();
        });

      _leftController
        ..addListener(() {
          setState(() {});

          if (widget.onDrag != null) widget.onDrag(_leftController.value);
          if (widget.onDragEnd != null) widget.onDragEnd();
        });
    });
  }

  onRightDragEnd() {
    if (_rightController.isAnimating) return;

    if (_rightController.value > 0.5) {
      _rightController.fling(velocity: 1.0);
    } else {
      _rightController.animateTo(0.2,
          duration: Duration(milliseconds: 300), curve: Curves.fastOutSlowIn);
    }
  }

  onLeftDragEnd() {
    if (_leftController.isAnimating) return;

    if (_leftController.value > 0.5) {
      _leftController.fling(velocity: 1.0);
    } else {
      _leftController.animateTo(0.2,
          duration: Duration(milliseconds: 300), curve: Curves.fastOutSlowIn);
    }
  }

  onDrag(BuildContext context, DragUpdateDetails details) {
    RenderBox box = context.findRenderObject();
    Offset offset = box.globalToLocal(details.globalPosition);
    /*double value = (offset.dx) / 320;
    double x = (1 / (0.5 + (22.5 / 320)));
    //left region
    if (value >= 0 && value <= (0.5 + (22.5 / 320))) {
      _leftController.value = 1 - (value * x) < 0.2 ? 0.2 : 1 - (value * x);
    }
    //right region
    if (value >= (0.5 - (22.5 / 320)) && value <= 1) {
      _rightController.value = (value + (22.5 / 320) - 0.5) * x < 0.2
          ? 0.2
          : (value + (22.5 / 320) - 0.5) * x;
    }*/
    double value = (offset.dx) / widget.width;
    double x = (1 / (0.5 + (((widget.width / 13) * 0.75) / widget.width)));
    //left region
    if (value >= 0 &&
        value <= (0.5 + (((widget.width / 13) * 0.75) / widget.width))) {
      _leftController.value = 1 - (value * x) < 0.2 ? 0.2 : 1 - (value * x);
    }
    //right region
    if (value >= (0.5 - (((widget.width / 13) * 0.75) / widget.width)) &&
        value <= 1) {
      _rightController.value = (value + (22.5 / 320) - 0.5) * x < 0.2
          ? 0.2
          : (value + (22.5 / 320) - 0.5) * x;
    }
  }

  onDragEnd() {
    onRightDragEnd();
    onLeftDragEnd();
  }

  @override
  void dispose() {
    super.dispose();
    _rightController.dispose();
    _leftController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var panelHeight = (widget.width) / 6.5;
    return Container(
      //padding: EdgeInsets.all(20.0),
      //height: 50,
      //width: 320,
      width: widget.width,
      height: (widget.width) / 6.5,
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              /*margin: EdgeInsets.only(left: 2.5),
                  height: 45,
                  width: 180,*/
              margin: EdgeInsets.only(left: widget.width / 52),
              height: (widget.width / 6.5) * 0.75,
              width: (widget.width / 2) + ((widget.width / 13) * 0.75),
              //color: Colors.grey,
              child: Align(
                alignment: Alignment.centerRight,
                child: FractionallySizedBox(
                  heightFactor: 1.0,
                  widthFactor: _leftController.value,
                  child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          color: Color(0xffffb300))),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              /*margin: EdgeInsets.only(right: 2.5),
                  height: 45,
                  width: 180,*/
              margin: EdgeInsets.only(right: widget.width / 52),
              height: (widget.width / 6.5) * 0.75,
              width: (widget.width / 2) + ((widget.width / 13) * 0.75),
              color: Colors.transparent,
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  heightFactor: 1.0,
                  widthFactor: _rightController.value,
                  child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          color: Color(0xffffb300))),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              /*
                  height: 45,
                  width: 45,
                  */
              height: (widget.width / 6.5) * 0.75,
              width: (widget.width / 6.5) * 0.75,
              //color: Colors.grey,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  color: Color(0xffffb300)),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Text(
                    'Drop-In',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: (panelHeight * 14) / 49.23076923076923,
                    ),
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.center,
                  child: Icon(Icons.shopping_cart)),
              Expanded(
                child: Center(
                  child: Text(
                    'Now',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: (panelHeight * 14) / 49.23076923076923,
                    ),
                  ),
                ),
              )
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onHorizontalDragUpdate: (details) => onDrag(context, details),
              onHorizontalDragEnd: (_) => onDragEnd(),
              child: Container(
                margin: EdgeInsets.only(
                    left: widget.width / 52, right: widget.width / 52),
                /*height: 45,
                    width: 320,*/
                height: (widget.width / 6.5) * 0.75,
                width: widget.width,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    color: Colors.transparent),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

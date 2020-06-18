import 'package:flutter/material.dart';

class DualButton extends StatefulWidget {
  @override
  _DualButtonState createState() => _DualButtonState();
}

class _DualButtonState extends State<DualButton> {
  final _transformRight = Matrix4.identity()..translate(130.0);

  final _transformLeft = Matrix4.identity();
  bool _shouldTransformRight = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Stack(
            children: <Widget>[
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  //You can create a variable to unify the
                  //borderRadius for all containers.
                  borderRadius: BorderRadius.circular(15.0),
                ),
                transform:
                    _shouldTransformRight ? _transformRight : _transformLeft,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Text(
                        'Reservation',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Icon(Icons.attach_money),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Now',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        onHorizontalDragEnd: (details) {
          setState(() {
            _shouldTransformRight = !_shouldTransformRight;
          });
        });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:frute/Animations/FadeAnimations.dart';

class InputModal extends StatefulWidget {
  @override
  _InputModalState createState() => _InputModalState();
}

class _InputModalState extends State<InputModal> {
  double quantity = 0.0;
  double width, height;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return FadeAnimation(
      1,
      AlertDialog(
        title: Text('Tomato'),
        content: Column(
          children: [
            CircleAvatar(
              maxRadius: 100,
              minRadius: 50,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage('assets/tomato.png'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
            ),
            Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.start,
              spacing: 10,
              runSpacing: 20,
              children: [
                QuantityDialog(50),
                QuantityDialog(100),
                QuantityDialog(250),
                QuantityDialog(500),
                QuantityDialog(1000),
                QuantityDialog(1500),
                QuantityDialog(2000),
                QuantityDialog(3000),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class QuantityDialog extends StatefulWidget {
  int val;
  QuantityDialog(
    this.val,
  );
  @override
  _QuantityDialogState createState() => _QuantityDialogState();
}

class _QuantityDialogState extends State<QuantityDialog> {
  double height;

  double width;

  int selectedIndex = 0;

  @override
  Widget build(BuildContext lowercontext) {
    height = MediaQuery.of(lowercontext).size.height;
    width = MediaQuery.of(lowercontext).size.width;
    return GestureDetector(
      child: Container(
        child: Neumorphic(
          style: NeumorphicStyle(
            shape: NeumorphicShape.convex,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
            depth: 8,
            lightSource: LightSource.topLeft,
            color: Color(0xffE0E5EC),
          ),
          child: Container(
            height: (50 / 820) * height,
            width: (60 / 411) * width,
            child: Center(
              child: widget.val >= 1000
                  ? Text('${widget.val / 1000} kg')
                  : Text('${widget.val} g'),
            ),
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context).pop(widget.val.toDouble());
      },
    );
  }
}

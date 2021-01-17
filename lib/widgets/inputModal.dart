import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frute/Animations/FadeAnimations.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:frute/config/borderRadius.dart';
import 'package:frute/models/vegetable.dart';

class InputModal extends StatefulWidget {
  Vegetable vegetable;
  InputModal({@required this.vegetable});
  @override
  _InputModalState createState() => _InputModalState();
}

class _InputModalState extends State<InputModal> {
  double quantity = 0.0;
  double width, height;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //width = MediaQuery.of(context).size.width;
    //height = MediaQuery.of(context).size.height;
    return FadeAnimation(
      1,
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: UdusBorderRadius.medium,
        ),
        title: Text(widget.vegetable.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              maxRadius: 100,
              minRadius: 50,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage(widget.vegetable.imageUrl),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
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
            SizedBox(
              height: 15,
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
    //height = MediaQuery.of(lowercontext).size.height;
    //width = MediaQuery.of(lowercontext).size.width;
    return GestureDetector(
      child: Container(
        height: 45,
        width: 55,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: UdusBorderRadius.small,
        ),
        child: Center(
          child: widget.val >= 1000
              ? Text(
                  '${widget.val / 1000} kg',
                  style: TextStyle(
                    fontSize: 11.5,
                  ),
                )
              : Text(
                  '${widget.val} g',
                  style: TextStyle(
                    fontSize: 11.5,
                  ),
                ),
        ),
      ),
      onTap: () {
        Navigator.of(context).pop(widget.val / 1000);
      },
    );
  }
}

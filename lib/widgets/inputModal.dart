import 'package:flutter/material.dart';
import 'package:frute/Animations/FadeAnimations.dart';

class InputModal extends StatefulWidget {
  @override
  _InputModalState createState() => _InputModalState();
}

class _InputModalState extends State<InputModal> {
  double quantity;
  double width, height;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return FadeAnimation(
      1,
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            (25 / (640 * 360)) * height * width,
          ),
        ),
        backgroundColor: Color(0xffe7e6e1),
        elevation: 100.0,
        title: Text(
          'Enter Quatity',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: (50 / 360) * width,
                  height: (10 / 640) * height,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter quantity (kg)',
                  ),
                  onSaved: (val) {
                    quantity = double.parse(val);
                  },
                  validator: (val) {
                    if (val.isEmpty) {
                      return 'Enter Some Value';
                    }
                    if (double.tryParse(val) == null) {
                      return 'enter a valid quantity';
                    }
                    if(double.tryParse(val) == 0.0) {
                      return 'Field cannot be zero';
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          SizedBox(
            width: (100 / 360) * width,
            height: (50 / 640) * height,
          ),
          RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular((30 / (360 * 640)) * width * height),
                side: BorderSide(color: Color(0xff23cd63))),
            child: Text('Submit', textAlign: TextAlign.center),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                Navigator.of(context).pop(quantity);
              }
            },
          ),
        ],
      ),
    );
  }
}

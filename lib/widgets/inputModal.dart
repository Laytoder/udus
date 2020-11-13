import 'package:bi_counter_field/bi_counter_field.dart';
import 'package:flutter/material.dart';
import 'package:frute/Animations/FadeAnimations.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            (25 / (640 * 360)) * height * width,
          ),
        ),
        backgroundColor: Color(0xffe7e6e1),
        elevation: 100.0,
        title: Text(
          'Enter Quantity',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        /*content: SfSlider(
          min: 50.0,
          max: 5000.0,
          value: quantity,
          interval: 50,
          //showTicks: true,
          //showLabels: true,
          showTooltip: true,
          stepSize: 50.0,
          onChanged: (dynamic value) {
            setState(() {
              quantity = value;
            });
          },
        ),*/
        /*content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NumberPicker.integer(
              initialValue: 0,
              minValue: 0,
              maxValue: 9,
              onChanged: (value) {},
              listViewWidth: 40,
            ),
            NumberPicker.integer(
              initialValue: 5,
              minValue: 5,
              maxValue: 10,
              onChanged: (value) {},
              listViewWidth: 40,
            ),
            NumberPicker.integer(
              initialValue: 0,
              minValue: 0,
              maxValue: 10,
              onChanged: (value) {},
              listViewWidth: 40,
            ),
          ],
        ),*/
        /*content: TextFormField(
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-5]')),
          ],
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Enter Price',
          ),
          onSaved: (val) {
            //price = double.parse(val);
          },
          validator: (val) {
            /*if (val.isEmpty) {
              return 'Enter Some Value';
            }
            if (double.tryParse(val) == null) {
              return 'enter a valid price';
            }
            if (unitLabel == null) return 'enter a valid unit';*/
          },
        ),*/
        content: Wrap(
          children: [
            PinCodeTextField(
              textInputType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-5]')),
              ],
              length: 3,
              onChanged: null,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.underline,
                fieldHeight: (50 / 678) * height,
                fieldWidth: (60 / 678) * height,
                inactiveColor: Colors.black,
                activeColor: Colors.black,
                selectedColor: Colors.grey[400],
              ),
              autoDisposeControllers: false,
              backgroundColor: Colors.transparent,
              enableActiveFill: false,
              onCompleted: (otp) async {},
              animationType: AnimationType.fade,
              autoFocus: false,
              controller: controller,
              onSubmitted: (quantity){
                Navigator.of(context).pop(double.parse(quantity));
              },
            ),
            Text('Grams'),
          ],
        )
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:frute/AppState.dart';
import 'package:frute/Pages/phoneNumPage.dart';
import 'package:frute/widgets/pageHeading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/pageHeading.dart';

class NamePage extends StatefulWidget {
  AppState appState;

  NamePage(this.appState);

  @override
  _NamePageState createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController controller = TextEditingController();
  double width, height;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xffE0E5EC),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: (20 / 678) * height,
            ),
            child: PageHeading(
              "Hi There \nThis is Hawfer ! \nWhat's your name?",
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(),
          ),
          Container(
            width: 320,
            child: Neumorphic(
              style: NeumorphicStyle(
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(30)),
                depth: -3,
              ),
              padding: EdgeInsets.only(
                left: (20 / 360) * width,
                right: (20 / 360) * width,
              ),
              child: Form(
                key: formKey,
                child: TextFormField(
                  controller: controller,
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: 'Name',
                    border: InputBorder.none,
                    errorStyle: TextStyle(
                      color: Colors.red,
                      fontSize: (12 / 678) * height,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Ubuntu',
                    ),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: (12 / 678) * height,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Ubuntu',
                    ),
                  ),
                  validator: (value) {
                    if (value.isEmpty) return 'Please specify a name';
                  },
                  onSaved: (value) async {
                    widget.appState.clientName = value;
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    preferences.setString('clientName', value);
                  },
                ),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(),
          ),
          Container(
            width: width,
            height: (50 / 678) * height,
            margin: EdgeInsets.only(
              left: (40 / 360) * width,
              right: (40 / 360) * width,
              bottom: (20 / 678) * height,
            ),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular((80 / 678) * height),
              ),
              padding: EdgeInsets.all(0.0),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    new BoxShadow(
                      color: Color.fromRGBO(35, 205, 99, 0.2),
                    ),
                  ],
                  color: Color.fromRGBO(35, 205, 99, 1),
                  borderRadius: BorderRadius.all(
                    Radius.circular((40 / 678) * height),
                  ),
                ),
                width: width,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Continue',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: (20 / 678) * height,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Ubuntu',
                    ),
                  ),
                ),
              ),
              onPressed: () async {
                if (formKey.currentState.validate()) {
                  formKey.currentState.save();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PhoneNumPage(widget.appState),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

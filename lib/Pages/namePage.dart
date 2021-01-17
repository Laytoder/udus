import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:frute/AppState.dart';
import 'package:frute/Pages/phoneNumPage.dart';
import 'package:frute/widgets/pageHeading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/pageHeading.dart';
import 'package:frute/config/borderRadius.dart';

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
      backgroundColor: Colors.white,
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: 20,
            ),
            child: PageHeading(
              "Hi There! \nThis is udus -:) \nWhat's your name?",
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(),
          ),
          Container(
            width: (320 / 360) * width,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: UdusBorderRadius.large,
            ),
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
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
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Ubuntu',
                  ),
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
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
          Expanded(
            flex: 6,
            child: Container(),
          ),
          Container(
            width: width,
            height: 50,
            margin: EdgeInsets.only(
              left: 40,
              right: 40,
              bottom: 20,
            ),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(80),
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
                    Radius.circular(40),
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
                      fontSize: 20,
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

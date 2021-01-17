import 'package:flutter/material.dart';
import 'package:frute/AppState.dart';
import 'package:frute/widgets/pageHeading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frute/config/borderRadius.dart';
import 'package:frute/config/colors.dart';

class EditName extends StatefulWidget {
  AppState appState;

  EditName({
    @required this.appState,
  });

  @override
  _EditNameState createState() => _EditNameState();
}

class _EditNameState extends State<EditName> {
  TextEditingController controller = TextEditingController();
  //double height, width;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //height = MediaQuery.of(context).size.height;
    //width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 8,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        right: 8,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SafeArea(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                PageHeading('Edit Name'),
                Expanded(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                            left: 20,
                            right: 20,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(
                              30,
                            ),
                            border: Border.all(
                              color: UdusColors.primaryColor,
                            ),
                          ),
                          child: ListTile(
                            title: Text(
                              'Current Name',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              widget.appState.clientName,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: UdusBorderRadius.large,
                            color: Colors.grey[100],
                          ),
                          margin: EdgeInsets.only(
                            left: 20,
                            right: 20,
                          ),
                          padding: EdgeInsets.only(
                            left: 20,
                            right: 20,
                          ),
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              controller: controller,
                              autofocus: true,
                              decoration: InputDecoration(
                                hintText: 'New Name',
                                border: InputBorder.none,
                                errorStyle: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                ),
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                ),
                              ),
                              validator: (value) {
                                if (value.isEmpty)
                                  return 'Please specify a new name';
                              },
                              onSaved: (value) async {
                                widget.appState.clientName = value;
                                SharedPreferences preferences =
                                    widget.appState.preferences;
                                preferences.setString('clientName', value);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

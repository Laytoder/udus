import 'package:flutter/material.dart';
import 'package:frute/AppState.dart';
import 'package:frute/widgets/pageHeading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditNameLayout extends StatefulWidget {
  AppState appState;
  GlobalKey<FormState> formKey;
  EditNameLayout({
    @required this.appState,
    @required this.formKey,
  });

  @override
  _EditNameLayoutState createState() => _EditNameLayoutState();
}

class _EditNameLayoutState extends State<EditNameLayout>
    with SingleTickerProviderStateMixin {
  TextEditingController controller = TextEditingController();
  double height, width;

  @override
  void dispose() {
    //SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: height * 0.87,
      child: Column(
        children: <Widget>[
          PageHeading('Edit Name'),
          Expanded(
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                      left: (20 / 360) * width,
                      right: (20 / 360) * width,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(
                        (30 / 678) * height,
                      ),
                    ),
                    child: ListTile(
                      title: Text(
                        'Current Name',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: (16 / 678) * height,
                        ),
                      ),
                      subtitle: Text(
                        widget.appState.clientName,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: (14 / 678) * height,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: (30 / 678) * height,
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: (20 / 360) * width,
                      right: (20 / 360) * width,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(
                        (30 / 678) * height,
                      ),
                    ),
                    padding: EdgeInsets.only(
                      left: (20 / 360) * width,
                      right: (20 / 360) * width,
                    ),
                    child: Form(
                      key: widget.formKey,
                      child: TextFormField(
                        controller: controller,
                        autofocus: true,
                        decoration: InputDecoration(
                          labelText: 'New Name',
                          border: InputBorder.none,
                          errorStyle: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w400,
                            fontSize: (12 / 678) * height,
                          ),
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: (12 / 678) * height,
                          ),
                        ),
                        validator: (value) {
                          if (value.isEmpty) return 'Please specify a new name';
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:frute/AppState.dart';
import 'package:frute/widgets/MinimalPageHeading.dart';
import 'EditName.dart';
import 'EditPhone.dart';
import 'orderPage.dart';
import 'package:frute/Pages/homebuilder.dart';

class ProfilePage extends StatefulWidget {
  //final PageController controller;
  final AppState appState;

  ProfilePage({
    //@required this.controller,
    @required this.appState,
  });

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  double height, width;

  // String state = 'profile';
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  buildTrailingLogo(InfoState infoState) {
    if (infoState == InfoState.edit) return Icon(Icons.edit_outlined);
    if (infoState == InfoState.visit)
      return Icon(Icons.keyboard_arrow_right_outlined);
    if (infoState == InfoState.editing) return Icon(Icons.check);
    if (infoState == InfoState.readOnly) return null;
  }

  Widget buildAvatar() {
    return CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: 50,
      child: Icon(
        Icons.account_circle_sharp,
        size: 100,
        color: Colors.grey[800],
      ),
    );
  }

  Widget buildProfileItemHeading(String label) {
    if (label != null)
      return Padding(
        padding: const EdgeInsets.only(left: 16, top: 10),
        child: Text(
          label,
          style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 16),
        ),
      );
    return SizedBox();
  }

  Widget buildCard(String label, Widget childWidget) {
    return Container(
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Colors.grey[100], width: 1)),
            color: Colors.white),
        width: width,
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Wrap(
          // direction: Axis.vertical,
          children: [buildProfileItemHeading(label), childWidget],
        ));
  }

  Widget buildProfileItem(String displayValue, InfoState infoState,
      {@required IconData leadingIcon,
      bool isEditing,
      Function callback,
      String label}) {
    isEditing = isEditing ?? false;
    return buildCard(
        label,
        ListTile(
          leading: Icon(leadingIcon),
          title:
              isEditing ? Text("editing") : Text(displayValue ?? "Not added"),
          trailing: buildTrailingLogo(infoState),
          onTap: callback,
        ));
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              MinimalPageHeading(heading: "Profile"),
              buildAvatar(),
              SizedBox(height: 20),
              buildProfileItem(
                widget.appState.clientName, InfoState.edit,
                // label: "Name",
                leadingIcon: Icons.face_outlined,
                callback: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditName(
                        appState: widget.appState,
                      ),
                    ),
                  );
                },
              ),
              buildProfileItem(
                widget.appState.phoneNumber, InfoState.edit,
                // label: "Phone",
                leadingIcon: Icons.phone_android_outlined,
                isEditing: false,
                callback: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditPhone(
                        appState: widget.appState,
                      ),
                    ),
                  );
                },
              ),
              buildProfileItem(
                "Orders",
                InfoState.visit,
                leadingIcon: Icons.shopping_bag_outlined,
                callback: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderPage(
                        appState: widget.appState,
                      ),
                    ),
                  );
                },
              ),
              buildProfileItem(
                "mange Addresses",
                InfoState.visit,
                leadingIcon: Icons.business_outlined,
                callback: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeBuilder(
                        widget.appState,
                        state: 'edit',
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

enum InfoState { edit, visit, readOnly, editing }

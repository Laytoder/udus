import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:frute/AppState.dart';
import 'package:frute/Pages/homePage.dart';
import 'package:frute/Pages/homebuilder.dart';
import 'package:frute/helpers/tripCompleter.dart';
import 'package:frute/models/vegetable.dart';
import 'package:frute/widgets/pageHeading.dart';
import 'package:slider_button/slider_button.dart';

class BillPage extends StatefulWidget {
  List<Vegetable> vegetables;
  double total;
  AppState appState;
  String state, date;
  PageController controller;
  BillPage({
    @required this.state,
    @required this.vegetables,
    @required this.total,
    this.controller,
    //this.vendorId,
    this.appState,
    this.date,
  });
  @override
  _BillPageState createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> {
  TripCompleter tripCompleter = TripCompleter();
  bool loading = false;
  String vendorId;
  double height, width;

  @override
  void initState() {
    super.initState();
    vendorId = widget.appState.pendingTrip == null
        ? null
        : widget.appState.pendingTrip.vendorId;
  }

  selectImageType(String link) {
    if (link.startsWith('https'))
      return NetworkImage(link);
    else
      return AssetImage(link);
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Color(0xffE0E5EC),
        /*appBar: AppBar(
          backgroundColor: Color(0xffE0E5EC),
          centerTitle: true,
          title: widget.state == 'Verification'
              ? Text(
                  'Verify bill',
                  style: TextStyle(fontSize: (14 / 678) * height),
                )
              : ListTile(
                  contentPadding: EdgeInsets.only(
                    top: 10,
                  ),
                  title: Text(
                    'Bill details',
                    style: TextStyle(
                      fontSize: (28 / 678) * height,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w300,
                      letterSpacing: 1,
                    ),
                  ),
                  subtitle: Text(widget.date),
                ),
          bottomOpacity: 0.0,
          elevation: 0.0,
          leading: widget.state == 'Verification'
              ? null
              : IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: (24 / 678) * height,
                  ),
                  onPressed: () {
                    widget.controller.animateToPage(0,
                        duration: Duration(milliseconds: 1000),
                        curve: Curves.fastLinearToSlowEaseIn);
                  },
                ),
          actions: widget.state == 'Verification'
              ? <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.check,
                      size: (24 / 678) * height,
                    ),
                    onPressed: () async {
                      setState(() => loading = true);
                      await tripCompleter.completeTrip(widget.vegetables,
                          widget.total, vendorId, widget.appState);
                      setState(() => loading = false);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeBuilder(widget.appState)),
                      );
                    },
                  ),
                ]
              : null,
        ),*/
        body: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: <Widget>[
                  widget.state == 'Verification'
                      ? SizedBox(
                          height: 0,
                          width: 0,
                          child: Container(),
                        )
                      : Align(
                          alignment: Alignment.topLeft,
                          child: GestureDetector(
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: (35 / 678) * height,
                                left: (13 / 360) * width,
                              ),
                              child: Neumorphic(
                                style: NeumorphicStyle(
                                  boxShape: NeumorphicBoxShape.circle(),
                                  shape: NeumorphicShape.flat,
                                  depth: 3,
                                  /*border: NeumorphicBorder(
                                          color: Colors.white,
                                          width: 0.2,
                                        ),*/
                                  color: Color(0xffE0E5EC),
                                ),
                                child: Container(
                                  height: (40 / 678) * height,
                                  width: (40 / 678) * height,
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: Color.fromRGBO(35, 205, 99, 1.0),
                                    size: (24 / 678) * height,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              widget.controller.animateToPage(0,
                                  duration: Duration(milliseconds: 1000),
                                  curve: Curves.fastLinearToSlowEaseIn);
                            },
                          ),
                        ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          top: (50 / 678) * height,
                          left: (16 / 360) * width,
                          right: (16 / 360) * width,
                          bottom: (10 / 678) * height,
                        ),
                        child: Text(
                          "Bill Details",
                          style: TextStyle(
                              fontSize: (36 / 678) * height,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w300,
                              letterSpacing: 1),
                        ),
                      ),
                      widget.state == 'Verification'
                          ? SizedBox(
                              height: 0,
                              width: 0,
                              child: Container(),
                            )
                          : Text(
                              widget.date,
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                      Expanded(
                        flex: 20,
                        child: ListView.builder(
                          itemCount: widget.vegetables.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: selectImageType(
                                    widget.vegetables[index].imageUrl),
                                radius: (20 / 678) * height,
                              ),
                              title: Wrap(
                                direction: Axis.horizontal,
                                children: <Widget>[
                                  Text(
                                    widget.vegetables[index].name,
                                    style: TextStyle(
                                      fontFamily: 'Ubuntu',
                                      fontSize: (16 / 678) * height,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                widget.vegetables[index].quantity.toString() +
                                    'kg',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: (14 / 678) * height,
                                  fontFamily: 'Ubuntu',
                                ),
                              ),
                              trailing: Text(
                                '\u20B9' +
                                    widget.vegetables[index].price.toString() +
                                    '/kg',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: (14 / 678) * height,
                                  fontFamily: 'Ubuntu',
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          margin: EdgeInsets.only(
                            left: (20 / 678) * height,
                            right: (20 / 678) * height,
                            bottom: (20 / 678) * height,
                          ),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular((88 / 678) * height),
                          ),
                          child: widget.state == 'Verification'
                              ? SliderButton(
                                  width: width * 0.77,
                                  height: height * 0.08,
                                  child: Container(
                                    height: height * 0.08,
                                    width: height * 0.077,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black,
                                          blurRadius: 4,
                                        ),
                                      ],
                                      color: Color.fromRGBO(35, 205, 99, 1),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Neumorphic(
                                      style: NeumorphicStyle(
                                        boxShape: NeumorphicBoxShape.roundRect(
                                          BorderRadius.circular(100),
                                        ),
                                        border: NeumorphicBorder(
                                          width: 0.5,
                                        ),
                                        shadowLightColor: Colors.transparent,
                                        shape: NeumorphicShape.concave,
                                        color: Color.fromRGBO(35, 205, 99, 1),
                                        depth: 20,
                                      ),
                                      child: Center(
                                        child: Container(
                                          child: Icon(
                                            Icons.check,
                                            color:
                                                Color.fromRGBO(13, 47, 61, 1),
                                            size: 32.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  vibrationFlag: false,
                                  action: () async {
                                    setState(() => loading = true);
                                    await tripCompleter.completeTrip(
                                        widget.vegetables,
                                        widget.total,
                                        vendorId,
                                        widget.appState);
                                    setState(() => loading = false);
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              HomeBuilder(widget.appState)),
                                    );
                                  },
                                  dismissible: false,
                                  buttonSize: height * 0.077,
                                  startPercent: 1,
                                  baseColor: Color.fromRGBO(13, 47, 61, 1),
                                  backgroundColor: Color(0xffE0E5EC),
                                  highlightedColor:
                                      Color.fromRGBO(35, 205, 99, 1),
                                  label: Text(
                                    'Slide to confirm bill',
                                    style: TextStyle(
                                        fontFamily: 'Ubuntu',
                                        //color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15),
                                  ),
                                )
                              : Neumorphic(
                                  style: NeumorphicStyle(
                                    shape: NeumorphicShape.flat,
                                    boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(
                                          (20 / 678) * height),
                                    ),
                                    depth: 3,
                                    lightSource: LightSource.topLeft,
                                    border: NeumorphicBorder(
                                      color: Colors.white,
                                      width: 0.5,
                                    ),
                                    //color: Colors.white,
                                    color: Color(0xffE0E5EC),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          (20 / 678) * height),
                                      /*gradient: LinearGradient(colors: [
                                  Color.fromRGBO(35, 205, 99, 1),
                                  Color.fromRGBO(35, 205, 99, 0.5),
                                ]),*/
                                      color: Color.fromRGBO(35, 205, 99, 1),
                                    ),
                                    child: Center(
                                      child: ListTile(
                                        title: Text(
                                          'Total: ',
                                          style: TextStyle(
                                            fontSize: (25 / 678) * height,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        trailing: Text(
                                          '\u20B9' + widget.total.toString(),
                                          style: TextStyle(
                                            fontSize: (25 / 678) * height,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}

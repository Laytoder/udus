import 'package:flutter/material.dart';
import 'package:frute/AppState.dart';
import 'package:frute/Pages/homePage.dart';
import 'package:frute/Pages/homebuilder.dart';
import 'package:frute/helpers/tripCompleter.dart';
import 'package:frute/models/vegetable.dart';

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
        appBar: AppBar(
          title: widget.state == 'Verification'
              ? Text(
                  'Verify bill',
                  style: TextStyle(fontSize: (14 / 678) * height),
                )
              : Text(
                  'Bill of date ${widget.date}',
                  style: TextStyle(fontSize: (14 / 678) * height),
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
        ),
        body: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: <Widget>[
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
                            widget.vegetables[index].quantity.toString() + 'kg',
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
                    child: Card(
                      margin: EdgeInsets.only(
                        left: (20 / 678) * height,
                        right: (20 / 678) * height,
                        bottom: (20 / 678) * height,
                      ),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular((40 / 678) * height),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular((88 / 678) * height),
                          gradient: LinearGradient(
                              colors: [Color(0xff00b4db), Color(0xff0083b0)]),
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
                              widget.total.toString(),
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
                ],
              ),
      ),
    );
  }
}

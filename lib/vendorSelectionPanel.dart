import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class VendorSelectionPanel extends StatefulWidget {
  final void Function() showModalSearchLocation;
  double upperFadeVal = 1.0;
  String placeName;
  VendorSelectionPanel(
      {@required this.showModalSearchLocation,
      this.placeName,
      this.upperFadeVal});
  @override
  _VendorSelectionPanelState createState() => _VendorSelectionPanelState();
}

class _VendorSelectionPanelState extends State<VendorSelectionPanel>
    with SingleTickerProviderStateMixin {
  final List<String> imgList = [
    'https://i.ibb.co/XtPf1d4/truck-3.png',
    'https://i.ibb.co/XtPf1d4/truck-3.png',
    'https://i.ibb.co/XtPf1d4/truck-3.png',
    'https://i.ibb.co/XtPf1d4/truck-3.png',
    'https://i.ibb.co/XtPf1d4/truck-3.png'
  ];

  AnimationController _controller;
  Animation animation;
  TextEditingController _textEditingController;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      imgList.forEach((imageUrl) {
        precacheImage(NetworkImage(imageUrl), context);
      });
    });
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    _controller.value = 1.0;
    animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _textEditingController = new TextEditingController();
    _textEditingController.text = '22-1b baker street';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screen_height = MediaQuery.of(context).size.height;
    var screen_width = MediaQuery.of(context).size.width;
    /*return Stack(
      children: <Widget>[
        Opacity(
          opacity: widget.upperFadeVal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                alignment: Alignment.topCenter,
                width: MediaQuery.of(context).size.width,
                child: CarouselSlider(
                  options: CarouselOptions(
                      height: MediaQuery.of(context).size.height / 4.3,
                      initialPage: 0,
                      enlargeCenterPage: true,
                      autoPlay: false,
                      enableInfiniteScroll: true,
                      onPageChanged: (_, __) async {
                        await _controller.reverse();
                        _controller.forward();
                      }),
                  items: imgList.map((imgUrl) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Column(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topCenter,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                              ),
                              child: Image.network(
                                imgUrl,
                                //fit: BoxFit.fill,
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(),
                  ),
                  ScaleTransition(
                    scale: animation,
                    child: Container(
                      //margin: EdgeInsets.all(10.0),
                      //width: double.infinity,
                      padding: EdgeInsets.all(10.0),
                      child: Center(
                        child: Wrap(
                          direction: Axis.vertical,
                          children: <Widget>[
                            Text(
                              '-\nQuantity',
                              style: TextStyle(
                                  fontSize: (screen_height * 16) / 678),
                            ),
                            Text(
                              '10',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: (screen_height * 12) / 678),
                            ),
                          ],
                        ),
                      ),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Color(0xfff6f6f6),
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  ScaleTransition(
                    scale: animation,
                    child: Container(
                      //width: double.infinity,
                      //margin: EdgeInsets.all(10.0),
                      padding: EdgeInsets.all(10.0),
                      child: Center(
                        child: Wrap(
                          direction: Axis.vertical,
                          children: <Widget>[
                            Text(
                              '-\nDistance',
                              style: TextStyle(
                                  fontSize: (screen_height * 16) / 678),
                            ),
                            Text(
                              '100 km',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: (screen_height * 12) / 678),
                            ),
                          ],
                        ),
                      ),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Color(0xfff6f6f6),
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  ScaleTransition(
                    scale: animation,
                    child: Container(
                      //width: double.infinity,
                      //margin: EdgeInsets.all(10.0),
                      padding: EdgeInsets.all(10.0),
                      child: Center(
                        child: Wrap(
                          direction: Axis.vertical,
                          children: <Widget>[
                            Text(
                              '-\nE.T.A',
                              style: TextStyle(
                                  fontSize: (screen_height * 16) / 678),
                            ),
                            Text(
                              '10 min',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: (screen_height * 12) / 678),
                            ),
                          ],
                        ),
                      ),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Color(0xfff6f6f6),
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                ],
              ),
              Expanded(
                child: Container(),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Container(),
            ),
            ListTile(
              //contentPadding: EdgeInsets.only(left: 30.0, right: 30.0),
              contentPadding: EdgeInsets.only(
                  left: screen_width / 13, right: screen_width / 13),
              leading: ScaleTransition(
                scale: animation,
                child: CircleAvatar(
                  radius: (screen_height * 20) / 678,
                  backgroundImage: NetworkImage(
                      'https://c8.alamy.com/comp/EJ2D70/portrait-of-an-indian-old-man-a-street-vendor-sell-street-food-in-EJ2D70.jpg'),
                ),
              ),
              title: FadeTransition(
                opacity: animation,
                child: Text(
                  'Ramu kaka',
                  style: TextStyle(
                    fontSize: (screen_height * 16) / 678,
                  ),
                ),
              ),
              subtitle: FadeTransition(
                opacity: animation,
                child: Text(
                  'Pro Vendor',
                  style: TextStyle(
                    fontSize: (screen_height * 14) / 678,
                  ),
                ),
              ),
              trailing: ScaleTransition(
                scale: animation,
                child: Wrap(
                  direction: Axis.vertical,
                  children: <Widget>[
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                      //size: 26.0,
                      size: (screen_height * 13) / 339,
                    ),
                    Text(
                      ' 4.9',
                      style: TextStyle(
                          //fontSize: 14,
                          fontSize: (screen_height * 7) / 339),
                    )
                  ],
                ),
              ),
            ),
            /*Expanded(
          child: Container(),
        ),*/
            SizedBox(
              //height: 20,
              height: (screen_height * 8) / 678,
            ),
            /*Expanded(
          child: Container(),
        ),*/
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(),
                    flex: 2,
                  ),
                  Wrap(
                    //spacing: 15.0,
                    spacing: (screen_height * 10) / 678,
                    direction: Axis.vertical,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            //height: 20,
                            //width: 20,
                            height: (screen_height * 10) / 339,
                            width: (screen_height * 10) / 339,
                            decoration: BoxDecoration(
                                color: Color(0xffffb300),
                                shape: BoxShape.circle),
                            child: Center(
                              child: Container(
                                //height: 5,
                                //width: 5,
                                height: (screen_height * 5) / 678,
                                width: (screen_height * 5) / 678,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.grey),
                              ),
                            ),
                          ),
                          SizedBox(
                            //width: 30,
                            width: (screen_width * 30) / 360,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              children: <Widget>[
                                Center(
                                  child: Text('From',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        //fontSize: 12.0,
                                        fontSize: (screen_height * 2) / 113,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            //height: 20,
                            //width: 20,
                            height: (screen_height * 10) / 339,
                            width: (screen_height * 10) / 339,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                shape: BoxShape.circle),
                            child: Center(
                              child: Container(
                                //height: 5,
                                //width: 5,
                                height: (screen_height * 5) / 678,
                                width: (screen_height * 5) / 678,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.grey),
                              ),
                            ),
                          ),
                          SizedBox(
                            //width: 30,
                            width: (screen_width * 30) / 360,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              children: <Widget>[
                                Center(
                                  child: FadeTransition(
                                    opacity: animation,
                                    child: Text(
                                      '128/241 Kidwai Nagar, Kanpur',
                                      style: TextStyle(
                                        color: Colors.black,
                                        //fontSize: 16.0,
                                        fontSize: (screen_height * 8) / 339,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            //height: 20,
                            //width: 20,
                            height: (screen_height * 10) / 339,
                            width: (screen_height * 10) / 339,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                shape: BoxShape.circle),
                            child: Center(
                              child: Container(
                                //height: 5,
                                //width: 5,
                                height: (screen_height * 5) / 339,
                                width: (screen_height * 5) / 339,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.grey),
                              ),
                            ),
                          ),
                          SizedBox(
                            //width: 32,
                            width: (screen_width * 32) / 360,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              children: <Widget>[
                                Center(
                                  child: Container(
                                    //height: 1.5,
                                    //width: 200.0,
                                    height: (screen_height * 1.5) / 678,
                                    width: (screen_width * 200) / 360,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            //width: 12,
                            width: (screen_width * 12) / 360,
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            //height: 20,
                            //width: 20,
                            height: (screen_height * 10) / 339,
                            width: (screen_height * 10) / 339,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                shape: BoxShape.circle),
                            child: Center(
                              child: Container(
                                //height: 5,
                                //width: 5,
                                height: (screen_height * 5) / 678,
                                width: (screen_height * 5) / 678,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.grey),
                              ),
                            ),
                          ),
                          SizedBox(
                            //width: 30,
                            width: (screen_width * 30) / 360,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              children: <Widget>[
                                Center(
                                  child: Text('To',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        //fontSize: 12.0,
                                        fontSize: (screen_height * 12) / 678,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            //height: 20,
                            //width: 20,
                            height: (screen_height * 10) / 339,
                            width: (screen_height * 10) / 339,
                            decoration: BoxDecoration(
                                color: Color(0xffffb300),
                                shape: BoxShape.circle),
                            child: Center(
                              child: Container(
                                //height: 5,
                                //width: 5,
                                height: (screen_height * 5) / 678,
                                width: (screen_height * 5) / 678,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.grey),
                              ),
                            ),
                          ),
                          SizedBox(
                              //width: 30,
                              width: (screen_width * 30) / 360),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              children: <Widget>[
                                Center(
                                  child: Text(widget.placeName,
                                      style: TextStyle(
                                          color: Colors.black,
                                          //fontSize: 16.0,
                                          fontSize:
                                              (screen_height * 16) / 678)),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (screen_width * 7) / 360,
                          ),
                          GestureDetector(
                            child: Icon(
                              Icons.edit,
                              size: (screen_height * 20) / 678,
                            ),
                            onTap: () {
                              widget.showModalSearchLocation();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(),
                    flex: 4,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: (screen_height * 22) / 678,
            ),
          ],
        ),
      ],
    );*/
    return SingleChildScrollView(
      reverse: true,
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            alignment: Alignment.topCenter,
            width: MediaQuery.of(context).size.width,
            child: CarouselSlider(
              options: CarouselOptions(
                  height: MediaQuery.of(context).size.height / 4.3,
                  initialPage: 0,
                  enlargeCenterPage: true,
                  autoPlay: false,
                  enableInfiniteScroll: true,
                  onPageChanged: (_, __) async {
                    await _controller.reverse();
                    _controller.forward();
                  }),
              items: imgList.map((imgUrl) {
                return Builder(
                  builder: (BuildContext context) {
                    return Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.topCenter,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: Image.network(
                            imgUrl,
                            //fit: BoxFit.fill,
                          ),
                        ),
                      ],
                    );
                  },
                );
              }).toList(),
            ),
          ),
          /*SizedBox(
            height: (screen_height * 40) / 678,
          ),*/
          Row(
            children: <Widget>[
              Expanded(
                child: Container(),
              ),
              ScaleTransition(
                scale: animation,
                child: Container(
                  //margin: EdgeInsets.all(10.0),
                  //width: double.infinity,
                  padding: EdgeInsets.all(10.0),
                  child: Center(
                    child: Wrap(
                      direction: Axis.vertical,
                      children: <Widget>[
                        Text(
                          'Quantity',
                          style:
                              TextStyle(fontSize: (screen_height * 14) / 678),
                        ),
                        Text(
                          '10',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: (screen_height * 12) / 678),
                        ),
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Color(0xfff6f6f6),
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                ),
              ),
              Expanded(
                child: Container(),
              ),
              ScaleTransition(
                scale: animation,
                child: Container(
                  //width: double.infinity,
                  //margin: EdgeInsets.all(10.0),
                  padding: EdgeInsets.all(10.0),
                  child: Center(
                    child: Wrap(
                      direction: Axis.vertical,
                      children: <Widget>[
                        Text(
                          'Distance',
                          style:
                              TextStyle(fontSize: (screen_height * 14) / 678),
                        ),
                        Text(
                          '100 km',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: (screen_height * 12) / 678),
                        ),
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Color(0xfff6f6f6),
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                ),
              ),
              Expanded(
                child: Container(),
              ),
              ScaleTransition(
                scale: animation,
                child: Container(
                  //width: double.infinity,
                  //margin: EdgeInsets.all(10.0),
                  padding: EdgeInsets.all(10.0),
                  child: Center(
                    child: Wrap(
                      direction: Axis.vertical,
                      children: <Widget>[
                        Text(
                          'E.T.A',
                          style:
                              TextStyle(fontSize: (screen_height * 14) / 678),
                        ),
                        Text(
                          '10 min',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: (screen_height * 12) / 678),
                        ),
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Color(0xfff6f6f6),
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                ),
              ),
              Expanded(
                child: Container(),
              ),
            ],
          ),
          /*Expanded(
            child: Container(),
          ),*/
          SizedBox(
            //height: 20,
            height: (screen_height * 20) / 678,
          ),
          ListTile(
            //contentPadding: EdgeInsets.only(left: 30.0, right: 30.0),
            contentPadding: EdgeInsets.only(
                left: screen_width / 13, right: screen_width / 13),
            leading: ScaleTransition(
              scale: animation,
              child: CircleAvatar(
                radius: (screen_height * 20) / 678,
                backgroundImage: NetworkImage(
                    'https://c8.alamy.com/comp/EJ2D70/portrait-of-an-indian-old-man-a-street-vendor-sell-street-food-in-EJ2D70.jpg'),
              ),
            ),
            title: FadeTransition(
              opacity: animation,
              child: Text(
                'Ramu kaka',
                style: TextStyle(
                  fontSize: (screen_height * 14) / 678,
                ),
              ),
            ),
            subtitle: FadeTransition(
              opacity: animation,
              child: Text(
                'Pro Vendor',
                style: TextStyle(
                  fontSize: (screen_height * 12) / 678,
                ),
              ),
            ),
            trailing: ScaleTransition(
              scale: animation,
              child: Wrap(
                direction: Axis.vertical,
                children: <Widget>[
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                    //size: 26.0,
                    size: (screen_height * 13) / 339,
                  ),
                  Text(
                    ' 4.9',
                    style: TextStyle(
                        //fontSize: 14,
                        fontSize: (screen_height * 7) / 339),
                  )
                ],
              ),
            ),
          ),
          /*Expanded(
          child: Container(),
        ),*/
          SizedBox(
            //height: 20,
            height: (screen_height * 10) / 678,
          ),
          /*Expanded(
          child: Container(),
        ),*/
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(),
                  flex: 2,
                ),
                Wrap(
                  //spacing: 15.0,
                  spacing: (screen_height * 8) / 678,
                  direction: Axis.vertical,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          //height: 20,
                          //width: 20,
                          height: (screen_height * 10) / 339,
                          width: (screen_height * 10) / 339,
                          decoration: BoxDecoration(
                              color: Color(0xffffb300), shape: BoxShape.circle),
                          child: Center(
                            child: Container(
                              //height: 5,
                              //width: 5,
                              height: (screen_height * 5) / 678,
                              width: (screen_height * 5) / 678,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.grey),
                            ),
                          ),
                        ),
                        SizedBox(
                          //width: 30,
                          width: (screen_width * 30) / 360,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            children: <Widget>[
                              Center(
                                child: Text('From',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      //fontSize: 12.0,
                                      fontSize: (screen_height * 2) / 113,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          //height: 20,
                          //width: 20,
                          height: (screen_height * 10) / 339,
                          width: (screen_height * 10) / 339,
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              shape: BoxShape.circle),
                          child: Center(
                            child: Container(
                              //height: 5,
                              //width: 5,
                              height: (screen_height * 5) / 678,
                              width: (screen_height * 5) / 678,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.grey),
                            ),
                          ),
                        ),
                        SizedBox(
                          //width: 30,
                          width: (screen_width * 30) / 360,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            children: <Widget>[
                              Center(
                                child: FadeTransition(
                                  opacity: animation,
                                  child: Text(
                                    '128/241 Kidwai Nagar, Kanpur',
                                    style: TextStyle(
                                      color: Colors.black,
                                      //fontSize: 16.0,
                                      fontSize: (screen_height * 7) / 339,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          //height: 20,
                          //width: 20,
                          height: (screen_height * 10) / 339,
                          width: (screen_height * 10) / 339,
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              shape: BoxShape.circle),
                          child: Center(
                            child: Container(
                              //height: 5,
                              //width: 5,
                              height: (screen_height * 5) / 339,
                              width: (screen_height * 5) / 339,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.grey),
                            ),
                          ),
                        ),
                        SizedBox(
                          //width: 32,
                          width: (screen_width * 32) / 360,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            children: <Widget>[
                              Center(
                                child: Container(
                                  //height: 1.5,
                                  //width: 200.0,
                                  height: (screen_height * 1.5) / 678,
                                  width: (screen_width * 200) / 360,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          //width: 12,
                          width: (screen_width * 12) / 360,
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          //height: 20,
                          //width: 20,
                          height: (screen_height * 10) / 339,
                          width: (screen_height * 10) / 339,
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              shape: BoxShape.circle),
                          child: Center(
                            child: Container(
                              //height: 5,
                              //width: 5,
                              height: (screen_height * 5) / 678,
                              width: (screen_height * 5) / 678,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.grey),
                            ),
                          ),
                        ),
                        SizedBox(
                          //width: 30,
                          width: (screen_width * 30) / 360,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            children: <Widget>[
                              Center(
                                child: Text('To',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      //fontSize: 12.0,
                                      fontSize: (screen_height * 12) / 678,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          //height: 20,
                          //width: 20,
                          height: (screen_height * 10) / 339,
                          width: (screen_height * 10) / 339,
                          decoration: BoxDecoration(
                              color: Color(0xffffb300), shape: BoxShape.circle),
                          child: Center(
                            child: Container(
                              //height: 5,
                              //width: 5,
                              height: (screen_height * 5) / 678,
                              width: (screen_height * 5) / 678,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.grey),
                            ),
                          ),
                        ),
                        SizedBox(
                            //width: 30,
                            width: (screen_width * 30) / 360),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            children: <Widget>[
                              Center(
                                child: Text(widget.placeName,
                                    style: TextStyle(
                                        color: Colors.black,
                                        //fontSize: 16.0,
                                        fontSize: (screen_height * 14) / 678)),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: (screen_width * 7) / 360,
                        ),
                        GestureDetector(
                          child: Icon(
                            Icons.edit,
                            size: (screen_height * 20) / 678,
                          ),
                          onTap: () {
                            widget.showModalSearchLocation();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: Container(),
                  flex: 4,
                ),
              ],
            ),
          ),
          SizedBox(
            height: (screen_height * 40) / 678,
          ),
        ],
      ),
    );
  }
}

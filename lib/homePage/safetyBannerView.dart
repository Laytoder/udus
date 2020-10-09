import 'package:flutter/material.dart';

class SafetyBannerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(0.0),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Color(0xffE0E5EC),
              border: Border.all(color: Color(0xff23cd63), width: 2.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              children: <Widget>[
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 20),
                            Text(
                              'No-contact Delivery',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Have your order dropped of at your door or gate for added safety',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      FlatButton(
                        child: Text(
                          'Know More',
                          style: TextStyle(
                            color: Color(0xff23cd63),
                          ),
                        ),
                        onPressed: () {},
                      )
                    ],
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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frute/models/vendorInfo.dart';
import 'package:rating_bar/rating_bar.dart';

class VendorInfoPage extends StatelessWidget {
  VendorInfo vendor;
  VendorInfoPage(this.vendor);

  selectImageType(String link) {
    if (link.startsWith('https'))
      return NetworkImage(link);
    else
      return AssetImage(link);
  }

  double height, width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.only(
          top: (16 / 678) * height, bottom: (16 / 678) * height),
      child: Card(
        elevation: 10,
        shadowColor: Color.fromRGBO(35, 205, 99, 0.3),
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular((24 / 678) * height),
        ),
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Container(
                      decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular((24 / 678) * height),
                    //color: Color(0xffdd4f41),
                    image: DecorationImage(
                      image: AssetImage('assets/BG-img.jpg'),
                      fit: BoxFit.contain,
                    ),
                  )),
                ),
                Expanded(
                  flex: 10,
                  child: ListView.builder(
                    itemCount: vendor.vegetables.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Container(
                          height: (50 / 678) * height,
                          width: (50 / 360) * width,
                          child: CircleAvatar(
                            backgroundImage: selectImageType(
                                vendor.vegetables[index].imageUrl),
                            radius: (20 / 678) * height,
                          ),
                        ),
                        title: Wrap(
                          direction: Axis.horizontal,
                          children: <Widget>[
                            Text(
                              vendor.vegetables[index].name,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: (16 / 678) * height,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          vendor.vegetables[index].quantity.toString() + 'kg',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: (14 / 678) * height,
                          ),
                        ),
                        trailing: Text(
                          '\u20B9' +
                              vendor.vegetables[index].price.toString() +
                              '/kg',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: (14 / 678) * height,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: CachedNetworkImage(
                    imageUrl: vendor.imageUrl,
                    imageBuilder: (context, imageProvider) => Container(
                      margin: EdgeInsets.only(
                        top: (20 / 678) * height,
                        bottom: (5 / 678) * height,
                      ),
                      width: width * 0.25,
                      height: width * 0.25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(),
                    ),
                    Card(
                      elevation: 5,
                      shadowColor: Color.fromRGBO(35, 205, 99, 0.1),
                      color: Colors.grey[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          (15 / 678) * height,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: (10 / 360) * width,
                                top: (10 / 678) * height,
                                right: (10 / 360) * width,
                                bottom: (5 / 678) * height,
                              ),
                              child: Text(
                                vendor.name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: (15 / 678) * height,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              margin: EdgeInsets.only(
                                left: (10 / 360) * width,
                                bottom: (10 / 678) * height,
                                right: (10 / 360) * width,
                              ),
                              child: RatingBar.readOnly(
                                initialRating: 5,
                                filledIcon: Icons.star,
                                emptyIcon: Icons.star_border,
                                filledColor: Colors.amber,
                                size: (25 / 678) * height,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

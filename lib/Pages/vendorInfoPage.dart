import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frute/models/vendorInfo.dart';

class VendorInfoPage extends StatelessWidget {
  VendorInfo vendor;
  VendorInfoPage(this.vendor);

  selectImageType(String link) {
    if (link.startsWith('https'))
      return NetworkImage(link);
    else
      return AssetImage(link);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: CachedNetworkImage(
            imageUrl: vendor.imageUrl,
            imageBuilder: (context, imageProvider) => Container(
              padding: EdgeInsets.all(10),
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Text(vendor.name),
        ),
        ListView.builder(
          itemCount: vendor.vegetables.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                backgroundImage:
                    selectImageType(vendor.vegetables[index].imageUrl),
              ),
              title: Wrap(
                direction: Axis.horizontal,
                children: <Widget>[
                  Text(vendor.vegetables[index].name),
                ],
              ),
              subtitle:
                  Text(vendor.vegetables[index].quantity.toString() + '/kg'),
              trailing:
                  Text('\u20B9' + vendor.vegetables[index].price.toString()),
            );
          },
        ),
      ],
    );
  }
}

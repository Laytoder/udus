import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class OfferBannerView extends StatelessWidget {
  final List<String> images = [
    'assets/banner1.jpg',
    'assets/banner2.jpg',
  ];
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Neumorphic(
        child: Container(
          height: 180.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Swiper(
            itemHeight: 100,
            duration: 500,
            itemWidth: double.infinity,
            pagination: SwiperPagination.rect,
            itemCount: images.length,
            itemBuilder: (BuildContext context, int index) => Container(
              decoration: BoxDecoration(
                //borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(images[index]),
                ),
              ),
            ),
            autoplay: true,
            viewportFraction: 1.0,
            scale: 1.0,
          ),
        ),
      ),
      onTap: () {},
    );
  }
}
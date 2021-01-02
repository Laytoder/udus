import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:frute/config/borderRadius.dart';

class OfferBannerView extends StatelessWidget {
  final List<String> images = [
    'assets/banner1.jpg',
    'assets/banner2.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 180.0,
        child: Swiper(
          itemHeight: 100,
          duration: 800,
          itemWidth: double.infinity,
          pagination: SwiperPagination.rect,
          itemCount: images.length,
          itemBuilder: (BuildContext context, int index) => Container(
            decoration: BoxDecoration(
              borderRadius: UdusBorderRadius.medium,
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
      onTap: () {},
    );
  }
}

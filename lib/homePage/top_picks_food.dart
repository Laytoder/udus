import 'package:flutter/foundation.dart';

class TopPicksFood {
  final String image;
  final String name;

  TopPicksFood({
    @required this.image,
    @required this.name,
  });

  static List<TopPicksFood> getTopPicksfoods() {
    return [
      TopPicksFood(
        image: 'assets/tomato.png',
        name: 'Tomatos',
      ),
      TopPicksFood(
        image: 'assets/tomato.png',
        name: 'Cabbages',
      ),
      TopPicksFood(
        image: 'assets/tomato.png',
        name: 'Apple',
      ),
      TopPicksFood(
        image: 'assets/tomato.png',
        name: 'Mangoes',
      ),
      TopPicksFood(
        image: 'assets/tomato.png',
        name: 'Bananas',
      ),
      TopPicksFood(
        image: 'assets/tomato.png',
        name: 'Cucumbers',
      ),
      TopPicksFood(
        image: 'assets/tomato.png',
        name: 'Ladyfinger',
      ),
    ];
  }
}

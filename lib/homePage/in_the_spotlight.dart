import 'package:flutter/foundation.dart';

class InTheSpotlight {
  final String image;
  final String name;

  InTheSpotlight({
    @required this.image,
    @required this.name,
  });

  static List<InTheSpotlight> getInTheSpotlight() {
    return [
      InTheSpotlight(
        image: 'assets/tomato.png',
        name: 'Tomatos',
      ),
      InTheSpotlight(
        image: 'assets/tomato.png',
        name: 'Cabbages',
      ),
      InTheSpotlight(
        image: 'assets/tomato.png',
        name: 'Apple',
      ),
      InTheSpotlight(
        image: 'assets/tomato.png',
        name: 'Mangoes',
      ),
      InTheSpotlight(
        image: 'assets/tomato.png',
        name: 'Bananas',
      ),
      InTheSpotlight(
        image: 'assets/tomato.png',
        name: 'Cucumbers',
      ),
      InTheSpotlight(
        image: 'assets/tomato.png',
        name: 'Ladyfinger',
      ),
    ];
  }
}

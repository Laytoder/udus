import 'package:frute/AppState.dart';
import 'package:frute/models/vegetable.dart';

const List<String> topPickVegNames = [
  'Potato',
  'Onion',
  'Tomato',
  'Carrot',
  'Okra',
  'Cabbage',
  'Brinjal',
  'Capsicum',
  'Bottle Gourd',
  'Ridge Gourd',
];

const List<String> necessities = [
  'Ginger',
  'Garlic',
  'Chilli',
  'Coriander',
  'Cucumber',
  'Cucumber',
  'Radish',
  'Mint Leaves',
  'Spinach',
  'Methi',
];

List<String> seasonal = [
  'Cabbage',
  'Cauliflower',
  'Carrot',
  'Kiwi',
  'Okra',
  'Green Mango',
  'Jackfruit',
  'Arbi',
  'Drumsticks',
  'Green Beans',
  'Green Peas',
  'Beet',
];

List<String> otherveg = [
  'Pumpkin',
  'Imli',
  'Green Banana',
  'Methi',
  'Tinda',
  'Amla',
  'Bitter Gourd',
  'Turnip',
  'Kundru',
  'Broccoli',
  'Corn',
  'Spring Onion',
  'Mushrooms',
];

List<Vegetable> getTopPickFilter(AppState appState) {
  List<Vegetable> avlVegs = appState.avlVegs;
  /*print(avlVegs[0].toJson());
  print(avlVegs.length);*/
  //List<Vegetable> avlVegs = vegetables;
  List<Vegetable> filteredVegetables = [];
  for (Vegetable vegetable in avlVegs) {
    if (topPickVegNames.contains(vegetable.name))
      filteredVegetables.add(vegetable);
  }
  print(filteredVegetables.length);
  return filteredVegetables;
}

List<Vegetable> getNecessityFilter(AppState appState) {
  List<Vegetable> avlVegs = appState.avlVegs;
  //List<Vegetable> avlVegs = vegetables;
  List<Vegetable> filteredVegetables = [];
  for (Vegetable vegetable in avlVegs) {
    if (necessities.contains(vegetable.name)) filteredVegetables.add(vegetable);
  }
  return filteredVegetables;
}

List<Vegetable> getSeasonalFilter(AppState appState) {
  List<Vegetable> avlVegs = appState.avlVegs;
  //List<Vegetable> avlVegs = vegetables;
  List<Vegetable> filteredVegetables = [];
  for (Vegetable vegetable in avlVegs) {
    if (seasonal.contains(vegetable.name)) filteredVegetables.add(vegetable);
  }
  return filteredVegetables;
}

List<Vegetable> getOtherFilter(AppState appState) {
  List<Vegetable> avlVegs = appState.avlVegs;
  //List<Vegetable> avlVegs = vegetables;
  List<Vegetable> filteredVegetables = [];
  for (Vegetable vegetable in avlVegs) {
    if (otherveg.contains(vegetable.name)) filteredVegetables.add(vegetable);
  }
  return filteredVegetables;
}

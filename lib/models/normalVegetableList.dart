/*import 'vegetable.dart';

List<Vegetable> vegetables = [
  Vegetable(
    'Potato',
    imageUrl: 'assets/potato.jpg',
    commonNames: ['Aaloo', 'Aloo', 'Aalo', 'Alo'],
  ),
  Vegetable(
    'Onion',
    imageUrl: 'assets/onion.jpg',
    commonNames: ['Pyaaz', 'Kaanda', 'Kanda'],
  ),
  Vegetable(
    'Ginger',
    imageUrl: 'assets/ginger.jpg',
    commonNames: ['Adrak'],
  ),
  Vegetable(
    'Garlic',
    imageUrl: 'assets/garlic.jpg',
    commonNames: ['Lehsun'],
  ),
  Vegetable(
    'Chilli',
    imageUrl: 'assets/chilli.jpg',
    commonNames: ['Hari Mirch', 'Mircha', 'Mirch'],
  ),
  Vegetable(
    'Coriander',
    imageUrl: 'assets/dhaniya.jpg',
    commonNames: ['Dhaniya'],
  ),
  Vegetable(
    'Lemon',
    imageUrl: 'assets/lemon.jpg',
    commonNames: ['Lime', 'Nimbu', 'Nibu', 'Neebu', 'Neembu'],
  ),
  Vegetable(
    'Tomato',
    imageUrl: 'assets/tomato.jpg',
    commonNames: ['Tamaatar', 'Tamatar'],
  ),
  Vegetable(
    'Brinjal',
    imageUrl: 'assets/brinjal.jpg',
    commonNames: ['Baigan', 'Baingan'],
  ),
  Vegetable(
    'Okra',
    imageUrl: 'assets/bhindi.jpg',
    commonNames: ['Bhindi', 'Okhra'],
  ),
  Vegetable(
    'Cabbage',
    imageUrl: 'assets/cabbage.jpg',
    commonNames: [
      'Patta Gobi',
      'Gobi',
      'Gobhi',
      'Pata Gobi',
      'Band Gobi',
      'Patta Gobhi',
      'Band Gobhi',
      'Pata Gobhi',
      'Banda',
      'Bandha'
    ],
  ),
  Vegetable(
    'Cauliflower',
    imageUrl: 'assets/cauliflower.jpg',
    commonNames: [
      'Gobi',
      'Gobhi',
      'Phool Gobi',
      'Phool Gobi',
      'Fool Gobhi',
      'Fool Gobi',
    ],
  ),
  Vegetable(
    'Carrot',
    imageUrl: 'assets/carrot.jpg',
    commonNames: ['Gajar', 'Gaajar', 'Gaazar', 'Gazar'],
  ),
  Vegetable(
    'Pumpkin',
    imageUrl: 'assets/pumpkin.jpg',
    commonNames: ['Kadu', 'Kaddu', 'Sitafal'],
  ),
  Vegetable(
    'Bottle Gourd',
    imageUrl: 'assets/gourd.jpg',
    commonNames: ['Lauki', 'Ghiya'],
  ),
  Vegetable(
    'Radish',
    imageUrl: 'assets/radish.jpg',
    commonNames: ['Mooli'],
  ),
  Vegetable(
    'Imli',
    imageUrl: 'assets/imli.jpg',
    commonNames: [],
  ),
  Vegetable(
    'Cucumber',
    imageUrl: 'assets/cucumber.jpg',
    commonNames: ['Kheera', 'Kakdi'],
  ),
  Vegetable(
    'Mint Leaves',
    imageUrl: 'assets/mint.jpg',
    commonNames: ['Pudina', 'Pudeena'],
  ),
  Vegetable(
    'Green Banana',
    imageUrl: 'assets/greenbanana.jpg',
    commonNames: ['Hara Kela'],
  ),
  Vegetable(
    'Methi',
    imageUrl: 'assets/methi.jpg',
    commonNames: [],
  ),
  Vegetable(
    'Parwal',
    imageUrl: 'assets/parwal.jpg',
    commonNames: [],
  ),
  Vegetable(
    'Jackfruit',
    imageUrl: 'assets/kathal.jpg',
    commonNames: ['Kathal', 'Katahal'],
  ),
  Vegetable(
    'Green Mango',
    imageUrl: 'assets/rawmango.jpg',
    commonNames: ['Hara Aam', 'Ambiya', 'Amiya', 'Kacha Aam', 'Kachcha Aam'],
  ),
  Vegetable(
    'Arbi',
    imageUrl: 'assets/arbi.jpg',
    commonNames: ['Ghuiya', 'Ghuiyya', 'Ghuiyan', 'Ghuiyyan'],
  ),
  Vegetable(
    'Tinda',
    imageUrl: 'assets/tinda.jpg',
    commonNames: [],
  ),
  Vegetable(
    'Drumsticks',
    imageUrl: 'assets/drumsticks.jpg',
    commonNames: ['Sehjan'],
  ),
  Vegetable(
    'Amla',
    imageUrl: 'assets/amla.jpg',
    commonNames: [],
  ),
  Vegetable(
    'Bitter Gourd',
    imageUrl: 'assets/bittergourd.jpg',
    commonNames: ['Karela'],
  ),
  Vegetable(
    'Green Beans',
    imageUrl: 'assets/greenbeans.jpeg',
    commonNames: ['Sem', 'Same', 'Chhiya', 'Chiya', 'Lobhiya', 'Lobiya'],
  ),
  Vegetable(
    'Green Peas',
    imageUrl: 'assets/greenpeas.jpg',
    commonNames: ['Hari Matar', 'Matar'],
  ),
  Vegetable(
    'Capsicum',
    imageUrl: 'assets/capsicum.jpg',
    commonNames: ['Shimla Mirch', 'Simla Mirch'],
  ),
  Vegetable(
    'Spinach',
    imageUrl: 'assets/spinach.jpg',
    commonNames: ['Paalak', 'Palak'],
  ),
  Vegetable(
    'Turnip',
    imageUrl: 'assets/turnip.jpg',
    commonNames: [
      'Shalgam',
      'Shaljam',
      'Salgam',
      'Saljam',
      'Shalgum',
      'Shaljum',
      'Salgum',
      'Saljum',
    ],
  ),
  Vegetable(
    'Beet',
    imageUrl: 'assets/beet.jpg',
    commonNames: ['Chukandar'],
  ),
  Vegetable(
    'Kundru',
    imageUrl: 'assets/kundru.jpeg',
    commonNames: [],
  ),
  Vegetable(
    'Broccoli',
    imageUrl: 'assets/broccoli.jpg',
    commonNames: [],
  ),
  Vegetable(
    'Corn',
    imageUrl: 'assets/corn.jpg',
    commonNames: ['Baby Corn', 'Bhutta', 'Bhuta'],
  ),
  Vegetable(
    'Spring Onion',
    imageUrl: 'assets/springonion.jpg',
    commonNames: [],
  ),
  Vegetable(
    'Mushrooms',
    imageUrl: 'assets/mushroom.jpg',
    commonNames: [],
  ),
  Vegetable(
    'Kiwi',
    imageUrl: 'assets/kiwi.jpg',
    commonNames: [],
  ),
  Vegetable(
    'Curry Leaves',
    imageUrl: 'assets/curryleaves.jpg',
    commonNames: [
      'Kadi Patta',
      'Curry Patta',
      'Kadi Pata',
      'Curry Pata',
      'Meethhi Neem',
      'Meethi Neem',
      'Meeti Neem',
    ],
  ),
  Vegetable(
    'Ridge Gourd',
    imageUrl: 'assets/tori.jpg',
    commonNames: ['Taroi', 'Tori', 'Torai', 'Turai'],
  ),
];*/

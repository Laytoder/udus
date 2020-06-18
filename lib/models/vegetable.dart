class Vegetable {
  String name, imageUrl;
  double price, quantity;

  Vegetable(this.name,
      {this.price, this.quantity});

  Vegetable.fromJson(Map json) {
    name = json['name'];
    quantity = json['quantity'];
    price = json['price'];
    imageUrl = json['imageUrl'];
  }

  Map toJson() =>
      {'name': name, 'quantity': quantity, 'price': price, 'imageUrl': imageUrl};
}

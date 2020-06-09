class Vegetable {
  String name;
  double price, quantity;

  Vegetable(this.name,
      {this.price, this.quantity});

  Vegetable.fromJson(Map json) {
    name = json['name'];
    quantity = json['quantity'];
    price = json['price'];
  }
}

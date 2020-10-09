class Vegetable {
  String name, imageUrl;
  double price, quantity;
  bool isSelected = false;

  Vegetable(this.name, {this.imageUrl, this.price, this.quantity});

  Vegetable.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    quantity = json['quantity'];
    price = json['price'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'quantity': quantity,
        'price': price,
        'imageUrl': imageUrl
      };
}

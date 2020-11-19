class Vegetable {
  String name, imageUrl;
  double price, quantity;

  //dispCommonName and currCommonName is just used while searching
  //it is real-time so doesn't need to be stored in preferences.
  bool isSelected = false, dispCommonName = false;
  String currCommonName = null;
  List<String> commonNames;

  Vegetable(
    this.name, {
    this.imageUrl,
    this.price,
    this.quantity,
    this.commonNames,
  });

  Vegetable.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json.containsKey('quantiy')) quantity = json['quantity'];
    price = json['price'].toDouble();
    imageUrl = json['imageUrl'];
    //jst for testing data lacking field
    commonNames = json['commonNames'] == null ? [] : json['commonNames'];
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'quantity': quantity,
        'price': price,
        'imageUrl': imageUrl,
        'commonNames': commonNames,
      };
}

class AddOn {
  final String addOnsTypeId;
  final String id;
  final String name;
  final String description;
  final double price;
  final String prettyPrice;
  bool isSelected;
  int quantity;

  AddOn(
      {this.addOnsTypeId, this.id, this.name, this.description, this.price, this.prettyPrice, this.isSelected = false, this.quantity = 1});

  factory AddOn.fromJson(Map<String, dynamic> parsedJson, String addOnsTypeId) {
    return AddOn(
      addOnsTypeId: addOnsTypeId,
        id: parsedJson['sub_item_id'],
        description: parsedJson['item_description'],
        name: parsedJson['sub_item_name'],
        prettyPrice: parsedJson['pretty_price'],
        price: double.parse(parsedJson['price'].toString()));
  }
}
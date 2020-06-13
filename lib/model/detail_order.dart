class DetailOrder {

  final String orderInstruction;
  final String username;
  final String restaurantAddress;
  final String restaurantContact;
  final String transactionType;
  final String transferDate;
  final String deliveryDate;
  final String deliveryTime;
  final String deliveryAddress;
  final String deliveryAddressName;
  final String deliveryContact;

  DetailOrder({
    this.username,
    this.restaurantAddress,
    this.restaurantContact,
    this.transactionType,
    this.transferDate,
    this.deliveryDate,
    this.deliveryTime,
    this.deliveryAddress,
    this.deliveryAddressName,
    this.deliveryContact,
    this.orderInstruction});

  factory DetailOrder.fromJson(Map<String, dynamic> parsedJson){
    return DetailOrder(

    );
  }
}

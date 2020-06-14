import 'package:flyereats/model/restaurant.dart';

class Order {
  final String id;
  final String title;
  final Restaurant restaurant;
  final String itemsString;
  final String date;
  final String status;
  final String total;
  final String paymentType;

/*  final String offer;
  final String voucher;
  final String packaging;
  final String deliveryCharge;
  final String tax;*/

  Order(
      {this.restaurant,
      this.itemsString,
      this.date,
      this.status,
      this.id,
      this.title,
      this.total,
      this.paymentType});

  factory Order.fromJson(Map<String, dynamic> parsedJson) {
    String itemsString = '';
    var listItems = parsedJson['items'] as List;
    int i = 0;
    listItems.forEach((item) {
      i++;
      String add = (i == listItems.length) ? " " : ", ";
      itemsString = itemsString + item['item_name'] + " X " + item['quantity'] + add;
    });

    return Order(
      id: parsedJson['order_id'],
      title: parsedJson['title_new'],
      restaurant: Restaurant("", parsedJson['merchant_name'], "", "",
          parsedJson['marchant_logo'], "", ""),
      date: parsedJson['place_on'],
      status: parsedJson['status'],
      total: parsedJson['total'],
      itemsString: itemsString,
      paymentType: parsedJson['payment_type'],
    );
  }
}

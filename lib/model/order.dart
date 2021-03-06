import 'package:clients/model/restaurant.dart';

class Order {
  final String id;
  final String title;
  final String sizeName;
  final Restaurant restaurant;
  final String itemsString;
  final String date;
  final String status;
  final String total;
  final String paymentType;
  final String currencyCode;

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
      this.sizeName,
      this.total,
      this.paymentType,
      this.currencyCode});

  String getIcon() {
    switch (this.status) {
      case "Order Placed":
        return "assets/in process icon.svg";
      case "Food Preparing":
        return "assets/in process icon.svg";
      case "On the way":
        return "assets/in process icon.svg";
      case "Delivered":
        return "assets/check.svg";
      case "Cancelled":
        return "assets/remove.svg";
      default:
        return "assets/remove.svg";
    }
  }

  String getMapStatus() {
    switch (this.status) {
      case "Order Placed":
        return "In Progress";
      case "Food Preparing":
        return "In Progress";
      case "On the way":
        return "In Progress";
      case "Delivered":
        return "Delivered";
      case "Cancelled":
        return "Cancelled";
      default:
        return "Cancelled";
    }
  }

  factory Order.fromJson(Map<String, dynamic> parsedJson) {
    String itemsString = '';
    var listItems = parsedJson['items'] as List;
    int i = 0;
    listItems.forEach((item) {
      i++;
      String add = (i == listItems.length) ? " " : ", ";
      String sizeName =
          item['size_name'] != null ? (" " + item['size_name']) : "";
      itemsString = itemsString +
          item['item_name'] +
          sizeName +
          " X " +
          item['quantity'] +
          add;
    });

    var listStatus = parsedJson['order_history'] as List;

    return Order(
      id: parsedJson['order_id'],
      title: parsedJson['title_new'],
      restaurant: Restaurant(
        "",
        parsedJson['merchant_name'],
        "",
        null,
        parsedJson['marchant_logo'],
        "",
        "",
        true,
        parsedJson['currency_code'],
      ),
      date: parsedJson['place_on'],
      status: listStatus.last['status'],
      total: parsedJson['total'],
      itemsString: itemsString,
      currencyCode: parsedJson['currency_code'],
      paymentType: parsedJson['payment_type'],
    );
  }
}

class PickupOrder {
  final String id;
  final String title;
  final String shopName;
  final String shopDescription;
  final String pickupAddress;
  final List<String> items;
  final String date;
  final String amount;
  final String status;
  final String currencyCode;

  PickupOrder(
      {this.id,
      this.title,
      this.shopName,
      this.shopDescription,
      this.pickupAddress,
      this.items,
      this.date,
      this.amount,
      this.status,
      this.currencyCode});

  factory PickupOrder.fromJson(Map<String, dynamic> parsedJson) {
    var itemsJson = parsedJson['items'] as List;
    List<String> items = itemsJson.map((i) {
      return i['item_name'].toString();
    }).toList();

    return PickupOrder(
        id: parsedJson['order_id'],
        title: parsedJson['title'],
        amount: parsedJson['total'],
        date: parsedJson['place_on'],
        pickupAddress: parsedJson['pickup_details']['pickup_address'],
        shopName: parsedJson['pickup_details']['shop_name'],
        shopDescription: parsedJson['pickup_details']['shop_description'],
        status: parsedJson['status'],
        currencyCode: parsedJson['currency_code'],
        items: items);
  }

  String getItemString() {
    return this.items.join(", ");
  }

  String getIcon() {
    switch (this.status) {
      case "Order Placed":
        return "assets/in process icon.svg";
      case "Accepted":
        return "assets/in process icon.svg";
      case "On the way":
        return "assets/in process icon.svg";
      case "Delivered":
        return "assets/check.svg";
      case "Cancelled":
        return "assets/remove.svg";
      default:
        return "assets/remove.svg";
    }
  }

  String getMapStatus() {
    switch (this.status) {
      case "Order Placed":
        return "In Progress";
      case "Accepted":
        return "In Progress";
      case "On the way":
        return "In Progress";
      case "Delivered":
        return "Delivered";
      case "Cancelled":
        return "Cancelled";
      default:
        return "Cancelled";
    }
  }
}

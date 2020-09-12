import 'package:clients/model/add_on.dart';
import 'package:clients/model/food.dart';
import 'package:clients/model/food_cart.dart';
import 'package:clients/model/menu_category.dart';
import 'package:clients/model/price.dart';
import 'package:clients/model/restaurant.dart';
import 'package:clients/model/status_order.dart';

class DetailOrder {
  final String id;
  final String orderInstruction;
  final String username;
  final Restaurant restaurant;
  final String transactionType;
  final String transferDate;
  final String createdDate;
  final String deliveryDate;
  final String currencyCode;

  //final String deliveryTime;
  final String deliveryAddress;
  final String deliveryAddressName;
  final String deliveryContact;
  final String restaurantContactNumber;
  final FoodCart foodCart;

  //this is field fee
  final double grandTotal;
  final double subtotal;
  final double deliveryCharges;
  final double packagingFee;
  final double tax;
  final double discountOrder;
  final double voucherAmount;

  //this is status field
  final List<StatusOrder> statusHistory;
  final StatusOrder currentStatus;

  //review
  final bool isReviewAdded;

  DetailOrder({
    this.id,
    this.currentStatus,
    this.foodCart,
    this.username,
    this.restaurant,
    this.transactionType,
    this.transferDate,
    this.createdDate,
    this.deliveryDate,
    this.currencyCode,
    //this.deliveryTime,
    this.deliveryAddress,
    this.deliveryAddressName,
    this.deliveryContact,
    this.orderInstruction,
    this.restaurantContactNumber,
    this.grandTotal,
    this.subtotal,
    this.deliveryCharges,
    this.packagingFee,
    this.tax,
    this.discountOrder,
    this.voucherAmount,
    this.statusHistory,
    this.isReviewAdded,
  });

  StatusOrder getCurrentStatus() {
    return statusHistory.last;
  }

  factory DetailOrder.fromJson(Map<String, dynamic> parsedJson) {
    FoodCart foodCart = new FoodCart(Map<String, FoodCartItem>(), List());
    var foodCartItemJson = parsedJson['html']['item'] as List;

    for (int i = 0; i < foodCartItemJson.length; i++) {
      List<AddOn> addOns = [];

      if (foodCartItemJson[i]['sub_item'] is List) {
        var addOnJson = foodCartItemJson[i]['sub_item'] as List;
        addOns = addOnJson.map((i) {
          return AddOn.fromOrderDetailJson(i);
        }).toList();
      }

      foodCart.addSingleItemFoodToCart(
          foodCartItemJson[i]['item_id'] + i.toString(),
          Food(
            id: foodCartItemJson[i]['id'],
            title: foodCartItemJson[i]['item_name'] +
                " " +
                foodCartItemJson[i]['size_words'],
            category: MenuCategory(foodCartItemJson[i]['category_id'],
                foodCartItemJson[i]['category_name']),
            discount: double.parse(foodCartItemJson[i]['discount'].toString()),
            price: Price(
                price: double.parse(
                    foodCartItemJson[i]['normal_price'].toString())),
          ),
          int.parse(foodCartItemJson[i]['qty'].toString()),
          Price(
              discountedPrice: double.parse(
                  foodCartItemJson[i]['discounted_price'].toString()),
              price:
                  double.parse(foodCartItemJson[i]['normal_price'].toString())),
          addOns);
    }

    var statusHistoryJson = parsedJson['order_history'] as List;
    List<StatusOrder> statusHistory = statusHistoryJson.map((e) {
      return StatusOrder.fromJson(e);
    }).toList();

    return DetailOrder(
        id: parsedJson['order_id'],
        foodCart: foodCart,
        createdDate: parsedJson['date_created'],
        orderInstruction: parsedJson['delivery_instruction'],
        currencyCode: parsedJson['corrency_code'],
        restaurant: Restaurant(
          parsedJson['merchant_id'],
          parsedJson['marchant_name'],
          parsedJson['delivery_time'],
          null,
          parsedJson['marchant_logo'],
          "",
          parsedJson['address'],
          true,
          parsedJson['currency_code'],
        ),
        deliveryAddress: parsedJson['info']['Deliver to'],
        deliveryAddressName: parsedJson['info']['Location Name'],
        deliveryContact: parsedJson['info']['Contact Number'],
        transferDate: parsedJson['info']['TRN Date'],
        username: parsedJson['info']['Name'],
        transactionType: parsedJson['info']['TRN Type'],
        deliveryDate: parsedJson['info']['Delivery Date'],
        //deliveryTime: parsedJson['info']['Delivery Time'],
        restaurantContactNumber: parsedJson['info']['Telephone'],
        currentStatus: StatusOrder(status: "On the way"),
        grandTotal:
            double.parse(parsedJson['html']['total']['total'].toString()),
        tax: double.parse(
            parsedJson['html']['total']['taxable_total'].toString()),
        deliveryCharges: double.parse(
            parsedJson['html']['total']['delivery_charges'].toString()),
        packagingFee: double.parse(parsedJson['html']['total']
                ['merchant_packaging_charge']
            .toString()),
        voucherAmount: double.parse(
            parsedJson['html']['total']['voucher_value'].toString()),
        discountOrder: double.parse(
            parsedJson['html']['total']['discounted_amount'].toString()),
        subtotal: foodCart.getCartTotalAmount(),
        statusHistory: statusHistory,
        isReviewAdded: parsedJson['is_rating_added']);
  }
}

class PickupDetailOrder {
  final String orderId;
  final String title;
  final String status;
  final String total;
  final String date;
  final List<String> thumbnails;
  final List<String> items;
  final String shopName;
  final String shopDescription;
  final String shopAddress;
  final List<StatusOrder> statusHistory;
  final String deliveryInstruction;
  final String currencyCode;

  PickupDetailOrder(
      {this.orderId,
      this.title,
      this.status,
      this.total,
      this.date,
      this.thumbnails,
      this.items,
      this.shopName,
      this.shopDescription,
      this.shopAddress,
      this.statusHistory,
      this.deliveryInstruction,
      this.currencyCode});

  StatusOrder getCurrentStatus() {
    return statusHistory.last;
  }

  factory PickupDetailOrder.fromJson(Map<String, dynamic> parsedJson) {
    var itemsJson = parsedJson['items'] as List;
    List<String> items = itemsJson.map((i) {
      return i['item_name'].toString();
    }).toList();

    var thumbnailsJson = parsedJson['thumbnail'] as List;
    List<String> thumbnails = thumbnailsJson.map((i) {
      return i.toString();
    }).toList();

    var statusHistoryJson = parsedJson['order_history'] as List;
    List<StatusOrder> statusHistory = statusHistoryJson.map((e) {
      return StatusOrder.fromJson(e);
    }).toList();

    return PickupDetailOrder(
        orderId: parsedJson['order_id'],
        title: parsedJson['title'],
        status: parsedJson['status'],
        total: parsedJson['total'],
        date: parsedJson['place_on'],
        shopName: parsedJson['pickup_details']['shop_name'],
        shopAddress: parsedJson['pickup_details']['pickup_address'],
        shopDescription: parsedJson['pickup_details']['shop_description'],
        deliveryInstruction: parsedJson['delivery_instruction'],
        currencyCode: parsedJson['currency_code'],
        items: items,
        thumbnails: thumbnails,
        statusHistory: statusHistory);
  }
}

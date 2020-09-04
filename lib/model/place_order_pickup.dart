import 'package:clients/model/address.dart';
import 'package:clients/model/payment_method.dart';
import 'package:clients/model/pickup.dart';
import 'package:clients/model/user.dart';

class PlaceOrderPickup {
  final User user;
  final bool isValid;
  final String message;
  final String id;
  final PickUp pickUp;
  final Address address;
  final String location;
  final String contact;
  final bool isChangePrimaryContact;
  final double deliveryAmount;
  final String razorKey;
  final String razorSecret;
  final String stripePublishKey;
  final String stripeSecretKey;
  final String distance;
  final String currencyCode;
  final String paymentReference;
  final String selectedPaymentMethod;
  final List<PaymentMethod> listPaymentMethod;

  factory PlaceOrderPickup.fromJson(Map<String, dynamic> parsedJson) {
    var listPaymentMethod = parsedJson['payment_list'] as List;
    List<PaymentMethod> listPayment = listPaymentMethod.map((i) {
      return PaymentMethod.fromJson(i);
    }).toList();
    return PlaceOrderPickup(
        isValid: true,
        stripePublishKey: parsedJson['stripe_publish_key'],
        stripeSecretKey: parsedJson['stripe_secret_key'],
        razorSecret: parsedJson['razorpay']['razor_secret'],
        razorKey: parsedJson['razorpay']['razor_key'],
        distance: parsedJson['distance'].toString(),
        currencyCode: parsedJson['currency_code'],
        listPaymentMethod: listPayment,
        deliveryAmount: double.parse(parsedJson['price'].toString()));
  }

  PlaceOrderPickup(
      {this.user,
      this.razorKey,
      this.razorSecret,
      this.isValid,
      this.message,
      this.id,
      this.pickUp,
      this.address,
      this.location,
      this.contact,
      this.isChangePrimaryContact,
      this.deliveryAmount,
      this.distance,
      this.currencyCode,
      this.stripePublishKey,
      this.stripeSecretKey,
      this.paymentReference,
      this.listPaymentMethod,
      this.selectedPaymentMethod});

  PlaceOrderPickup copyWith(
      {User user,
      String id,
      PickUp pickUp,
      Address address,
      String contact,
      bool isChangePrimaryContact,
      double deliveryAmount,
      bool isValid,
      String message,
      String location,
      String razorKey,
      String razorSecret,
      String distance,
      String stripePublishKey,
      String stripeSecretKey,
      String currencyCode,
      String paymentReference,
      List<PaymentMethod> listPaymentMethod,
      String selectedPaymentMethod}) {
    return PlaceOrderPickup(
        user: user ?? this.user,
        isValid: isValid ?? this.isValid,
        message: message ?? this.message,
        address: address ?? this.address,
        pickUp: pickUp ?? this.pickUp,
        id: id ?? this.id,
        location: location ?? this.location,
        isChangePrimaryContact:
            isChangePrimaryContact ?? this.isChangePrimaryContact,
        contact: contact ?? this.contact,
        deliveryAmount: deliveryAmount ?? this.deliveryAmount,
        razorKey: razorKey ?? this.razorKey,
        razorSecret: razorSecret ?? this.razorSecret,
        distance: distance ?? this.distance,
        currencyCode: currencyCode ?? this.currencyCode,
        stripePublishKey: stripePublishKey ?? this.stripePublishKey,
        stripeSecretKey: stripeSecretKey ?? this.stripeSecretKey,
        paymentReference: paymentReference ?? this.paymentReference,
        listPaymentMethod: listPaymentMethod ?? this.listPaymentMethod,
        selectedPaymentMethod:
            selectedPaymentMethod ?? this.selectedPaymentMethod);
  }
}

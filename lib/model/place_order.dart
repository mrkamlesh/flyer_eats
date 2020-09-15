import 'package:clients/model/address.dart';
import 'package:clients/model/food_cart.dart';
import 'package:clients/model/payment_method.dart';
import 'package:clients/model/restaurant.dart';
import 'package:clients/model/user.dart';
import 'package:clients/model/voucher.dart';
import 'package:intl/intl.dart';

class PlaceOrder {
  final String id;
  final bool isValid;
  final bool isMerchantOpen;
  final String message;
  final Restaurant restaurant;
  final User user;
  final String transactionType;
  final FoodCart foodCart;
  final Address address;
  final Voucher voucher;
  final String selectedPaymentMethod;
  final String razorKey;
  final String razorSecret;
  final String deliveryInstruction;
  final String contact;
  final double deliveryCharges;
  final double packagingCharges;
  final double taxCharges;
  final String taxPrettyString;
  final double discountOrder;
  final String discountOrderPrettyString;
  final bool isUseWallet;
  final double walletAmount;
  final bool isChangePrimaryContact;
  final List<PaymentMethod> listPaymentMethod;
  final DateTime now;
  final DateTime selectedDeliveryTime;
  final String stripePublishKey;
  final String stripeSecretKey;
  final String applyVoucherErrorMessage;
  final String paymentReference;
  final bool isBusy;
  final bool isDeliveryEnabled;
  final bool isSelfPickupEnabled;
  final bool isVoucherEnabled;

  final List<String> shownBusyDialogRestaurantIds;

  PlaceOrder(
      {this.id,
      this.isValid,
      this.isMerchantOpen,
      this.message,
      this.restaurant,
      this.user,
      this.transactionType,
      this.foodCart,
      this.address,
      this.voucher,
      this.applyVoucherErrorMessage,
      this.selectedPaymentMethod,
      this.razorKey,
      this.razorSecret,
      this.stripePublishKey,
      this.stripeSecretKey,
      this.deliveryInstruction,
      this.contact,
      this.deliveryCharges,
      this.packagingCharges,
      this.taxCharges,
      this.taxPrettyString,
      this.discountOrder,
      this.discountOrderPrettyString,
      this.walletAmount,
      this.isUseWallet,
      this.isChangePrimaryContact,
      this.listPaymentMethod,
      this.selectedDeliveryTime,
      this.now,
      this.shownBusyDialogRestaurantIds,
      this.paymentReference,
      this.isBusy,
      this.isDeliveryEnabled,
      this.isSelfPickupEnabled,
      this.isVoucherEnabled});

  factory PlaceOrder.fromJson(Map<String, dynamic> parsedJson) {
    var listPaymentMethod = parsedJson['details']['payment_list'] as List;
    List<PaymentMethod> listPayment = listPaymentMethod.map((i) {
      return PaymentMethod.fromJson(i);
    }).toList();

    String applyVoucherMessage;
    Voucher voucher;
    if (parsedJson['details']['apply_voucher'] is Map) {
      if ((parsedJson['details']['apply_voucher'] as Map)
          .containsKey('error')) {
        applyVoucherMessage = parsedJson['details']['apply_voucher']['error'];
      } else {
        voucher = Voucher.fromJson(parsedJson['details']['apply_voucher']);
      }
    }

    return PlaceOrder(
      isValid: true,
      message: parsedJson['msg'],
      isMerchantOpen: parsedJson['details']['is_merchant_open'],
      discountOrder: (parsedJson['details']['cart'] as Map)
              .containsKey('discount')
          ? double.parse(
              parsedJson['details']['cart']['discount']['amount'].toString())
          : 0,
      discountOrderPrettyString:
          (parsedJson['details']['cart'] as Map).containsKey('discount')
              ? parsedJson['details']['cart']['discount']['display'].toString()
              : "Discount Order",
      deliveryCharges:
          (parsedJson['details']['cart'] as Map).containsKey('delivery_charges')
              ? double.parse(parsedJson['details']['cart']['delivery_charges']
                      ['amount']
                  .toString())
              : 0,
      packagingCharges: (parsedJson['details']['cart'] as Map)
              .containsKey('packaging')
          ? double.parse(
              parsedJson['details']['cart']['packaging']['amount'].toString())
          : 0,
      taxCharges: (parsedJson['details']['cart'] as Map).containsKey('tax')
          ? double.parse(parsedJson['details']['cart']['tax']['tax'].toString())
          : 0,
      taxPrettyString: (parsedJson['details']['cart'] as Map).containsKey('tax')
          ? parsedJson['details']['cart']['tax']['tax_pretty']
          : "Tax",
      razorKey: parsedJson['details']['razorpay']['razor_key'],
      razorSecret: parsedJson['details']['razorpay']['razor_secret'],
      stripePublishKey: parsedJson['details']['stripe_publish_key'],
      stripeSecretKey: parsedJson['details']['stripe_secret_key'],
      walletAmount: double.parse(
        parsedJson['details']['wallet_amount'].toString(),
      ),
      isBusy: parsedJson['details']['is_busy'],
      isDeliveryEnabled: parsedJson['details']['services']['delivery'],
      isSelfPickupEnabled: parsedJson['details']['services']['pickup'],
      isVoucherEnabled: parsedJson['details']['enableVoucher'],
      listPaymentMethod: listPayment,
      applyVoucherErrorMessage: applyVoucherMessage,
      voucher: voucher,
    );
  }

  PlaceOrder copyWith({
    String id,
    bool isValid,
    bool isMerchantOpen,
    String message,
    Restaurant restaurant,
    User user,
    String transactionType,
    FoodCart foodCart,
    Address address,
    Voucher voucher,
    String applyVoucherMessage,
    String selectedPaymentMethod,
    String razorKey,
    String razorSecret,
    String stripePublishKey,
    String stripeSecretKey,
    String deliveryInstruction,
    String contact,
    double deliveryCharges,
    double packagingCharges,
    double taxCharges,
    String taxPrettyString,
    double discountOrder,
    String discountOrderPrettyString,
    double walletAmount,
    bool isUseWallet,
    bool isChangePrimaryContact,
    List<PaymentMethod> listPaymentMethod,
    DateTime selectedDeliveryTime,
    DateTime now,
    List<String> shownBusyDialogRestaurantIds,
    String paymentReference,
    bool isVoucherEnabled,
    bool isBusy,
    bool isDeliveryEnabled,
    bool isSelfPickupEnabled,
  }) {
    return PlaceOrder(
        id: id ?? this.id,
        isValid: isValid ?? this.isValid,
        isMerchantOpen: isMerchantOpen ?? this.isMerchantOpen,
        message: message ?? this.message,
        restaurant: restaurant ?? this.restaurant,
        user: user ?? this.user,
        transactionType: transactionType ?? this.transactionType,
        address: address ?? this.address,
        contact: contact ?? this.contact,
        deliveryInstruction: deliveryInstruction ?? this.deliveryInstruction,
        foodCart: foodCart ?? this.foodCart,
        selectedPaymentMethod:
            selectedPaymentMethod ?? this.selectedPaymentMethod,
        razorKey: razorKey ?? this.razorKey,
        razorSecret: razorSecret ?? this.razorSecret,
        stripePublishKey: stripePublishKey ?? this.stripePublishKey,
        stripeSecretKey: stripeSecretKey ?? this.stripeSecretKey,
        voucher: voucher ?? this.voucher,
        applyVoucherErrorMessage: applyVoucherMessage,
        deliveryCharges: deliveryCharges ?? this.deliveryCharges,
        packagingCharges: packagingCharges ?? this.packagingCharges,
        taxCharges: taxCharges ?? this.taxCharges,
        taxPrettyString: taxPrettyString ?? this.taxPrettyString,
        discountOrder: discountOrder ?? this.discountOrder,
        discountOrderPrettyString:
            discountOrderPrettyString ?? this.discountOrderPrettyString,
        walletAmount: walletAmount ?? this.walletAmount,
        isUseWallet: isUseWallet ?? this.isUseWallet,
        isChangePrimaryContact:
            isChangePrimaryContact ?? this.isChangePrimaryContact,
        listPaymentMethod: listPaymentMethod ?? this.listPaymentMethod,
        selectedDeliveryTime: selectedDeliveryTime ?? this.selectedDeliveryTime,
        now: now ?? this.now,
        shownBusyDialogRestaurantIds:
            shownBusyDialogRestaurantIds ?? this.shownBusyDialogRestaurantIds,
        paymentReference: paymentReference ?? paymentReference,
        isSelfPickupEnabled: isSelfPickupEnabled ?? this.isSelfPickupEnabled,
        isDeliveryEnabled: isDeliveryEnabled ?? this.isDeliveryEnabled,
        isVoucherEnabled: isVoucherEnabled ?? this.isVoucherEnabled,
        isBusy: isBusy ?? this.isBusy);
  }

  String getDeliveryDate() {
    return DateFormat('yyyy-MM-dd').format(this.selectedDeliveryTime);
  }

  String getDeliveryDatePretty() {
    return DateFormat('MMM dd, yyyy').format(this.selectedDeliveryTime);
  }

  String getDeliveryTime() {
    return DateFormat('hh:mm a').format(this.selectedDeliveryTime);
  }

  List<DateTime> getDeliveryTimeOptions() {
    List<DateTime> list = List();

    DateTime tressHold = DateTime(
      this.now.year,
      this.now.month,
      this.now.day,
      22,
      this.now.minute,
    );

    DateTime i = DateTime(
      this.now.year,
      this.now.month,
      this.now.day,
      this.now.hour,
      this.now.minute,
      this.now.second,
      this.now.millisecond,
      this.now.microsecond,
    ).add(Duration(minutes: 45));
    do {
      list.add(i);
      i = i.add(Duration(minutes: 15));
    } while (i.isBefore(tressHold));
    return list;
  }

  double subTotal() {
    return this.foodCart.getCartTotalAmount();
  }

  double getDiscountFoodTotal() {
    double discountTotal = 0;

    foodCart.getAllFoodCartItem().forEach((item) {
      discountTotal = discountTotal + item.quantity * item.food.discount;
    });

    return discountTotal;
  }

  double getTotal() {
    double total = 0;

    total = subTotal() +
        deliveryCharges +
        packagingCharges +
        taxCharges -
        discountOrder -
        voucher.amount;

    if (total < 0) {
      return 0;
    }

    return total;
  }

  double getWalletUsed() {
    if (isUseWallet) {
      if (walletAmount >= getTotal()) {
        return getTotal();
      } else {
        return walletAmount;
      }
    } else {
      return 0;
    }
  }

  bool hasShownBusyDialog(String id) {
    return this.shownBusyDialogRestaurantIds.contains(id);
  }
}

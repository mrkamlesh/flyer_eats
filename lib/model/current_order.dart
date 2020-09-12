import 'package:clients/model/scratch_card.dart';
import 'package:clients/model/status_order.dart';

class CurrentOrder {
  final StatusOrder statusOrder;
  final String orderId;
  final bool isActive;
  final bool isShowScratch;
  final bool isShowReview;
  final bool isScratchShowFirst;
  final double driverLatitude;
  final double driverLongitude;
  final String driverName;
  final String driverPhone;
  final String merchantId;
  final String merchantName;
  final String merchantLogo;
  final String merchantAddress;
  final String merchantCity;
  final String merchantState;
  final ScratchCard scratchCard;
  final bool isShownCancel;
  final String orderType;
  final String currencyCode;
  final String cancelReason;

  CurrentOrder(
      {this.driverLatitude,
      this.driverLongitude,
      this.driverName,
      this.driverPhone,
      this.statusOrder,
      this.orderId,
      this.orderType,
      this.isActive,
      this.isShowScratch,
      this.isShowReview,
      this.isScratchShowFirst,
      this.merchantCity,
      this.merchantState,
      this.merchantId,
      this.merchantLogo,
      this.merchantName,
      this.merchantAddress,
      this.scratchCard,
      this.isShownCancel,
      this.currencyCode,
      this.cancelReason});

  factory CurrentOrder.fromJson(Map<String, dynamic> parsedJson) {
    StatusOrder order = StatusOrder.fromJson2(parsedJson['details']);
    ScratchCard scratchCard;
    if (parsedJson['details']['cardInfo'] is Map) {
      scratchCard = ScratchCard.fromJson(parsedJson['details']['cardInfo']);
    }

    return CurrentOrder(
        statusOrder: order,
        orderId: parsedJson['details']['order_id'],
        isActive: parsedJson['details']['active_order'],
        isShowScratch: parsedJson['details']['is_show_scratch'],
        isShowReview: parsedJson['details']['is_show_add_review'],
        isScratchShowFirst: parsedJson['details']['is_scratch_card_show_first'],
        driverLatitude: parsedJson['details']['driver_latitudee'] != ""
        ? double.parse(parsedJson['details']['driver_latitudee'].toString())
        : null,
        driverLongitude: parsedJson['details']['driver_longitude'] != ""
            ? double.parse(parsedJson['details']['driver_longitude'].toString())
            : null,
        /*driverLatitude: -6.200000,
        driverLongitude: 106.816666,*/
        driverName: parsedJson['details']['driver_name'],
        driverPhone: parsedJson['details']['driver_phone'],
        merchantId: parsedJson['details']['merchant_id'],
        merchantLogo: parsedJson['details']['marchant_logo'],
        merchantName: parsedJson['details']['marchant_name'],
        merchantAddress: parsedJson['details']['merchant_address'],
        scratchCard: scratchCard,
        isShownCancel: parsedJson['details']['isShowCancel'],
        merchantState: parsedJson['details']['merchant_state'],
        merchantCity: parsedJson['details']['merchant_city'],
        orderType: parsedJson['details']['trans_type'],
        currencyCode: parsedJson['details']['currency_code'],
        cancelReason: parsedJson['details']['cancelReason']);
  }

  bool isPickupOrder() {
    return orderType == "pickup_drop";
  }
}

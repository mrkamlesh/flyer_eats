import 'package:clients/model/pickup.dart';
import 'package:clients/model/shop.dart';

class DeliveryOrderState {
  final PickUp pickUp;
  final String pickUpInfo;
  final String topPickUpInfo;

  DeliveryOrderState({this.pickUp, this.pickUpInfo, this.topPickUpInfo});
}

class InitialState extends DeliveryOrderState {
  InitialState() : super(pickUp: PickUp(shop: Shop(), attachment: [], items: [], deliveryInstruction: ""));
}

class LoadingInfo extends DeliveryOrderState {
  LoadingInfo({PickUp pickUp, String pickUpInfo, String topPickUpInfo})
      : super(pickUp: pickUp, pickUpInfo: pickUpInfo, topPickUpInfo: topPickUpInfo);
}

class ErrorInfo extends DeliveryOrderState {
  final String message;

  ErrorInfo(this.message, {PickUp pickUp, String pickUpInfo, String topPickUpInfo})
      : super(pickUp: pickUp, pickUpInfo: pickUpInfo, topPickUpInfo: topPickUpInfo);
}

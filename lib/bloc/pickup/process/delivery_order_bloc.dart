import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:clients/bloc/pickup/process/delivery_order_state.dart';
import 'package:clients/classes/data_repository.dart';
import 'package:clients/model/shop.dart';
import 'package:clients/model/pickup.dart';
import 'bloc.dart';

class DeliveryOrderBloc extends Bloc<DeliveryOrderEvent, DeliveryOrderState> {
  DataRepository repository = DataRepository();

  @override
  DeliveryOrderState get initialState => InitialState();

  @override
  Stream<DeliveryOrderState> mapEventToState(
    DeliveryOrderEvent event,
  ) async* {
    if (event is ChooseShop) {
      yield* mapChooseShopToState(event.shop);
    } else if (event is UpdateItem) {
      yield* mapUpdateItemToState(event.index, event.item);
    } else if (event is AddAttachment) {
      yield* mapAddAttachment(event.file);
    } else if (event is AddItem) {
      yield* mapAddTextFieldToState(event.index);
    } else if (event is RemoveItem) {
      yield* mapRemoveItemToState(event.index);
    } else if (event is UpdateDeliveryInstruction) {
      yield* mapUpdateDeliveryInstructionToState(event.deliveryInstruction);
    } else if (event is GetInfo) {
      yield* mapGetInfoToState(event.token, event.address);
    }
  }

  Stream<DeliveryOrderState> mapChooseShopToState(Shop shop) async* {
    yield DeliveryOrderState(pickUp: state.pickUp.copyWith(shop: shop), pickUpInfo: state.pickUpInfo);
  }

  Stream<DeliveryOrderState> mapUpdateItemToState(int i, String item) async* {
    PickUp pickUp = state.pickUp.copyWith();
    pickUp.items[i] = item;
    yield DeliveryOrderState(pickUp: pickUp, pickUpInfo: state.pickUpInfo);
  }

  Stream<DeliveryOrderState> mapAddAttachment(File file) async* {
    PickUp pickUp = state.pickUp.copyWith();
    pickUp.attachment.add(file);
    yield DeliveryOrderState(pickUp: pickUp, pickUpInfo: state.pickUpInfo);
  }

  Stream<DeliveryOrderState> mapAddTextFieldToState(int index) async* {
    PickUp pickUp = state.pickUp.copyWith();
    pickUp.items.insert(index, "");
    yield DeliveryOrderState(pickUp: pickUp, pickUpInfo: state.pickUpInfo);
  }

  Stream<DeliveryOrderState> mapRemoveItemToState(int index) async* {
    PickUp pickUp = state.pickUp.copyWith();
    pickUp.items.removeAt(index);
    yield DeliveryOrderState(pickUp: pickUp, pickUpInfo: state.pickUpInfo);
  }

  Stream<DeliveryOrderState> mapUpdateDeliveryInstructionToState(String deliveryInstruction) async* {
    yield DeliveryOrderState(
        pickUp: state.pickUp.copyWith(deliveryInstruction: deliveryInstruction), pickUpInfo: state.pickUpInfo);
  }

  Stream<DeliveryOrderState> mapGetInfoToState(String token, String address) async* {
    yield LoadingInfo(pickUpInfo: state.pickUpInfo, pickUp: state.pickUp);
    try {
      String result = await repository.getPickupInfo(token, address);
      yield DeliveryOrderState(pickUp: state.pickUp, pickUpInfo: result);
    } catch (e) {
      yield ErrorInfo(e.toString(), pickUpInfo: state.pickUpInfo, pickUp: state.pickUp);
    }
  }
}

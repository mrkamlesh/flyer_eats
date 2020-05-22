import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flyereats/model/shop.dart';
import 'package:flyereats/model/pickup.dart';
import './bloc.dart';

class DeliveryOrderBloc extends Bloc<DeliveryOrderEvent, PickUp> {
  @override
  PickUp get initialState => PickUp(attachment: [], items: [], );

  @override
  Stream<PickUp> mapEventToState(
    DeliveryOrderEvent event,
  ) async* {
    if (event is ChooseShop) {
      yield* mapChooseShopToState(event.shop);
    } else if (event is UpdateItem) {
      yield* mapUpdateItemToState(event.index, event.item);
    } else if (event is AddAttachment) {
      yield* mapAddAttachment(event.file);
    } else if (event is AddTextField) {
      yield* mapAddTextFieldToState();
    }
  }

  Stream<PickUp> mapChooseShopToState(Shop shop) async* {
    yield state.copyWith(shop: shop);
  }

  Stream<PickUp> mapUpdateItemToState(int i, String item) async* {
    PickUp pickUp = state.copyWith();
    pickUp.items[i] = item;
    yield pickUp;
  }

  Stream<PickUp> mapAddAttachment(File file) async* {
    PickUp pickUp = state.copyWith();
    pickUp.attachment.add(file);
    yield pickUp;
  }

  Stream<PickUp> mapAddTextFieldToState() async* {
    PickUp pickUp = state.copyWith();
    pickUp.items.insert(0, "");
    yield pickUp;
  }
}

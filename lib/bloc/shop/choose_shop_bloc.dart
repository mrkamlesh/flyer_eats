import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flyereats/model/shop.dart';
import './bloc.dart';

class ChooseShopBloc extends Bloc<ChooseShopEvent, Shop> {
  @override
  Shop get initialState => Shop();

  @override
  Stream<Shop> mapEventToState(
    ChooseShopEvent event,
  ) async* {
    if (event is EntryShopName) {
      Shop shop = state.copyWith(name: event.name);
      yield shop;
    } else if (event is EntryAddress) {
      Shop shop = state.copyWith(address: event.address);
      yield shop;
    } else if (event is PageOpen) {
      if (event.shop == null) {
        yield Shop();
      } else {
        Shop shop = state.copyWith(
            name: event.shop.name,
            address: event.shop.address,
            lat: event.shop.lat,
            long: event.shop.long);
        yield shop;
      }
    }
  }
}

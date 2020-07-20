import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:clients/model/shop.dart';
import 'package:meta/meta.dart';

@immutable
abstract class DeliveryOrderEvent extends Equatable {
  const DeliveryOrderEvent();
}

class ChooseShop extends DeliveryOrderEvent {
  final Shop shop;

  const ChooseShop(this.shop);

  @override
  List<Object> get props => [shop];
}

class UpdateItem extends DeliveryOrderEvent {
  final String item;
  final int index;

  const UpdateItem(this.index, this.item);

  @override
  List<Object> get props => [index, item];
}

class AddItem extends DeliveryOrderEvent {
  final int index;

  AddItem(this.index);

  @override
  List<Object> get props => [];
}

class RemoveItem extends DeliveryOrderEvent {
  final int index;

  RemoveItem(this.index);

  @override
  List<Object> get props => [];
}

class AddAttachment extends DeliveryOrderEvent {
  final File file;

  const AddAttachment(this.file);

  @override
  List<Object> get props => [file];
}

class UpdateDeliveryInstruction extends DeliveryOrderEvent {
  final String deliveryInstruction;

  const UpdateDeliveryInstruction(this.deliveryInstruction);

  @override
  List<Object> get props => [deliveryInstruction];
}

class GetInfo extends DeliveryOrderEvent {
  final String token;
  final String address;

  const GetInfo(this.token, this.address);

  @override
  List<Object> get props => [];
}

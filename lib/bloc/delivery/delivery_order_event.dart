import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flyereats/model/shop.dart';
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

class AddTextField extends DeliveryOrderEvent{
  @override
  List<Object> get props => [];

}

class AddAttachment extends DeliveryOrderEvent {
  final File file;

  const AddAttachment(this.file);

  @override
  List<Object> get props => [file];
}

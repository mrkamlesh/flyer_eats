import 'package:equatable/equatable.dart';
import 'package:flyereats/model/restaurant.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CouponEvent extends Equatable {
  const CouponEvent();
}

class GetCouponList extends CouponEvent {
  final Restaurant restaurant;
  final String token;

  const GetCouponList(this.restaurant, this.token);

  @override
  List<Object> get props => [restaurant, token];
}

class UpdateCouponTyped extends CouponEvent {
  final String couponTyped;

  const UpdateCouponTyped(this.couponTyped);

  @override
  List<Object> get props => [couponTyped];
}

class ApplyCoupon extends CouponEvent {
  final Restaurant restaurant;
  final double totalOrder;
  final String token;

  const ApplyCoupon(this.restaurant, this.totalOrder, this.token);

  @override
  List<Object> get props => [];
}

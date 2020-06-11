import 'package:flyereats/model/voucher.dart';

class CouponState {
  final String couponTyped;
  final Voucher voucher;
  final List<String> couponList;

  CouponState copyWith(
      {String couponTyped, Voucher voucher, List<String> couponList}) {
    return CouponState(
        voucher: voucher ?? this.voucher,
        couponList: couponList ?? this.couponList,
        couponTyped: couponTyped ?? this.couponTyped);
  }

  CouponState({
    this.couponTyped,
    this.voucher,
    this.couponList,
  });
}

class InitialCouponState extends CouponState {
  InitialCouponState()
      : super(couponTyped: "", voucher: null, couponList: []);
}

class LoadingCouponList extends CouponState {
  LoadingCouponList(
      {String couponTyped, Voucher voucher, List<String> couponList})
      : super(
            couponTyped: couponTyped,
            voucher: voucher,
            couponList: couponList);
}

class ErrorCouponList extends CouponState {
  final String message;

  ErrorCouponList(this.message,
      {String couponTyped, Voucher voucher, List<String> couponList})
      : super(
            couponTyped: couponTyped,
            voucher: voucher,
            couponList: couponList);
}

class LoadingApplyCoupon extends CouponState {
  LoadingApplyCoupon(
      {String couponTyped, Voucher voucher, List<String> couponList})
      : super(
            couponTyped: couponTyped,
            voucher: voucher,
            couponList: couponList);
}

class ErrorApplyCoupon extends CouponState {
  final String message;

  ErrorApplyCoupon(this.message,
      {String couponTyped, Voucher voucher, List<String> couponList})
      : super(
            couponTyped: couponTyped,
            voucher: voucher,
            couponList: couponList);
}

class SuccessApplyCoupon extends CouponState {
  SuccessApplyCoupon(
      {String couponTyped, Voucher voucher, List<String> couponList})
      : super(
            couponTyped: couponTyped,
            voucher: voucher,
            couponList: couponList);
}

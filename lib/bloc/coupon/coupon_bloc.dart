import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:clients/classes/data_repository.dart';
import 'package:clients/model/voucher.dart';
import './bloc.dart';

class CouponBloc extends Bloc<CouponEvent, CouponState> {
  DataRepository repository = DataRepository();

  @override
  CouponState get initialState => InitialCouponState();

  @override
  Stream<CouponState> mapEventToState(
    CouponEvent event,
  ) async* {
    if (event is GetCouponList) {
      yield* mapGetCouponListToState(event.restaurant.id, event.token);
    } else if (event is UpdateCouponTyped) {
      yield* mapUpdateCouponTypedToState(event.couponTyped);
    } else if (event is ApplyCoupon) {
      yield* mapApplyCouponToState(
          event.restaurant.id, event.totalOrder, event.token);
    }
  }

  Stream<CouponState> mapGetCouponListToState(
      String restaurantId, String token) async* {
    yield LoadingCouponList(
        couponList: state.couponList,
        voucher: state.voucher,
        couponTyped: state.couponTyped);

    try {
      List<Voucher> couponList = await repository.getCoupons(restaurantId, token);
      yield state.copyWith(couponList: couponList);
    } catch (e) {
      yield ErrorCouponList(e.toString(),
          couponList: state.couponList,
          voucher: state.voucher,
          couponTyped: state.couponTyped);
    }
  }

  Stream<CouponState> mapUpdateCouponTypedToState(String couponTyped) async* {
    yield state.copyWith(couponTyped: couponTyped);
  }

  Stream<CouponState> mapApplyCouponToState(
      String restaurantId, double totalOrder, String token) async* {
    yield LoadingApplyCoupon(
        couponList: state.couponList,
        voucher: state.voucher,
        couponTyped: state.couponTyped);

    try {
      var result = await repository.applyVoucher(
          restaurantId, state.couponTyped, totalOrder, token);

      if (result is Voucher) {
        yield SuccessApplyCoupon(
            voucher: result,
            couponTyped: state.couponTyped,
            couponList: state.couponList);
      } else if (result is String) {
        yield ErrorApplyCoupon(result,
            couponList: state.couponList,
            voucher: state.voucher,
            couponTyped: state.couponTyped);
      }
    } catch (e) {
      yield ErrorApplyCoupon(e.toString(),
          couponList: state.couponList,
          voucher: state.voucher,
          couponTyped: state.couponTyped);
    }
  }
}

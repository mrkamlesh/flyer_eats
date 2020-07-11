import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flyereats/classes/data_repository.dart';
import 'package:flyereats/model/current_order.dart';
import './bloc.dart';

class CurrentOrderBloc extends Bloc<CurrentOrderEvent, CurrentOrderState> {
  DataRepository repository = DataRepository();

  @override
  CurrentOrderState get initialState => InitialCurrentOrderState();

  @override
  Stream<CurrentOrderState> mapEventToState(
    CurrentOrderEvent event,
  ) async* {
    if (event is GetActiveOrder) {
      yield* mapGetActiveOrderToState(event.token);
    } else if (event is Retry) {
      yield* mapRetryToState(event.token);
    } else if (event is UpdateReviewComment) {
      yield* mapUpdateReviewCommentToState(event.comment);
    } else if (event is UpdateReviewRating) {
      yield* mapUpdateReviewRatingToState(event.rating);
    } else if (event is AddReview) {
      yield* mapAddReviewToState(event.token, event.orderId);
    } else if (event is ScratchCardEvent) {
      yield* mapScratchCardEventToState(event.token, event.cardId);
    }
  }

  Stream<CurrentOrderState> mapGetActiveOrderToState(String token) async* {
    try {
      CurrentOrder currentOrder = await repository.getActiveOrder(token);
      if (currentOrder.isActive) {
        yield SuccessState(currentOrder: currentOrder);
        Future.delayed(Duration(seconds: 3), () {
          add(GetActiveOrder(token));
        });
      } else {
        if (currentOrder.statusOrder == null) {
          yield NoActiveOrderState(currentOrder: currentOrder);
        } else {
          if (currentOrder.statusOrder.isDelivered()) {
            yield DeliveredOrderState(currentOrder: currentOrder);
          } else if (currentOrder.statusOrder.isCancelled()) {
            if (currentOrder.isShownCancel) {
              yield CancelledOrderState(currentOrder: currentOrder);
            } else {
              yield NoActiveOrderState(currentOrder: currentOrder);
            }
          }
        }
      }
    } catch (e) {
      yield ErrorState(e.toString(), currentOrder: state.currentOrder);
      /*Future.delayed(Duration(seconds: 3), () {
        add(GetActiveOrder(token));
      });*/
    }
  }

  Stream<CurrentOrderState> mapRetryToState(String token) async* {
    yield LoadingState(currentOrder: state.currentOrder);
    try {
      CurrentOrder currentOrder = await repository.getActiveOrder(token);
      if (currentOrder.isActive) {
        yield SuccessState(currentOrder: currentOrder);
        Future.delayed(Duration(seconds: 3), () {
          add(GetActiveOrder(token));
        });
      } else {
        if (currentOrder.statusOrder == null) {
          yield NoActiveOrderState(currentOrder: currentOrder);
        } else {
          if (currentOrder.statusOrder.isDelivered()) {
            yield DeliveredOrderState(currentOrder: currentOrder);
          } else if (currentOrder.statusOrder.isCancelled()) {
            if (currentOrder.isShownCancel) {
              yield CancelledOrderState(currentOrder: currentOrder);
            } else {
              yield NoActiveOrderState(currentOrder: currentOrder);
            }
          }
        }
      }
    } catch (e) {
      yield ErrorState(e.toString(), currentOrder: state.currentOrder);
      /*Future.delayed(Duration(seconds: 3), () {
        add(GetActiveOrder(token));
      });*/
    }
  }

  Stream<CurrentOrderState> mapAddReviewToState(String token, String orderId) async* {
    yield LoadingAddReview(currentOrder: state.currentOrder);

    try {
      bool isAdded = await repository.addReview(token, orderId, state.comment, state.rating);
      if (isAdded) {
        yield SuccessAddReview(currentOrder: state.currentOrder);
      } else {
        yield ErrorAddReview("Can not add review", currentOrder: state.currentOrder);
      }
    } catch (e) {
      yield ErrorAddReview(e.toString(), currentOrder: state.currentOrder);
    }
  }

  Stream<CurrentOrderState> mapUpdateReviewCommentToState(String comment) async* {
    yield CurrentOrderState(
        currentOrder: state.currentOrder, comment: comment, rating: state.rating, hasGivenStar: state.hasGivenStar);
  }

  Stream<CurrentOrderState> mapUpdateReviewRatingToState(double rating) async* {
    yield CurrentOrderState(
        currentOrder: state.currentOrder, comment: state.comment, rating: rating, hasGivenStar: true);
  }

  Stream<CurrentOrderState> mapScratchCardEventToState(String token, String cardId) async* {
    await repository.scratchCard(token, cardId);
    /*yield CardScratched(
        rating: state.rating,
        hasGivenStar: state.hasGivenStar,
        comment: state.comment,
        currentOrder: state.currentOrder);*/
  }
}

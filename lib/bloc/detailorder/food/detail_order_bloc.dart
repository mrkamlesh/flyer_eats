import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:clients/classes/data_repository.dart';
import 'package:clients/model/detail_order.dart';
import 'bloc.dart';

class DetailOrderBloc extends Bloc<DetailOrderEvent, DetailOrderState> {
  DataRepository repository = DataRepository();

  @override
  DetailOrderState get initialState => LoadingDetailOrderState();

  @override
  Stream<DetailOrderState> mapEventToState(
    DetailOrderEvent event,
  ) async* {
    if (event is GetDetailOrder) {
      yield* mapGetDetailOrderToState(event.orderId, event.token);
    } else if (event is UpdateReviewComment) {
      yield* mapUpdateReviewCommentToState(event.comment);
    } else if (event is UpdateReviewRating) {
      yield* mapUpdateReviewRatingToState(event.rating);
    } else if (event is AddReview) {
      yield* mapAddReviewToState(event.token);
    }
  }

  Stream<DetailOrderState> mapGetDetailOrderToState(
      String orderId, String token) async* {
    yield LoadingDetailOrderState();
    try {
      var result = await repository.getDetailOrder(orderId, token);
      if (result is DetailOrder) {
        yield DetailOrderState(
            rating: state.rating,
            hasGivenStar: state.hasGivenStar,
            comment: state.comment,
            detailOrder: result,
            isReviewAdded: result.isReviewAdded);
      } else {
        yield ErrorDetailOrderState(result as String,
            rating: state.rating,
            hasGivenStar: state.hasGivenStar,
            comment: state.comment,
            detailOrder: state.detailOrder,
            isReviewAdded: state.isReviewAdded);
      }
    } catch (e) {
      yield ErrorDetailOrderState(e.toString(),
          rating: state.rating,
          hasGivenStar: state.hasGivenStar,
          comment: state.comment,
          detailOrder: state.detailOrder,
          isReviewAdded: state.isReviewAdded);
    }
  }

  Stream<DetailOrderState> mapUpdateReviewCommentToState(
      String comment) async* {
    yield state.copyWith(comment: comment);
  }

  Stream<DetailOrderState> mapUpdateReviewRatingToState(double rating) async* {
    yield state.copyWith(rating: rating, hasGivenStar: true);
  }

  Stream<DetailOrderState> mapAddReviewToState(String token) async* {
    yield LoadingAddReview(
        hasGivenStar: state.hasGivenStar,
        rating: state.rating,
        comment: state.comment,
        detailOrder: state.detailOrder,
        isReviewAdded: state.isReviewAdded);

    try {
      bool isAdded = await repository.addReview(
          token, state.detailOrder.id, state.comment, state.rating);
      if (isAdded) {
        yield SuccessAddReview(
            hasGivenStar: state.hasGivenStar,
            rating: state.rating,
            comment: state.comment,
            detailOrder: state.detailOrder,
            isReviewAdded: true);
      } else {
        yield ErrorAddReview("Can not add review",
            hasGivenStar: state.hasGivenStar,
            rating: state.rating,
            comment: state.comment,
            detailOrder: state.detailOrder,
            isReviewAdded: state.isReviewAdded);
      }
    } catch (e) {
      yield ErrorAddReview(e.toString(),
          hasGivenStar: state.hasGivenStar,
          rating: state.rating,
          comment: state.comment,
          detailOrder: state.detailOrder,
          isReviewAdded: state.isReviewAdded);
    }
  }
}

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:clients/classes/data_repository.dart';
import 'package:clients/model/review.dart';
import './bloc.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  DataRepository repository = DataRepository();

  @override
  ReviewState get initialState => LoadingReviewState();

  @override
  Stream<ReviewState> mapEventToState(
    ReviewEvent event,
  ) async* {
    if (event is GetReview) {
      yield* mapGetReviewToState(event.restaurantId, event.token);
    }
  }

  Stream<ReviewState> mapGetReviewToState(
      String restaurantId, String token) async* {
    try {
      List<Review> list = await repository.getReview(restaurantId, token);
      yield SuccessReviewState(list);
    } catch (e) {
      yield ErrorReviewState(e.toString());
    }
  }
}

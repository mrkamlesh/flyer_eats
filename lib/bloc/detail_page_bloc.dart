import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flyereats/bloc/food_repository.dart';
import 'package:flyereats/model/food.dart';
import './bloc.dart';

class DetailPageBloc extends Bloc<DetailPageEvent, DetailPageState> {
  final FoodRepository foodRepository;

  final FoodCartRepository cartRepository;

  DetailPageBloc(this.foodRepository, this.cartRepository);

  @override
  DetailPageState get initialState => Uninitialized();

  @override
  Stream<DetailPageState> mapEventToState(
    DetailPageEvent event,
  ) async* {
    print(event);
    if (event is PageOpen) {
      yield* mapPageOpenToState();
    } else if (event is SwitchVegOnly) {
      yield* mapSwitchVegOnlyToState(event.isVegOnly);
    } else if (event is SwitchCategory) {
      yield* mapSwitchCategoryToState(event.id);
    } else if (event is ChangeQuantity) {
      yield* mapChangeQuantityToState(event.id, event.food, event.quantity);
    }
  }

  Stream<DetailPageState> mapPageOpenToState() async* {
    yield OnDataLoading();
    //await Future.delayed(Duration(seconds: 2));
    try {
      List<Food> list = await foodRepository.getFoodData(true);
      yield OnDataLoaded(list);
      yield CartState(cartRepository.foodCart);
    } catch (e) {
      yield OnDataError(e.toString());
    }
  }

  Stream<DetailPageState> mapSwitchVegOnlyToState(bool isVegOnly) async* {
    yield OnDataLoading();
    try {
      List<Food> list = await foodRepository.getFoodData(isVegOnly);
      yield OnDataLoaded(list);
    } catch (e) {
      yield OnDataError(e.toString());
    }
  }

  Stream<DetailPageState> mapSwitchCategoryToState(String id) async* {
    yield OnDataLoading();
    try {
      List<Food> list = await foodRepository.getFoodData(true);
      yield OnDataLoaded(list);
    } catch (e) {
      yield OnDataError(e.toString());
    }
  }

  Stream<DetailPageState> mapChangeQuantityToState(
      int id, Food food, int quantity) async* {
    yield OnDataLoading();
    cartRepository.changeQuantity(id, food, quantity);

    yield CartState(cartRepository.foodCart);
  }
}

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flyereats/bloc/food/food_repository.dart';
import 'package:flyereats/model/food.dart';
import 'package:flyereats/model/food_cart.dart';
import 'bloc.dart';

class DetailPageBloc extends Bloc<DetailPageEvent, DetailPageState> {
  final FoodRepository foodRepository;

  FoodCartRepository foodCartRepository;

  DetailPageBloc(this.foodRepository);

  @override
  DetailPageState get initialState => Uninitialized();

  @override
  Stream<DetailPageState> mapEventToState(
    DetailPageEvent event,
  ) async* {
    print(event);
    if (event is PageDetailRestaurantOpen) {
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
    await Future.delayed(Duration(seconds: 2));
    try {
      List<Food> list = await foodRepository.getFoodData(true);
      yield OnDataLoaded(list);
      foodCartRepository = FoodCartRepository();
      yield CartState(foodCartRepository.foodCart);
    } catch (e) {
      yield OnDataError(e.toString());
    }
  }

  Stream<DetailPageState> mapSwitchVegOnlyToState(bool isVegOnly) async* {
    yield OnDataLoading();
    await Future.delayed(Duration(seconds: 2));
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
    //yield OnDataLoading();
    foodCartRepository.foodCart.changeQuantity(id, food, quantity);
    FoodCart cart = FoodCart(Map.from((foodCartRepository.foodCart).cart));

    yield CartState(cart);
  }
}

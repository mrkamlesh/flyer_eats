import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:clients/bloc/search/search_event.dart';
import 'package:clients/classes/data_repository.dart';
import 'package:clients/model/restaurant.dart';
import './bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  DataRepository repository = DataRepository();

  @override
  SearchState get initialState => InitialSearchState();

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is Search) {
      yield* mapSearchToState(event.token, event.address, event.searchText);
    } else if (event is LoadMore) {
      yield* mapLoadMoreToState(event.token, event.address);
    }
  }

  Stream<SearchState> mapSearchToState(String token, String address, String searchText) async* {
    if (searchText != "" && searchText != null) {
      yield LoadingNewSearch();
      try {
        List<Restaurant> list = await repository.globalSearch(token, searchText, address, 0);

        yield SearchState(
            page: 1,
            restaurants: list,
            hasReachedMax: list.isEmpty,
            searchText: searchText);
      } catch (e) {
        yield ErrorNewSearch(e.toString());
      }
    } else {
      yield InitialSearchState();
    }
  }

  Stream<SearchState> mapLoadMoreToState(String token, String address) async* {
    yield LoadingMore(
        page: state.page,
        hasReachedMax: state.hasReachedMax,
        searchText: state.searchText,
        restaurants: state.restaurants);

    try {
      List<Restaurant> list = await repository.globalSearch(token, state.searchText, address, state.page);
      yield SearchState(
          page: state.page + 1,
          hasReachedMax: list.isEmpty,
          searchText: state.searchText,
          restaurants: state.restaurants + list);
    } catch (e) {
      yield ErrorLoadingMore(e.toString(),
          page: state.page,
          hasReachedMax: state.hasReachedMax,
          searchText: state.searchText,
          restaurants: state.restaurants);
    }
  }

}

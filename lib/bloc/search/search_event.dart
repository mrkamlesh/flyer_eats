import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class Search extends SearchEvent {
  final String token;
  final String address;
  final String searchText;

  Search(this.token, this.address, this.searchText);

  @override
  List<Object> get props => [token, address, searchText];
}

class LoadMore extends SearchEvent {
  final String token;
  final String address;

  LoadMore(this.token, this.address);

  @override
  List<Object> get props => [token, address];
}

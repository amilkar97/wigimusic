part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
}
class LoadSearchEvent extends SearchEvent{
  final String keyword;

  const LoadSearchEvent(this.keyword);
  @override
  // TODO: implement props
  List<Object?> get props => [keyword];
}
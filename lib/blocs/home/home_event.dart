part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}


class LoadHomeEvent extends HomeEvent{
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class LoadCategoriesEvent extends HomeEvent{
  final String countryCode;

  const LoadCategoriesEvent(this.countryCode);
  @override
  // TODO: implement props
  List<Object?> get props => [countryCode];
}

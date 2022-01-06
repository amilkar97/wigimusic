part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}
class HomeLoading extends HomeState{
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class HomeLoaded extends HomeState{
  final UserGoogle userGoogle;
  final List<Category> categories;
  final List<Album> releases;

  const HomeLoaded(this.userGoogle,this.categories,this.releases);

  @override
  // TODO: implement props
  List<Object?> get props => [userGoogle,categories,releases];
}

class HomeError extends HomeState {
  final String error;

  const HomeError(this.error);

  @override
  // TODO: implement props
  List<Object?> get props => [error];

}

class LoadingCategories extends HomeState{
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

}


class LoadedCategories extends HomeState{
  final List<Category> categories;
  final UserGoogle userGoogle;
  final List<Album> releases;

  const LoadedCategories(this.categories,this.userGoogle,this.releases);
  @override
  // TODO: implement props
  List<Object?> get props => [categories,userGoogle,releases];

}
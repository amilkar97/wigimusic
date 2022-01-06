part of 'playlist_bloc.dart';

abstract class PlaylistEvent extends Equatable {
  const PlaylistEvent();
}


class LoadPlaylistEvent extends PlaylistEvent{
  final String categoryId;
  final String country;

  const LoadPlaylistEvent(this.categoryId, this.country);
  @override
  // TODO: implement props
  List<Object?> get props => [categoryId,country];
}
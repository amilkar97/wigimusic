part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();
}

class SearchInitial extends SearchState {
  @override
  List<Object> get props => [];
}

class SearchLoading extends SearchState{
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

}

class SearchLoaded extends SearchState{
  final List<Track> tracks;
  final List<Album> albums;
  final List<Playlist> playlists;

  const SearchLoaded(this.tracks, this.albums, this.playlists);


  @override
  // TODO: implement props
  List<Object?> get props => [tracks,albums,playlists];
}
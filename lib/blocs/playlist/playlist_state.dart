part of 'playlist_bloc.dart';

abstract class PlaylistState extends Equatable {
  const PlaylistState();
}

class PlaylistInitial extends PlaylistState {
  @override
  List<Object> get props => [];
}

class PlaylistLoaded extends PlaylistState{
  final List<Playlist> playlists;

  const PlaylistLoaded(this.playlists);
  @override
  List<Object?> get props => [playlists];
}

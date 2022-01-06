part of 'artist_bloc.dart';

abstract class ArtistState extends Equatable {
  const ArtistState();
}

class ArtistInitial extends ArtistState {
  @override
  List<Object> get props => [];
}

class ArtistLoaded extends ArtistState{
  final Artist artist;
  final List<Album> albums;
  final List<Track> topTracks;

  const ArtistLoaded(this.artist, this.albums, this.topTracks);
  @override
  // TODO: implement props
  List<Object?> get props => [artist,albums,topTracks];
}

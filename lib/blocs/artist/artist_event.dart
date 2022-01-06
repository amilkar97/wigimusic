part of 'artist_bloc.dart';

abstract class ArtistEvent extends Equatable {
  const ArtistEvent();
}


class LoadArtistEvent extends ArtistEvent{
  final String artistId;

  const LoadArtistEvent(this.artistId);

  @override
  List<Object?> get props => [artistId];
}
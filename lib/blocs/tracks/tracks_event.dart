part of 'tracks_bloc.dart';

abstract class TracksEvent extends Equatable {
  const TracksEvent();
}


class LoadTracksEvent extends TracksEvent{
  final String playlistId;

  const LoadTracksEvent(this.playlistId);
  @override
  List<Object?> get props => [playlistId];
}
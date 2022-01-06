part of 'tracks_bloc.dart';

abstract class TracksState extends Equatable {
  const TracksState();
}

class TracksInitial extends TracksState {
  @override
  List<Object> get props => [];
}


class TracksLoaded extends TracksState{
  final List<Track> tracks;

  const TracksLoaded(this.tracks);
  @override
  List<Object?> get props => [tracks];
}
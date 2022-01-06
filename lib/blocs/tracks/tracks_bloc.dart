import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wigi/blocs/auth/auth_bloc.dart';
import 'package:wigi/models/track_model.dart';
import 'package:wigi/services/spotify_auth_service.dart';
import 'package:dio/dio.dart';
import 'package:wigi/services/spotify_service.dart';


part 'tracks_event.dart';
part 'tracks_state.dart';

class TracksBloc extends Bloc<TracksEvent, TracksState> {
  TracksBloc() : super(TracksInitial()) {
    on<LoadTracksEvent>(_loadTracks);
  }

  Future<void> _loadTracks(LoadTracksEvent event, Emitter<TracksState> emit) async{
    try{
      final storage = FlutterSecureStorage();
      final accessToken = await storage.read(key: 'access_token');
      final service = SpotifyService.create(accessToken!);
      String? response = await service.getPlaylistTracks(event.playlistId);
      Map<String,dynamic> fullData = jsonDecode(response!);
      List<dynamic> dataConverted = fullData['items'];
      List<Track> tracks = [];
      dataConverted.forEach((element) {
        tracks.add(Track.fromJson(jsonDecode(jsonEncode(element['track']))));
      });
      emit(TracksLoaded(tracks));
    }catch(error){
      if(error is DioError){
        if(error.response!.statusCode == 401){
          await AuthBloc().authWithSpotify();
          await _loadTracks(event, emit);
        }
      }
    }
  }


}

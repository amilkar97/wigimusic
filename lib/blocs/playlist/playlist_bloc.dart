import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wigi/blocs/auth/auth_bloc.dart';
import 'package:wigi/models/playlist_model.dart';
import 'package:wigi/services/spotify_auth_service.dart';
import 'package:dio/dio.dart';
import 'package:wigi/services/spotify_service.dart';
part 'playlist_event.dart';
part 'playlist_state.dart';

class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  FlutterSecureStorage storage = const FlutterSecureStorage();

  PlaylistBloc() : super(PlaylistInitial()) {
    on<LoadPlaylistEvent>(_loadPlaylist);
  }

  Future<void> _loadPlaylist(LoadPlaylistEvent event, Emitter<PlaylistState> emit) async{
    try{
      final accessToken = await storage.read(key: 'access_token');
      final service = SpotifyService.create(accessToken!);
      String? response = await service.getCategoryPlaylists(event.categoryId, event.country);
      Map<String, dynamic> fullData = jsonDecode(response!);
      List<dynamic> playlistConverted = fullData['playlists']['items'];
      List<Playlist> playlists = [];
      playlistConverted.forEach((element) {playlists.add(Playlist.fromJson(element));});
      emit(PlaylistLoaded(playlists));
    }catch(error){
      if(error is DioError){
        if(error.response!.statusCode == 401){
          await AuthBloc().authWithSpotify();
          await _loadPlaylist(event, emit);
        }
      }
    }
  }


}

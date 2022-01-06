import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wigi/blocs/auth/auth_bloc.dart';
import 'package:wigi/models/album_model.dart';
import 'package:wigi/models/playlist_model.dart';
import 'package:wigi/models/track_model.dart';
import 'package:wigi/services/spotify_auth_service.dart';
import 'package:wigi/services/spotify_service.dart';
part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  FlutterSecureStorage storage = FlutterSecureStorage();
  SearchBloc() : super(SearchInitial()) {
    on<LoadSearchEvent>(_loadSearch);
  }

  Future<void> _loadSearch(LoadSearchEvent event, Emitter<SearchState> emit) async{

    try{
      emit(SearchLoading());
      final accessToken = await storage.read(key: 'access_token');
      final service = SpotifyService.create(accessToken!);
      final fullData = await service.search(event.keyword,'album,artist,playlist,track,show,episode');
      Map<String, dynamic> dataConverted = jsonDecode(fullData!);
      List<dynamic> trackList = dataConverted['tracks']['items'];
      List<dynamic> albumList = dataConverted['albums']['items'];
      List<dynamic> paylistList = dataConverted['playlists']['items'];

      List<Track> tracks = [];
      List<Album> albums = [];
      List<Playlist> playlists = [];

      for (var element in trackList) {tracks.add(Track.fromJson(element));}
      for (var element in albumList) {albums.add(Album.fromJson(element));}
      for (var element in paylistList) {playlists.add(Playlist.fromJson(element));}

      emit(SearchLoaded(tracks,albums,playlists));
    }catch(error){
      if(error is DioError){
        if(error.response!.statusCode == 401){
          await AuthBloc().authWithSpotify();
          await _loadSearch(event, emit);

        }
      }
    }
  }

}

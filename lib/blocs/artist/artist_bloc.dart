import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wigi/blocs/auth/auth_bloc.dart';
import 'package:wigi/models/album_model.dart';
import 'package:dio/dio.dart';
import 'package:wigi/models/track_model.dart';
import 'package:wigi/services/spotify_auth_service.dart';
import 'package:wigi/services/spotify_service.dart';
part 'artist_event.dart';
part 'artist_state.dart';

class ArtistBloc extends Bloc<ArtistEvent, ArtistState> {
  FlutterSecureStorage storage = const FlutterSecureStorage();

  ArtistBloc() : super(ArtistInitial()) {
    on<LoadArtistEvent>(_loadArtist);
  }

  Future<void> _loadArtist(LoadArtistEvent event, Emitter<ArtistState> emit) async{
    try{
      final accessToken = await storage.read(key: 'access_token');
      final country = await storage.read(key: 'country');
      final service = SpotifyService.create(accessToken!);
      final artistResponse = await service.getArtist(event.artistId);
      final artistAlbumResponse = await service.getArtistAlbums(event.artistId);
      final artistTopTracksResponse = await service.getArtistTopTracks(event.artistId,country!);
      Map<String, dynamic> artistResponseFullData = jsonDecode(artistResponse!);
      Map<String, dynamic> artistAlbumResponseFullData = jsonDecode(artistAlbumResponse!);
      Map<String, dynamic> artistTopTracksResponseFullData = jsonDecode(artistTopTracksResponse!);

      var artistFromJson = {
        'id':artistResponseFullData['id'],
        'name': artistResponseFullData['name'],
        'followers': artistResponseFullData['followers']['total'],
        'genres': artistResponseFullData['genres'],
        'images': artistResponseFullData['images'],
        'popularity': artistResponseFullData['popularity']
      };

      Artist artist = Artist.fromJson(artistFromJson);
      List<dynamic> albumList = artistAlbumResponseFullData['items'];
      List<Album> albums = [];
      for(var element in albumList){
        albums.add(Album.fromJson(element));
      }
      List<dynamic> topTracksList = artistTopTracksResponseFullData['tracks'];
      List<Track> topTracks = [];
      for(var element in topTracksList){
        topTracks.add(Track.fromJson(element));
      }
      emit(ArtistLoaded(artist,albums,topTracks));
    }catch(error){
      if(error is DioError){
        print(error.response!.data);
        if(error.response!.statusCode == 401){
          await AuthBloc().authWithSpotify();
          await _loadArtist(event, emit);
        }
      }
    }
  }

}

import 'dart:io';

import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'spotify_service.g.dart';

@RestApi(baseUrl: "https://api.spotify.com/v1")
abstract class SpotifyService {
  factory SpotifyService(Dio dio, {String baseUrl}) = _SpotifyService;

  @GET("/browse/categories")
  Future<String?> getCategories(@Query('country') String country);

  @GET("/browse/new-releases")
  Future<String?> getReleases(@Query('country') String country);

  @GET("/browse/categories/{category_id}/playlists")
  Future<String?> getCategoryPlaylists(@Path('category_id') String categoryId,@Query('country') String country);

  @GET("/playlists/{playlist_id}/tracks")
  Future<String?> getPlaylistTracks(@Path('playlist_id') String playlistID);

  @GET("/artists/{id}")
  Future<String?> getArtist(@Path('id') String artistId);

  @GET("/artists/{id}/albums")
  Future<String?> getArtistAlbums(@Path('id') String artistId);

  @GET("/artists/{id}/top-tracks")
  Future<String?> getArtistTopTracks(@Path('id') String artistId,@Query('market') String country);

  @GET("/search")
  Future<String?> search(@Query('q') String keyword,@Query('type') String type);

  static SpotifyService create(String token){
    final dio = Dio();
    dio.options.headers[HttpHeaders.acceptHeader] = 'application/json';
    dio.options.headers[HttpHeaders.contentTypeHeader] = 'application/json';
    dio.options.headers[HttpHeaders.authorizationHeader] = 'Bearer '+token;

    return SpotifyService(dio);
  }
}
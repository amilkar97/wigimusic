import 'dart:io';

import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'spotify_auth_service.g.dart';

@RestApi(baseUrl: "https://accounts.spotify.com")
abstract class SpotifyAuthService {
  factory SpotifyAuthService(Dio dio, {String baseUrl}) = _SpotifyAuthService;

  @GET("/authorize")
  Future<String?> auth(@Queries() Map<String,dynamic> map);

  @POST("/api/token")
  Future<String?> getToken(@Body() Map<String,dynamic> map,@Header('Authorization') String credentials);

  static SpotifyAuthService create(){
    final dio = Dio();
    dio.options.headers[HttpHeaders.acceptHeader] = 'application/json';
    dio.options.headers[HttpHeaders.contentTypeHeader] = 'application/x-www-form-urlencoded';

    return SpotifyAuthService(dio);
  }
}
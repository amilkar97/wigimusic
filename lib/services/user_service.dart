import 'dart:io';

import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'user_service.g.dart';

@RestApi(baseUrl: "https://apim3w.com/api/index.php/v1/soap/LoginUsuario.json")
abstract class UserService {
  factory UserService(Dio dio, {String baseUrl}) = _UserService;

  @POST("/")
  Future<String?> getUserData(@Body() Map<String,dynamic> map);

  static UserService create(){
    final dio = Dio();
    dio.options.headers[HttpHeaders.acceptHeader] = 'application/json';
    dio.options.headers[HttpHeaders.contentTypeHeader] = 'application/json';
    dio.options.headers['X-MC-SO'] = 'WigilabsTest';


    return UserService(dio);
  }
}
import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wigi/blocs/auth/auth_bloc.dart';
import 'package:wigi/models/category_model.dart';
import 'package:wigi/models/album_model.dart';
import 'package:wigi/models/user_google_model.dart';
import 'package:dio/dio.dart';
import 'package:wigi/services/spotify_service.dart';
import 'package:wigi/utilities/firebase_messaging.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  FlutterSecureStorage storage = const FlutterSecureStorage();

  HomeBloc() : super(HomeInitial()) {
    on<LoadHomeEvent>(_loadHome);
    on<LoadCategoriesEvent>(_loadCategories);
  }
  Future<void> _loadCategories(LoadCategoriesEvent event, Emitter<HomeState> emit) async{
    try{
      await storage.write(key: 'country', value: event.countryCode);
      final token = await storage.read(key: 'access_token');
      final service = SpotifyService.create(token!);
      String? responseCategories = await service.getCategories(event.countryCode);
      String? responseReleases = await service.getReleases(event.countryCode);

      //adding categories
      Map<String, dynamic> fullDataCategories = jsonDecode(responseCategories!);
      List<dynamic> dataCategories = fullDataCategories['categories']['items'];
      List<Category> categories = [];
      for (var element in dataCategories) {categories.add(Category.fromJson(element));}
      //adding releases
      Map<String, dynamic> fullDataReleases = jsonDecode(responseReleases!);
      List<dynamic> dataReleases = fullDataReleases['albums']['items'];
      List<Album> releases = [];
      for (var element in dataReleases) {releases.add(Album.fromJson(element));}
      String? userData = await storage.read(key: 'user');
      if(userData != null) {
        UserGoogle userGoogle = UserGoogle.fromJson(jsonDecode(userData));
        emit(LoadedCategories(categories,userGoogle,releases));
      }
    }catch(error){
      if(error is DioError){
        switch(error.response!.statusCode){
          case 400:
            emit(const HomeError('No se encontro esta ruta'));break;
          case 401:
            await AuthBloc().authWithSpotify();
            await _loadCategories(event,emit);break;
        }
      }else{
        emit(const HomeError('Error, ha pasado algo inesperado'));
      }
    }
  }
  Future<void> _loadHome(LoadHomeEvent event, Emitter<HomeState> emit) async{
    try{
      String? userData = await storage.read(key: 'user');
      final firebasemessaging = PushNotifications();
      final String? pushToken = await firebasemessaging.initNotifications();
      await storage.write(key: 'push_token', value: pushToken);
      if(userData != null) {
       UserGoogle userGoogle = UserGoogle.fromJson(jsonDecode(userData));
       String? category = await storage.read(key: 'category');
       if(category == null){
         final token = await storage.read(key: 'access_token');
         final service = SpotifyService.create(token!);
         String? responseCategories = await service.getCategories('CO');
         String? responseReleases = await service.getReleases('CO');
         await storage.write(key: 'country', value: 'CO');

         //adding categories
         Map<String, dynamic> fullDataCategories = jsonDecode(responseCategories!);
         List<dynamic> dataCategories = fullDataCategories['categories']['items'];
         List<Category> categories = [];
         for (var element in dataCategories) {categories.add(Category.fromJson(element));}
        //adding releases
         Map<String, dynamic> fullDataReleases = jsonDecode(responseReleases!);
         List<dynamic> dataReleases = fullDataReleases['albums']['items'];
         List<Album> releases = [];
         for (var element in dataReleases) {releases.add(Album.fromJson(element));}
         emit(HomeLoaded(userGoogle,categories,releases));
       }
      }
    }catch(error){
      if(error is DioError){
        switch(error.response!.statusCode){
          case 400:
            emit(const HomeError('No se encontro esta ruta'));break;
          case 401:
            await AuthBloc().authWithSpotify();
            await _loadHome(event,emit);
            break;
        }
      }else{
         emit(const HomeError('Error, ha pasado algo inesperado'));
      }
    }

  }


}

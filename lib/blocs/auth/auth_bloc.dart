import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wigi/services/spotify_auth_service.dart';
import 'package:wigi/services/user_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  late FirebaseAuth auth;
  FlutterSecureStorage storage = const FlutterSecureStorage();

  AuthBloc() : super(AuthInitial()) {
    auth = FirebaseAuth.instance;

    on<LoginWithCredentials>(_doLoginWithCredentials);
    on<LoginWithGoogle>(_doLoginWithGoogle);
    on<LoginWithFacebook>(_doLoginWithFacebook);
    on<SignOutEvent>(_doSignOut);

  }
  Future<void> _doLoginWithGoogle(LoginWithGoogle event, Emitter<AuthState> emit) async{
    try{
      emit(const LoggingState('social'));
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      final googleCredential = GoogleAuthProvider.credential(accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken,);
      await auth.signInWithCredential(googleCredential);
      await authWithSpotify();
      await authOtherAccount('social');
    }catch(error){
      print(error);
      if(error is FirebaseAuthException){
        emit(LoginError(error.message!));
      }
      if(error is DioError){
        print(error.response!.statusCode);
        print(error.response!.statusMessage);
        print(error.response);
      }
    }
  }

  Future<void> _doLoginWithCredentials(LoginWithCredentials event, Emitter<AuthState> emit) async{
    try{
      emit(const LoggingState('credentials'));
      await auth.signInWithEmailAndPassword(email: event.email, password: event.password);
      await authWithSpotify();
      await authOtherAccount('credentials');
    }on FirebaseAuthException catch(error){
      print(error.message);
      if (error.code == 'user-not-found') {
        emit(const LoginError('No se ha encontrado este correo en el sistema'));
      } else if (error.code == 'wrong-password') {
        emit(const LoginError('Contraseña incorrecta'));
      }
    }
  }

  Future<void> _doLoginWithFacebook(LoginWithFacebook event, Emitter<AuthState> emit) async{
    try{
      final LoginResult result = await FacebookAuth.instance.login();
      final AuthCredential facebookCredential = FacebookAuthProvider.credential(result.accessToken!.token);
      await auth.signInWithCredential(facebookCredential);
      emit(const LoggingState('social'));
      await authWithSpotify();
      await authOtherAccount('social');
    }catch(error){
      if(error is FirebaseAuthException){

      }
    }
  }

  Future<void> authWithSpotify() async{
    try{
      final authSpotifyService = SpotifyAuthService.create();
      Map<String, dynamic> authorizationTokenBody = {
        'grant_type': 'client_credentials'
      };
      String? authorizationTokenResponse = await authSpotifyService.getToken(authorizationTokenBody,'Basic '+dotenv.env['CREDENTIALS'].toString());
      if(authorizationTokenResponse != null){
        Map<String, dynamic> authorizationTokenResponseConverted = jsonDecode(authorizationTokenResponse);
        await storage.write(key: 'access_token', value: authorizationTokenResponseConverted['access_token']);
      }
    }catch(error){
      print(error);
      if(error is DioError){
        print(error.response!.statusCode);
        print(error.response!.statusMessage);
      }
    }

  }

  Future<void> authOtherAccount(mode) async{
    try{
      Map<String, dynamic> data = {
        "data":{
          "nombreUsuario":
          "odraude1362@gmail.com",
          "clave":"Jorgito123"
        }
      };
      final userService = UserService.create();
      String? response = await userService.getUserData(data);

      if(response != null) {
        Map<String, dynamic> data = jsonDecode(response);
        Map<String, dynamic> userData = {
          'email': data['response']['usuario']['UserProfileID'],
          'name': data['response']['usuario']['nombre'],
          'lastname': data['response']['usuario']['apellido'],
          'documentNumber': data['response']['usuario']['DocumentNumber'],
        };
        await storage.write(key: 'user', value: jsonEncode(userData));
        emit(LoggedState(mode));
      }
    }catch(error){
      print(error);
      if(error is DioError){
        print(error.response!.statusCode);
        print(error.response!.statusMessage);
        print(error.message);
      }
    }


  }

  Future<void> _doSignOut(SignOutEvent event, Emitter<AuthState> emit) async{
    try{
      await auth.signOut();
      const localStorage = FlutterSecureStorage();
      localStorage.deleteAll();
      emit(ClosedSessionState());
    }on FirebaseAuthException catch (error){
      emit(SignOutError(error.message!));
    }
  }



}

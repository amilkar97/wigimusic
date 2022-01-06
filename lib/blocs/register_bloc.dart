import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial()) {
    on<doRegisterEvent>(_doRegister);
  }
  Future<void> _doRegister(doRegisterEvent event,Emitter<RegisterState> emit) async {
    emit(RegisterIsLoading());
    try{
      final _auth = FirebaseAuth.instance;
      UserCredential user = await _auth.createUserWithEmailAndPassword(email: event.email, password: event.password);
      //final localStorage = FlutterSecureStorage();
      //await localStorage.write(key: 'uid', value: user.user!.uid);
      emit(RegisterIsDone());
    }on FirebaseAuthException catch (error){
      emit(RegisterError(error.message.toString()));
    }
  }
}

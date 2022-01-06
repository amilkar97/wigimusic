part of 'register_bloc.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();
}

class RegisterInitial extends RegisterState {
  @override
  List<Object> get props => [];
}

class RegisterIsLoading extends RegisterState{

  @override
  List<Object?> get props => [];
}

class RegisterIsDone extends RegisterState{

  @override
  List<Object?> get props => throw UnimplementedError();
}

class RegisterError extends RegisterState{
  final String error;

  const RegisterError(this.error);

  @override
  // TODO: implement props
  List<Object?> get props => [this.error];

}

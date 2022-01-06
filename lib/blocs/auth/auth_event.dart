part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class LoginWithCredentials extends AuthEvent{
  final String email;
  final String password;

  const LoginWithCredentials(this.email, this.password);
  @override
  List<Object?> get props => [email,password];
}

class LoginWithGoogle extends AuthEvent{
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class LoginWithFacebook extends AuthEvent{
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class SignOutEvent extends AuthEvent{
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
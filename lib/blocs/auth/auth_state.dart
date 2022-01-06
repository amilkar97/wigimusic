part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

class LoggingState extends AuthState{
  final String mode;

  const LoggingState(this.mode);
  @override
  List<Object?> get props => [mode];
}

class LoggedState extends AuthState{
  final String mode;

  const LoggedState(this.mode);

  @override
  List<Object?> get props =>  [mode];
}

class LoginError extends AuthState{
  final String error;

  const LoginError(this.error);
  @override
  List<Object?> get props => [error];
}

class ClosingSessionState extends AuthState{
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class ClosedSessionState extends AuthState{
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

}

class SignOutError extends AuthState{
  final String error;

  const SignOutError(this.error);
  @override
  List<Object?> get props => [error];
}

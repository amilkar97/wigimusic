part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

}


class doRegisterEvent extends RegisterEvent{
  final String email;
  final String password;

  const doRegisterEvent(this.email, this.password);

  @override
  List<Object?> get props => [email,password];
}
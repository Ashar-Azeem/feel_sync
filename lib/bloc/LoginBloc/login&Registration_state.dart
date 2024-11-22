part of 'login&Registration_bloc.dart';

class LoginState extends Equatable {
  final Loginandregisterationstatus status;
  final String error;
  const LoginState(
      {this.status = Loginandregisterationstatus.sucess, this.error = ''});

  LoginState copyWith({Loginandregisterationstatus? status, String? error}) {
    return LoginState(
        status: status ?? this.status, error: error ?? this.error);
  }

  @override
  List<Object> get props => [status];
}

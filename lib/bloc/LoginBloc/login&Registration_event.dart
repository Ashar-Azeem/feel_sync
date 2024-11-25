part of 'login&Registration_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class Login extends LoginEvent {
  final String email;
  final String password;

  const Login({required this.email, required this.password});
}

class Registration extends LoginEvent {
  final String email;
  final String password;
  final String fullName;
  final String userName;
  final Uint8List? file;
  final String gender;
  final DateTime DOB;
  const Registration(
      {required this.fullName,
      required this.userName,
      required this.email,
      required this.password,
      this.file,
      required this.DOB,
      required this.gender});
}

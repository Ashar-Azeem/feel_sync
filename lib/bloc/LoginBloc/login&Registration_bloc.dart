import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:feel_sync/Services/AuthService.dart';
import 'package:feel_sync/Utilities/LoginAndRegisterationStatus.dart';

part 'login&Registration_event.dart';
part 'login&Registration_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {
    on<Login>(login);
    on<Registration>(register);
  }

  void login(Login event, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: Loginandregisterationstatus.loading));
    await AuthService()
        .login(email: event.email, password: event.password)
        .then((user) {
      if (user != null) {
        emit(state.copyWith(
            status: Loginandregisterationstatus.sucess, error: ""));
      } else {
        emit(state.copyWith(
            status: Loginandregisterationstatus.failure,
            error: "Something went wrong, please try again later"));
      }
    }).onError((error, stackTrace) {
      emit(state.copyWith(
          status: Loginandregisterationstatus.failure,
          error: error.toString()));
    });
  }

  void register(Registration event, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: Loginandregisterationstatus.loading));
    try {
      //DataBase Tasks:
      // bool checkUserName = await db.userNameExists(u);
      // if (!checkUserName) {
      await AuthService()
          .createUser(email: event.email, password: event.password);

      //Perform DataBase Tasks Here:
      // if (file != null) {
      //   file = await compressImage(file);
      //   url = await uploadImageGetUrl(file, "profile", false);
      // }

      // await db.insertUser(
      //     FirebaseAuth.instance.currentUser!.uid, n, u, url, [], [], token);

      emit(state.copyWith(
          status: Loginandregisterationstatus.sucess, error: ""));

      //   else {
      //      emit(state.copyWith(
      //  status: Loginandregisterationstatus.failure,
      //  error: "Username already exists"));
      // }
    } catch (error) {
      emit(state.copyWith(
          status: Loginandregisterationstatus.failure,
          error: error.toString()));
    }
  }
}

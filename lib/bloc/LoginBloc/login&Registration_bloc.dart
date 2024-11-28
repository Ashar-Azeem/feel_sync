import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:feel_sync/Services/AWS_StorageService.dart';
import 'package:feel_sync/Services/AuthService.dart';
import 'package:feel_sync/Services/CRUD.dart';
import 'package:feel_sync/Services/Messaging.dart';
import 'package:feel_sync/Utilities/Image.dart';
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
      bool checkUserName = await Crud().userNameExists(event.userName);
      if (!checkUserName) {
        await AuthService()
            .createUser(email: event.email, password: event.password);

        //Adding a profile picture
        String? profile;

        if (event.file != null) {
          final compressedFile = await compressImage(event.file!);
          profile = await uploadImageWithUUID(imageData: compressedFile);
        }

        //DataBase Tasks
        int age =
            (DateTime.now().difference(event.DOB).inDays / 365.25).toInt();
        String token = await Messaging().getFCMToken();
        await Crud().insertUser(AuthService().getUser()!.uid, event.fullName,
            event.userName, profile, token, age, event.gender);

        emit(state.copyWith(
            status: Loginandregisterationstatus.sucess, error: ""));
      } else {
        emit(state.copyWith(
            status: Loginandregisterationstatus.failure,
            error: "Username already exists"));
      }
    } catch (error) {
      final user = AuthService().getUser();
      if (user != null) {
        await user.delete();
      }
      emit(state.copyWith(
          status: Loginandregisterationstatus.failure,
          error: error.toString()));
    }
  }
}

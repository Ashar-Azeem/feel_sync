// ignore_for_file: use_build_context_synchronously
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:feel_sync/Models/user.dart';
import 'package:feel_sync/Services/AWS_StorageService.dart';
import 'package:feel_sync/Services/AuthService.dart';
import 'package:feel_sync/Services/CRUD.dart';
import 'package:feel_sync/Utilities/ReusableUI/ErrorMessage.dart';
import 'package:feel_sync/Utilities/Image.dart';
import 'package:feel_sync/Utilities/ReusableUI/ShowEditUserProfile.dart';
import 'package:feel_sync/bloc/user/user_state.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
part 'user_event.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc(PersistentTabController controller)
      : super(UserState(controller: controller)) {
    on<FetchUser>(fetchUser);
    on<ChangeProfilePicture>(changeProfilePicture);
    on<ChangeName>(changeName);
    on<ChangeUserName>(changeUserName);
    on<ChangeAboutSection>(changeAboutSection);
    on<LogOut>(logOut);
  }

  void fetchUser(FetchUser event, Emitter<UserState> emit) async {
    try {
      User user = await Crud().getUser(event.userId) as User;

      emit(state.copyWith(user: user, state: States.done));
    } catch (e) {
      emit(state.copyWith(state: States.error));
    }
  }

  void changeProfilePicture(
      ChangeProfilePicture event, Emitter<UserState> emit) async {
    Uint8List? img = await imagepicker(ImageSource.gallery);
    try {
      String? profile;
      if (img != null) {
        emit(state.copyWith(profileState: ProfileState.loading));

        final compressedFile = await compressImage(img);
        profile = await uploadImageWithUUID(imageData: compressedFile);
        bool validationOfUpdate = await Crud().changeProfilePictureInDataBase(
            userId: state.user!.userId, profileLocation: profile);
        if (validationOfUpdate) {
          emit(state.copyWith(
              user: state.user!.copyWith(profileLocation: profile),
              profileState: ProfileState.done));
        }
      }
    } catch (e) {
      print(e.toString());
      emit(state.copyWith(profileState: ProfileState.error));
    }
  }

  void changeName(ChangeName event, Emitter<UserState> emit) async {
    try {
      String? updatedName =
          await showUserTextEditor(event.context, "Name", state.user!.name);
      if (updatedName != null) {
        if (updatedName.trim().isEmpty) {
          await showErrorDialog(
              event.context, "You can't leave you 'Name' blank");
        } else if (updatedName != state.user!.name) {
          emit(state.copyWith(nameState: NameStates.loading));
          await Crud()
              .changeName(userId: state.user!.userId, newName: updatedName)
              .then((check) async {
            if (check) {
              emit(state.copyWith(
                  nameState: NameStates.done,
                  user: state.user!.copyWith(name: updatedName)));
              return;
            } else {
              emit(state.copyWith(nameState: NameStates.error));
              await showErrorDialog(event.context, "Something went wrong");
              return;
            }
          });
        }
      }
    } catch (e) {
      emit(state.copyWith(nameState: NameStates.error));
      return;
    }
  }

  void changeUserName(ChangeUserName event, Emitter<UserState> emit) async {
    try {
      String? updatedUserName = await showUserTextEditor(
          event.context, "UserName", state.user!.userName);
      if (updatedUserName != null) {
        if (updatedUserName.trim().isEmpty) {
          await showErrorDialog(
              event.context, "You can't leave you 'User Name' empty");
        } else if (updatedUserName != state.user!.userName) {
          emit(state.copyWith(userNameState: UserNameStates.loading));
          await Crud()
              .changeUserName(
                  userId: state.user!.userId, newUserName: updatedUserName)
              .then((check) async {
            if (check) {
              emit(state.copyWith(
                  userNameState: UserNameStates.done,
                  user: state.user!.copyWith(userName: updatedUserName)));
              return;
            } else {
              emit(state.copyWith(userNameState: UserNameStates.error));
              await showErrorDialog(event.context, "Something went wrong");
              return;
            }
          }).onError((error, stacktrace) async {
            if (error.toString().contains("User Already Exists")) {
              emit(state.copyWith(userNameState: UserNameStates.error));
              await showErrorDialog(event.context, "User Name Already Exists");
              return;
            }
          });
        }
      }
    } catch (e) {
      emit(state.copyWith(userNameState: UserNameStates.error));
      return;
    }
  }

  void changeAboutSection(
      ChangeAboutSection event, Emitter<UserState> emit) async {
    try {
      String? updatedAboutSection =
          await showUserTextEditor(event.context, "About", state.user!.bio);

      if (updatedAboutSection != null) {
        if (updatedAboutSection != state.user!.bio) {
          emit(state.copyWith(aboutSectionState: AboutSectionStates.loading));
          await Crud()
              .changeAboutSection(
                  userId: state.user!.userId, newAbout: updatedAboutSection)
              .then((check) async {
            if (check) {
              emit(state.copyWith(
                  aboutSectionState: AboutSectionStates.done,
                  user: state.user!.copyWith(bio: updatedAboutSection)));
              return;
            } else {
              emit(state.copyWith(aboutSectionState: AboutSectionStates.error));
              await showErrorDialog(event.context, "Something went wrong");
              return;
            }
          });
        }
      }
    } catch (e) {
      emit(state.copyWith(aboutSectionState: AboutSectionStates.error));
      return;
    }
  }

  void logOut(LogOut event, Emitter<UserState> emit) async {
    emit(state.copyWith(logOutState: LogOutState.loading));
    await AuthService().logout();
    emit(state.copyWith(logOutState: LogOutState.yes));
  }
}

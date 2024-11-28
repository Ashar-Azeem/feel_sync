import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:feel_sync/Models/user.dart';
import 'package:feel_sync/Services/AWS_StorageService.dart';
import 'package:feel_sync/Services/CRUD.dart';
import 'package:feel_sync/Utilities/Image.dart';
import 'package:feel_sync/bloc/user/user_state.dart';
import 'package:image_picker/image_picker.dart';
part 'user_event.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(const UserState()) {
    on<FetchUser>(fetchUser);
    on<ChangeProfilePicture>(changeProfilePicture);
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
}

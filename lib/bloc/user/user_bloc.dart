import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:feel_sync/Models/user.dart';
import 'package:feel_sync/Services/CRUD.dart';
import 'package:feel_sync/bloc/user/user_state.dart';
part 'user_event.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(const UserState()) {
    on<FetchUser>(fetchUser);
  }

  void fetchUser(FetchUser event, Emitter<UserState> emit) async {
    try {
      User user = await Crud().getUser(event.userId) as User;
      emit(state.copyWith(user, States.done));
    } catch (e) {
      emit(state.copyWith(null, States.error));
    }
  }
}

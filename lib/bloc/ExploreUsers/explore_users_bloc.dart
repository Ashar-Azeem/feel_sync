import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:feel_sync/Models/user.dart';
part 'explore_users_event.dart';
part 'explore_users_state.dart';

class ExploreUsersBloc extends Bloc<ExploreUsersEvent, ExploreUsersState> {
  ExploreUsersBloc() : super(const ExploreUsersState()) {
    on<FetchUsers>(fetchUsers);
  }

  void fetchUsers(FetchUsers event, Emitter<ExploreUsersState> emit) {
    List<User> listOfUsers = [];
    for (DocumentSnapshot d in event.snapshsot) {
      listOfUsers.add(User.fromDocumentSnapshot(d));
    }

    for (User user in listOfUsers) {
      if (!state.users.contains(user)) {
        emit(state.copyWith(users: listOfUsers));
      }
    }
  }
}

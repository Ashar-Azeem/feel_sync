import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:feel_sync/Models/user.dart';
import 'package:feel_sync/Services/CRUD.dart';
part 'explore_users_event.dart';
part 'explore_users_state.dart';

class ExploreUsersBloc extends Bloc<ExploreUsersEvent, ExploreUsersState> {
  ExploreUsersBloc() : super(const ExploreUsersState()) {
    on<FetchUsers>(fetchUsers);
    on<Search>(searchUser);
    on<SearchEnded>(searchEnded);
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

  void searchUser(Search event, Emitter<ExploreUsersState> emit) async {
    if (state.previousQuery != event.query) {
      //Enables the list view for searching a specific user
      emit(state.copyWith(searching: Searching.yes));

      //First checking in the local cache
      List<User> filteredUsers = state.users.where((user) {
        return user.userName.compareTo(event.query) >= 0 &&
            user.userName.compareTo('${event.query}z') < 0;
      }).toList();
      if (filteredUsers.isNotEmpty) {
        emit(state.copyWith(searchedUser: List.from(filteredUsers)));
      } else {
        emit(state.copyWith(searchingState: SearchingState.loading));
        await Crud().retreiveUsers(event.query).then((list) {
          emit(state.copyWith(
              searchedUser: List.from(list),
              searchingState: SearchingState.done));
        });
      }

      emit(state.copyWith(previousQuery: event.query));
    }
  }

  void searchEnded(SearchEnded event, Emitter<ExploreUsersState> emit) {
    if (state.searching == Searching.yes) {
      emit(state.copyWith(searching: Searching.no));
    }
  }
}

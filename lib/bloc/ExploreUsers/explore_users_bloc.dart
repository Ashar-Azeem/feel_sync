import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:feel_sync/Models/user.dart';
import 'package:feel_sync/Services/CRUD.dart';
part 'explore_users_event.dart';
part 'explore_users_state.dart';

class ExploreUsersBloc extends Bloc<ExploreUsersEvent, ExploreUsersState> {
  ExploreUsersBloc() : super(const ExploreUsersState()) {
    on<Cache>(fetchUsers);
    on<Search>(searchUser);
    on<SearchEnded>(searchEnded);
  }

  void fetchUsers(Cache event, Emitter<ExploreUsersState> emit) {
    List<User> listOfUsers = [];
    for (DocumentSnapshot d in event.snapshsot) {
      listOfUsers.add(User.fromDocumentSnapshot(d));
    }

    if (utilityFunction(listOfUsers)) {
      emit(state.copyWith(users: listOfUsers));
    }
  }

  void searchUser(Search event, Emitter<ExploreUsersState> emit) async {
    //Enables the list view for searching a specific user
    emit(state.copyWith(searching: Searching.yes));

    //First checking in the local cache
    List<User> filteredUsers = state.users.where((user) {
      return user.userName.compareTo(event.query) >= 0 &&
          user.userName.compareTo('${event.query}z') < 0;
    }).toList();
    if (filteredUsers.isNotEmpty && !checkInSearchedUsers(filteredUsers)) {
      emit(state.copyWith(
          searchedUser: List.from(filteredUsers),
          searchingState: SearchingState.done));
    } else {
      emit(state.copyWith(searchingState: SearchingState.loading));
      await Crud().retreiveUsers(event.query).then((list) {
        emit(state.copyWith(
            searchedUser: List.from(list),
            searchingState: SearchingState.done));
      });
    }
  }

  void searchEnded(SearchEnded event, Emitter<ExploreUsersState> emit) {
    if (state.searching == Searching.yes) {
      emit(state.copyWith(searching: Searching.no));
    }
  }

  bool utilityFunction(List<User> newUsersList) {
    for (User user in newUsersList) {
      if (!state.users.contains(user)) {
        return true;
      }
    }
    return false;
  }

  bool checkInSearchedUsers(List<User> newUsersList) {
    for (User user in newUsersList) {
      if (!state.searchedUser.contains(user)) {
        return true;
      }
    }
    return false;
  }
}

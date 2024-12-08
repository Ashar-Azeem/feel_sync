part of 'explore_users_bloc.dart';

class ExploreUsersState extends Equatable {
  final List<User> users;
  final List<User> searchedUser;
  final Searching searching;
  final SearchingState searchingState;

  const ExploreUsersState(
      {this.searchingState = SearchingState.done,
      this.searching = Searching.no,
      this.searchedUser = const [],
      this.users = const []});

  ExploreUsersState copyWith(
      {List<User>? users,
      List<User>? searchedUser,
      Searching? searching,
      SearchingState? searchingState}) {
    return ExploreUsersState(
      users: users ?? this.users,
      searchedUser: searchedUser ?? this.searchedUser,
      searching: searching ?? this.searching,
      searchingState: searchingState ?? this.searchingState,
    );
  }

  @override
  List<Object> get props => [users, searchedUser, searching, searchingState];
}

enum Searching { yes, no }

enum SearchingState { loading, done }

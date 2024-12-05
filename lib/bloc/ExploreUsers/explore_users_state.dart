part of 'explore_users_bloc.dart';

class ExploreUsersState extends Equatable {
  final List<User> users;
  final List<User> searchedUser;
  final Searching searching;
  final SearchingState searchingState;
  final String previousQuery;

  const ExploreUsersState(
      {this.previousQuery = '',
      this.searchingState = SearchingState.done,
      this.searching = Searching.no,
      this.searchedUser = const [],
      this.users = const []});

  ExploreUsersState copyWith(
      {List<User>? users,
      List<User>? searchedUser,
      Searching? searching,
      SearchingState? searchingState,
      String? previousQuery}) {
    return ExploreUsersState(
        users: users ?? this.users,
        searchedUser: searchedUser ?? this.searchedUser,
        searching: searching ?? this.searching,
        searchingState: searchingState ?? this.searchingState,
        previousQuery: previousQuery ?? this.previousQuery);
  }

  @override
  List<Object> get props =>
      [users, searchedUser, searching, searchingState, previousQuery];
}

enum Searching { yes, no }

enum SearchingState { loading, done }

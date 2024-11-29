part of 'explore_users_bloc.dart';

class ExploreUsersState extends Equatable {
  final List<User> users;

  const ExploreUsersState({this.users = const []});

  ExploreUsersState copyWith({List<User>? users}) {
    return ExploreUsersState(users: users ?? this.users);
  }

  @override
  List<Object> get props => [users];
}

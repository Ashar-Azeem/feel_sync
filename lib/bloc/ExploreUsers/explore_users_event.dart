part of 'explore_users_bloc.dart';

abstract class ExploreUsersEvent extends Equatable {
  const ExploreUsersEvent();

  @override
  List<Object> get props => [];
}

class FetchUsers extends ExploreUsersEvent {
  final List<DocumentSnapshot<Object?>> snapshsot;

  const FetchUsers({required this.snapshsot});
}

class Search extends ExploreUsersEvent {
  final String query;

  const Search({required this.query});
}

class SearchEnded extends ExploreUsersEvent {}

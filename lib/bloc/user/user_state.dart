import 'package:equatable/equatable.dart';
import 'package:feel_sync/Models/user.dart';

class UserState extends Equatable {
  final User? user;
  final States state;

  const UserState({this.user, this.state = States.loading});

  UserState copyWith(User? user, States? state) {
    return UserState(user: user ?? this.user, state: state ?? this.state);
  }

  @override
  List<Object?> get props => [user, state];
}

enum States { loading, done, error }

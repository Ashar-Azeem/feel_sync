import 'package:equatable/equatable.dart';
import 'package:feel_sync/Models/user.dart';

class UserState extends Equatable {
  final User? user;
  final States state;
  final ProfileState profileState;

  const UserState(
      {this.user,
      this.state = States.loading,
      this.profileState = ProfileState.done});

  UserState copyWith({User? user, States? state, ProfileState? profileState}) {
    return UserState(
        user: user ?? this.user,
        state: state ?? this.state,
        profileState: profileState ?? this.profileState);
  }

  @override
  List<Object?> get props => [user, state, profileState];
}

enum States { loading, done, error }

enum ProfileState { loading, done, error }

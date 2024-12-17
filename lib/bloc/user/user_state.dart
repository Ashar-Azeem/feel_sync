import 'package:equatable/equatable.dart';
import 'package:feel_sync/EmotionDetector/EmotionDetectionManager.dart';
import 'package:feel_sync/Models/user.dart';

class UserState extends Equatable {
  final User? user;
  final States state;
  final ProfileState profileState;
  final NameStates nameState;
  final UserNameStates userNameState;
  final AboutSectionStates aboutSectionState;
  final LogOutState logOutState;
  final EmotionDetectionManager? edm;

  const UserState(
      {this.logOutState = LogOutState.no,
      this.userNameState = UserNameStates.done,
      this.aboutSectionState = AboutSectionStates.done,
      this.nameState = NameStates.done,
      this.user,
      this.state = States.loading,
      this.profileState = ProfileState.done,
      this.edm});

  UserState copyWith(
      {User? user,
      States? state,
      ProfileState? profileState,
      UserNameStates? userNameState,
      NameStates? nameState,
      AboutSectionStates? aboutSectionState,
      LogOutState? logOutState,
      EmotionDetectionManager? edm}) {
    return UserState(
        user: user ?? this.user,
        state: state ?? this.state,
        profileState: profileState ?? this.profileState,
        userNameState: userNameState ?? this.userNameState,
        nameState: nameState ?? this.nameState,
        aboutSectionState: aboutSectionState ?? this.aboutSectionState,
        logOutState: logOutState ?? this.logOutState,
        edm: edm ?? this.edm);
  }

  @override
  List<Object?> get props => [
        user,
        state,
        profileState,
        nameState,
        userNameState,
        aboutSectionState,
        logOutState,
        edm
      ];
}

enum States { loading, done, error }

enum ProfileState { loading, done, error }

enum NameStates { loading, done, error }

enum UserNameStates { loading, done, error }

enum AboutSectionStates { loading, done, error }

enum LogOutState { loading, yes, no }

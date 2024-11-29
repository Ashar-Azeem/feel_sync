part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class FetchUser extends UserEvent {
  final String userId;

  const FetchUser({required this.userId});
}

class ChangeProfilePicture extends UserEvent {}

class ChangeName extends UserEvent {
  final BuildContext context;

  const ChangeName({required this.context});
}

class ChangeUserName extends UserEvent {
  final BuildContext context;

  const ChangeUserName({required this.context});
}

class ChangeAboutSection extends UserEvent {
  final BuildContext context;

  const ChangeAboutSection({required this.context});
}

class LogOut extends UserEvent {
  final BuildContext context;

  const LogOut({required this.context});
}

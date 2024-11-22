part of 'password_visibility_bloc.dart';

class PasswordVisibilityState extends Equatable {
  final bool visibility;
  const PasswordVisibilityState({this.visibility = false});
  PasswordVisibilityState copyWith({required bool? visibility}) {
    return PasswordVisibilityState(visibility: visibility ?? this.visibility);
  }

  @override
  List<Object> get props => [visibility];
}

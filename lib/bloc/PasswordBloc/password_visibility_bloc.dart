import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'password_visibility_event.dart';
part 'password_visibility_state.dart';

class PasswordVisibilityBloc
    extends Bloc<PasswordVisibilityEvent, PasswordVisibilityState> {
  PasswordVisibilityBloc() : super(const PasswordVisibilityState()) {
    on<Toggle>(toggle);
  }

  void toggle(Toggle event, Emitter<PasswordVisibilityState> emit) {
    emit(state.copyWith(visibility: !state.visibility));
  }
}

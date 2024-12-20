import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:feel_sync/Services/CRUD.dart';

part 'visiting_user_compatibility_event.dart';
part 'visiting_user_compatibility_state.dart';

class VisitingUserCompatibilityBloc extends Bloc<VisitingUserCompatibilityEvent,
    VisitingUserCompatibilityState> {
  VisitingUserCompatibilityBloc()
      : super(const VisitingUserCompatibilityState()) {
    on<MeasureCompatibility>(measureCompatibility);
  }

  void measureCompatibility(MeasureCompatibility event,
      Emitter<VisitingUserCompatibilityState> emit) async {
    await Crud().measureCompatibility(event.userId).then((value) {
      emit(state.copyWith(compatibilityMeasure: value));
    });
  }
}

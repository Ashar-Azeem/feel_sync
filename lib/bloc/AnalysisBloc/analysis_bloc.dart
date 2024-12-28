import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:feel_sync/Services/CRUD.dart';

part 'analysis_event.dart';
part 'analysis_state.dart';

class AnalysisBloc extends Bloc<AnalysisEvent, AnalysisState> {
  AnalysisBloc() : super(const AnalysisState()) {
    on<FetchData>(fetchData);
  }

  void fetchData(FetchData event, Emitter<AnalysisState> emit) async {
    emit(state.copyWith(loading: true));
    await Crud().getAnalysisData(event.userId).then((data) {
      emit(state.copyWith(
          loading: false,
          ageGroupAnalysis: Map.from(data.ageGroupAnalysis),
          genderGroupAnalysis: Map.from(data.genderGroupAnalysis)));
    });
  }
}

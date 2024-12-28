part of 'analysis_bloc.dart';

class AnalysisState extends Equatable {
  final bool loading;
  final Map<String, int> ageGroupAnalysis;
  final Map<String, int> genderGroupAnalysis;

  const AnalysisState(
      {this.loading = true,
      this.ageGroupAnalysis = const {},
      this.genderGroupAnalysis = const {}});

  AnalysisState copyWith(
      {bool? loading,
      Map<String, int>? ageGroupAnalysis,
      Map<String, int>? genderGroupAnalysis}) {
    return AnalysisState(
        loading: loading ?? this.loading,
        ageGroupAnalysis: ageGroupAnalysis ?? this.ageGroupAnalysis,
        genderGroupAnalysis: genderGroupAnalysis ?? this.genderGroupAnalysis);
  }

  @override
  List<Object> get props => [loading, ageGroupAnalysis, genderGroupAnalysis];
}

part of 'analysis_bloc.dart';

abstract class AnalysisEvent extends Equatable {
  const AnalysisEvent();

  @override
  List<Object> get props => [];
}

class FetchData extends AnalysisEvent {
  final String userId;

  const FetchData({required this.userId});
}

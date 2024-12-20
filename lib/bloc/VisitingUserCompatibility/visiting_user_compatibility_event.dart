part of 'visiting_user_compatibility_bloc.dart';

class VisitingUserCompatibilityEvent extends Equatable {
  const VisitingUserCompatibilityEvent();

  @override
  List<Object> get props => [];
}

class MeasureCompatibility extends VisitingUserCompatibilityEvent {
  final String userId;

  const MeasureCompatibility({required this.userId});
}

part of 'visiting_user_compatibility_bloc.dart';

class VisitingUserCompatibilityState extends Equatable {
  final double? compatibilityMeasure;
  const VisitingUserCompatibilityState({this.compatibilityMeasure});
  VisitingUserCompatibilityState copyWith({double? compatibilityMeasure}) {
    return VisitingUserCompatibilityState(
        compatibilityMeasure:
            compatibilityMeasure ?? this.compatibilityMeasure);
  }

  @override
  List<Object?> get props => [compatibilityMeasure];
}

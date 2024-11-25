part of 'date_selector_bloc.dart';

class DateSelectorState extends Equatable {
  final DateTime? dateTime;
  const DateSelectorState({this.dateTime});

  DateSelectorState copyWith(DateTime? datetime) {
    return DateSelectorState(dateTime: datetime ?? this.dateTime);
  }

  @override
  List<Object?> get props => [dateTime];
}

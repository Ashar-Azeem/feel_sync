part of 'date_selector_bloc.dart';

abstract class DateSelectorEvent extends Equatable {
  const DateSelectorEvent();

  @override
  List<Object> get props => [];
}

class SelectDate extends DateSelectorEvent {
  final BuildContext context;

  const SelectDate({required this.context});
}

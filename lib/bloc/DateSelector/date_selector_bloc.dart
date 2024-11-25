import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'date_selector_event.dart';
part 'date_selector_state.dart';

class DateSelectorBloc extends Bloc<DateSelectorEvent, DateSelectorState> {
  DateSelectorBloc() : super(DateSelectorState()) {
    on<SelectDate>(selectDate);
  }

  selectDate(SelectDate event, Emitter<DateSelectorState> emit) async {
    DateTime? pickedDate = await showDatePicker(
      context: event.context,
      initialDate: state.dateTime ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != state.dateTime) {
      emit(state.copyWith(pickedDate));
    }
  }
}

import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:feel_sync/Utilities/Image.dart';
import 'package:image_picker/image_picker.dart';

part 'image_picker_event.dart';
part 'image_picker_state.dart';

class ImagePickerBloc extends Bloc<ImagePickerEvent, ImagePickerState> {
  ImagePickerBloc() : super(const ImagePickerState(file: null)) {
    on<ImagePickerEvent>(selecImage);
  }

  void selecImage(
      ImagePickerEvent event, Emitter<ImagePickerState> emit) async {
    Uint8List? img = await imagepicker(ImageSource.gallery);
    emit(state.copyWith(file: img));
  }
}

part of 'image_picker_bloc.dart';

class ImagePickerState extends Equatable {
  final Uint8List? file;
  const ImagePickerState({this.file});

  ImagePickerState copyWith({Uint8List? file}) {
    return ImagePickerState(file: file ?? this.file);
  }

  @override
  List<Object> get props => [file!];
}

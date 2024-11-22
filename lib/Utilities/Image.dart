import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

imagepicker(ImageSource source) async {
  XFile? image = await ImagePicker().pickImage(source: source);

  if (image != null) {
    return image.readAsBytes();
  }
}

Future<String> uploadImageGetUrl(
    Uint8List image, String category, bool isPost) async {
  String imageId = const Uuid().v1();
  if (isPost) {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child(category)
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child(imageId);
    UploadTask task = storageReference.putData(image);
    TaskSnapshot snap = await task;
    return snap.ref.getDownloadURL();
  } else {
    Reference storageReference =
        FirebaseStorage.instance.ref().child(category).child(imageId);
    UploadTask task = storageReference.putData(image);
    TaskSnapshot snap = await task;
    return snap.ref.getDownloadURL();
  }
}

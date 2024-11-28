import 'dart:typed_data';
import 'package:feel_sync/Services/AuthService.dart';
import 'package:feel_sync/Utilities/constants.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart'; // For generating UUID

Future<String> uploadImageWithUUID({required Uint8List imageData}) async {
  const uuid = Uuid();
  String fileName = uuid.v4();
  String url =
      'https://$bucketName.s3.$region.amazonaws.com/profiles/${AuthService().getUser()!.uid}/$fileName';
  final uri = Uri.parse(url);

  try {
    final response = await http.put(
      uri,
      headers: {
        'Content-Type': 'application/octet-stream',
      },
      body: imageData,
    );

    if (response.statusCode == 200) {
      print('Image uploaded successfully to: $uri');
      return url;
    } else {
      print('Failed to upload image. Status code: ${response.statusCode}');
      throw Exception("Something went wrong, please try again");
    }
  } catch (e) {
    print('Error: $e');
    throw Exception(e.toString());
  }
}

import 'dart:convert';
import 'dart:io';

Future<String?> convertImageToBase64(String? imagePath) async {
  if (imagePath == null) {
    return null;
  }
  File imageFile = File(imagePath);
  if (!imageFile.existsSync()) {
    return null;
  }
  List<int> imageBytes = await imageFile.readAsBytes();
  return base64Encode(imageBytes);
}
import 'dart:convert';
import 'dart:io';

/// Returns a base64 data URI string for the given image file path.
/// Returns null if the file doesn't exist or the path is null.
String? getBase64ImageUri(String? imagePath) {
  if (imagePath == null) {
    print('[TemplateUtils] profileImagePath is NULL');
    return null;
  }
  if (imagePath.isEmpty) {
    print('[TemplateUtils] profileImagePath is EMPTY string');
    return null;
  }
  final file = File(imagePath);
  if (!file.existsSync()) {
    print('[TemplateUtils] Image file does NOT exist at: $imagePath');
    return null;
  }
  print('[TemplateUtils] Image file FOUND at: $imagePath (${file.lengthSync()} bytes)');

  final bytes = file.readAsBytesSync();
  final base64Str = base64Encode(bytes);

  // Detect extension for MIME type
  final ext = imagePath.split('.').last.toLowerCase();
  String mime;
  switch (ext) {
    case 'png':
      mime = 'image/png';
      break;
    case 'webp':
      mime = 'image/webp';
      break;
    case 'gif':
      mime = 'image/gif';
      break;
    case 'jpg':
    case 'jpeg':
    default:
      mime = 'image/jpeg';
      break;
  }

  return 'data:$mime;base64,$base64Str';
}

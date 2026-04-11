import 'package:file_picker/file_picker.dart';

import '../models/picked_document.dart';

Future<PickedDocument?> pickDocument({required bool imagesOnly}) async {
  final result = await FilePicker.platform.pickFiles(
    withData: true,
    type: imagesOnly ? FileType.image : FileType.any,
  );

  if (result == null || result.files.isEmpty) {
    return null;
  }

  final pickedFile = result.files.first;
  final bytes = pickedFile.bytes;
  if (bytes == null) {
    return null;
  }

  return PickedDocument(
    bytes: bytes,
    fileName: pickedFile.name,
    isImage: _isImageFile(pickedFile.extension, pickedFile.name),
    previewBytes: _isImageFile(pickedFile.extension, pickedFile.name)
        ? bytes
        : null,
  );
}

bool _isImageFile(String? extension, String fileName) {
  const imageExtensions = {'jpg', 'jpeg', 'png', 'webp', 'heic', 'gif', 'bmp'};
  final normalizedExtension = (extension ?? fileName.split('.').last)
      .toLowerCase()
      .trim();
  return imageExtensions.contains(normalizedExtension);
}

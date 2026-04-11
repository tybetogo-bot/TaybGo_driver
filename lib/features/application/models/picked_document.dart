import 'dart:typed_data';

class PickedDocument {
  const PickedDocument({
    required this.bytes,
    required this.fileName,
    required this.isImage,
    this.previewBytes,
  });

  final Uint8List bytes;
  final String fileName;
  final bool isImage;
  final Uint8List? previewBytes;
}

library;

import 'dart:async';
import 'dart:js_interop';
import 'package:web/web.dart' as web;

import '../models/picked_document.dart';

Future<PickedDocument?> pickDocument({required bool imagesOnly}) {
  final completer = Completer<PickedDocument?>();

  final input = web.HTMLInputElement()
    ..type = 'file'
    ..accept = imagesOnly ? 'image/*' : ''
    ..multiple = false
    ..style.display = 'none';

  void complete(PickedDocument? result) {
    if (completer.isCompleted) return;
    completer.complete(result);
    try {
      input.remove();
    } catch (_) {}
  }

  // Attach change listener BEFORE click().
  input.onChange.listen((_) {
    final files = input.files;
    if (files == null || files.length == 0) {
      complete(null);
      return;
    }
    final file = files.item(0);
    if (file == null) {
      complete(null);
      return;
    }

    final reader = web.FileReader();
    reader.onLoadEnd.listen((_) {
      final result = reader.result;
      if (result != null && result.isA<JSArrayBuffer>()) {
        final bytes = (result as JSArrayBuffer).toDart.asUint8List();
        final isImage = _isImageFile(file.type, file.name);
        complete(
          PickedDocument(
            bytes: bytes,
            fileName: file.name,
            isImage: isImage,
            previewBytes: isImage ? bytes : null,
          ),
        );
      } else {
        complete(null);
      }
    });
    reader.addEventListener(
      'error',
      ((web.Event _) => complete(null)).toJS,
    );
    reader.readAsArrayBuffer(file);
  });

  // Cancel fallback: if window regains focus and no file was picked
  // within 800 ms, treat as cancelled.
  JSFunction? focusListener;
  focusListener = ((web.Event _) {
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!completer.isCompleted) {
        if (focusListener != null) {
          web.window.removeEventListener('focus', focusListener);
        }
        complete(null);
      }
    });
  }).toJS;
  web.window.addEventListener('focus', focusListener);

  // KEY: append and keep attached. file_picker removes right after click(),
  // which breaks the change event on recent Chrome/Flutter combinations.
  web.document.body?.append(input);
  input.click();

  return completer.future;
}

bool _isImageFile(String mimeType, String fileName) {
  const imageExtensions = {'jpg', 'jpeg', 'png', 'webp', 'heic', 'gif', 'bmp'};
  if (mimeType.startsWith('image/')) {
    return true;
  }

  final extension = fileName.contains('.')
      ? fileName.split('.').last.toLowerCase().trim()
      : '';
  return imageExtensions.contains(extension);
}

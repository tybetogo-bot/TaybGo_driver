import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/cloudinary_constants.dart';

class CloudinaryService {
  final Dio _dio = Dio();

  /// Upload image bytes to Cloudinary using unsigned upload.
  ///
  /// Uses in-memory bytes (not a file path) so it works on every platform,
  /// including web — `dart:io` files and `MultipartFile.fromFile` are not
  /// supported there. Returns the secure URL of the uploaded image, or null
  /// on failure.
  Future<String?> uploadImage(
    Uint8List bytes, {
    required String filename,
    String? folder,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(bytes, filename: filename),
        'upload_preset': CloudinaryConstants.uploadPreset,
        if (folder != null) 'folder': folder,
      });

      debugPrint('[CloudinaryService] Uploading $filename (${bytes.length} bytes)...');

      final response = await _dio.post(
        CloudinaryConstants.uploadUrl,
        data: formData,
      );

      if (response.statusCode == 200) {
        final url = response.data['secure_url'] as String?;
        debugPrint('[CloudinaryService] Upload success: $url');
        return url;
      }

      debugPrint('[CloudinaryService] Upload failed: ${response.statusCode}');
      return null;
    } on DioException catch (e) {
      debugPrint('[CloudinaryService] Upload error: ${e.message}');
      debugPrint('[CloudinaryService] Response: ${e.response?.data}');
      return null;
    }
  }
}

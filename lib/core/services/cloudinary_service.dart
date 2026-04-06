import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/cloudinary_constants.dart';

class CloudinaryService {
  final Dio _dio = Dio();

  /// Upload an image file to Cloudinary using unsigned upload.
  /// Returns the secure URL of the uploaded image, or null on failure.
  Future<String?> uploadImage(
    Uint8List bytes, {
    required String fileName,
    String? folder,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(bytes, filename: fileName),
        'upload_preset': CloudinaryConstants.uploadPreset,
        if (folder != null) 'folder': folder,
      });

      debugPrint('[CloudinaryService] Uploading $fileName...');

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

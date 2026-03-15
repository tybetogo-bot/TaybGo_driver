import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/cloudinary_constants.dart';

class CloudinaryService {
  final Dio _dio = Dio();

  /// Upload an image file to Cloudinary using unsigned upload.
  /// Returns the secure URL of the uploaded image, or null on failure.
  Future<String?> uploadImage(File file, {String? folder}) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path),
        'upload_preset': CloudinaryConstants.uploadPreset,
        if (folder != null) 'folder': folder,
      });

      debugPrint('[CloudinaryService] Uploading ${file.path}...');

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

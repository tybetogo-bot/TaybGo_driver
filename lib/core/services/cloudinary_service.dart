import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/cloudinary_constants.dart';

class CloudinaryService {
  final Dio _dio = Dio();

  /// Upload a file to Cloudinary using unsigned upload.
  /// Returns the secure URL of the uploaded file, or null on failure.
  Future<String?> uploadFile(
    Uint8List bytes, {
    required String fileName,
    String? folder,
    String resourceType = 'auto',
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(bytes, filename: fileName),
        'upload_preset': CloudinaryConstants.uploadPreset,
        if (folder != null) 'folder': folder,
      });

      debugPrint('[CloudinaryService] Uploading $fileName as $resourceType...');

      final response = await _dio.post(
        CloudinaryConstants.uploadUrl(resourceType: resourceType),
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

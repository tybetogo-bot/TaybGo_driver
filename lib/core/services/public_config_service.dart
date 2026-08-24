import '../api/api_client.dart';
import '../api/api_constants.dart';
import '../config/public_app_config.dart';

class PublicConfigService {
  PublicConfigService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<PublicAppConfig> fetch({required String currentVersion}) async {
    final response = await _apiClient
        .get<Map<String, dynamic>>(
          ApiConstants.publicConfig,
          queryParameters: {'current_version': currentVersion},
        )
        .timeout(const Duration(seconds: 12));
    final data = response.data;
    if (data == null) {
      throw const FormatException('Public configuration response was empty.');
    }
    return PublicAppConfig.fromJson(data);
  }
}

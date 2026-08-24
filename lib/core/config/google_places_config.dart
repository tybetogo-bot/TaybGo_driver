/// Compile-time configuration for Google Places address search.
abstract final class GooglePlacesConfig {
  static const apiKey = String.fromEnvironment('GOOGLE_MAPS_API_KEY');

  static bool get isConfigured => isValidApiKey(apiKey);

  static bool isValidApiKey(String value) {
    return RegExp(r'^AIza[0-9A-Za-z_-]{20,}$').hasMatch(value.trim());
  }
}

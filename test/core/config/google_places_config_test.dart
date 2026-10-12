import 'package:flutter_test/flutter_test.dart';
import 'package:teybatdriver/core/config/google_places_config.dart';

void main() {
  group('GooglePlacesConfig', () {
    test('accepts a Google API key shape', () {
      expect(
        GooglePlacesConfig.isValidApiKey(
          ['AIza', '0123456789abcdefghijklmnopqrstuvwxyz'].join(),
        ),
        isTrue,
      );
    });

    test('rejects missing, placeholder, and malformed values', () {
      expect(GooglePlacesConfig.isValidApiKey(''), isFalse);
      expect(
        GooglePlacesConfig.isValidApiKey(
          'replace-with-a-restricted-google-places-api-key',
        ),
        isFalse,
      );
      expect(GooglePlacesConfig.isValidApiKey('not-a-google-key'), isFalse);
    });
  });
}

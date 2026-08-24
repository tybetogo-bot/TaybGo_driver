import 'package:flutter_test/flutter_test.dart';
import 'package:teybatdriver/core/config/public_app_config.dart';

void main() {
  test('parses dotted keys and selects password for driver', () {
    final config = PublicAppConfig.fromJson({
      'auth.otp_enabled_roles': ['customer'],
      'auth.password_only_roles': ['seller', 'driver', 'admin'],
      'app.latest_version': '1.2.0',
      'app.min_supported_version': '1.1.0',
      'app.force_update': true,
      'app.update_url': '/download/',
      'legal.privacy_url': '/privacy-policy/',
      'legal.terms_url': '/terms-and-conditions/',
      'legal.support_url': '/contact/',
    });

    expect(config.usesPasswordFor('driver'), isTrue);
    expect(config.usesOtpFor('driver'), isFalse);
    expect(config.forceUpdate, isTrue);
  });

  test('password wins when driver appears in both role lists', () {
    final config = PublicAppConfig.fromJson({
      'auth.otp_enabled_roles': ['driver'],
      'auth.password_only_roles': ['driver'],
      'app.latest_version': '1.0.0',
      'app.min_supported_version': '1.0.0',
      'app.force_update': false,
      'app.update_url': null,
      'legal.privacy_url': '/privacy/',
      'legal.terms_url': '/terms/',
      'legal.support_url': '/support/',
    });

    expect(config.usesPasswordFor('driver'), isTrue);
    expect(config.usesOtpFor('driver'), isFalse);
  });

  test('rejects missing required URLs', () {
    expect(
      () => PublicAppConfig.fromJson({
        'auth.otp_enabled_roles': ['customer'],
        'auth.password_only_roles': ['driver'],
        'app.latest_version': '1.0.0',
        'app.min_supported_version': '1.0.0',
        'app.force_update': false,
        'app.update_url': null,
      }),
      throwsFormatException,
    );
  });
}

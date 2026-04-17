import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teybatdriver/core/api/api_client.dart';
import 'package:teybatdriver/core/config/app_config.dart';
import 'package:teybatdriver/core/l10n/app_localizations.dart';
import 'package:teybatdriver/core/providers/auth_provider.dart';
import 'package:teybatdriver/core/services/auth_service.dart';

void main() {
  setUpAll(() {
    AppConfig.init(env: Environment.dev);
  });

  testWidgets(
    'raw backend 409 text is replaced by the translated generic message',
    (tester) async {
      final authProvider = AuthProvider(authService: _ConflictAuthService());

      await authProvider.requestOtp('+49123456789');

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              final l10n = AppLocalizations.of(context)!;
              final message = authProvider.localizedError(l10n) ?? '';
              return Text(message, textDirection: TextDirection.ltr);
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('This number is already registered.'), findsOneWidget);
      expect(find.textContaining('registered as customer'), findsNothing);
      expect(find.textContaining('Use a driver account instead'), findsNothing);
    },
  );
}

class _ConflictAuthService extends AuthService {
  @override
  Future<OtpRequestResponse> requestOtp({
    required String phoneNumber,
    required String targetRole,
  }) {
    throw ApiException(
      message:
          'Phone already registered as customer. Use a driver account instead.',
      statusCode: 409,
      data: {
        'detail':
            'Phone already registered as customer. Use a driver account instead.',
      },
    );
  }
}

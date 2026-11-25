import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:teybatdriver/core/api/api_client.dart';
import 'package:teybatdriver/core/config/app_config.dart';
import 'package:teybatdriver/core/l10n/app_localizations.dart';
import 'package:teybatdriver/core/models/driver_address.dart';
import 'package:teybatdriver/core/models/driver_profile.dart';
import 'package:teybatdriver/core/providers/auth_provider.dart';
import 'package:teybatdriver/core/providers/driver_provider.dart';
import 'package:teybatdriver/core/services/auth_service.dart';
import 'package:teybatdriver/core/services/driver_service.dart';
import 'package:teybatdriver/core/utils/email_utils.dart';
import 'package:teybatdriver/shared/widgets/mandatory_email_gate.dart';

class _FakeDriverService extends DriverService {
  DriverProfile currentProfile;
  String? lastSubmittedEmail;
  Object? nextError;

  _FakeDriverService({required this.currentProfile})
    : super(apiClient: ApiClient());

  @override
  Future<DriverProfile> getProfile() async => currentProfile;

  @override
  Future<DriverProfile> updateUserProfile({
    String? name,
    String? email,
    String? phone,
    DateTime? birthdate,
    String? vehicleType,
    bool clearCarDetails = false,
    String? carSize,
    String? vehiclePlateNumber,
    String? vehicleColor,
    String? vehicleMake,
    String? vehicleModel,
    int? vehicleYear,
    bool? acceptsFood,
    bool? acceptsShipping,
    bool? acceptsTaxi,
    String? drivingLicense,
    String? idDocument,
    String? otherDocuments,
    String? healthInsuranceDocument,
    String? addressDocument,
    String? bankDocument,
    DriverAddress? address,
  }) async {
    if (nextError != null) {
      throw nextError!;
    }
    lastSubmittedEmail = email;
    currentProfile = currentProfile.copyWith(
      email: email ?? currentProfile.email,
      needsEmail: email == null || email.trim().isEmpty,
    );
    return currentProfile;
  }
}

class _FakeAuthProvider extends AuthProvider {
  bool logoutCalled = false;

  _FakeAuthProvider()
    : super(authService: AuthService(apiClient: ApiClient()));

  @override
  Future<void> logout({bool forced = false}) async {
    logoutCalled = true;
  }
}

void main() {
  setUpAll(() {
    AppConfig.init(env: Environment.dev);
  });

  group('Email normalization and validation', () {
    test('normalizes whitespace and casing', () {
      expect(normalizeEmail('  Driver.Name+Tag@Example.COM  '), 'driver.name+tag@example.com');
    });

    test('validates normalized emails including long TLDs', () {
      expect(isValidNormalizedEmail('driver@taybgo.com'), isTrue);
      expect(isValidNormalizedEmail('driver@taybgo.museum'), isTrue);
      expect(isValidNormalizedEmail(''), isFalse);
      expect(isValidNormalizedEmail('not-an-email'), isFalse);
      expect(isValidNormalizedEmail('a@b.c'), isFalse);
      expect(isValidNormalizedEmail('a b@taybgo.com'), isFalse);
    });
  });

  group('DriverProfile needsEmail parsing', () {
    test('defaults needsEmail to true when email is missing or empty', () {
      final profile = DriverProfile.fromJson({
        'id': 1,
        'user': {'id': 1, 'phone': '+436601234567', 'email': ''},
      });
      expect(profile.needsEmail, isTrue);
    });

    test('reads explicit needs_email flag and clears it via copyWith', () {
      final profile = DriverProfile.fromJson({
        'id': 2,
        'needs_email': true,
        'user': {'id': 2, 'phone': '+436601234567', 'email': null},
      });
      expect(profile.needsEmail, isTrue);

      final updated = profile.copyWith(email: 'driver@example.com');
      expect(updated.email, 'driver@example.com');
      expect(updated.needsEmail, isFalse);
    });
  });

  group('MandatoryEmailGate widget', () {
    Future<void> pumpGate(
      WidgetTester tester, {
      required _FakeDriverService driverService,
      required _FakeAuthProvider authProvider,
      VoidCallback? onUnderlyingTap,
    }) async {
      final driverProvider = DriverProvider(driverService: driverService);
      await driverProvider.fetchProfile();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
            ChangeNotifierProvider<DriverProvider>.value(value: driverProvider),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: MandatoryEmailGate(
              child: Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: onUnderlyingTap,
                    child: const Text('Underlying Action'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets(
      'blocks underlying actions when needsEmail is true and dismisses after saving valid email',
      (tester) async {
        var underlyingTapped = false;
        final service = _FakeDriverService(
          currentProfile: DriverProfile(
            id: 7,
            firstName: 'Ali',
            lastName: 'Driver',
            phone: '+436601234567',
            email: null,
            needsEmail: true,
          ),
        );
        final auth = _FakeAuthProvider();

        await pumpGate(
          tester,
          driverService: service,
          authProvider: auth,
          onUnderlyingTap: () => underlyingTapped = true,
        );

        expect(find.byType(MandatoryEmailDialog), findsOneWidget);

        // Underlying button is behind ModalBarrier + AbsorbPointer
        await tester.tap(
          find.text('Underlying Action'),
          warnIfMissed: false,
        );
        expect(underlyingTapped, isFalse);

        // Empty / invalid email fails validation and does not submit
        await tester.tap(find.text('Save Email'));
        await tester.pumpAndSettle();
        expect(service.lastSubmittedEmail, isNull);
        expect(find.text('Please enter your email address'), findsOneWidget);

        // Valid uppercase email is normalized, saved, and removes gate
        await tester.enterText(
          find.byType(TextFormField),
          '  Driver@TAYBGO.AT  ',
        );
        await tester.tap(find.text('Save Email'));
        await tester.pumpAndSettle();

        expect(service.lastSubmittedEmail, 'driver@taybgo.at');
        expect(find.byType(MandatoryEmailDialog), findsNothing);
      },
    );

    testWidgets('shows API error on failure and allows logout escape hatch', (
      tester,
    ) async {
      final service = _FakeDriverService(
        currentProfile: DriverProfile(
          id: 8,
          firstName: 'Sara',
          lastName: 'Driver',
          phone: '+436601234568',
          email: '',
          needsEmail: true,
        ),
      )..nextError = ApiException(message: 'This email is already in use.');
      final auth = _FakeAuthProvider();

      await pumpGate(tester, driverService: service, authProvider: auth);

      await tester.enterText(find.byType(TextFormField), 'taken@taybgo.at');
      await tester.tap(find.text('Save Email'));
      await tester.pumpAndSettle();

      expect(find.text('This email is already in use.'), findsOneWidget);
      expect(find.byType(MandatoryEmailDialog), findsOneWidget);

      await tester.tap(find.byIcon(Icons.logout));
      await tester.pumpAndSettle();
      expect(auth.logoutCalled, isTrue);
    });
  });
}

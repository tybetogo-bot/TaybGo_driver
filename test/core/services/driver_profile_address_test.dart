import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teybatdriver/core/api/api_client.dart';
import 'package:teybatdriver/core/api/token_storage.dart';
import 'package:teybatdriver/core/config/app_config.dart';
import 'package:teybatdriver/core/models/driver_address.dart';
import 'package:teybatdriver/core/models/driver_profile.dart';
import 'package:teybatdriver/core/services/driver_registration_service.dart';
import 'package:teybatdriver/core/services/driver_service.dart';

void main() {
  setUpAll(() {
    AppConfig.init(env: Environment.dev);
  });

  final completeAddress = const DriverAddress(
    label: 'Home',
    lat: '24.713600',
    lng: '46.675300',
    fullAddress: '12 King Street, Riyadh',
    streetName: 'King Street',
    houseNumber: '12',
    city: 'Riyadh',
    postalCode: '12345',
    country: 'SA',
  );

  group('DriverAddress serialization', () {
    test('creates a complete address without null or is_default fields', () {
      final json = completeAddress.toCreateJson();

      expect(json, {
        'label': 'Home',
        'lat': '24.713600',
        'lng': '46.675300',
        'full_address': '12 King Street, Riyadh',
        'street_name': 'King Street',
        'house_number': '12',
        'city': 'Riyadh',
        'postal_code': '12345',
        'country': 'SA',
      });
      expect(json.containsKey('is_default'), isFalse);
    });

    test('supports partial patch payloads', () {
      final json = const DriverAddress(city: 'Riyadh').toPatchJson();

      expect(json, {'city': 'Riyadh'});
      expect(json.containsKey('label'), isFalse);
      expect(json.containsKey('is_default'), isFalse);
    });

    test('requires the first address fields', () {
      expect(
        () => const DriverAddress(label: 'Home').toCreateJson(),
        throwsArgumentError,
      );
    });
  });

  test('DriverProfile parses complete and null addresses', () {
    final profile = DriverProfile.fromJson({
      'id': 1,
      'phone': '+966500000000',
      'address': completeAddress.toCreateJson(),
    });
    final profileWithoutAddress = DriverProfile.fromJson({
      'id': 2,
      'phone': '+966500000001',
      'address': null,
    });

    expect(profile.address?.label, 'Home');
    expect(profile.address?.lat, '24.713600');
    expect(profile.address?.city, 'Riyadh');
    expect(profileWithoutAddress.address, isNull);
  });

  group('profile endpoint payloads', () {
    test('POST includes nested address when supplied', () async {
      final client = _RecordingApiClient(
        responseData: {
          'id': 10,
          'message': 'Registration successful',
          'address': completeAddress.toCreateJson(),
        },
      );
      final service = DriverRegistrationService(apiClient: client);

      final result = await service.registerDriver(
        name: 'Driver',
        phone: '+966500000000',
        birthdate: DateTime(1990, 1, 1),
        vehicleType: 'CAR',
        acceptsFood: true,
        acceptsShipping: false,
        acceptsTaxi: true,
        address: completeAddress,
      );

      final payload = client.postedData as Map<String, dynamic>;
      expect(payload['address'], completeAddress.toCreateJson());
      expect(payload.containsKey('is_default'), isFalse);
      expect(result.address?.fullAddress, '12 King Street, Riyadh');
    });

    test('POST omits address when it is not supplied', () async {
      final client = _RecordingApiClient(
        responseData: {'id': 11, 'message': 'Registration successful'},
      );
      final service = DriverRegistrationService(apiClient: client);

      await service.registerDriver(
        name: 'Driver',
        phone: '+966500000001',
        birthdate: DateTime(1990, 1, 1),
        vehicleType: 'CAR',
        acceptsFood: true,
        acceptsShipping: false,
        acceptsTaxi: true,
      );

      final payload = client.postedData as Map<String, dynamic>;
      expect(payload.containsKey('address'), isFalse);
      expect(payload.containsKey('is_default'), isFalse);
    });

    test(
      'PATCH sends only partial address fields and parses the response',
      () async {
        final client = _RecordingApiClient(
          responseData: {
            'id': 12,
            'phone': '+966500000002',
            'status': 'APPROVED',
            'address': completeAddress.toCreateJson(),
          },
        );
        final service = DriverService(apiClient: client);

        final profile = await service.updateUserProfile(
          address: const DriverAddress(city: 'Riyadh'),
        );

        final payload = client.patchedData as Map<String, dynamic>;
        expect(payload, {
          'address': {'city': 'Riyadh'},
        });
        expect(payload.containsKey('is_default'), isFalse);
        expect(profile.address?.country, 'SA');
        expect(profile.status, 'APPROVED');
      },
    );

    test('PATCH omits address when it is not supplied', () async {
      final client = _RecordingApiClient(
        responseData: {'id': 13, 'phone': '+966500000003'},
      );
      final service = DriverService(apiClient: client);

      await service.updateUserProfile();

      final payload = client.patchedData as Map<String, dynamic>;
      expect(payload.containsKey('address'), isFalse);
      expect(payload.containsKey('is_default'), isFalse);
    });
  });
}

class _RecordingApiClient extends ApiClient {
  _RecordingApiClient({required this.responseData})
    : super(tokenStorage: _InMemoryTokenStorage());

  final dynamic responseData;
  dynamic postedData;
  dynamic patchedData;

  @override
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    postedData = data;
    return Response<T>(
      requestOptions: RequestOptions(path: path),
      statusCode: 201,
      data: responseData as T,
    );
  }

  @override
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Options? options,
  }) async {
    patchedData = data;
    return Response<T>(
      requestOptions: RequestOptions(path: path),
      statusCode: 200,
      data: responseData as T,
    );
  }
}

class _InMemoryTokenStorage extends TokenStorage {
  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<String?> getRefreshToken() async => null;
}

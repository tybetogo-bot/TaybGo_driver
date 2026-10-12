import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:teybatdriver/core/services/google_places_service.dart';

void main() {
  group('GooglePlacesService', () {
    test('parses autocomplete suggestions', () async {
      final service = GooglePlacesService(
        apiKey: 'test-key',
        client: MockClient((request) async {
          expect(request.method, 'POST');
          expect(request.url.path, '/v1/places:autocomplete');
          expect(request.headers['X-Goog-Api-Key'], 'test-key');
          expect(jsonDecode(request.body)['sessionToken'], 'session-1');
          return http.Response(
            jsonEncode({
              'suggestions': [
                {
                  'placePrediction': {
                    'placeId': 'place-123',
                    'text': {'text': '12 Main Street, Vienna, Austria'},
                    'structuredFormat': {
                      'mainText': {'text': '12 Main Street'},
                      'secondaryText': {'text': 'Vienna, Austria'},
                    },
                  },
                },
              ],
            }),
            200,
          );
        }),
      );

      final results = await service.autocomplete(
        input: 'Main Street',
        sessionToken: 'session-1',
        languageCode: 'en',
      );

      expect(results, hasLength(1));
      expect(results.single.placeId, 'place-123');
      expect(results.single.primaryText, '12 Main Street');
      expect(results.single.secondaryText, 'Vienna, Austria');
    });

    test('maps place details into a driver address', () async {
      final service = GooglePlacesService(
        apiKey: 'test-key',
        client: MockClient((request) async {
          expect(request.method, 'GET');
          expect(request.url.path, '/v1/places/place-123');
          expect(request.url.queryParameters['sessionToken'], 'session-2');
          return http.Response(
            jsonEncode({
              'id': 'place-123',
              'formattedAddress': 'Main Street 12, 1010 Vienna, Austria',
              'location': {'latitude': 48.208174, 'longitude': 16.373819},
              'addressComponents': [
                {
                  'longText': '12',
                  'types': ['street_number'],
                },
                {
                  'longText': 'Main Street',
                  'types': ['route'],
                },
                {
                  'longText': 'Vienna',
                  'types': ['locality'],
                },
                {
                  'longText': '1010',
                  'types': ['postal_code'],
                },
                {
                  'longText': 'Austria',
                  'shortText': 'AT',
                  'types': ['country'],
                },
              ],
            }),
            200,
          );
        }),
      );

      const suggestion = GooglePlaceSuggestion(
        placeId: 'place-123',
        fullText: '12 Main Street, Vienna, Austria',
        primaryText: '12 Main Street',
      );
      final selection = await service.resolveAddress(
        suggestion: suggestion,
        sessionToken: 'session-2',
        label: 'Home',
      );

      expect(selection.address.label, 'Home');
      expect(selection.address.lat, '48.208174');
      expect(selection.address.lng, '16.373819');
      expect(
        selection.address.fullAddress,
        'Main Street 12, 1010 Vienna, Austria',
      );
      expect(selection.address.streetName, 'Main Street');
      expect(selection.address.houseNumber, '12');
      expect(selection.address.city, 'Vienna');
      expect(selection.address.postalCode, '1010');
      expect(selection.address.country, 'AT');
    });

    test('throws a typed error for a failed Google response', () async {
      var requestCount = 0;
      final service = GooglePlacesService(
        apiKey: 'test-key',
        client: MockClient((request) async {
          requestCount += 1;
          if (request.url.host == 'places.googleapis.com') {
            return http.Response(
              jsonEncode({
                'error': {'message': 'API key rejected'},
              }),
              403,
            );
          }
          return http.Response(
            jsonEncode({
              'status': 'REQUEST_DENIED',
              'error_message': 'Legacy API key rejected',
            }),
            200,
          );
        }),
      );

      await expectLater(
        service.autocomplete(input: 'Vienna', sessionToken: 'session-3'),
        throwsA(
          isA<GooglePlacesException>()
              .having((error) => error.statusCode, 'statusCode', 200)
              .having(
                (error) => error.message,
                'message',
                'Legacy API key rejected',
              ),
        ),
      );
      expect(requestCount, 2);
    });

    test(
      'falls back to legacy autocomplete when the new API rejects',
      () async {
        var requestCount = 0;
        final service = GooglePlacesService(
          apiKey: 'test-key',
          client: MockClient((request) async {
            requestCount += 1;
            if (request.url.host == 'places.googleapis.com') {
              return http.Response(
                jsonEncode({
                  'error': {'message': 'New API unavailable'},
                }),
                403,
              );
            }
            expect(request.method, 'GET');
            expect(request.url.path, '/maps/api/place/autocomplete/json');
            expect(request.url.queryParameters['input'], 'Main Street');
            expect(request.url.queryParameters['key'], 'test-key');
            expect(request.url.queryParameters['sessiontoken'], 'session-4');
            expect(request.url.queryParameters['components'], 'country:AT');
            return http.Response(
              jsonEncode({
                'status': 'OK',
                'predictions': [
                  {
                    'place_id': 'legacy-place-123',
                    'description': '12 Main Street, Vienna, Austria',
                    'structured_formatting': {
                      'main_text': '12 Main Street',
                      'secondary_text': 'Vienna, Austria',
                    },
                  },
                ],
              }),
              200,
            );
          }),
        );

        final results = await service.autocomplete(
          input: 'Main Street',
          sessionToken: 'session-4',
          languageCode: 'en',
          regionCode: 'AT',
        );

        expect(requestCount, 2);
        expect(results, hasLength(1));
        expect(results.single.placeId, 'legacy-place-123');
        expect(results.single.primaryText, '12 Main Street');
        expect(results.single.secondaryText, 'Vienna, Austria');
      },
    );

    test('falls back to legacy details when the new API rejects', () async {
      var requestCount = 0;
      final service = GooglePlacesService(
        apiKey: 'test-key',
        client: MockClient((request) async {
          requestCount += 1;
          if (request.url.host == 'places.googleapis.com') {
            return http.Response(
              jsonEncode({
                'error': {'message': 'New API unavailable'},
              }),
              403,
            );
          }
          expect(request.method, 'GET');
          expect(request.url.path, '/maps/api/place/details/json');
          expect(request.url.queryParameters['place_id'], 'legacy-place-123');
          expect(request.url.queryParameters['sessiontoken'], 'session-5');
          expect(request.url.queryParameters['region'], 'AT');
          return http.Response(
            jsonEncode({
              'status': 'OK',
              'result': {
                'place_id': 'legacy-place-123',
                'formatted_address': 'Main Street 12, 1010 Vienna, Austria',
                'geometry': {
                  'location': {'lat': 48.208174, 'lng': 16.373819},
                },
                'address_components': [
                  {
                    'long_name': '12',
                    'short_name': '12',
                    'types': ['street_number'],
                  },
                  {
                    'long_name': 'Main Street',
                    'short_name': 'Main Street',
                    'types': ['route'],
                  },
                  {
                    'long_name': 'Vienna',
                    'short_name': 'Vienna',
                    'types': ['locality'],
                  },
                  {
                    'long_name': '1010',
                    'short_name': '1010',
                    'types': ['postal_code'],
                  },
                  {
                    'long_name': 'Austria',
                    'short_name': 'AT',
                    'types': ['country'],
                  },
                ],
              },
            }),
            200,
          );
        }),
      );

      const suggestion = GooglePlaceSuggestion(
        placeId: 'legacy-place-123',
        fullText: '12 Main Street, Vienna, Austria',
        primaryText: '12 Main Street',
      );
      final selection = await service.resolveAddress(
        suggestion: suggestion,
        sessionToken: 'session-5',
        label: 'Home',
        regionCode: 'AT',
      );

      expect(requestCount, 2);
      expect(selection.address.lat, '48.208174');
      expect(selection.address.lng, '16.373819');
      expect(selection.address.streetName, 'Main Street');
      expect(selection.address.houseNumber, '12');
      expect(selection.address.city, 'Vienna');
      expect(selection.address.postalCode, '1010');
      expect(selection.address.country, 'AT');
    });
  });
}

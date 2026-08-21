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
      final service = GooglePlacesService(
        apiKey: 'test-key',
        client: MockClient(
          (_) async => http.Response(
            jsonEncode({
              'error': {'message': 'API key rejected'},
            }),
            403,
          ),
        ),
      );

      expect(
        () => service.autocomplete(input: 'Vienna', sessionToken: 'session-3'),
        throwsA(
          isA<GooglePlacesException>()
              .having((error) => error.statusCode, 'statusCode', 403)
              .having((error) => error.message, 'message', 'API key rejected'),
        ),
      );
    });
  });
}

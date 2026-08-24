import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

import '../models/driver_address.dart';
import 'web_places_bridge.dart';

class GooglePlaceSuggestion {
  const GooglePlaceSuggestion({
    required this.placeId,
    required this.fullText,
    required this.primaryText,
    this.secondaryText,
  });

  final String placeId;
  final String fullText;
  final String primaryText;
  final String? secondaryText;
}

class GooglePlaceAddressSelection {
  const GooglePlaceAddressSelection({
    required this.placeId,
    required this.address,
  });

  final String placeId;
  final DriverAddress address;
}

class GooglePlacesException implements Exception {
  const GooglePlacesException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'GooglePlacesException($message)';
}

/// Small client for the Google Places API (New) address autocomplete flow.
class GooglePlacesService {
  GooglePlacesService({required this.apiKey, http.Client? client})
    : _client = client ?? http.Client();

  static const _baseUrl = 'https://places.googleapis.com/v1';
  static const _legacyBaseUrl = 'https://maps.googleapis.com/maps/api/place';
  static const _autocompleteFieldMask =
      'suggestions.placePrediction.placeId,'
      'suggestions.placePrediction.text.text,'
      'suggestions.placePrediction.structuredFormat.mainText.text,'
      'suggestions.placePrediction.structuredFormat.secondaryText.text';
  static const _detailsFieldMask =
      'id,displayName,formattedAddress,shortFormattedAddress,'
      'postalAddress,addressComponents,location';

  final String apiKey;
  final http.Client _client;

  Future<List<GooglePlaceSuggestion>> autocomplete({
    required String input,
    required String sessionToken,
    String? languageCode,
    String? regionCode,
  }) async {
    final normalizedInput = input.trim();
    if (normalizedInput.length < 3) return const [];

    if (kIsWeb) {
      final suggestions = await webPlacesAutocomplete(
        apiKey,
        normalizedInput,
        countryCode: regionCode,
      );
      return suggestions
          .map(_suggestionFromWebJson)
          .whereType<GooglePlaceSuggestion>()
          .toList(growable: false);
    }

    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/places:autocomplete'),
        headers: _headers(_autocompleteFieldMask),
        body: jsonEncode({
          'input': normalizedInput,
          'sessionToken': sessionToken,
          if (_isNonEmpty(languageCode)) 'languageCode': languageCode,
          if (_isNonEmpty(regionCode)) 'regionCode': regionCode,
        }),
      );
      final data = _decodeResponse(response);
      final suggestions = data['suggestions'];
      if (suggestions is! List) return const [];

      return suggestions
          .whereType<Map>()
          .map((item) => item.cast<String, dynamic>())
          .map((item) => item['placePrediction'])
          .whereType<Map>()
          .map((item) => item.cast<String, dynamic>())
          .map(_suggestionFromJson)
          .whereType<GooglePlaceSuggestion>()
          .toList(growable: false);
    } on Exception {
      return _legacyAutocomplete(
        input: normalizedInput,
        sessionToken: sessionToken,
        languageCode: languageCode,
        regionCode: regionCode,
      );
    }
  }

  Future<GooglePlaceAddressSelection> resolveAddress({
    required GooglePlaceSuggestion suggestion,
    required String sessionToken,
    required String label,
    String? languageCode,
    String? regionCode,
  }) async {
    if (kIsWeb) {
      final data = await webPlaceDetails(apiKey, suggestion.placeId);
      if (data == null) {
        throw const GooglePlacesException(
          'Google Places did not return address details.',
        );
      }
      return _selectionFromWebJson(
        data: data,
        suggestion: suggestion,
        label: label,
      );
    }

    final uri =
        Uri.parse(
          '$_baseUrl/places/${Uri.encodeComponent(suggestion.placeId)}',
        ).replace(
          queryParameters: {
            'sessionToken': sessionToken,
            if (_isNonEmpty(languageCode)) 'languageCode': languageCode!,
            if (_isNonEmpty(regionCode)) 'regionCode': regionCode!,
          },
        );
    try {
      final response = await _client.get(
        uri,
        headers: _headers(_detailsFieldMask),
      );
      final data = _decodeResponse(response);
      return _selectionFromNewJson(
        data: data,
        suggestion: suggestion,
        label: label,
      );
    } on Exception {
      return _legacyResolveAddress(
        suggestion: suggestion,
        sessionToken: sessionToken,
        label: label,
        languageCode: languageCode,
        regionCode: regionCode,
      );
    }
  }

  GooglePlaceAddressSelection _selectionFromNewJson({
    required Map<String, dynamic> data,
    required GooglePlaceSuggestion suggestion,
    required String label,
  }) {
    final location = data['location'];
    if (location is! Map) {
      throw const GooglePlacesException(
        'The selected place did not include coordinates.',
      );
    }

    final locationMap = location.cast<String, dynamic>();
    final latitude = (locationMap['latitude'] as num?)?.toDouble();
    final longitude = (locationMap['longitude'] as num?)?.toDouble();
    if (latitude == null || longitude == null) {
      throw const GooglePlacesException(
        'The selected place did not include valid coordinates.',
      );
    }

    final components = _addressComponents(data['addressComponents']);
    final postalAddress = data['postalAddress'] is Map
        ? (data['postalAddress'] as Map).cast<String, dynamic>()
        : const <String, dynamic>{};
    final fullAddress = _firstNonEmpty([
      data['formattedAddress']?.toString(),
      data['shortFormattedAddress']?.toString(),
      suggestion.fullText,
    ]);

    final address = DriverAddress(
      label: _normalize(label),
      lat: latitude.toStringAsFixed(6),
      lng: longitude.toStringAsFixed(6),
      fullAddress: fullAddress,
      streetName: _component(components, 'route'),
      houseNumber: _component(components, 'street_number'),
      city: _firstNonEmpty([
        _component(components, 'locality'),
        postalAddress['locality']?.toString(),
        _component(components, 'administrative_area_level_1'),
        postalAddress['administrativeArea']?.toString(),
      ]),
      postalCode: _firstNonEmpty([
        _component(components, 'postal_code'),
        postalAddress['postalCode']?.toString(),
      ]),
      country: _firstNonEmpty([
        _component(components, 'country', short: true),
        postalAddress['regionCode']?.toString(),
        _component(components, 'country'),
      ]),
    );

    return GooglePlaceAddressSelection(
      placeId: suggestion.placeId,
      address: address,
    );
  }

  void close() => _client.close();

  Future<List<GooglePlaceSuggestion>> _legacyAutocomplete({
    required String input,
    required String sessionToken,
    String? languageCode,
    String? regionCode,
  }) async {
    final response = await _client.get(
      Uri.parse('$_legacyBaseUrl/autocomplete/json').replace(
        queryParameters: {
          'input': input,
          'key': apiKey,
          'sessiontoken': sessionToken,
          if (_isNonEmpty(languageCode)) 'language': languageCode!,
          if (_isNonEmpty(regionCode)) 'components': 'country:$regionCode',
        },
      ),
    );
    final data = _decodeLegacyResponse(response);
    if (data['status'] == 'ZERO_RESULTS') return const [];

    final predictions = data['predictions'];
    if (predictions is! List) return const [];
    return predictions
        .whereType<Map>()
        .map((item) => item.cast<String, dynamic>())
        .map(_suggestionFromLegacyJson)
        .whereType<GooglePlaceSuggestion>()
        .toList(growable: false);
  }

  Future<GooglePlaceAddressSelection> _legacyResolveAddress({
    required GooglePlaceSuggestion suggestion,
    required String sessionToken,
    required String label,
    String? languageCode,
    String? regionCode,
  }) async {
    final response = await _client.get(
      Uri.parse('$_legacyBaseUrl/details/json').replace(
        queryParameters: {
          'place_id': suggestion.placeId,
          'key': apiKey,
          'sessiontoken': sessionToken,
          'fields': 'place_id,formatted_address,address_component,geometry',
          if (_isNonEmpty(languageCode)) 'language': languageCode!,
          if (_isNonEmpty(regionCode)) 'region': regionCode!,
        },
      ),
    );
    final data = _decodeLegacyResponse(response);
    final result = data['result'];
    final resultMap = result is Map
        ? result.cast<String, dynamic>()
        : const <String, dynamic>{};
    final geometry = resultMap['geometry'];
    final geometryMap = geometry is Map
        ? geometry.cast<String, dynamic>()
        : const <String, dynamic>{};
    final location = geometryMap['location'];
    final locationMap = location is Map
        ? location.cast<String, dynamic>()
        : const <String, dynamic>{};
    final latitude = (locationMap['lat'] as num?)?.toDouble();
    final longitude = (locationMap['lng'] as num?)?.toDouble();
    if (latitude == null || longitude == null) {
      throw const GooglePlacesException(
        'The selected place did not include valid coordinates.',
      );
    }

    final components = _addressComponents(resultMap['address_components']);
    return GooglePlaceAddressSelection(
      placeId: suggestion.placeId,
      address: DriverAddress(
        label: _normalize(label),
        lat: latitude.toStringAsFixed(6),
        lng: longitude.toStringAsFixed(6),
        fullAddress: _firstNonEmpty([
          resultMap['formatted_address']?.toString(),
          suggestion.fullText,
        ]),
        streetName: _component(components, 'route'),
        houseNumber: _component(components, 'street_number'),
        city: _firstNonEmpty([
          _component(components, 'locality'),
          _component(components, 'administrative_area_level_1'),
        ]),
        postalCode: _component(components, 'postal_code'),
        country: _firstNonEmpty([
          _component(components, 'country', short: true),
          _component(components, 'country'),
        ]),
      ),
    );
  }

  Map<String, String> _headers(String fieldMask) => {
    'Content-Type': 'application/json',
    'X-Goog-Api-Key': apiKey,
    'X-Goog-FieldMask': fieldMask,
  };

  Map<String, dynamic> _decodeResponse(http.Response response) {
    Map<String, dynamic> data;
    try {
      final decoded = jsonDecode(response.body);
      data = decoded is Map
          ? decoded.cast<String, dynamic>()
          : <String, dynamic>{};
    } on FormatException {
      throw GooglePlacesException(
        'Google Places returned an invalid response.',
        statusCode: response.statusCode,
      );
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final error = data['error'];
      final errorMap = error is Map
          ? error.cast<String, dynamic>()
          : const <String, dynamic>{};
      throw GooglePlacesException(
        errorMap['message']?.toString() ?? 'Google Places request failed.',
        statusCode: response.statusCode,
      );
    }
    return data;
  }

  Map<String, dynamic> _decodeLegacyResponse(http.Response response) {
    final data = _decodeResponse(response);
    final status = data['status']?.toString();
    if (status == 'OK' || status == 'ZERO_RESULTS') return data;
    throw GooglePlacesException(
      data['error_message']?.toString() ??
          'Google Places legacy request failed${status == null ? '' : ' ($status)'}.',
      statusCode: response.statusCode,
    );
  }

  GooglePlaceSuggestion? _suggestionFromJson(Map<String, dynamic> json) {
    final placeId = _normalize(json['placeId']?.toString());
    final text = json['text'];
    final textMap = text is Map
        ? text.cast<String, dynamic>()
        : const <String, dynamic>{};
    final structured = json['structuredFormat'];
    final structuredMap = structured is Map
        ? structured.cast<String, dynamic>()
        : const <String, dynamic>{};
    final mainText = structuredMap['mainText'];
    final secondaryText = structuredMap['secondaryText'];
    final primary = mainText is Map
        ? _normalize(mainText['text']?.toString())
        : null;
    final secondary = secondaryText is Map
        ? _normalize(secondaryText['text']?.toString())
        : null;
    final fullText = _normalize(textMap['text']?.toString());
    if (placeId == null || fullText == null) return null;

    return GooglePlaceSuggestion(
      placeId: placeId,
      fullText: fullText,
      primaryText: primary ?? fullText,
      secondaryText: secondary,
    );
  }

  GooglePlaceSuggestion? _suggestionFromWebJson(Map<String, dynamic> json) {
    final placeId = _normalize(json['placeId']?.toString());
    final fullText = _normalize(json['fullText']?.toString());
    if (placeId == null || fullText == null) return null;
    return GooglePlaceSuggestion(
      placeId: placeId,
      fullText: fullText,
      primaryText: _normalize(json['primaryText']?.toString()) ?? fullText,
      secondaryText: _normalize(json['secondaryText']?.toString()),
    );
  }

  GooglePlaceSuggestion? _suggestionFromLegacyJson(Map<String, dynamic> json) {
    final placeId = _normalize(json['place_id']?.toString());
    final fullText = _normalize(json['description']?.toString());
    if (placeId == null || fullText == null) return null;
    final structured = json['structured_formatting'];
    final structuredMap = structured is Map
        ? structured.cast<String, dynamic>()
        : const <String, dynamic>{};
    return GooglePlaceSuggestion(
      placeId: placeId,
      fullText: fullText,
      primaryText:
          _normalize(structuredMap['main_text']?.toString()) ?? fullText,
      secondaryText: _normalize(structuredMap['secondary_text']?.toString()),
    );
  }

  GooglePlaceAddressSelection _selectionFromWebJson({
    required Map<String, dynamic> data,
    required GooglePlaceSuggestion suggestion,
    required String label,
  }) {
    final latitude = (data['latitude'] as num?)?.toDouble();
    final longitude = (data['longitude'] as num?)?.toDouble();
    if (latitude == null || longitude == null) {
      throw const GooglePlacesException(
        'The selected place did not include valid coordinates.',
      );
    }

    return GooglePlaceAddressSelection(
      placeId: suggestion.placeId,
      address: DriverAddress(
        label: _normalize(label),
        lat: latitude.toStringAsFixed(6),
        lng: longitude.toStringAsFixed(6),
        fullAddress: _firstNonEmpty([
          data['formattedAddress']?.toString(),
          suggestion.fullText,
        ]),
        streetName: _normalize(data['streetName']?.toString()),
        houseNumber: _normalize(data['houseNumber']?.toString()),
        city: _normalize(data['city']?.toString()),
        postalCode: _normalize(data['postalCode']?.toString()),
        country: _normalize(data['country']?.toString()),
      ),
    );
  }

  List<Map<String, dynamic>> _addressComponents(Object? value) {
    if (value is! List) return const [];
    return value
        .whereType<Map>()
        .map((item) => item.cast<String, dynamic>())
        .toList(growable: false);
  }

  String? _component(
    List<Map<String, dynamic>> components,
    String type, {
    bool short = false,
  }) {
    for (final component in components) {
      final types = component['types'];
      if (types is List && types.contains(type)) {
        return _firstNonEmpty([
          component[short ? 'shortText' : 'longText']?.toString(),
          component[short ? 'short_name' : 'long_name']?.toString(),
        ]);
      }
    }
    return null;
  }

  String? _firstNonEmpty(Iterable<String?> values) {
    for (final value in values) {
      final normalized = _normalize(value);
      if (normalized != null) return normalized;
    }
    return null;
  }

  bool _isNonEmpty(String? value) => _normalize(value) != null;

  String? _normalize(String? value) {
    final normalized = value?.trim();
    return normalized == null || normalized.isEmpty ? null : normalized;
  }
}

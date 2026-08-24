Future<List<Map<String, dynamic>>> webPlacesAutocomplete(
  String apiKey,
  String query, {
  String? countryCode,
}) =>
    throw UnsupportedError('Google Maps JavaScript is only available on web.');

Future<Map<String, dynamic>?> webPlaceDetails(String apiKey, String placeId) =>
    throw UnsupportedError('Google Maps JavaScript is only available on web.');

Future<Map<String, dynamic>?> webGeocodeAddress(
  String apiKey,
  String address,
) => throw UnsupportedError('Google Maps JavaScript is only available on web.');

Future<String?> webReverseGeocodeCountry(
  String apiKey,
  double latitude,
  double longitude,
) => throw UnsupportedError('Google Maps JavaScript is only available on web.');

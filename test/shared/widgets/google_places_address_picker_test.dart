import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:teybatdriver/core/l10n/app_localizations.dart';
import 'package:teybatdriver/core/services/google_places_service.dart';
import 'package:teybatdriver/shared/widgets/google_places_address_picker.dart';

void main() {
  testWidgets('renders an address search field when configured', (
    tester,
  ) async {
    final searchController = TextEditingController();
    final labelController = TextEditingController();
    final houseController = TextEditingController();
    final postalController = TextEditingController();
    final service = GooglePlacesService(
      apiKey: 'test-key',
      client: MockClient((_) async => http.Response('{"suggestions":[]}', 200)),
    );
    addTearDown(() {
      searchController.dispose();
      labelController.dispose();
      houseController.dispose();
      postalController.dispose();
      service.close();
    });

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: GooglePlacesAddressPicker(
            service: service,
            searchController: searchController,
            selectedAddress: null,
            labelController: labelController,
            houseNumberController: houseController,
            postalCodeController: postalController,
            textColor: Colors.black,
            secondaryColor: Colors.grey,
            surfaceColor: Colors.white,
            borderColor: Colors.grey,
            hintColor: Colors.grey,
            onSelection: (_) {},
            onClear: () {},
            onError: (_) {},
            onQueryChanged: (_) {},
            onDetailsChanged: () {},
          ),
        ),
      ),
    );

    expect(find.text('Search for your address'), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appName => 'TaybGo Chauffeur';

  @override
  String get welcome => 'Welkom';

  @override
  String get getStarted => 'Aan de slag';

  @override
  String get next => 'Volgende';

  @override
  String get skip => 'Overslaan';

  @override
  String get done => 'Klaar';

  @override
  String get cancel => 'Annuleren';

  @override
  String get confirm => 'Bevestigen';

  @override
  String get save => 'Opslaan';

  @override
  String get edit => 'Bewerken';

  @override
  String get delete => 'Verwijderen';

  @override
  String get retry => 'Opnieuw proberen';

  @override
  String get loading => 'Laden...';

  @override
  String get error => 'Fout';

  @override
  String get success => 'Succes';

  @override
  String get seeAll => 'Alles bekijken';

  @override
  String get or => 'OF';

  @override
  String get onboardingTitle1 => 'Begin vandaag met verdienen';

  @override
  String get onboardingDesc1 =>
      'Sluit je aan bij duizenden chauffeurs die verdienen op hun eigen schema';

  @override
  String get onboardingTitle2 => 'Accepteer bestellingen eenvoudig';

  @override
  String get onboardingDesc2 =>
      'Ontvang meldingen voor nieuwe bestellingen en accepteer met één tik';

  @override
  String get onboardingTitle3 => 'Navigeer & Bezorg';

  @override
  String get onboardingDesc3 =>
      'Ingebouwde navigatie helpt je bestemmingen sneller te bereiken';

  @override
  String get phoneNumber => 'Telefoonnummer';

  @override
  String get enterPhoneNumber => 'Voer je telefoonnummer in';

  @override
  String get phoneHint => '+31 6 12345678';

  @override
  String get sendOtp => 'Code versturen';

  @override
  String get verifyOtp => 'Code verifiëren';

  @override
  String get enterOtp => 'Voer de code in die we hebben gestuurd naar';

  @override
  String get resendOtp => 'Code opnieuw versturen';

  @override
  String resendOtpIn(int seconds) {
    return 'Code opnieuw versturen over ${seconds}s';
  }

  @override
  String get invalidOtp => 'Ongeldige verificatiecode';

  @override
  String get otpSent => 'Verificatiecode verstuurd';

  @override
  String get errorsAuthPhoneAlreadyRegistered =>
      'Dit nummer is al geregistreerd.';

  @override
  String get email => 'E-mail';

  @override
  String get enterEmail => 'Voer je e-mail in';

  @override
  String get signUpWithApple => 'Registreren met Apple';

  @override
  String get signUpWithGoogle => 'Registreren met Google';

  @override
  String get forgotPassword => 'Wachtwoord vergeten';

  @override
  String get driverApplication => 'Chauffeur aanmelding';

  @override
  String get personalInfo => 'Persoonlijke informatie';

  @override
  String get vehicleInfo => 'Voertuiginformatie';

  @override
  String get documents => 'Documenten';

  @override
  String get otherDocuments => 'Other Documents';

  @override
  String get reviewSubmit => 'Controleren & Verzenden';

  @override
  String get fullName => 'Volledige naam';

  @override
  String get age => 'Geboortedatum';

  @override
  String get dateOfBirth => 'Geboortedatum';

  @override
  String get address => 'Adres';

  @override
  String get addressStepTitle => 'Saved Address';

  @override
  String get addressStepSubtitle =>
      'Search for your home address and select the correct result from Google.';

  @override
  String get addressOptionalSubtitle =>
      'Required — select an address from Google so we can verify your service area.';

  @override
  String get addressRequired => 'Please search for and select your address.';

  @override
  String get searchForAddress => 'Search for your address';

  @override
  String get searchAddressHint =>
      'Start typing a street, building, or place name';

  @override
  String get addressSelected => 'Address selected';

  @override
  String get addressDetails => 'Address details';

  @override
  String get addressSearchUnavailable =>
      'Address search is not configured for this build.';

  @override
  String get addressSearchError =>
      'We couldn\'t load address results. Check your connection and try again.';

  @override
  String get noAddressResults =>
      'No matching addresses found. Try adding a city or postal code.';

  @override
  String get selectAddressSuggestion =>
      'Please select an address from the Google suggestions.';

  @override
  String get addressCoordinatesMissing =>
      'This result is missing location details. Please choose another address.';

  @override
  String get clearAddress => 'Clear address';

  @override
  String get addressLabel => 'Address label';

  @override
  String get addressLabelHint => 'e.g. Home';

  @override
  String get fullAddress => 'Full address';

  @override
  String get fullAddressHint => 'e.g. 12 King Street, Riyadh';

  @override
  String get latitude => 'Latitude';

  @override
  String get latitudeHint => 'e.g. 24.713600';

  @override
  String get longitude => 'Longitude';

  @override
  String get longitudeHint => 'e.g. 46.675300';

  @override
  String get useCurrentLocation => 'Use current location';

  @override
  String get streetName => 'Street name';

  @override
  String get streetNameHint => 'e.g. King Street';

  @override
  String get houseNumber => 'House number';

  @override
  String get houseNumberHint => 'e.g. 12';

  @override
  String get city => 'Stad';

  @override
  String get cityHint => 'e.g. Riyadh';

  @override
  String get postalCode => 'Postal code';

  @override
  String get postalCodeHint => 'e.g. 12345';

  @override
  String get country => 'Country';

  @override
  String get countryHint => 'e.g. SA';

  @override
  String get addressRequiredFields =>
      'Label, latitude, longitude, and full address are required together.';

  @override
  String get invalidLatitude => 'Enter a valid latitude between -90 and 90.';

  @override
  String get invalidLongitude =>
      'Enter a valid longitude between -180 and 180.';

  @override
  String get locationFetchFailed =>
      'Unable to determine your current location.';

  @override
  String get vehicleType => 'Voertuigtype';

  @override
  String get selectVehicleType => 'Selecteer voertuigtype';

  @override
  String get car => 'Auto';

  @override
  String get van => 'Bestelwagen';

  @override
  String get motorcycle => 'Motor';

  @override
  String get bicycle => 'Fiets';

  @override
  String get scooter => 'Scooter';

  @override
  String get licensePlate => 'Kenteken';

  @override
  String get vehicleModel => 'Voertuigmodel';

  @override
  String get vehicleYear => 'Voertuigjaar';

  @override
  String get vehicleColor => 'Voertuigkleur';

  @override
  String get serviceType => 'Servicetype';

  @override
  String get selectServiceType => 'Welke diensten bied je aan?';

  @override
  String get foodDelivery => 'Maaltijdbezorging';

  @override
  String get shipping => 'Pakketbezorging';

  @override
  String get taxi => 'Taxi';

  @override
  String get foodOrder => 'Food order';

  @override
  String get shippingOrder => 'Shipping order';

  @override
  String get taxiRide => 'Taxi ride';

  @override
  String get allOrders => 'All';

  @override
  String get uploadDocuments => 'Documenten uploaden';

  @override
  String get driversLicense => 'Rijbewijs';

  @override
  String get nationalId => 'Identiteitskaart';

  @override
  String get healthInsuranceDocument => 'Health Insurance Document';

  @override
  String get addressDocument => 'Address Document';

  @override
  String get bankDocument => 'Bank Document';

  @override
  String get vehicleRegistration => 'Kentekenbewijs';

  @override
  String get insurance => 'Verzekering';

  @override
  String get profilePhoto => 'Profielfoto';

  @override
  String get uploadPhoto => 'Foto uploaden';

  @override
  String get takePhoto => 'Foto maken';

  @override
  String get chooseFromGallery => 'Kies uit galerij';

  @override
  String get submitApplication => 'Aanmelding verzenden';

  @override
  String get applicationSubmitted => 'Aanmelding verzonden';

  @override
  String get applicationPending => 'Je aanmelding wordt beoordeeld';

  @override
  String get applicationApproved => 'Aanmelding goedgekeurd';

  @override
  String get applicationRejected => 'Aanmelding afgewezen';

  @override
  String get pendingApprovalMessage =>
      'We beoordelen je documenten. Dit duurt meestal 24-48 uur.';

  @override
  String get vehicleChangeWarningTitle => 'Vehicle changes need approval';

  @override
  String get vehicleChangeWarningMessage =>
      'Changing your vehicle details will place your account on hold until the administration reviews and approves the update.';

  @override
  String get vehicleChangeWarningNote =>
      'You won\'t be able to go online or receive new orders while this review is in progress.';

  @override
  String get vehicleChangeWarningConfirm => 'Confirm and save';

  @override
  String get home => 'Home';

  @override
  String get orders => 'Bestellingen';

  @override
  String get recentOrders => 'Recente bestellingen';

  @override
  String get earnings => 'Verdiensten';

  @override
  String get profile => 'Profiel';

  @override
  String get search => 'Zoeken';

  @override
  String get online => 'Online';

  @override
  String get offline => 'Offline';

  @override
  String get goOnline => 'Online gaan';

  @override
  String get goOffline => 'Offline gaan';

  @override
  String get tapToGoOnline => 'Tik om online te gaan';

  @override
  String get tapToGoOffline => 'Tik om offline te gaan';

  @override
  String get youAreOnline =>
      'Je bent online en klaar om bestellingen te ontvangen';

  @override
  String get youAreOffline =>
      'Je bent offline. Ga online om bestellingen te ontvangen';

  @override
  String get newOrder => 'Nieuwe bestelling';

  @override
  String get newOrderTitle => 'Nieuwe bestelling!';

  @override
  String get newOrderSubtitle => 'Accepteer voordat de tijd afloopt';

  @override
  String get orderDetails => 'Besteldetails';

  @override
  String get navigate => 'Navigeren';

  @override
  String get details => 'Details';

  @override
  String get acceptOrder => 'Bestelling accepteren';

  @override
  String get rejectOrder => 'Bestelling weigeren';

  @override
  String get accept => 'Accepteren';

  @override
  String get reject => 'Weigeren';

  @override
  String acceptIn(int seconds) {
    return 'Accepteren over ${seconds}s';
  }

  @override
  String get orderAccepted => 'Bestelling geaccepteerd';

  @override
  String get items => 'artikelen';

  @override
  String get time => 'Tijd';

  @override
  String get orderRejected => 'Bestelling geweigerd';

  @override
  String get orderCompleted => 'Bestelling voltooid';

  @override
  String get orderCancelled => 'Bestelling geannuleerd';

  @override
  String get pending => 'In afwachting';

  @override
  String get searchingForDriver => 'Chauffeur wordt gezocht';

  @override
  String get driverNotificationSent => 'Chauffeursmelding verzonden';

  @override
  String get rejected => 'Geweigerd';

  @override
  String get cancelled => 'Geannuleerd';

  @override
  String get delivered => 'Bezorgd';

  @override
  String get expired => 'Expired';

  @override
  String get restaurantDelivered => 'Restaurant delivered';

  @override
  String get pickup => 'Ophalen';

  @override
  String get dropoff => 'Afleveren';

  @override
  String get pickupLocation => 'Ophaallocatie';

  @override
  String get dropoffLocation => 'Afleverlocatie';

  @override
  String get route => 'Route';

  @override
  String get inProgress => 'Bezig';

  @override
  String get headingToPickup => 'Onderweg naar ophaallocatie';

  @override
  String get headingToDropoff => 'Onderweg naar afleverlocatie';

  @override
  String get atPickupLocation => 'Bij ophaallocatie';

  @override
  String get atDropoffLocation => 'Bij afleverlocatie';

  @override
  String get orderId => 'Bestelnummer';

  @override
  String get customer => 'Klant';

  @override
  String get itemsOrdered => 'Artikelen';

  @override
  String get callCustomer => 'Klant bellen';

  @override
  String get distance => 'Afstand';

  @override
  String get estimatedTime => 'Geschatte tijd';

  @override
  String get yourDistanceTo => 'Jouw afstand tot';

  @override
  String get km => 'km';

  @override
  String get min => 'min';

  @override
  String get startNavigation => 'Navigatie starten';

  @override
  String get arrivedAtPickup => 'Aangekomen bij ophaallocatie';

  @override
  String get startDelivery => 'Bezorging starten';

  @override
  String get arrivedAtDropoff => 'Aangekomen bij afleverlocatie';

  @override
  String get completeOrder => 'Bestelling voltooien';

  @override
  String get markAsDelivered => 'Markeer als bezorgd';

  @override
  String get acceptOrderConfirmation =>
      'Weet je zeker dat je deze bestelling wilt accepteren?';

  @override
  String get rejectOrderConfirmation =>
      'Weet je zeker dat je deze bestelling wilt weigeren?';

  @override
  String get startDeliveryConfirmation =>
      'Bevestig dat je de bestelling hebt opgehaald en de bezorging start?';

  @override
  String get arrivedAtDropoffConfirmation =>
      'Bevestig dat je bent aangekomen bij de afleverlocatie?';

  @override
  String get completeOrderConfirmation =>
      'Bevestig dat je deze bezorging hebt voltooid?';

  @override
  String get updatingStatus => 'Status bijwerken...';

  @override
  String get tip => 'Fooi';

  @override
  String get earnings_label => 'Verdiensten';

  @override
  String get deliveryFee => 'Bezorgkosten';

  @override
  String get driverDeliveryFee => 'Driver delivery fee';

  @override
  String get requiredVehicle => 'Required vehicle';

  @override
  String get packageDetails => 'Package details';

  @override
  String get packageSize => 'Size';

  @override
  String get packageWeight => 'Weight';

  @override
  String get packageContents => 'Contents';

  @override
  String get rideDetails => 'Ride details';

  @override
  String get deliveryInstructions => 'Instructions';

  @override
  String get typeDetailsUnavailable =>
      'Additional details will appear when provided by dispatch.';

  @override
  String get headToPassenger => 'Head to passenger';

  @override
  String get passengerDroppedOff => 'Passenger dropped off';

  @override
  String get completeRide => 'Complete ride';

  @override
  String get acceptRide => 'Accept ride';

  @override
  String get acceptShippingOrder => 'Accept shipment';

  @override
  String get total => 'Totaal';

  @override
  String get currentOrders => 'Huidige bestellingen';

  @override
  String get orderHistory => 'Bestelgeschiedenis';

  @override
  String get noOrdersYet => 'Nog geen bestellingen';

  @override
  String get noActiveOrders => 'Geen actieve bestellingen';

  @override
  String get waitingForOrders => 'Wachten op nieuwe bestellingen...';

  @override
  String get totalOrders => 'Totaal bestellingen';

  @override
  String get totalEarnings => 'Totale verdiensten';

  @override
  String get avgTripTime => 'Gem. rijtijd';

  @override
  String get completionRate => 'Voltooiingspercentage';

  @override
  String get rating => 'Beoordeling';

  @override
  String get todayEarnings => 'Verdiensten vandaag';

  @override
  String get weeklyEarnings => 'Wekelijkse verdiensten';

  @override
  String get monthlyEarnings => 'Maandelijkse verdiensten';

  @override
  String get lastMonthEarnings => 'Verdiensten vorige maand';

  @override
  String get viewPayslips => 'Loonstroken bekijken';

  @override
  String get payslipsSentEmail => 'Loonstroken worden per e-mail verzonden';

  @override
  String get settings => 'Instellingen';

  @override
  String get language => 'Taal';

  @override
  String get english => 'Engels';

  @override
  String get german => 'Duits';

  @override
  String get french => 'Frans';

  @override
  String get arabic => 'Arabisch';

  @override
  String get luxembourgish => 'Luxemburgs';

  @override
  String get italian => 'Italiaans';

  @override
  String get dutch => 'Nederlands';

  @override
  String get swedish => 'Zweeds';

  @override
  String get norwegian => 'Noors';

  @override
  String get danish => 'Deens';

  @override
  String get finnish => 'Fins';

  @override
  String get theme => 'Thema';

  @override
  String get lightMode => 'Lichte modus';

  @override
  String get darkMode => 'Donkere modus';

  @override
  String get systemDefault => 'Systeemstandaard';

  @override
  String get notifications => 'Meldingen';

  @override
  String get orderNotifications => 'Bestelmeldingen';

  @override
  String get promotionalNotifications => 'Promotiemeldingen';

  @override
  String get soundEnabled => 'Geluid aan';

  @override
  String get vibrationEnabled => 'Trillen aan';

  @override
  String get notificationSoundRepeats => 'Meldingsgeluid herhalen';

  @override
  String notificationSoundRepeatsEnabledDesc(int count) {
    return 'Speel het signaalgeluid $count keer af voor elke melding.';
  }

  @override
  String get notificationSoundRepeatsDisabledDesc =>
      'Schakel eerst geluid in om te kiezen hoe vaak het signaal wordt herhaald.';

  @override
  String get notificationSoundRepeatsPickerDesc =>
      'Kies hoe vaak het signaalgeluid voor elke melding moet worden herhaald.';

  @override
  String get notificationRepeatTime => '1 keer';

  @override
  String notificationRepeatTimes(int count) {
    return '$count keer';
  }

  @override
  String get noNotifications => 'Nog geen meldingen';

  @override
  String get noNotificationsDesc => 'Je meldingen verschijnen hier';

  @override
  String get today => 'Vandaag';

  @override
  String get yesterday => 'Gisteren';

  @override
  String get earlier => 'Eerder';

  @override
  String get markAllRead => 'Alles als gelezen markeren';

  @override
  String get clearAll => 'Alles wissen';

  @override
  String get newOrderReceived => 'Nieuwe bestelling ontvangen';

  @override
  String get orderAcceptedNotif => 'Bestelling succesvol geaccepteerd';

  @override
  String get orderDeliveredNotif => 'Bestelling succesvol bezorgd';

  @override
  String get earningsReceived => 'Verdiensten ontvangen';

  @override
  String get weeklyReportReady => 'Wekelijks rapport is klaar';

  @override
  String get accountUpdated => 'Account bijgewerkt';

  @override
  String get account => 'Account';

  @override
  String get editProfile => 'Profiel bewerken';

  @override
  String get currentAddress => 'Current address';

  @override
  String get editAddress => 'Edit Address';

  @override
  String get saveAddress => 'Save Address';

  @override
  String get noAddressAdded => 'No address added yet';

  @override
  String get addressUpdatedSuccessfully => 'Address updated successfully';

  @override
  String get failedToUpdateAddress => 'Failed to update address';

  @override
  String get changePassword => 'Wachtwoord wijzigen';

  @override
  String get privacyPolicy => 'Privacybeleid';

  @override
  String get termsOfService => 'Servicevoorwaarden';

  @override
  String get helpSupport => 'Hulp & Ondersteuning';

  @override
  String get contactUs => 'Neem contact op';

  @override
  String get logout => 'Uitloggen';

  @override
  String get logoutConfirm => 'Weet je zeker dat je wilt uitloggen?';

  @override
  String get deleteAccount => 'Account verwijderen';

  @override
  String get deleteAccountConfirm =>
      'Weet je zeker dat je je account wilt verwijderen? Deze actie kan niet ongedaan worden gemaakt.';

  @override
  String get networkError => 'Netwerkfout. Controleer je verbinding.';

  @override
  String get somethingWentWrong => 'Er is iets misgegaan. Probeer het opnieuw.';

  @override
  String get sessionExpired => 'Sessie verlopen. Log opnieuw in.';

  @override
  String get locationPermissionDenied => 'Locatietoestemming geweigerd';

  @override
  String get enableLocationServices =>
      'Schakel locatieservices in om door te gaan';

  @override
  String version(String version) {
    return 'Versie $version';
  }

  @override
  String get goodMorning => 'Goedemorgen';

  @override
  String get goodAfternoon => 'Goedemiddag';

  @override
  String get goodEvening => 'Goedenavond';

  @override
  String get locationRequired => 'Locatie vereist';

  @override
  String get enableLocationAccess =>
      'Schakel locatietoegang in om bestellingen te ontvangen.';

  @override
  String get enable => 'Inschakelen';

  @override
  String get pleaseEnableLocationInSettings =>
      'Schakel locatie in bij instellingen.';

  @override
  String get backgroundLocationTitle => 'Achtergrondlocatie toestaan';

  @override
  String get backgroundLocationMessage =>
      'Zodat TaybGo je locatie kan blijven versturen wanneer de app op de achtergrond draait, open de instellingen en kies „Altijd toestaan“.';

  @override
  String get gpsDisabled => 'GPS uitgeschakeld';

  @override
  String get pleaseEnableGps => 'Schakel GPS in om bestellingen te ontvangen.';

  @override
  String get failedToUpdateStatus => 'Status bijwerken mislukt';

  @override
  String get ok => 'OK';

  @override
  String get accountUnderReview => 'Account wordt beoordeeld';

  @override
  String get accountBeingVerified =>
      'Je account wordt geverifieerd. Je wordt op de hoogte gesteld wanneer goedgekeurd.';

  @override
  String get receivingOrders => 'Bestellingen ontvangen';

  @override
  String get goOnlineToStart => 'Ga online om te starten';

  @override
  String get noRecentOrders => 'Geen recente bestellingen';

  @override
  String get headToPickup => 'Ga naar ophaallocatie';

  @override
  String get onTheWay => 'Onderweg';

  @override
  String get atDelivery => 'Bij bezorging';

  @override
  String get continueText => 'Doorgaan';

  @override
  String get week => 'Week';

  @override
  String get month => 'Maand';

  @override
  String get avgPerOrder => 'Gem./Bestelling';

  @override
  String get allTime => 'Totaal';

  @override
  String get noEarningsData => 'Geen verdienstengegevens';

  @override
  String get completeOrdersToSeeEarnings =>
      'Voltooi bestellingen om je verdiensten te zien';

  @override
  String get verified => 'Geverifieerd';

  @override
  String get approved => 'Goedgekeurd';

  @override
  String joinedOn(Object date) {
    return 'Lid sinds $date';
  }

  @override
  String get driver => 'Chauffeur';

  @override
  String get knowledgeBase => 'Kennisbank';

  @override
  String get searchForHelp => 'Zoek hulp...';

  @override
  String get noArticlesFound => 'Geen artikelen gevonden';

  @override
  String get tryDifferentSearch => 'Probeer een andere zoekterm';

  @override
  String get noCategoriesAvailable => 'Geen categorieën beschikbaar';

  @override
  String articlesCount(int count) {
    return '$count artikelen';
  }

  @override
  String get articleNotFound => 'Artikel niet gevonden';

  @override
  String get wasArticleHelpful => 'Was dit artikel nuttig?';

  @override
  String get thankYouFeedback => 'Bedankt voor je feedback!';

  @override
  String get willImproveArticle => 'We zullen dit artikel verbeteren.';

  @override
  String get relatedArticles => 'Gerelateerde artikelen';

  @override
  String get kbTip => 'Tip';

  @override
  String get kbWarning => 'Waarschuwing';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nee';

  @override
  String get article => 'Artikel';

  @override
  String get browseKnowledgeBase => 'Kennisbank doorzoeken';

  @override
  String sectionsCount(int count) {
    return '$count secties';
  }

  @override
  String minRead(int count) {
    return '$count min leestijd';
  }

  @override
  String get tourAccountUnderReviewTitle => 'Account wordt beoordeeld';

  @override
  String get tourAccountUnderReviewDesc =>
      'Je account wordt geverifieerd. Je kunt de app verkennen terwijl je wacht op goedkeuring.';

  @override
  String get tourGoOnlineTitle => 'Ga online om bestellingen te ontvangen';

  @override
  String get tourGoOnlineDesc =>
      'Schakel deze schakelaar in wanneer je klaar bent om bezorgingen te accepteren. Je kunt op elk moment offline gaan.';

  @override
  String get tourDailyStatsTitle => 'Je dagelijkse statistieken';

  @override
  String get tourDailyStatsDesc =>
      'Volg je bestellingen, verdiensten en beoordeling hier. Statistieken worden in realtime bijgewerkt.';

  @override
  String get tourNewOrderTitle => 'Nieuwe bestelling ontvangen!';

  @override
  String get tourNewOrderDesc =>
      'Zo verschijnen nieuwe bestellingen. Bekijk het ophalen, bezorgen, afstand en betaling.';

  @override
  String get tourOrdersTabTitle => 'Bestellingen tab';

  @override
  String get tourOrdersTabDesc =>
      'Wissel tussen huidige bestellingen en bestelgeschiedenis.';

  @override
  String get tourTotalEarningsTitle => 'Je totale verdiensten';

  @override
  String get tourTotalEarningsDesc =>
      'Volg al je verdiensten hier — basisloon, fooien en bonussen.';

  @override
  String get tourEarningsBreakdownTitle => 'Verdienstenoverzicht';

  @override
  String get tourEarningsBreakdownDesc =>
      'Bekijk je totale bestellingen en gemiddelde verdiensten per bestelling.';

  @override
  String get tourRouteDetailsTitle => 'Routedetails';

  @override
  String get tourRouteDetailsDesc =>
      'Bekijk de volledige ophaal- en bezorgroute met adressen, afstand en geschatte tijd.';

  @override
  String get tourYourEarningsTitle => 'Je verdiensten';

  @override
  String get tourYourEarningsDesc =>
      'Bekijk de volledige betalingsoverzicht — bezorgkosten, fooi en totale uitbetaling.';

  @override
  String get tourNavActionsTitle => 'Navigatie & Acties';

  @override
  String get tourNavActionsDesc =>
      'Navigeer naar ophaal-/afleverlocatie of werk de bestelstatus bij tijdens het rijden.';

  @override
  String get tourTurnByTurnTitle => 'Stap-voor-stap navigatie';

  @override
  String get tourTurnByTurnDesc =>
      'Volg realtime aanwijzingen naar je ophaal- of afleverlocatie.';

  @override
  String get tourTripControlsTitle => 'Ritbesturing';

  @override
  String get tourTripControlsDesc =>
      'Wissel tussen ophaal- en bezorgroutes, bekijk bestemmingsdetails en verdiensten.';

  @override
  String get tourUpdateStatusTitle => 'Status bijwerken';

  @override
  String get tourUpdateStatusDesc =>
      'Tik om belangrijke mijlpalen te markeren — Onderweg, Bezorgd of Voltooid.';

  @override
  String get tourAppSettingsTitle => 'App-instellingen';

  @override
  String get tourAppSettingsDesc =>
      'Wijzig je taal, thema en ga naar de kennisbank voor hulp.';

  @override
  String get tourKnowledgeBaseTitle => 'Kennisbank';

  @override
  String get tourKnowledgeBaseDesc =>
      'Doorzoek stap-voor-stap handleidingen, tips en antwoorden op veelgestelde vragen.';

  @override
  String get tourSkipBtn => 'Overslaan';

  @override
  String get tourBackBtn => 'Terug';

  @override
  String get tourNextBtn => 'Volgende';

  @override
  String get tourDoneBtn => 'Klaar';

  @override
  String get tourWelcomeTitle => 'Welkom bij TaybGo!';

  @override
  String get tourWelcomeDesc =>
      'Maak een snelle rondleiding om te leren hoe je de app gebruikt';

  @override
  String get tourSkipForNow => 'Nu overslaan';

  @override
  String get tourStartBtn => 'Start rondleiding';

  @override
  String get tourCompleteTitle => 'Rondleiding voltooid!';

  @override
  String get tourCompleteDesc =>
      'Je bent helemaal klaar om bestellingen te accepteren en te verdienen met TaybGo!';

  @override
  String get tourBrowseKb => 'Kennisbank doorzoeken';

  @override
  String get tourGetStarted => 'Aan de slag';

  @override
  String get selectCountry => 'Selecteer land';

  @override
  String get searchCountry => 'Zoek land...';

  @override
  String get secure => 'Beveiligd';

  @override
  String get wellSendVerificationCode => 'We sturen je een verificatiecode';

  @override
  String get byConsentTerms =>
      'Door verder te gaan, ga je akkoord met onze Voorwaarden & Privacy';

  @override
  String get otpSentSuccessfully => 'Verificatiecode succesvol verzonden';

  @override
  String resendIn(int seconds) {
    return 'Opnieuw versturen over ${seconds}s';
  }

  @override
  String get resendCode => 'Code opnieuw versturen';

  @override
  String get verify => 'Verifiëren';

  @override
  String get tellUsAboutYourself => 'Vertel ons over jezelf';

  @override
  String get basicInfoSubtitle =>
      'We hebben wat basisinformatie nodig om je chauffeuraccount in te stellen';

  @override
  String get enterYourFullName => 'Voer je volledige naam in';

  @override
  String get notAvailable => 'Niet beschikbaar';

  @override
  String get verifiedViaOtp => 'Geverifieerd via OTP';

  @override
  String get selectYourVehicle => 'Selecteer je voertuig';

  @override
  String get vehicleStepSubtitle =>
      'Kies het type voertuig dat je voor bezorgingen gebruikt';

  @override
  String get chooseYourServices => 'Kies je diensten';

  @override
  String get servicesStepSubtitle =>
      'Selecteer de soorten bezorgingen die je wilt accepteren';

  @override
  String get deliverFoodDesc => 'Bezorg eten van restaurants';

  @override
  String get deliverPackagesDesc => 'Bezorg pakketten en pakjes';

  @override
  String get transportPassengersDesc => 'Vervoer passagiers';

  @override
  String get changeServiceLater =>
      'Je kunt je servicevoorkeuren later wijzigen in instellingen';

  @override
  String get back => 'Terug';

  @override
  String get completeRegistration => 'Registratie voltooien';

  @override
  String get pleaseEnterYourName => 'Voer je naam in';

  @override
  String get pleaseSelectService => 'Selecteer minimaal één servicetype';

  @override
  String get pleaseUploadDriversLicense => 'Upload uw rijbewijs';

  @override
  String get pleaseUploadNationalId => 'Upload uw identiteitsbewijs';

  @override
  String pleaseUploadDocument(Object documentName) {
    return 'Upload $documentName';
  }

  @override
  String get registrationFailed => 'Registratie mislukt. Probeer het opnieuw.';

  @override
  String get stepPersonal => 'Persoonlijk';

  @override
  String get stepVehicle => 'Voertuig';

  @override
  String get stepServices => 'Diensten';

  @override
  String applicationStepProgress(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String applicationNextStep(String step) {
    return 'Next: $step';
  }

  @override
  String get ecoFriendlyOption => 'Milieuvriendelijke optie';

  @override
  String get fastAndAgile => 'Snel en wendbaar';

  @override
  String get mostVersatile => 'Meest veelzijdig';

  @override
  String get largeDeliveries => 'Grote bezorgingen';

  @override
  String get deleteDataWarning =>
      'Dit verwijdert permanent al je gegevens inclusief profiel, beoordelingen en bestelgeschiedenis.';

  @override
  String get finalConfirmation => 'Laatste bevestiging';

  @override
  String get finalDeleteWarning =>
      'Weet je het absoluut zeker? Deze actie is onomkeerbaar en je verliest al je gegevens.';

  @override
  String get deleteMyAccount => 'Mijn account verwijderen';

  @override
  String get deletingAccount => 'Account verwijderen...';

  @override
  String get accountDeletedSuccessfully => 'Account succesvol verwijderd';

  @override
  String failedToDeleteAccount(String error) {
    return 'Account verwijderen mislukt: $error';
  }

  @override
  String get justNow => 'Zojuist';

  @override
  String minutesAgo(int minutes) {
    return '${minutes}m geleden';
  }

  @override
  String hoursAgo(int hours) {
    return '${hours}u geleden';
  }

  @override
  String daysAgo(int days) {
    return '${days}d geleden';
  }

  @override
  String get clearAllNotificationsConfirm =>
      'Weet je zeker dat je alle meldingen wilt wissen?';

  @override
  String get failedToLoadNotifications => 'Meldingen laden mislukt';

  @override
  String get calculatingRoute => 'Route berekenen...';

  @override
  String get orderNotFound => 'Bestelling niet gevonden';

  @override
  String get goBack => 'Ga terug';

  @override
  String get gpsUnavailableTapRetry =>
      'GPS niet beschikbaar. Tik om opnieuw te proberen.';

  @override
  String get googleMaps => 'Google Maps';

  @override
  String get fetchingLocation => 'Locatie ophalen...';

  @override
  String secondsAgo(int seconds) {
    return '${seconds}s geleden';
  }

  @override
  String get subtotal => 'Subtotaal';

  @override
  String get orderType => 'Type';

  @override
  String get created => 'Aangemaakt';

  @override
  String get accepted => 'Geaccepteerd';

  @override
  String get completed => 'Voltooid';

  @override
  String get orderPaid => 'Betaald';

  @override
  String get orderPaidDescription => 'Geen contant geld te innen';

  @override
  String get collectCash => 'Contant innen';

  @override
  String get collectCashReminder =>
      'Vergeet niet de betaling van de klant te innen';

  @override
  String collectCashAmountReminder(String amount) {
    return 'Collect $amount from the customer before completing.';
  }

  @override
  String get locationPermissionLostWhileOnline =>
      'Locatietoegang is uitgeschakeld. U ontvangt geen bestellingen totdat dit is ingeschakeld.';

  @override
  String get batteryOptimizationTitle => 'Batterijoptimalisatie uitschakelen';

  @override
  String get batteryOptimizationMessage =>
      'Om live locatie op de achtergrond actief te houden, stel TaybGo Driver in de Android-instellingen in op onbeperkt batterijgebruik.';

  @override
  String get batteryOptimizationBannerMessage =>
      'Batterijoptimalisatie kan live locatie pauzeren terwijl u online bent. Stel TaybGo Driver in op onbeperkt batterijgebruik.';

  @override
  String get profileUpdatedSuccessfully => 'Profiel succesvol bijgewerkt';

  @override
  String get failedToUpdateProfile => 'Profiel bijwerken mislukt';

  @override
  String get supportTickets => 'Supporttickets';

  @override
  String get supportFilterAll => 'Alle';

  @override
  String get supportFilterOpen => 'Open';

  @override
  String get supportFilterInProgress => 'In behandeling';

  @override
  String get supportFilterClosed => 'Gesloten';

  @override
  String get supportStatusOpen => 'Open';

  @override
  String get supportStatusInProgress => 'In behandeling';

  @override
  String get supportStatusClosed => 'Gesloten';

  @override
  String get supportPriorityLow => 'Laag';

  @override
  String get supportPriorityMedium => 'Gemiddeld';

  @override
  String get supportPriorityHigh => 'Hoog';

  @override
  String get supportNoTickets => 'Nog geen tickets';

  @override
  String get supportNoTicketsDesc =>
      'Maak een ticket aan als je hulp nodig hebt';

  @override
  String get supportCreateTicket => 'Ticket aanmaken';

  @override
  String get supportTicketCreated => 'Ticket succesvol aangemaakt';

  @override
  String get supportRelatedOrder => 'Gerelateerde bestelling';

  @override
  String get supportSubject => 'Onderwerp';

  @override
  String get supportSubjectHint => 'Korte beschrijving van je probleem';

  @override
  String get supportSubjectRequired => 'Onderwerp is verplicht';

  @override
  String get supportMessage => 'Bericht';

  @override
  String get supportMessageHint => 'Beschrijf je probleem in detail...';

  @override
  String get supportMessageRequired => 'Bericht is verplicht';

  @override
  String get supportSubmitTicket => 'Ticket verzenden';

  @override
  String get supportSelectOrder => 'Selecteer een bestelling (optioneel)';

  @override
  String get supportNoOrder => 'Geen specifieke bestelling';

  @override
  String get supportTicketDetail => 'Ticketdetails';

  @override
  String get supportNoMessages => 'Nog geen berichten';

  @override
  String get supportTypeMessage => 'Typ een bericht...';

  @override
  String get supportTicketClosed => 'Dit ticket is gesloten';

  @override
  String get enterAge => 'Select your birthdate';

  @override
  String get carSize => 'Car Size';

  @override
  String get selectCarSize => 'Select car size';

  @override
  String get carSizeX => 'Standard (X)';

  @override
  String get carSizeComfort => 'Comfort';

  @override
  String get carSizeXL => 'XL';

  @override
  String get carSizeBlack => 'Black';

  @override
  String get vehicleMake => 'Vehicle Make';

  @override
  String get enterVehicleMake => 'e.g. Toyota, BMW';

  @override
  String get enterVehicleModel => 'e.g. Corolla, 3 Series';

  @override
  String get enterVehiclePlateNumber => 'e.g. W-AB 1234';

  @override
  String get enterVehicleColor => 'e.g. White, Black';

  @override
  String get enterVehicleYear => 'e.g. 2020';

  @override
  String get selectVehicleYear => 'Select vehicle year';

  @override
  String get vehicleDetailsTitle => 'Vehicle Details';

  @override
  String get vehicleDetailsSubtitle => 'Tell us more about your vehicle';

  @override
  String get stepDetails => 'Details';

  @override
  String get stepDocuments => 'Documents';

  @override
  String get documentsTitle => 'Upload Documents';

  @override
  String get documentsSubtitle =>
      'Upload all required documents to complete your application';

  @override
  String get tapToUpload => 'Tap to upload';

  @override
  String get uploadingFile => 'Uploading...';

  @override
  String get uploadFailed => 'Upload failed. Tap to retry.';

  @override
  String get uploaded => 'Uploaded';

  @override
  String get changePhoto => 'Change';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get file => 'Bestand';

  @override
  String get pleaseEnterAge => 'Please select your birthdate';

  @override
  String get invalidAge => 'Drivers must be between 18 and 80 years old';

  @override
  String get pleaseSelectCarSize => 'Please select a car size';

  @override
  String get pleaseEnterPlateNumber => 'Please enter your vehicle plate number';

  @override
  String get pleaseEnterVehicleColor => 'Please enter your vehicle color';

  @override
  String get pleaseEnterVehicleMake => 'Please enter your vehicle make';

  @override
  String get pleaseEnterVehicleModel => 'Please enter your vehicle model';

  @override
  String get pleaseEnterVehicleYear => 'Please enter your vehicle year';

  @override
  String get invalidVehicleYear => 'Please select a valid vehicle year';

  @override
  String get dropOrder => 'Drop Order';

  @override
  String get dropOrderDescription =>
      'Return this accepted order to dispatch so another driver can take it.';

  @override
  String get dropOrderConfirmation =>
      'Are you sure you want to drop this order? It will be removed from your active orders.';

  @override
  String get dropOrderWarning => 'This action is only available before pickup.';

  @override
  String get keepOrder => 'Keep Order';

  @override
  String get orderDroppedSuccessfully => 'Order returned to dispatch';

  @override
  String get failedToDropOrder => 'Failed to drop order. Please try again.';

  @override
  String get orderAlreadyTaken =>
      'This order was already taken by another driver';

  @override
  String get orderSuggestionExpired => 'This order suggestion has expired';

  @override
  String get failedToAcceptOrder => 'Failed to accept order. Please try again.';

  @override
  String get failedToRejectOrder => 'Failed to reject order';

  @override
  String get changelog => 'Wijzigingslogboek';

  @override
  String get changelogTitle => 'Wat is er nieuw?';

  @override
  String get changelogSubtitle =>
      'Bekijk snel de nieuwste verbeteringen in TaybGo Driver.';

  @override
  String get changelogCurrent => 'Huidig';

  @override
  String get changelogBuild => 'Build';

  @override
  String get changelogReleased => 'Uitgebracht';

  @override
  String get changelogReleaseNotes => 'Releaseopmerkingen';

  @override
  String get changelogHighlights => 'Hoogtepunten';

  @override
  String get changelogFixes => 'Oplossingen';

  @override
  String get changelogImprovements => 'Verbeteringen';

  @override
  String get changelogStability => 'Stabiliteit';

  @override
  String get changelogPlatform => 'Platform';

  @override
  String get changelogRelease => 'Release';

  @override
  String get changelogDateAug20 => '20 August 2026';

  @override
  String get changelogVersion101416ApplicationFlow =>
      'Redesigned the driver application into five focused steps with clearer progress, organized sections, better field guidance, and inline validation.';

  @override
  String get changelogVersion101416Address =>
      'Refactored registration address entry around required Google Places search, a clear selected-address summary, complete structured address data, coordinates, and stronger validation.';

  @override
  String get changelogVersion101416ProfileAddress =>
      'Edit Profile now shows the saved address in a compact card with an Edit Address action that opens a dedicated Google Places editor.';

  @override
  String get changelogVersion101416Vehicle =>
      'Restored complete vehicle details and added the same vehicle-year selector to registration and Edit Profile, covering 1960 through next year.';

  @override
  String get changelogVersion101416Documents =>
      'Improved required-document presentation, upload states, and registration error feedback.';

  @override
  String get changelogVersion101416DriverFee =>
      'Incoming orders now show the driver\'s delivery fee instead of the customer total; paid order details show only that fee, while unpaid orders also show the amount to collect.';

  @override
  String get changelogVersion101416OrderTypes =>
      'Added type-aware Food, Shipping, and Taxi experiences with package, vehicle, car-class, instruction, status, and action details where provided by the API.';

  @override
  String get changelogVersion101416History =>
      'Added Food, Shipping, and Taxi filters to order history with clearer type badges and references.';

  @override
  String get changelogVersion101416Earnings =>
      'Connected home and earnings summaries to driver earnings data, kept All Time as the default, and added date and order-type filters.';

  @override
  String get changelogVersion101416Reliability =>
      'Improved accepted-order refresh, active-order detail loading, API status handling, and fallback behavior when optional type-specific data is unavailable.';

  @override
  String get changelogVersion101416Release =>
      'Released driver app version 1.0.14+16.';

  @override
  String get changelogDateAug9 => '9 augustus 2026';

  @override
  String get changelogDateAug11 => '11 augustus 2026';

  @override
  String get changelogVersion1013Address =>
      'Optionele, gestructureerde chauffeursadressen met coördinaten en volledige adresgegevens toegevoegd tijdens registratie en profielbewerking.';

  @override
  String get changelogVersion1013Status =>
      'Updates die alleen het adres wijzigen gebruiken nu gedeeltelijke PATCH-verzoeken en behouden de status van een goedgekeurde chauffeur.';

  @override
  String get changelogVersion1013Release =>
      'Chauffeursapp versie 1.0.13+15 uitgebracht.';

  @override
  String get changelogDateMay31 => '31 mei 2026';

  @override
  String get changelogDateMay24 => '24 mei 2026';

  @override
  String get changelogDateMay13 => '13 mei 2026';

  @override
  String get changelogDateMay11 => '11 mei 2026';

  @override
  String get changelogCurrentTaxi =>
      'De taxidienst kan nu alleen door automobilisten worden geselecteerd; fietskoeriers kunnen deze tijdens registratie en profielbewerking niet meer inschakelen.';

  @override
  String get changelogVersion1113Upload =>
      'Het geheugengebruik bij webuploads is verlaagd, zodat het uploaden van documenten betrouwbaarder is op minder krachtige apparaten.';

  @override
  String get changelogCurrentChangelog =>
      'Een gelokaliseerd, uitklapbaar wijzigingslogboek is aan Profiel toegevoegd met releasegeschiedenis, buildnummers, datums en releaseopmerkingen.';

  @override
  String get changelogVersion1113Version =>
      'De appversie en releasedatum worden nu getoond op het inlogscherm en het web-startscherm.';

  @override
  String get changelogCurrentRelease =>
      'De app is bijgewerkt naar versie 1.0.12+14 met de nieuwste verbeteringen voor de chauffeursapp.';

  @override
  String get changelogVersion1113Release =>
      'De Play Store-build is bijgewerkt naar versie 1.0.11+13 (versiecode 13).';

  @override
  String get changelogVersion1112Release =>
      'De chauffeursapp is uitgebracht als versie 1.0.11+12 en de releasemetadata is vastgelegd.';

  @override
  String get changelogVersion1011Documents =>
      'Validatie van verplichte documenten voor automobilisten is toegevoegd.';

  @override
  String get changelogVersion1011Uploads =>
      'Verplichte documenten zijn duidelijker gemarkeerd en de verwerking van de uploadstatus is verbeterd.';

  @override
  String get changelogVersion1011Feedback =>
      'Validatie en foutmeldingen bij het opslaan van profielwijzigingen zijn verbeterd.';

  @override
  String get changelogVersion1011Release =>
      'De chauffeursapp is uitgebracht als versie 1.0.10+11.';

  @override
  String get changelogVersion0910Crashlytics =>
      'Crashlytics-rapportage voor fatale fouten in release-builds is toegevoegd.';

  @override
  String get changelogVersion0910Notifications =>
      'De levenscyclus van meldingen, deduplicatie en de verwerking van ordermeldingen zijn verbeterd.';

  @override
  String get changelogVersion0910Platform =>
      'De releaseconfiguratie voor Android, iOS, macOS en web is vernieuwd met ontwikkel- en productieflavors.';

  @override
  String get changelogVersion0910Release =>
      'De chauffeursapp is uitgebracht als versie 1.0.9+10.';
}

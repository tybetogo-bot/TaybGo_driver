// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'TaybGo Fahrer';

  @override
  String get welcome => 'Willkommen';

  @override
  String get getStarted => 'Loslegen';

  @override
  String get next => 'Weiter';

  @override
  String get skip => 'Überspringen';

  @override
  String get done => 'Fertig';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get save => 'Speichern';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get delete => 'Löschen';

  @override
  String get retry => 'Wiederholen';

  @override
  String get loading => 'Laden...';

  @override
  String get error => 'Fehler';

  @override
  String get success => 'Erfolg';

  @override
  String get seeAll => 'Alle anzeigen';

  @override
  String get or => 'ODER';

  @override
  String get onboardingTitle1 => 'Verdienen Sie noch heute';

  @override
  String get onboardingDesc1 =>
      'Schließen Sie sich Tausenden von Fahrern an, die nach eigenem Zeitplan verdienen';

  @override
  String get onboardingTitle2 => 'Aufträge einfach annehmen';

  @override
  String get onboardingDesc2 =>
      'Werden Sie über neue Aufträge benachrichtigt und nehmen Sie mit einem Tippen an';

  @override
  String get onboardingTitle3 => 'Navigieren & Liefern';

  @override
  String get onboardingDesc3 =>
      'Die integrierte Navigation hilft Ihnen, Ziele schneller zu erreichen';

  @override
  String get phoneNumber => 'Telefonnummer';

  @override
  String get enterPhoneNumber => 'Geben Sie Ihre Telefonnummer ein';

  @override
  String get phoneHint => '+49 123 456 7890';

  @override
  String get sendOtp => 'Code senden';

  @override
  String get verifyOtp => 'Code bestätigen';

  @override
  String get enterOtp => 'Geben Sie den Code ein, den wir gesendet haben an';

  @override
  String get resendOtp => 'Code erneut senden';

  @override
  String resendOtpIn(int seconds) {
    return 'Code erneut senden in ${seconds}s';
  }

  @override
  String get invalidOtp => 'Ungültiger Bestätigungscode';

  @override
  String get otpSent => 'Bestätigungscode gesendet';

  @override
  String get errorsAuthPhoneAlreadyRegistered =>
      'Diese Nummer ist bereits registriert.';

  @override
  String get email => 'E-Mail';

  @override
  String get enterEmail => 'Geben Sie Ihre E-Mail ein';

  @override
  String get signUpWithApple => 'Mit Apple anmelden';

  @override
  String get signUpWithGoogle => 'Mit Google anmelden';

  @override
  String get forgotPassword => 'Passwort vergessen';

  @override
  String get password => 'Password';

  @override
  String get enterPassword => 'Enter your password';

  @override
  String get signIn => 'Sign in';

  @override
  String get passwordRequiredForDriver =>
      'Password sign-in is required for driver accounts.';

  @override
  String get checkingSignInMethod => 'Checking sign-in method…';

  @override
  String get configFallback =>
      'Could not refresh sign-in settings. Using password sign-in.';

  @override
  String get updateRequiredTitle => 'Update required';

  @override
  String get updateRequiredMessage =>
      'Install the latest TaybGo Driver version to continue.';

  @override
  String latestVersionLabel(String version) {
    return 'Latest version: $version';
  }

  @override
  String get updateNow => 'Update now';

  @override
  String get checkAgain => 'Check again';

  @override
  String get invalidUpdateUrl =>
      'The update link is unavailable. Please try again.';

  @override
  String get couldNotOpenLink => 'Could not open this link.';

  @override
  String get driverApplication => 'Fahrerantrag';

  @override
  String get personalInfo => 'Persönliche Informationen';

  @override
  String get vehicleInfo => 'Fahrzeuginformationen';

  @override
  String get documents => 'Dokumente';

  @override
  String get otherDocuments => 'Other Documents';

  @override
  String get reviewSubmit => 'Überprüfen & Absenden';

  @override
  String get fullName => 'Vollständiger Name';

  @override
  String get age => 'Geburtsdatum';

  @override
  String get dateOfBirth => 'Geburtsdatum';

  @override
  String get address => 'Adresse';

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
  String get city => 'Stadt';

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
  String get vehicleType => 'Fahrzeugtyp';

  @override
  String get selectVehicleType => 'Fahrzeugtyp auswählen';

  @override
  String get car => 'Auto';

  @override
  String get van => 'Transporter';

  @override
  String get motorcycle => 'Motorrad';

  @override
  String get bicycle => 'Fahrrad';

  @override
  String get scooter => 'Roller';

  @override
  String get licensePlate => 'Kennzeichen';

  @override
  String get vehicleModel => 'Fahrzeugmodell';

  @override
  String get vehicleYear => 'Baujahr';

  @override
  String get vehicleColor => 'Fahrzeugfarbe';

  @override
  String get serviceType => 'Serviceart';

  @override
  String get selectServiceType => 'Welche Dienste werden Sie anbieten?';

  @override
  String get foodDelivery => 'Essenslieferung';

  @override
  String get shipping => 'Versand';

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
  String get uploadDocuments => 'Dokumente hochladen';

  @override
  String get driversLicense => 'Führerschein';

  @override
  String get nationalId => 'Personalausweis';

  @override
  String get healthInsuranceDocument => 'Health Insurance Document';

  @override
  String get addressDocument => 'Address Document';

  @override
  String get bankDocument => 'Bank Document';

  @override
  String get vehicleRegistration => 'Fahrzeugschein';

  @override
  String get insurance => 'Versicherung';

  @override
  String get profilePhoto => 'Profilfoto';

  @override
  String get uploadPhoto => 'Foto hochladen';

  @override
  String get takePhoto => 'Foto aufnehmen';

  @override
  String get chooseFromGallery => 'Aus Galerie wählen';

  @override
  String get submitApplication => 'Antrag absenden';

  @override
  String get applicationSubmitted => 'Antrag eingereicht';

  @override
  String get applicationPending => 'Ihr Antrag wird geprüft';

  @override
  String get applicationApproved => 'Antrag genehmigt';

  @override
  String get applicationRejected => 'Antrag abgelehnt';

  @override
  String get pendingApprovalMessage =>
      'Wir prüfen Ihre Dokumente. Dies dauert normalerweise 24-48 Stunden.';

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
  String get home => 'Startseite';

  @override
  String get orders => 'Aufträge';

  @override
  String get recentOrders => 'Letzte Aufträge';

  @override
  String get earnings => 'Einnahmen';

  @override
  String get profile => 'Profil';

  @override
  String get search => 'Suche';

  @override
  String get online => 'Online';

  @override
  String get offline => 'Offline';

  @override
  String get goOnline => 'Online gehen';

  @override
  String get goOffline => 'Offline gehen';

  @override
  String get tapToGoOnline => 'Tippen um online zu gehen';

  @override
  String get tapToGoOffline => 'Tippen um offline zu gehen';

  @override
  String get youAreOnline => 'Sie sind online und bereit, Aufträge zu erhalten';

  @override
  String get youAreOffline =>
      'Sie sind offline. Gehen Sie online, um Aufträge zu erhalten';

  @override
  String get newOrder => 'Neuer Auftrag';

  @override
  String get newOrderTitle => 'Neuer Auftrag!';

  @override
  String get newOrderSubtitle => 'Annehmen bevor die Zeit abläuft';

  @override
  String get orderDetails => 'Auftragsdetails';

  @override
  String get navigate => 'Navigieren';

  @override
  String get details => 'Details';

  @override
  String get acceptOrder => 'Auftrag annehmen';

  @override
  String get rejectOrder => 'Auftrag ablehnen';

  @override
  String get accept => 'Annehmen';

  @override
  String get reject => 'Ablehnen';

  @override
  String acceptIn(int seconds) {
    return 'Annehmen in ${seconds}s';
  }

  @override
  String get orderAccepted => 'Auftrag angenommen';

  @override
  String get items => 'Artikel';

  @override
  String get time => 'Zeit';

  @override
  String get orderRejected => 'Auftrag abgelehnt';

  @override
  String get orderCompleted => 'Auftrag abgeschlossen';

  @override
  String get orderCancelled => 'Auftrag storniert';

  @override
  String get pending => 'Ausstehend';

  @override
  String get searchingForDriver => 'Fahrer wird gesucht';

  @override
  String get driverNotificationSent => 'Fahrerbenachrichtigung gesendet';

  @override
  String get rejected => 'Abgelehnt';

  @override
  String get cancelled => 'Storniert';

  @override
  String get delivered => 'Geliefert';

  @override
  String get expired => 'Expired';

  @override
  String get restaurantDelivered => 'Restaurant delivered';

  @override
  String get pickup => 'Abholung';

  @override
  String get dropoff => 'Lieferung';

  @override
  String get pickupLocation => 'Abholort';

  @override
  String get dropoffLocation => 'Lieferort';

  @override
  String get route => 'Route';

  @override
  String get inProgress => 'In Bearbeitung';

  @override
  String get headingToPickup => 'Auf dem Weg zum Abholort';

  @override
  String get headingToDropoff => 'Auf dem Weg zum Lieferort';

  @override
  String get atPickupLocation => 'Am Abholort';

  @override
  String get atDropoffLocation => 'Am Lieferort';

  @override
  String get orderId => 'Auftrags-ID';

  @override
  String get customer => 'Kunde';

  @override
  String get itemsOrdered => 'Artikel';

  @override
  String get callCustomer => 'Kunden anrufen';

  @override
  String get distance => 'Entfernung';

  @override
  String get estimatedTime => 'Geschätzte Zeit';

  @override
  String get yourDistanceTo => 'Ihre Entfernung zu';

  @override
  String get km => 'km';

  @override
  String get min => 'Min';

  @override
  String get startNavigation => 'Navigation starten';

  @override
  String get arrivedAtPickup => 'Am Abholort angekommen';

  @override
  String get startDelivery => 'Lieferung starten';

  @override
  String get arrivedAtDropoff => 'Am Lieferort angekommen';

  @override
  String get completeOrder => 'Auftrag abschließen';

  @override
  String get markAsDelivered => 'Als geliefert markieren';

  @override
  String get acceptOrderConfirmation =>
      'Sind Sie sicher, dass Sie diesen Auftrag annehmen möchten?';

  @override
  String get rejectOrderConfirmation =>
      'Sind Sie sicher, dass Sie diesen Auftrag ablehnen möchten?';

  @override
  String get startDeliveryConfirmation =>
      'Bestätigen Sie, dass Sie den Auftrag abgeholt haben und die Lieferung beginnen?';

  @override
  String get arrivedAtDropoffConfirmation =>
      'Bestätigen Sie, dass Sie am Lieferort angekommen sind?';

  @override
  String get completeOrderConfirmation =>
      'Bestätigen Sie, dass Sie diese Lieferung abgeschlossen haben?';

  @override
  String get updatingStatus => 'Status wird aktualisiert...';

  @override
  String get tip => 'Trinkgeld';

  @override
  String get earnings_label => 'Einnahmen';

  @override
  String get deliveryFee => 'Liefergebühr';

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
  String get total => 'Gesamt';

  @override
  String get currentOrders => 'Aktuelle Aufträge';

  @override
  String get orderHistory => 'Auftragsverlauf';

  @override
  String get noOrdersYet => 'Noch keine Aufträge';

  @override
  String get noActiveOrders => 'Keine aktiven Aufträge';

  @override
  String get waitingForOrders => 'Warten auf neue Aufträge...';

  @override
  String get totalOrders => 'Gesamte Aufträge';

  @override
  String get totalEarnings => 'Gesamteinnahmen';

  @override
  String get avgTripTime => 'Durchschn. Fahrzeit';

  @override
  String get completionRate => 'Abschlussrate';

  @override
  String get rating => 'Bewertung';

  @override
  String get todayEarnings => 'Einnahmen heute';

  @override
  String get weeklyEarnings => 'Wöchentliche Einnahmen';

  @override
  String get monthlyEarnings => 'Monatliche Einnahmen';

  @override
  String get lastMonthEarnings => 'Einnahmen letzten Monat';

  @override
  String get viewPayslips => 'Gehaltsabrechnungen anzeigen';

  @override
  String get payslipsSentEmail =>
      'Gehaltsabrechnungen werden per E-Mail gesendet';

  @override
  String get settings => 'Einstellungen';

  @override
  String get language => 'Sprache';

  @override
  String get english => 'Englisch';

  @override
  String get german => 'Deutsch';

  @override
  String get french => 'Französisch';

  @override
  String get arabic => 'Arabisch';

  @override
  String get luxembourgish => 'Luxemburgisch';

  @override
  String get italian => 'Italienisch';

  @override
  String get dutch => 'Niederländisch';

  @override
  String get swedish => 'Schwedisch';

  @override
  String get norwegian => 'Norwegisch';

  @override
  String get danish => 'Dänisch';

  @override
  String get finnish => 'Finnisch';

  @override
  String get theme => 'Design';

  @override
  String get lightMode => 'Heller Modus';

  @override
  String get darkMode => 'Dunkler Modus';

  @override
  String get systemDefault => 'Systemstandard';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get orderNotifications => 'Auftragsbenachrichtigungen';

  @override
  String get promotionalNotifications => 'Werbebenachrichtigungen';

  @override
  String get soundEnabled => 'Ton aktiviert';

  @override
  String get vibrationEnabled => 'Vibration aktiviert';

  @override
  String get notificationSoundRepeats => 'Benachrichtigungston wiederholen';

  @override
  String notificationSoundRepeatsEnabledDesc(int count) {
    return 'Spielt den Signalton $count Mal f?r jede Benachrichtigung ab.';
  }

  @override
  String get notificationSoundRepeatsDisabledDesc =>
      'Aktivieren Sie zuerst den Ton, um festzulegen, wie oft das Signal wiederholt wird.';

  @override
  String get notificationSoundRepeatsPickerDesc =>
      'W?hlen Sie, wie oft der Signalton f?r jede Benachrichtigung wiederholt werden soll.';

  @override
  String get notificationRepeatTime => '1 Mal';

  @override
  String notificationRepeatTimes(int count) {
    return '$count Mal';
  }

  @override
  String get noNotifications => 'Noch keine Benachrichtigungen';

  @override
  String get noNotificationsDesc =>
      'Ihre Benachrichtigungen werden hier angezeigt';

  @override
  String get today => 'Heute';

  @override
  String get yesterday => 'Gestern';

  @override
  String get earlier => 'Früher';

  @override
  String get markAllRead => 'Alle als gelesen markieren';

  @override
  String get clearAll => 'Alle löschen';

  @override
  String get newOrderReceived => 'Neuer Auftrag erhalten';

  @override
  String get orderAcceptedNotif => 'Auftrag erfolgreich angenommen';

  @override
  String get orderDeliveredNotif => 'Auftrag erfolgreich geliefert';

  @override
  String get earningsReceived => 'Einnahmen erhalten';

  @override
  String get weeklyReportReady => 'Wochenbericht ist bereit';

  @override
  String get accountUpdated => 'Konto aktualisiert';

  @override
  String get account => 'Konto';

  @override
  String get editProfile => 'Profil bearbeiten';

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
  String get changePassword => 'Passwort ändern';

  @override
  String get privacyPolicy => 'Datenschutzrichtlinie';

  @override
  String get termsOfService => 'Nutzungsbedingungen';

  @override
  String get helpSupport => 'Hilfe & Support';

  @override
  String get contactUs => 'Kontaktieren Sie uns';

  @override
  String get logout => 'Abmelden';

  @override
  String get logoutConfirm =>
      'Sind Sie sicher, dass Sie sich abmelden möchten?';

  @override
  String get deleteAccount => 'Konto löschen';

  @override
  String get deleteAccountConfirm =>
      'Sind Sie sicher, dass Sie Ihr Konto löschen möchten? Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get networkError =>
      'Netzwerkfehler. Bitte überprüfen Sie Ihre Verbindung.';

  @override
  String get somethingWentWrong =>
      'Etwas ist schief gelaufen. Bitte versuchen Sie es erneut.';

  @override
  String get sessionExpired =>
      'Sitzung abgelaufen. Bitte melden Sie sich erneut an.';

  @override
  String get locationPermissionDenied => 'Standortberechtigung verweigert';

  @override
  String get enableLocationServices =>
      'Bitte aktivieren Sie die Standortdienste, um fortzufahren';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get goodMorning => 'Guten Morgen';

  @override
  String get goodAfternoon => 'Guten Tag';

  @override
  String get goodEvening => 'Guten Abend';

  @override
  String get locationRequired => 'Standort erforderlich';

  @override
  String get enableLocationAccess =>
      'Aktivieren Sie den Standortzugriff, um Bestellungen zu erhalten.';

  @override
  String get enable => 'Aktivieren';

  @override
  String get pleaseEnableLocationInSettings =>
      'Bitte aktivieren Sie den Standort in den Einstellungen.';

  @override
  String get backgroundLocationTitle => 'Standort im Hintergrund zulassen';

  @override
  String get backgroundLocationMessage =>
      'Damit TaybGo Ihren Standort auch im Hintergrund senden kann, öffnen Sie bitte die Einstellungen und wählen Sie „Immer zulassen“.';

  @override
  String get gpsDisabled => 'GPS deaktiviert';

  @override
  String get pleaseEnableGps =>
      'Bitte aktivieren Sie GPS, um Bestellungen zu erhalten.';

  @override
  String get failedToUpdateStatus => 'Status konnte nicht aktualisiert werden';

  @override
  String get ok => 'OK';

  @override
  String get accountUnderReview => 'Konto wird überprüft';

  @override
  String get accountBeingVerified =>
      'Ihr Konto wird überprüft. Sie werden benachrichtigt, wenn es genehmigt ist.';

  @override
  String get receivingOrders => 'Bestellungen empfangen';

  @override
  String get goOnlineToStart => 'Online gehen, um zu starten';

  @override
  String get noRecentOrders => 'Keine aktuellen Bestellungen';

  @override
  String get headToPickup => 'Zur Abholung fahren';

  @override
  String get onTheWay => 'Unterwegs';

  @override
  String get atDelivery => 'Bei der Lieferung';

  @override
  String get continueText => 'Fortfahren';

  @override
  String get week => 'Woche';

  @override
  String get month => 'Monat';

  @override
  String get avgPerOrder => 'Durchschn./Bestellung';

  @override
  String get allTime => 'Gesamt';

  @override
  String get noEarningsData => 'Keine Einnahmedaten';

  @override
  String get completeOrdersToSeeEarnings =>
      'Schließen Sie Bestellungen ab, um Ihre Einnahmen zu sehen';

  @override
  String get verified => 'Verifiziert';

  @override
  String get approved => 'Genehmigt';

  @override
  String joinedOn(Object date) {
    return 'Beigetreten $date';
  }

  @override
  String get driver => 'Fahrer';

  @override
  String get knowledgeBase => 'Wissensdatenbank';

  @override
  String get searchForHelp => 'Nach Hilfe suchen...';

  @override
  String get noArticlesFound => 'Keine Artikel gefunden';

  @override
  String get tryDifferentSearch => 'Versuchen Sie einen anderen Suchbegriff';

  @override
  String get noCategoriesAvailable => 'Keine Kategorien verfügbar';

  @override
  String articlesCount(int count) {
    return '$count Artikel';
  }

  @override
  String get articleNotFound => 'Artikel nicht gefunden';

  @override
  String get wasArticleHelpful => 'War dieser Artikel hilfreich?';

  @override
  String get thankYouFeedback => 'Vielen Dank für Ihr Feedback!';

  @override
  String get willImproveArticle => 'Wir werden diesen Artikel verbessern.';

  @override
  String get relatedArticles => 'Verwandte Artikel';

  @override
  String get kbTip => 'Tipp';

  @override
  String get kbWarning => 'Warnung';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nein';

  @override
  String get article => 'Artikel';

  @override
  String get browseKnowledgeBase => 'Wissensdatenbank durchsuchen';

  @override
  String sectionsCount(int count) {
    return '$count Abschnitte';
  }

  @override
  String minRead(int count) {
    return '$count Min. Lesezeit';
  }

  @override
  String get tourAccountUnderReviewTitle => 'Konto wird überprüft';

  @override
  String get tourAccountUnderReviewDesc =>
      'Ihr Konto wird verifiziert. Sie können die App erkunden, während Sie auf die Genehmigung warten.';

  @override
  String get tourGoOnlineTitle => 'Online gehen, um Bestellungen zu erhalten';

  @override
  String get tourGoOnlineDesc =>
      'Schalten Sie diesen Schalter um, wenn Sie bereit sind, Lieferungen anzunehmen. Sie können jederzeit offline gehen.';

  @override
  String get tourDailyStatsTitle => 'Ihre Tagesstatistiken';

  @override
  String get tourDailyStatsDesc =>
      'Verfolgen Sie hier Ihre Bestellungen, Einnahmen und Bewertungen. Die Statistiken werden in Echtzeit aktualisiert.';

  @override
  String get tourNewOrderTitle => 'Neue Bestellung eingegangen!';

  @override
  String get tourNewOrderDesc =>
      'So erscheinen neue Bestellungen. Überprüfen Sie Abholung, Zustellung, Entfernung und Bezahlung.';

  @override
  String get tourOrdersTabTitle => 'Bestellungen-Tab';

  @override
  String get tourOrdersTabDesc =>
      'Wechseln Sie zwischen aktuellen Bestellungen und dem Bestellverlauf.';

  @override
  String get tourTotalEarningsTitle => 'Ihre Gesamteinnahmen';

  @override
  String get tourTotalEarningsDesc =>
      'Verfolgen Sie hier alle Ihre Einnahmen – Grundlohn, Trinkgeld und Boni.';

  @override
  String get tourEarningsBreakdownTitle => 'Einnahmenübersicht';

  @override
  String get tourEarningsBreakdownDesc =>
      'Sehen Sie Ihre Gesamtbestellungen und die durchschnittlichen Einnahmen pro Bestellung.';

  @override
  String get tourRouteDetailsTitle => 'Routendetails';

  @override
  String get tourRouteDetailsDesc =>
      'Sehen Sie die vollständige Abhol- und Zustellroute mit Adressen, Entfernung und geschätzter Zeit.';

  @override
  String get tourYourEarningsTitle => 'Ihre Einnahmen';

  @override
  String get tourYourEarningsDesc =>
      'Sehen Sie die vollständige Aufschlüsselung – Liefergebühr, Trinkgeld und Gesamtauszahlung.';

  @override
  String get tourNavActionsTitle => 'Navigation & Aktionen';

  @override
  String get tourNavActionsDesc =>
      'Navigieren Sie zur Abholung/Zustellung oder aktualisieren Sie den Bestellstatus während der Fahrt.';

  @override
  String get tourTurnByTurnTitle => 'Schritt-für-Schritt-Navigation';

  @override
  String get tourTurnByTurnDesc =>
      'Folgen Sie den Echtzeitanweisungen zu Ihrem Abhol- oder Zustellort.';

  @override
  String get tourTripControlsTitle => 'Fahrtsteuerung';

  @override
  String get tourTripControlsDesc =>
      'Wechseln Sie zwischen Abhol- und Zustellrouten, sehen Sie Zieldetails und Einnahmen.';

  @override
  String get tourUpdateStatusTitle => 'Status aktualisieren';

  @override
  String get tourUpdateStatusDesc =>
      'Tippen Sie, um wichtige Meilensteine zu markieren – Unterwegs, Zugestellt oder Abgeschlossen.';

  @override
  String get tourAppSettingsTitle => 'App-Einstellungen';

  @override
  String get tourAppSettingsDesc =>
      'Ändern Sie Ihre Sprache, Ihr Design und greifen Sie auf die Wissensdatenbank zu.';

  @override
  String get tourKnowledgeBaseTitle => 'Wissensdatenbank';

  @override
  String get tourKnowledgeBaseDesc =>
      'Durchsuchen Sie Schritt-für-Schritt-Anleitungen, Tipps und Antworten auf häufige Fragen.';

  @override
  String get tourSkipBtn => 'Überspringen';

  @override
  String get tourBackBtn => 'Zurück';

  @override
  String get tourNextBtn => 'Weiter';

  @override
  String get tourDoneBtn => 'Fertig';

  @override
  String get tourWelcomeTitle => 'Willkommen bei TaybGo!';

  @override
  String get tourWelcomeDesc =>
      'Machen Sie eine kurze Tour, um die App kennenzulernen';

  @override
  String get tourSkipForNow => 'Erstmal überspringen';

  @override
  String get tourStartBtn => 'Tour starten';

  @override
  String get tourCompleteTitle => 'Tour abgeschlossen!';

  @override
  String get tourCompleteDesc =>
      'Sie sind bereit, Bestellungen anzunehmen und mit TaybGo zu verdienen!';

  @override
  String get tourBrowseKb => 'Wissensdatenbank durchsuchen';

  @override
  String get tourGetStarted => 'Loslegen';

  @override
  String get selectCountry => 'Land auswählen';

  @override
  String get searchCountry => 'Land suchen...';

  @override
  String get secure => 'Sicher';

  @override
  String get wellSendVerificationCode =>
      'Wir senden Ihnen einen Bestätigungscode';

  @override
  String get byConsentTerms =>
      'Mit dem Fortfahren stimmen Sie unseren AGB und Datenschutzrichtlinien zu';

  @override
  String get otpSentSuccessfully => 'Bestätigungscode erfolgreich gesendet';

  @override
  String resendIn(int seconds) {
    return 'Erneut senden in ${seconds}s';
  }

  @override
  String get resendCode => 'Code erneut senden';

  @override
  String get verify => 'Bestätigen';

  @override
  String get tellUsAboutYourself => 'Erzählen Sie uns von sich';

  @override
  String get basicInfoSubtitle =>
      'Wir benötigen einige grundlegende Informationen zur Einrichtung Ihres Fahrerkontos';

  @override
  String get enterYourFullName => 'Geben Sie Ihren vollständigen Namen ein';

  @override
  String get notAvailable => 'Nicht verfügbar';

  @override
  String get verifiedViaOtp => 'Per OTP verifiziert';

  @override
  String get selectYourVehicle => 'Wählen Sie Ihr Fahrzeug';

  @override
  String get vehicleStepSubtitle =>
      'Wählen Sie den Fahrzeugtyp, den Sie für Lieferungen verwenden';

  @override
  String get chooseYourServices => 'Wählen Sie Ihre Dienste';

  @override
  String get servicesStepSubtitle =>
      'Wählen Sie die Lieferarten, die Sie annehmen möchten';

  @override
  String get deliverFoodDesc => 'Essen von Restaurants liefern';

  @override
  String get deliverPackagesDesc => 'Pakete und Sendungen liefern';

  @override
  String get transportPassengersDesc => 'Passagiere transportieren';

  @override
  String get changeServiceLater =>
      'Sie können Ihre Dienstpräferenzen später in den Einstellungen ändern';

  @override
  String get back => 'Zurück';

  @override
  String get completeRegistration => 'Registrierung abschließen';

  @override
  String get pleaseEnterYourName => 'Bitte geben Sie Ihren Namen ein';

  @override
  String get pleaseSelectService =>
      'Bitte wählen Sie mindestens einen Diensttyp';

  @override
  String get pleaseUploadDriversLicense =>
      'Bitte laden Sie Ihren Führerschein hoch';

  @override
  String get pleaseUploadNationalId =>
      'Bitte laden Sie Ihren Personalausweis hoch';

  @override
  String pleaseUploadDocument(Object documentName) {
    return 'Bitte laden Sie $documentName hoch';
  }

  @override
  String get registrationFailed =>
      'Registrierung fehlgeschlagen. Bitte versuchen Sie es erneut.';

  @override
  String get stepPersonal => 'Persönlich';

  @override
  String get stepVehicle => 'Fahrzeug';

  @override
  String get stepServices => 'Dienste';

  @override
  String applicationStepProgress(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String applicationNextStep(String step) {
    return 'Next: $step';
  }

  @override
  String get ecoFriendlyOption => 'Umweltfreundliche Option';

  @override
  String get fastAndAgile => 'Schnell und wendig';

  @override
  String get mostVersatile => 'Am vielseitigsten';

  @override
  String get largeDeliveries => 'Große Lieferungen';

  @override
  String get deleteDataWarning =>
      'Dadurch werden alle Ihre Daten dauerhaft gelöscht, einschließlich Profil, Bewertungen und Bestellverlauf.';

  @override
  String get finalConfirmation => 'Letzte Bestätigung';

  @override
  String get finalDeleteWarning =>
      'Sind Sie absolut sicher? Diese Aktion ist unwiderruflich und Sie verlieren alle Ihre Daten.';

  @override
  String get deleteMyAccount => 'Mein Konto löschen';

  @override
  String get deletingAccount => 'Konto wird gelöscht...';

  @override
  String get accountDeletedSuccessfully => 'Konto erfolgreich gelöscht';

  @override
  String failedToDeleteAccount(String error) {
    return 'Konto konnte nicht gelöscht werden: $error';
  }

  @override
  String get justNow => 'Gerade eben';

  @override
  String minutesAgo(int minutes) {
    return 'vor $minutes Min.';
  }

  @override
  String hoursAgo(int hours) {
    return 'vor $hours Std.';
  }

  @override
  String daysAgo(int days) {
    return 'vor $days Tagen';
  }

  @override
  String get clearAllNotificationsConfirm =>
      'Sind Sie sicher, dass Sie alle Benachrichtigungen löschen möchten?';

  @override
  String get failedToLoadNotifications =>
      'Benachrichtigungen konnten nicht geladen werden';

  @override
  String get calculatingRoute => 'Route wird berechnet...';

  @override
  String get orderNotFound => 'Bestellung nicht gefunden';

  @override
  String get goBack => 'Zurück';

  @override
  String get gpsUnavailableTapRetry =>
      'GPS nicht verfügbar. Tippen zum Wiederholen.';

  @override
  String get googleMaps => 'Google Maps';

  @override
  String get fetchingLocation => 'Standort wird ermittelt...';

  @override
  String secondsAgo(int seconds) {
    return 'vor ${seconds}s';
  }

  @override
  String get subtotal => 'Zwischensumme';

  @override
  String get orderType => 'Typ';

  @override
  String get created => 'Erstellt';

  @override
  String get accepted => 'Angenommen';

  @override
  String get completed => 'Abgeschlossen';

  @override
  String get orderPaid => 'Bezahlt';

  @override
  String get orderPaidDescription => 'Kein Bargeld einzuziehen';

  @override
  String get collectCash => 'Bargeld kassieren';

  @override
  String get collectCashReminder =>
      'Vergessen Sie nicht, die Zahlung vom Kunden einzuziehen';

  @override
  String collectCashAmountReminder(String amount) {
    return 'Collect $amount from the customer before completing.';
  }

  @override
  String get locationPermissionLostWhileOnline =>
      'Standortzugriff ist deaktiviert. Sie erhalten keine Bestellungen, bis er aktiviert ist.';

  @override
  String get batteryOptimizationTitle => 'Akkuoptimierung deaktivieren';

  @override
  String get batteryOptimizationMessage =>
      'Damit der Live-Standort im Hintergrund aktiv bleibt, stellen Sie TaybGo Driver in den Android-Einstellungen auf uneingeschränkte Akkunutzung.';

  @override
  String get batteryOptimizationBannerMessage =>
      'Die Akkuoptimierung kann den Live-Standort pausieren, wenn Sie online sind. Stellen Sie TaybGo Driver auf uneingeschränkte Akkunutzung.';

  @override
  String get profileUpdatedSuccessfully => 'Profil erfolgreich aktualisiert';

  @override
  String get failedToUpdateProfile => 'Profil konnte nicht aktualisiert werden';

  @override
  String get supportTickets => 'Support-Tickets';

  @override
  String get supportFilterAll => 'Alle';

  @override
  String get supportFilterOpen => 'Offen';

  @override
  String get supportFilterInProgress => 'In Bearbeitung';

  @override
  String get supportFilterClosed => 'Geschlossen';

  @override
  String get supportStatusOpen => 'Offen';

  @override
  String get supportStatusInProgress => 'In Bearbeitung';

  @override
  String get supportStatusClosed => 'Geschlossen';

  @override
  String get supportPriorityLow => 'Niedrig';

  @override
  String get supportPriorityMedium => 'Mittel';

  @override
  String get supportPriorityHigh => 'Hoch';

  @override
  String get supportNoTickets => 'Noch keine Tickets';

  @override
  String get supportNoTicketsDesc =>
      'Erstellen Sie ein Ticket, wenn Sie Hilfe benötigen';

  @override
  String get supportCreateTicket => 'Ticket erstellen';

  @override
  String get supportTicketCreated => 'Ticket erfolgreich erstellt';

  @override
  String get supportRelatedOrder => 'Zugehörige Bestellung';

  @override
  String get supportSubject => 'Betreff';

  @override
  String get supportSubjectHint => 'Kurze Beschreibung Ihres Problems';

  @override
  String get supportSubjectRequired => 'Betreff ist erforderlich';

  @override
  String get supportMessage => 'Nachricht';

  @override
  String get supportMessageHint => 'Beschreiben Sie Ihr Problem im Detail...';

  @override
  String get supportMessageRequired => 'Nachricht ist erforderlich';

  @override
  String get supportSubmitTicket => 'Ticket absenden';

  @override
  String get supportSelectOrder => 'Bestellung auswählen (optional)';

  @override
  String get supportNoOrder => 'Keine bestimmte Bestellung';

  @override
  String get supportTicketDetail => 'Ticket-Details';

  @override
  String get supportNoMessages => 'Noch keine Nachrichten';

  @override
  String get supportTypeMessage => 'Nachricht eingeben...';

  @override
  String get supportTicketClosed => 'Dieses Ticket ist geschlossen';

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
  String get file => 'Datei';

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
  String get changelog => 'Änderungsprotokoll';

  @override
  String get changelogTitle => 'Was ist neu?';

  @override
  String get changelogSubtitle =>
      'Ein kurzer Überblick über die neuesten Verbesserungen in TaybGo Driver.';

  @override
  String get changelogCurrent => 'Aktuell';

  @override
  String get changelogBuild => 'Build';

  @override
  String get changelogReleased => 'Veröffentlicht';

  @override
  String get changelogReleaseNotes => 'Versionshinweise';

  @override
  String get changelogHighlights => 'Highlights';

  @override
  String get changelogFixes => 'Fehlerbehebungen';

  @override
  String get changelogImprovements => 'Verbesserungen';

  @override
  String get changelogStability => 'Stabilität';

  @override
  String get changelogPlatform => 'Plattform';

  @override
  String get changelogRelease => 'Veröffentlichung';

  @override
  String get changelogDateAug24 => '24 August 2026';

  @override
  String get changelogVersion101517Authentication =>
      'Driver sign-in now follows the live backend policy and automatically uses password or OTP authentication when enabled for the driver role.';

  @override
  String get changelogVersion101517Password =>
      'Added secure password sign-in for driver accounts while keeping role-aware OTP support available for configured deployments.';

  @override
  String get changelogVersion101517Updates =>
      'Added a required-update screen so unsupported app versions can be directed to the correct update without entering the app.';

  @override
  String get changelogVersion101517Legal =>
      'Terms of Service and Privacy Policy links now come from the public application configuration and can be updated without a new app release.';

  @override
  String get changelogVersion101517Reliability =>
      'Improved anonymous authentication error handling, configuration fallback behavior, startup timeouts, validation feedback, and small-screen login layout.';

  @override
  String get changelogVersion101517Release =>
      'Released TaybGo Driver version 1.0.15+17.';

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
  String get changelogDateAug9 => '9. August 2026';

  @override
  String get changelogDateAug11 => '11. August 2026';

  @override
  String get changelogVersion1013Address =>
      'Optionale strukturierte Fahreradressen mit Koordinaten und vollständigen Adressdetails wurden bei Registrierung und Profilbearbeitung hinzugefügt.';

  @override
  String get changelogVersion1013Status =>
      'Adressänderungen allein verwenden jetzt partielle PATCH-Anfragen und erhalten den Status eines genehmigten Fahrers.';

  @override
  String get changelogVersion1013Release =>
      'Fahrer-App Version 1.0.13+15 veröffentlicht.';

  @override
  String get changelogDateMay31 => '31. Mai 2026';

  @override
  String get changelogDateMay24 => '24. Mai 2026';

  @override
  String get changelogDateMay13 => '13. Mai 2026';

  @override
  String get changelogDateMay11 => '11. Mai 2026';

  @override
  String get changelogCurrentTaxi =>
      'Die Auswahl des Taxidienstes wurde auf Autofahrer beschränkt; Fahrradfahrer können ihn bei Registrierung und Profilbearbeitung nicht mehr aktivieren.';

  @override
  String get changelogVersion1113Upload =>
      'Der Speicherverbrauch bei Web-Uploads wurde reduziert, damit Dokumentuploads auf leistungsschwächeren Geräten zuverlässiger funktionieren.';

  @override
  String get changelogCurrentChangelog =>
      'Ein lokalisiertes, aufklappbares Änderungsprotokoll mit Versionshistorie, Buildnummern, Daten und Versionshinweisen wurde zum Profil hinzugefügt.';

  @override
  String get changelogVersion1113Version =>
      'App-Version und Veröffentlichungsdatum werden jetzt auf dem Anmeldebildschirm und im Web-Startbildschirm angezeigt.';

  @override
  String get changelogCurrentRelease =>
      'Die App wurde auf Version 1.0.12+14 mit den neuesten Verbesserungen der Fahrer-App aktualisiert.';

  @override
  String get changelogVersion1113Release =>
      'Der Play-Store-Build wurde auf Version 1.0.11+13 (Versionscode 13) aktualisiert.';

  @override
  String get changelogVersion1112Release =>
      'Die Fahrer-App wurde in Version 1.0.11+12 veröffentlicht und ihre Veröffentlichungsmetadaten wurden hinterlegt.';

  @override
  String get changelogVersion1011Documents =>
      'Eine Prüfung der erforderlichen Dokumente für Autofahrer wurde hinzugefügt.';

  @override
  String get changelogVersion1011Uploads =>
      'Erforderliche Dokumente werden deutlicher markiert und der Upload-Status wurde verbessert.';

  @override
  String get changelogVersion1011Feedback =>
      'Validierung und Fehlermeldungen beim Speichern von Profiländerungen wurden verbessert.';

  @override
  String get changelogVersion1011Release =>
      'Die Fahrer-App wurde in Version 1.0.10+11 veröffentlicht.';

  @override
  String get changelogVersion0910Crashlytics =>
      'Crashlytics-Berichte für schwerwiegende Fehler in Release-Builds wurden hinzugefügt.';

  @override
  String get changelogVersion0910Notifications =>
      'Benachrichtigungsabläufe, Duplikaterkennung und die Verarbeitung von Bestellbenachrichtigungen wurden verbessert.';

  @override
  String get changelogVersion0910Platform =>
      'Die Release-Konfiguration für Android, iOS, macOS und Web wurde mit Entwicklungs- und Produktions-Flavors aktualisiert.';

  @override
  String get changelogVersion0910Release =>
      'Die Fahrer-App wurde in Version 1.0.9+10 veröffentlicht.';
}

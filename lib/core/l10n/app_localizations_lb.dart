// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Luxembourgish Letzeburgesch (`lb`).
class AppLocalizationsLb extends AppLocalizations {
  AppLocalizationsLb([String locale = 'lb']) : super(locale);

  @override
  String get appName => 'TaybGo Chauffeur';

  @override
  String get welcome => 'Wëllkomm';

  @override
  String get getStarted => 'Ufänken';

  @override
  String get next => 'Weider';

  @override
  String get skip => 'Iwwersprangen';

  @override
  String get done => 'Fäerdeg';

  @override
  String get cancel => 'Ofbriechen';

  @override
  String get confirm => 'Bestätegen';

  @override
  String get save => 'Späicheren';

  @override
  String get edit => 'Änneren';

  @override
  String get delete => 'Läschen';

  @override
  String get retry => 'Nach eng Kéier';

  @override
  String get loading => 'Lueden...';

  @override
  String get error => 'Feeler';

  @override
  String get success => 'Erfolleg';

  @override
  String get seeAll => 'Alles gesinn';

  @override
  String get or => 'ODER';

  @override
  String get onboardingTitle1 => 'Fänkt haut un ze verdéngen';

  @override
  String get onboardingDesc1 =>
      'Schléisst Iech Dausende vu Chauffeure un, déi no hirem eegene Zäitplang verdéngen';

  @override
  String get onboardingTitle2 => 'Acceptéiert Bestellunge ganz einfach';

  @override
  String get onboardingDesc2 =>
      'Kritt Notifikatiounen iwwer nei Bestellungen an acceptéiert mat engem Tipp';

  @override
  String get onboardingTitle3 => 'Navigéiert & Liwwert';

  @override
  String get onboardingDesc3 =>
      'Déi integréiert Navigatioun hëlleft Iech, Destinatiounen méi séier z\'erreechen';

  @override
  String get phoneNumber => 'Telefonsnummer';

  @override
  String get enterPhoneNumber => 'Gitt Är Telefonsnummer an';

  @override
  String get phoneHint => '+352 123 456 789';

  @override
  String get sendOtp => 'Code schécken';

  @override
  String get verifyOtp => 'Code bestätegen';

  @override
  String get enterOtp => 'Gitt de Code an, dee mir geschéckt hunn un';

  @override
  String get resendOtp => 'Code nach eng Kéier schécken';

  @override
  String resendOtpIn(int seconds) {
    return 'Code nach eng Kéier schécken an ${seconds}s';
  }

  @override
  String get invalidOtp => 'Ongëltege Verifizéierungscode';

  @override
  String get otpSent => 'Verifizéierungscode geschéckt';

  @override
  String get errorsAuthPhoneAlreadyRegistered =>
      'Dës Nummer ass schonn registréiert.';

  @override
  String get email => 'E-Mail';

  @override
  String get enterEmail => 'Gitt Är E-Mail an';

  @override
  String get signUpWithApple => 'Mat Apple umellen';

  @override
  String get signUpWithGoogle => 'Mat Google umellen';

  @override
  String get forgotPassword => 'Passwuert vergiess';

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
  String get driverApplication => 'Chauffeur Demande';

  @override
  String get personalInfo => 'Perséinlech Informatiounen';

  @override
  String get vehicleInfo => 'Gefierfsinformatiounen';

  @override
  String get documents => 'Dokumenter';

  @override
  String get otherDocuments => 'Other Documents';

  @override
  String get reviewSubmit => 'Iwwerpréiwen & Aschécken';

  @override
  String get fullName => 'Vollstännegen Numm';

  @override
  String get age => 'Gebuertsdatum';

  @override
  String get dateOfBirth => 'Gebuertsdatum';

  @override
  String get address => 'Adress';

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
  String get vehicleType => 'Gefierfstyp';

  @override
  String get selectVehicleType => 'Gefierfstyp auswielen';

  @override
  String get car => 'Auto';

  @override
  String get van => 'Camionnette';

  @override
  String get motorcycle => 'Motorrad';

  @override
  String get bicycle => 'Vëlo';

  @override
  String get scooter => 'Roller';

  @override
  String get licensePlate => 'Nummerschëld';

  @override
  String get vehicleModel => 'Gefierfsmodell';

  @override
  String get vehicleYear => 'Gefierfsjor';

  @override
  String get vehicleColor => 'Gefierfsfaarf';

  @override
  String get serviceType => 'Serviceart';

  @override
  String get selectServiceType => 'Wéi eng Servicer bitt Dir un?';

  @override
  String get foodDelivery => 'Iessensliwwerung';

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
  String get uploadDocuments => 'Dokumenter eroplueden';

  @override
  String get driversLicense => 'Führerschäin';

  @override
  String get nationalId => 'Identitéitskaart';

  @override
  String get healthInsuranceDocument => 'Health Insurance Document';

  @override
  String get addressDocument => 'Address Document';

  @override
  String get bankDocument => 'Bank Document';

  @override
  String get vehicleRegistration => 'Gefierfsschäin';

  @override
  String get insurance => 'Versécherung';

  @override
  String get profilePhoto => 'Profilfoto';

  @override
  String get uploadPhoto => 'Foto eroplueden';

  @override
  String get takePhoto => 'Foto maachen';

  @override
  String get chooseFromGallery => 'Aus der Galerie wielen';

  @override
  String get submitApplication => 'Demande aschécken';

  @override
  String get applicationSubmitted => 'Demande ageschéckt';

  @override
  String get applicationPending => 'Är Demande gëtt iwwerpréift';

  @override
  String get applicationApproved => 'Demande ugeholl';

  @override
  String get applicationRejected => 'Demande ofgeleent';

  @override
  String get pendingApprovalMessage =>
      'Mir iwwerpréifen Är Dokumenter. Dat dauert normalerweis 24-48 Stonnen.';

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
  String get home => 'Heemsigg';

  @override
  String get orders => 'Bestellungen';

  @override
  String get recentOrders => 'Rezent Bestellungen';

  @override
  String get earnings => 'Verdéngschter';

  @override
  String get profile => 'Profil';

  @override
  String get search => 'Sichen';

  @override
  String get online => 'Online';

  @override
  String get offline => 'Offline';

  @override
  String get goOnline => 'Online goen';

  @override
  String get goOffline => 'Offline goen';

  @override
  String get tapToGoOnline => 'Tippt fir online ze goen';

  @override
  String get tapToGoOffline => 'Tippt fir offline ze goen';

  @override
  String get youAreOnline =>
      'Dir sidd online a prett fir Bestellungen ze kréien';

  @override
  String get youAreOffline =>
      'Dir sidd offline. Gitt online fir Bestellungen ze kréien';

  @override
  String get newOrder => 'Nei Bestellung';

  @override
  String get newOrderTitle => 'Nei Bestellung!';

  @override
  String get newOrderSubtitle => 'Acceptéiert ier d\'Zäit ofleeft';

  @override
  String get orderDetails => 'Bestellungsdetailer';

  @override
  String get navigate => 'Navigéieren';

  @override
  String get details => 'Detailer';

  @override
  String get acceptOrder => 'Bestellung acceptéieren';

  @override
  String get rejectOrder => 'Bestellung oflehnen';

  @override
  String get accept => 'Acceptéieren';

  @override
  String get reject => 'Oflehnen';

  @override
  String acceptIn(int seconds) {
    return 'Acceptéieren an ${seconds}s';
  }

  @override
  String get orderAccepted => 'Bestellung acceptéiert';

  @override
  String get items => 'Artikelen';

  @override
  String get time => 'Zäit';

  @override
  String get orderRejected => 'Bestellung ofgeleent';

  @override
  String get orderCompleted => 'Bestellung ofgeschloss';

  @override
  String get orderCancelled => 'Bestellung annuléiert';

  @override
  String get pending => 'Am Waarden';

  @override
  String get searchingForDriver => 'Chauffeur gëtt gesicht';

  @override
  String get driverNotificationSent => 'Chauffeur-Notifikatioun geschéckt';

  @override
  String get rejected => 'Ofgeleent';

  @override
  String get cancelled => 'Annuléiert';

  @override
  String get delivered => 'Geliwwert';

  @override
  String get expired => 'Expired';

  @override
  String get restaurantDelivered => 'Restaurant delivered';

  @override
  String get pickup => 'Ofhuelen';

  @override
  String get dropoff => 'Liwwerung';

  @override
  String get pickupLocation => 'Ofhuelplaz';

  @override
  String get dropoffLocation => 'Liwwerplaz';

  @override
  String get route => 'Route';

  @override
  String get inProgress => 'Am Gaang';

  @override
  String get headingToPickup => 'Op Wee zum Ofhuelplaz';

  @override
  String get headingToDropoff => 'Op Wee zum Liwwerplaz';

  @override
  String get atPickupLocation => 'Um Ofhuelplaz';

  @override
  String get atDropoffLocation => 'Um Liwwerplaz';

  @override
  String get orderId => 'Bestellungs-ID';

  @override
  String get customer => 'Client';

  @override
  String get itemsOrdered => 'Artikelen';

  @override
  String get callCustomer => 'Client uruffen';

  @override
  String get distance => 'Distanz';

  @override
  String get estimatedTime => 'Geschat Zäit';

  @override
  String get yourDistanceTo => 'Är Distanz bis';

  @override
  String get km => 'km';

  @override
  String get min => 'Min';

  @override
  String get startNavigation => 'Navigatioun starten';

  @override
  String get arrivedAtPickup => 'Um Ofhuelplaz ukomm';

  @override
  String get startDelivery => 'Liwwerung starten';

  @override
  String get arrivedAtDropoff => 'Um Liwwerplaz ukomm';

  @override
  String get completeOrder => 'Bestellung ofschléissen';

  @override
  String get markAsDelivered => 'Als geliwwert markéieren';

  @override
  String get acceptOrderConfirmation =>
      'Sidd Dir sécher, datt Dir dës Bestellung acceptéiere wëllt?';

  @override
  String get rejectOrderConfirmation =>
      'Sidd Dir sécher, datt Dir dës Bestellung oflehne wëllt?';

  @override
  String get startDeliveryConfirmation =>
      'Bestätegt, datt Dir d\'Bestellung ofgeholl hutt an d\'Liwwerung ufänkt?';

  @override
  String get arrivedAtDropoffConfirmation =>
      'Bestätegt, datt Dir um Liwwerplaz ukomm sidd?';

  @override
  String get completeOrderConfirmation =>
      'Bestätegt, datt Dir dës Liwwerung ofgeschloss hutt?';

  @override
  String get updatingStatus => 'Status gëtt aktualiséiert...';

  @override
  String get tip => 'Drénkgeld';

  @override
  String get earnings_label => 'Verdéngschter';

  @override
  String get deliveryFee => 'Liwwergebühr';

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
  String get total => 'Total';

  @override
  String get currentOrders => 'Aktuell Bestellungen';

  @override
  String get orderHistory => 'Bestellungsverlaf';

  @override
  String get noOrdersYet => 'Nach keng Bestellungen';

  @override
  String get noActiveOrders => 'Keng aktiv Bestellungen';

  @override
  String get waitingForOrders => 'Waarden op nei Bestellungen...';

  @override
  String get totalOrders => 'Total Bestellungen';

  @override
  String get totalEarnings => 'Total Verdéngschter';

  @override
  String get avgTripTime => 'Duerchschn. Fuerzäit';

  @override
  String get completionRate => 'Ofschlossrat';

  @override
  String get rating => 'Bewäertung';

  @override
  String get todayEarnings => 'Verdéngschter haut';

  @override
  String get weeklyEarnings => 'Wëchentlech Verdéngschter';

  @override
  String get monthlyEarnings => 'Méintlech Verdéngschter';

  @override
  String get lastMonthEarnings => 'Verdéngschter leschte Mount';

  @override
  String get viewPayslips => 'Gehaltsabrechnunge gesinn';

  @override
  String get payslipsSentEmail =>
      'Gehaltsabrechnunge ginn per E-Mail geschéckt';

  @override
  String get settings => 'Astellungen';

  @override
  String get language => 'Sprooch';

  @override
  String get english => 'Englesch';

  @override
  String get german => 'Däitsch';

  @override
  String get french => 'Franséisch';

  @override
  String get arabic => 'Arabesch';

  @override
  String get luxembourgish => 'Lëtzebuergesch';

  @override
  String get italian => 'Italieenesch';

  @override
  String get dutch => 'Hollännesch';

  @override
  String get swedish => 'Schwedesch';

  @override
  String get norwegian => 'Norwegesch';

  @override
  String get danish => 'Dänesch';

  @override
  String get finnish => 'Finnesch';

  @override
  String get theme => 'Design';

  @override
  String get lightMode => 'Hell Modus';

  @override
  String get darkMode => 'Donkel Modus';

  @override
  String get systemDefault => 'System Standard';

  @override
  String get notifications => 'Notifikatiounen';

  @override
  String get orderNotifications => 'Bestellungsnotifikatiounen';

  @override
  String get promotionalNotifications => 'Promotiounsnotifikatiounen';

  @override
  String get soundEnabled => 'Toun aktivéiert';

  @override
  String get vibrationEnabled => 'Vibratioun aktivéiert';

  @override
  String get notificationSoundRepeats =>
      'Widderhuelunge vum Notifikatiounstoun';

  @override
  String notificationSoundRepeatsEnabledDesc(int count) {
    return 'Spillt de Signaltoun $count Mol fir all Notifikatioun.';
  }

  @override
  String get notificationSoundRepeatsDisabledDesc =>
      'Aktiv?iert fir d??ischt den Toun, fir ze wielen, w?i dacks de Signal widderholl g?tt.';

  @override
  String get notificationSoundRepeatsPickerDesc =>
      'Wielt, w?i dacks de Signaltoun fir all Notifikatioun widderholl soll ginn.';

  @override
  String get notificationRepeatTime => '1 Mol';

  @override
  String notificationRepeatTimes(int count) {
    return '$count Mol';
  }

  @override
  String get noNotifications => 'Nach keng Notifikatiounen';

  @override
  String get noNotificationsDesc => 'Är Notifikatiounen erschéngen hei';

  @override
  String get today => 'Haut';

  @override
  String get yesterday => 'Gëschter';

  @override
  String get earlier => 'Virdrun';

  @override
  String get markAllRead => 'Alles als gelies markéieren';

  @override
  String get clearAll => 'Alles läschen';

  @override
  String get newOrderReceived => 'Nei Bestellung kritt';

  @override
  String get orderAcceptedNotif => 'Bestellung erfollegräich acceptéiert';

  @override
  String get orderDeliveredNotif => 'Bestellung erfollegräich geliwwert';

  @override
  String get earningsReceived => 'Verdéngschter kritt';

  @override
  String get weeklyReportReady => 'Wëchentleche Rapport ass fäerdeg';

  @override
  String get accountUpdated => 'Kont aktualiséiert';

  @override
  String get account => 'Kont';

  @override
  String get editProfile => 'Profil änneren';

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
  String get changePassword => 'Passwuert änneren';

  @override
  String get privacyPolicy => 'Dateschutzpolitik';

  @override
  String get termsOfService => 'Notzungsbedingungen';

  @override
  String get helpSupport => 'Hëllef & Support';

  @override
  String get contactUs => 'Kontaktéiert eis';

  @override
  String get logout => 'Ausloggen';

  @override
  String get logoutConfirm => 'Sidd Dir sécher, datt Dir Iech auslogge wëllt?';

  @override
  String get deleteAccount => 'Kont läschen';

  @override
  String get deleteAccountConfirm =>
      'Sidd Dir sécher, datt Dir Äre Kont läsche wëllt? Dës Aktioun kann net réckgängeg gemaach ginn.';

  @override
  String get networkError =>
      'Netzwierkfeeler. Iwwerpréift w.e.g. Är Verbindung.';

  @override
  String get somethingWentWrong =>
      'Eppes ass schif gaangen. Probéiert w.e.g. nach eng Kéier.';

  @override
  String get sessionExpired =>
      'Sessioun ofgelaf. Loggt Iech w.e.g. nach eng Kéier an.';

  @override
  String get locationPermissionDenied => 'Standuerterlaubnis verweigert';

  @override
  String get enableLocationServices =>
      'Aktivéiert w.e.g. d\'Standuertservicer fir weiderzemaachen';

  @override
  String version(String version) {
    return 'Versioun $version';
  }

  @override
  String get goodMorning => 'Gudde Moien';

  @override
  String get goodAfternoon => 'Gudden Dag';

  @override
  String get goodEvening => 'Gudden Owend';

  @override
  String get locationRequired => 'Standuert erfuerderlech';

  @override
  String get enableLocationAccess =>
      'Aktivéiert den Zougang zum Standuert fir Bestellungen ze kréien.';

  @override
  String get enable => 'Aktivéieren';

  @override
  String get pleaseEnableLocationInSettings =>
      'Aktivéiert w.e.g. de Standuert an den Astellungen.';

  @override
  String get backgroundLocationTitle => 'Standuert am Hannergrond erlaben';

  @override
  String get backgroundLocationMessage =>
      'Fir datt TaybGo Äre Standuert och am Hannergrond ka schécken, maacht w.e.g. d\'Astellungen op a wielt „Ëmmer erlaben“.';

  @override
  String get gpsDisabled => 'GPS desaktivéiert';

  @override
  String get pleaseEnableGps =>
      'Aktivéiert w.e.g. GPS fir Bestellungen ze kréien.';

  @override
  String get failedToUpdateStatus => 'Status konnt net aktualiséiert ginn';

  @override
  String get ok => 'OK';

  @override
  String get accountUnderReview => 'Kont gëtt iwwerpréift';

  @override
  String get accountBeingVerified =>
      'Äre Kont gëtt verifizéiert. Dir gitt benoriichtegt wann en ugeholl gëtt.';

  @override
  String get receivingOrders => 'Bestellunge kréien';

  @override
  String get goOnlineToStart => 'Online goen fir unzefänken';

  @override
  String get noRecentOrders => 'Keng rezent Bestellungen';

  @override
  String get headToPickup => 'Op zum Ofhuelen';

  @override
  String get onTheWay => 'Ënnerwee';

  @override
  String get atDelivery => 'Bei der Liwwerung';

  @override
  String get continueText => 'Weiderfueren';

  @override
  String get week => 'Woch';

  @override
  String get month => 'Mount';

  @override
  String get avgPerOrder => 'Duerchschn./Bestellung';

  @override
  String get allTime => 'Gesamt';

  @override
  String get noEarningsData => 'Keng Verdéngschter-Daten';

  @override
  String get completeOrdersToSeeEarnings =>
      'Schléisst Bestellungen of fir Är Verdéngschter ze gesinn';

  @override
  String get verified => 'Verifizéiert';

  @override
  String get approved => 'Ugeholl';

  @override
  String joinedOn(Object date) {
    return 'Dobäi zanter $date';
  }

  @override
  String get driver => 'Chauffeur';

  @override
  String get knowledgeBase => 'Wëssensdatenbank';

  @override
  String get searchForHelp => 'No Hëllef sichen...';

  @override
  String get noArticlesFound => 'Keng Artikele fonnt';

  @override
  String get tryDifferentSearch => 'Probéiert en anere Sichbegrëff';

  @override
  String get noCategoriesAvailable => 'Keng Kategorien disponibel';

  @override
  String articlesCount(int count) {
    return '$count Artikelen';
  }

  @override
  String get articleNotFound => 'Artikel net fonnt';

  @override
  String get wasArticleHelpful => 'War dësen Artikel hëllefräich?';

  @override
  String get thankYouFeedback => 'Merci fir Äre Feedback!';

  @override
  String get willImproveArticle =>
      'Mir schaffen drun, dësen Artikel ze verbesseren.';

  @override
  String get relatedArticles => 'Verwandte Artikelen';

  @override
  String get kbTip => 'Tipp';

  @override
  String get kbWarning => 'Warnung';

  @override
  String get yes => 'Jo';

  @override
  String get no => 'Nee';

  @override
  String get article => 'Artikel';

  @override
  String get browseKnowledgeBase => 'Wëssensdatenbank duerchsichen';

  @override
  String sectionsCount(int count) {
    return '$count Sektiounen';
  }

  @override
  String minRead(int count) {
    return '$count Min. Liesezäit';
  }

  @override
  String get tourAccountUnderReviewTitle => 'Kont gëtt iwwerpréift';

  @override
  String get tourAccountUnderReviewDesc =>
      'Äre Kont gëtt verifizéiert. Dir kënnt d\'App entdecken während Dir op d\'Zoustëmmung waart.';

  @override
  String get tourGoOnlineTitle => 'Online goen fir Bestellungen ze kréien';

  @override
  String get tourGoOnlineDesc =>
      'Schalt dëse Schalter ëm wann Dir prett sidd fir Liwwerungen unzehuelen. Dir kënnt zu all Moment offline goen.';

  @override
  String get tourDailyStatsTitle => 'Är deeglech Statistiken';

  @override
  String get tourDailyStatsDesc =>
      'Verfollegt Är Bestellungen, Verdéngschter a Bewäertung hei. Statistiken aktualiséiere sech an Echtzäit.';

  @override
  String get tourNewOrderTitle => 'Nei Bestellung kritt!';

  @override
  String get tourNewOrderDesc =>
      'Esou gesinn nei Bestellungen aus. Iwwerpréift d\'Ofhuelen, d\'Liwwerung, d\'Distanz an d\'Bezuelen.';

  @override
  String get tourOrdersTabTitle => 'Bestellungen Tab';

  @override
  String get tourOrdersTabDesc =>
      'Wiesselt tëscht aktuelle Bestellungen an dem Bestellungsverlaf.';

  @override
  String get tourTotalEarningsTitle => 'Är total Verdéngschter';

  @override
  String get tourTotalEarningsDesc =>
      'Verfollegt hei all Är Verdéngschter – Grondloun, Drénkgelder a Bonussen.';

  @override
  String get tourEarningsBreakdownTitle => 'Verdéngschter Iwwersiicht';

  @override
  String get tourEarningsBreakdownDesc =>
      'Gesitt Är total Bestellungen an duerchschnëttlech Verdéngschter pro Bestellung.';

  @override
  String get tourRouteDetailsTitle => 'Route Detailer';

  @override
  String get tourRouteDetailsDesc =>
      'Gesitt déi komplett Ofhuel- a Liwwerroute mat Adressen, Distanz an geschater Zäit.';

  @override
  String get tourYourEarningsTitle => 'Är Verdéngschter';

  @override
  String get tourYourEarningsDesc =>
      'Gesitt déi komplett Opschlësselung – Liwwergebühr, Drénkgeld an Total.';

  @override
  String get tourNavActionsTitle => 'Navigatioun & Aktiounen';

  @override
  String get tourNavActionsDesc =>
      'Navigéiert zum Ofhuel-/Liwwerplaz oder aktualiséiert de Bestellungsstatus während Dir ënnerwee sidd.';

  @override
  String get tourTurnByTurnTitle => 'Schrëtt-fir-Schrëtt Navigatioun';

  @override
  String get tourTurnByTurnDesc =>
      'Follegt den Echtzäit-Uweisungen zu Ärem Ofhuel- oder Liwwerplaz.';

  @override
  String get tourTripControlsTitle => 'Fuertsteierung';

  @override
  String get tourTripControlsDesc =>
      'Wiesselt tëscht Ofhuel- a Liwwerrouten, gesitt Destinatiounsdetailer a Verdéngschter.';

  @override
  String get tourUpdateStatusTitle => 'Status aktualiséieren';

  @override
  String get tourUpdateStatusDesc =>
      'Tippt fir wichteg Etappen ze markéieren – Ënnerwee, Geliwwert oder Ofgeschloss.';

  @override
  String get tourAppSettingsTitle => 'App Astellungen';

  @override
  String get tourAppSettingsDesc =>
      'Ännert Är Sprooch, Design an Zougang zur Wëssensdatenbank fir Hëllef.';

  @override
  String get tourKnowledgeBaseTitle => 'Wëssensdatenbank';

  @override
  String get tourKnowledgeBaseDesc =>
      'Duerchsicht Schrëtt-fir-Schrëtt Guiden, Tipps an Äntwerten op heefeg Froen.';

  @override
  String get tourSkipBtn => 'Iwwersprangen';

  @override
  String get tourBackBtn => 'Zréck';

  @override
  String get tourNextBtn => 'Weider';

  @override
  String get tourDoneBtn => 'Fäerdeg';

  @override
  String get tourWelcomeTitle => 'Wëllkomm bei TaybGo!';

  @override
  String get tourWelcomeDesc =>
      'Maacht eng kuerz Tour fir ze léieren wéi Dir d\'App benotzt';

  @override
  String get tourSkipForNow => 'Fir de Moment iwwersprangen';

  @override
  String get tourStartBtn => 'Tour ufänken';

  @override
  String get tourCompleteTitle => 'Tour ofgeschloss!';

  @override
  String get tourCompleteDesc =>
      'Dir sidd prett fir Bestellungen unzehuelen a mat TaybGo ze verdéngen!';

  @override
  String get tourBrowseKb => 'Wëssensdatenbank duerchsichen';

  @override
  String get tourGetStarted => 'Ufänken';

  @override
  String get selectCountry => 'Land auswielen';

  @override
  String get searchCountry => 'Land sichen...';

  @override
  String get secure => 'Sécher';

  @override
  String get wellSendVerificationCode =>
      'Mir schécken Iech e Verifizéierungscode';

  @override
  String get byConsentTerms =>
      'Andeems Dir weiderfuert, stëmmt Dir eise Bedingungen a Dateschutzpolitik zou';

  @override
  String get otpSentSuccessfully =>
      'Verifizéierungscode erfollegräich geschéckt';

  @override
  String resendIn(int seconds) {
    return 'Erëm schécken an ${seconds}s';
  }

  @override
  String get resendCode => 'Code erëm schécken';

  @override
  String get verify => 'Verifizéieren';

  @override
  String get tellUsAboutYourself => 'Erzielt eis iwwer Iech';

  @override
  String get basicInfoSubtitle =>
      'Mir brauchen e puer Basisinformatiounen fir Äre Chauffeurskont anzeriichten';

  @override
  String get enterYourFullName => 'Gitt Äre vollstännegen Numm an';

  @override
  String get notAvailable => 'Net disponibel';

  @override
  String get verifiedViaOtp => 'Per OTP verifizéiert';

  @override
  String get selectYourVehicle => 'Wielt Äre Gefier';

  @override
  String get vehicleStepSubtitle =>
      'Wielt de Gefierfstyp, dee Dir fir Liwwerunge benotzt';

  @override
  String get chooseYourServices => 'Wielt Är Servicer';

  @override
  String get servicesStepSubtitle =>
      'Wielt d\'Liwwerungsaarten, déi Dir acceptéiere wëllt';

  @override
  String get deliverFoodDesc => 'Iessen vu Restaurante liwweren';

  @override
  String get deliverPackagesDesc => 'Paketen a Sendungen liwweren';

  @override
  String get transportPassengersDesc => 'Passagéier transportéieren';

  @override
  String get changeServiceLater =>
      'Dir kënnt Är Servicepräferenzen méi spéit an den Astellungen änneren';

  @override
  String get back => 'Zréck';

  @override
  String get completeRegistration => 'Registréierung ofschléissen';

  @override
  String get pleaseEnterYourName => 'Gitt w.e.g. Ären Numm an';

  @override
  String get pleaseSelectService => 'Wielt w.e.g. op d\'mannst eng Serviceart';

  @override
  String get pleaseUploadDriversLicense => 'Luet w.e.g. Äre Führerschäin erop';

  @override
  String get pleaseUploadNationalId => 'Luet w.e.g. Är Identitéitskaart erop';

  @override
  String pleaseUploadDocument(Object documentName) {
    return 'Luet w.e.g. $documentName erop';
  }

  @override
  String get registrationFailed =>
      'Registréierung fehlgeschloen. Probéiert w.e.g. nach eng Kéier.';

  @override
  String get stepPersonal => 'Perséinlech';

  @override
  String get stepVehicle => 'Gefier';

  @override
  String get stepServices => 'Servicer';

  @override
  String applicationStepProgress(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String applicationNextStep(String step) {
    return 'Next: $step';
  }

  @override
  String get ecoFriendlyOption => 'Ëmweltfrëndlech Optioun';

  @override
  String get fastAndAgile => 'Séier a beweglech';

  @override
  String get mostVersatile => 'Am versatilsten';

  @override
  String get largeDeliveries => 'Grouss Liwwerungen';

  @override
  String get deleteDataWarning =>
      'Dëst läscht all Är Donnéeë permanent, dorënner Profil, Bewäertungen a Bestellungsverlaf.';

  @override
  String get finalConfirmation => 'Lescht Bestätegung';

  @override
  String get finalDeleteWarning =>
      'Sidd Dir absolut sécher? Dës Aktioun ass onëmkéierbar an Dir verléiert all Är Donnéeën.';

  @override
  String get deleteMyAccount => 'Mäi Kont läschen';

  @override
  String get deletingAccount => 'Kont gëtt geläscht...';

  @override
  String get accountDeletedSuccessfully => 'Kont erfollegräich geläscht';

  @override
  String failedToDeleteAccount(String error) {
    return 'Kont konnt net geläscht ginn: $error';
  }

  @override
  String get justNow => 'Grad elo';

  @override
  String minutesAgo(int minutes) {
    return 'viru(n) $minutes Min.';
  }

  @override
  String hoursAgo(int hours) {
    return 'viru(n) $hours St.';
  }

  @override
  String daysAgo(int days) {
    return 'viru(n) $days Deeg';
  }

  @override
  String get clearAllNotificationsConfirm =>
      'Sidd Dir sécher, datt Dir all Notifikatiounen läsche wëllt?';

  @override
  String get failedToLoadNotifications =>
      'Notifikatiounen konnten net geluede ginn';

  @override
  String get calculatingRoute => 'Route gëtt berechent...';

  @override
  String get orderNotFound => 'Bestellung net fonnt';

  @override
  String get goBack => 'Zréck';

  @override
  String get gpsUnavailableTapRetry =>
      'GPS net disponibel. Tippt fir et nach eng Kéier ze probéieren.';

  @override
  String get googleMaps => 'Google Maps';

  @override
  String get fetchingLocation => 'Standuert gëtt gesicht...';

  @override
  String secondsAgo(int seconds) {
    return 'viru(n) ${seconds}s';
  }

  @override
  String get subtotal => 'Zwëschensumm';

  @override
  String get orderType => 'Typ';

  @override
  String get created => 'Erstallt';

  @override
  String get accepted => 'Ugeholl';

  @override
  String get completed => 'Ofgeschloss';

  @override
  String get orderPaid => 'Bezuelt';

  @override
  String get orderPaidDescription => 'Kee Boergeld anzezéien';

  @override
  String get collectCash => 'Boergeld asammelen';

  @override
  String get collectCashReminder =>
      'Vergiesst net d\'Bezuelung vum Client anzezéien';

  @override
  String collectCashAmountReminder(String amount) {
    return 'Collect $amount from the customer before completing.';
  }

  @override
  String get locationPermissionLostWhileOnline =>
      'Den Zougang zum Standuert ass desaktivéiert. Dir kritt keng Bestellungen bis en ageschalt ass.';

  @override
  String get batteryOptimizationTitle => 'Batterieoptimisatioun ausschalten';

  @override
  String get batteryOptimizationMessage =>
      'Fir de Live-Standuert am Hannergrond aktiv ze halen, setzt TaybGo Driver an den Android-Astellungen op onlimitéiert Batteriebenzung.';

  @override
  String get batteryOptimizationBannerMessage =>
      'Batterieoptimisatioun kann de Live-Standuert pauséieren, wann Dir online sidd. Setzt TaybGo Driver op onlimitéiert Batteriebenzung.';

  @override
  String get profileUpdatedSuccessfully => 'Profil erfollegräich aktualiséiert';

  @override
  String get failedToUpdateProfile => 'Profil konnt net aktualiséiert ginn';

  @override
  String get supportTickets => 'Support-Ticketen';

  @override
  String get supportFilterAll => 'Alles';

  @override
  String get supportFilterOpen => 'Op';

  @override
  String get supportFilterInProgress => 'Am Gaang';

  @override
  String get supportFilterClosed => 'Zou';

  @override
  String get supportStatusOpen => 'Op';

  @override
  String get supportStatusInProgress => 'Am Gaang';

  @override
  String get supportStatusClosed => 'Zou';

  @override
  String get supportPriorityLow => 'Niddreg';

  @override
  String get supportPriorityMedium => 'Mëttel';

  @override
  String get supportPriorityHigh => 'Héich';

  @override
  String get supportNoTickets => 'Nach keng Ticketen';

  @override
  String get supportNoTicketsDesc =>
      'Erstellt en Ticket wann Dir Hëllef braucht';

  @override
  String get supportCreateTicket => 'Ticket erstellen';

  @override
  String get supportTicketCreated => 'Ticket erfollegräich erstallt';

  @override
  String get supportRelatedOrder => 'Verbonne Bestellung';

  @override
  String get supportSubject => 'Sujet';

  @override
  String get supportSubjectHint => 'Kuerz Beschreiwung vun Ärem Problem';

  @override
  String get supportSubjectRequired => 'Sujet ass erfuerderlech';

  @override
  String get supportMessage => 'Noriicht';

  @override
  String get supportMessageHint => 'Beschreift Äert Problem am Detail...';

  @override
  String get supportMessageRequired => 'Noriicht ass erfuerderlech';

  @override
  String get supportSubmitTicket => 'Ticket aschécken';

  @override
  String get supportSelectOrder => 'Eng Bestellung auswielen (optional)';

  @override
  String get supportNoOrder => 'Keng spezifesch Bestellung';

  @override
  String get supportTicketDetail => 'Ticket-Detailer';

  @override
  String get supportNoMessages => 'Nach keng Noriichten';

  @override
  String get supportTypeMessage => 'Eng Noriicht schreiwen...';

  @override
  String get supportTicketClosed => 'Dësen Ticket ass zou';

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
  String get file => 'Fichier';

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
  String get changelog => 'Ännerungsprotokoll';

  @override
  String get changelogTitle => 'Wat ass nei?';

  @override
  String get changelogSubtitle =>
      'E séieren Iwwerbléck iwwer déi lescht Verbesserungen am TaybGo Driver.';

  @override
  String get changelogCurrent => 'Aktuell';

  @override
  String get changelogBuild => 'Build';

  @override
  String get changelogReleased => 'Verëffentlecht';

  @override
  String get changelogReleaseNotes => 'Release-Notizen';

  @override
  String get changelogHighlights => 'Highlights';

  @override
  String get changelogFixes => 'Feelerbehebungen';

  @override
  String get changelogImprovements => 'Verbesserungen';

  @override
  String get changelogStability => 'Stabilitéit';

  @override
  String get changelogPlatform => 'Plattform';

  @override
  String get changelogRelease => 'Release';

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
      'Optional strukturéiert Adresse fir Chauffeuren mat Koordinaten a kompletten Adressdetailer bei der Umeldung an der Profilbearbechtung dobäigesat.';

  @override
  String get changelogVersion1013Status =>
      'Nëmmen Adressaktualiséierunge benotzen elo partiell PATCH-Ufroen a behalen de Status vun engem approuvéierte Chauffeur.';

  @override
  String get changelogVersion1013Release =>
      'Chauffeurs-App Versioun 1.0.13+15 verëffentlecht.';

  @override
  String get changelogDateMay31 => '31. Mee 2026';

  @override
  String get changelogDateMay24 => '24. Mee 2026';

  @override
  String get changelogDateMay13 => '13. Mee 2026';

  @override
  String get changelogDateMay11 => '11. Mee 2026';

  @override
  String get changelogCurrentTaxi =>
      'D\'Auswiel vum Taxidéngscht gouf op Autofuerer limitéiert; Vëlosfuerer kënnen en bei der Registréierung an der Profilbearbechtung net méi aktivéieren.';

  @override
  String get changelogVersion1113Upload =>
      'D\'Späicherverbrauch bei Web-Uploads gouf reduzéiert, fir Dokumenter op manner staarken Apparater méi zouverlässeg eropzelueden.';

  @override
  String get changelogCurrentChangelog =>
      'Am Profil gouf en lokaliséierten, ausklappbare Ännerungsprotokoll mat Verëffentlechungsgeschicht, Buildnummeren, Datumen a Release-Notize bäigefüügt.';

  @override
  String get changelogVersion1113Version =>
      'D\'App-Versioun an de Verëffentlechungsdatum ginn elo um Login-Bildschierm an um Web-Startbildschierm ugewisen.';

  @override
  String get changelogCurrentRelease =>
      'D\'App gouf op d\'Versioun 1.0.12+14 mat den neiste Verbesserunge vun der Fuerer-App aktualiséiert.';

  @override
  String get changelogVersion1113Release =>
      'De Play-Store-Build gouf op d\'Versioun 1.0.11+13 (Versiounscode 13) aktualiséiert.';

  @override
  String get changelogVersion1112Release =>
      'D\'Fuerer-App gouf an der Versioun 1.0.11+12 verëffentlecht an hir Verëffentlechungsmetadate goufe gespäichert.';

  @override
  String get changelogVersion1011Documents =>
      'D\'Validatioun vun den erfuerderlechen Dokumenter fir Autofuerer gouf derbäigesat.';

  @override
  String get changelogVersion1011Uploads =>
      'Erfuerderlech Dokumenter ginn elo méi kloer markéiert an d\'Veraarbechtung vum Upload-Status gouf verbessert.';

  @override
  String get changelogVersion1011Feedback =>
      'D\'Validatioun an d\'Feelermeldunge beim Späichere vu Profilännerunge goufe verbessert.';

  @override
  String get changelogVersion1011Release =>
      'D\'Fuerer-App gouf an der Versioun 1.0.10+11 verëffentlecht.';

  @override
  String get changelogVersion0910Crashlytics =>
      'Crashlytics-Berichter fir schwéier Feeler a Release-Builds goufen derbäigesat.';

  @override
  String get changelogVersion0910Notifications =>
      'Den Notifikatiouns-Liewenszyklus, d\'Deduplikatioun an d\'Veraarbechtung vun Bestellungsnotifikatioune goufe verbessert.';

  @override
  String get changelogVersion0910Platform =>
      'D\'Release-Konfiguratioun fir Android, iOS, macOS an de Web gouf mat Entwécklungs- a Produktiouns-Flavors aktualiséiert.';

  @override
  String get changelogVersion0910Release =>
      'D\'Fuerer-App gouf an der Versioun 1.0.9+10 verëffentlecht.';
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian Bokmål (`nb`).
class AppLocalizationsNb extends AppLocalizations {
  AppLocalizationsNb([String locale = 'nb']) : super(locale);

  @override
  String get appName => 'TaybGo Sjåfør';

  @override
  String get welcome => 'Velkommen';

  @override
  String get getStarted => 'Kom i gang';

  @override
  String get next => 'Neste';

  @override
  String get skip => 'Hopp over';

  @override
  String get done => 'Ferdig';

  @override
  String get cancel => 'Avbryt';

  @override
  String get confirm => 'Bekreft';

  @override
  String get save => 'Lagre';

  @override
  String get edit => 'Rediger';

  @override
  String get delete => 'Slett';

  @override
  String get retry => 'Prøv igjen';

  @override
  String get loading => 'Laster...';

  @override
  String get error => 'Feil';

  @override
  String get success => 'Suksess';

  @override
  String get seeAll => 'Se alle';

  @override
  String get or => 'ELLER';

  @override
  String get onboardingTitle1 => 'Begynn å tjene i dag';

  @override
  String get onboardingDesc1 =>
      'Bli med tusenvis av sjåfører som tjener etter sin egen timeplan';

  @override
  String get onboardingTitle2 => 'Aksepter bestillinger enkelt';

  @override
  String get onboardingDesc2 =>
      'Bli varslet om nye bestillinger og aksepter med ett trykk';

  @override
  String get onboardingTitle3 => 'Naviger & Lever';

  @override
  String get onboardingDesc3 =>
      'Innebygd navigasjon hjelper deg å nå destinasjoner raskere';

  @override
  String get phoneNumber => 'Telefonnummer';

  @override
  String get enterPhoneNumber => 'Skriv inn telefonnummeret ditt';

  @override
  String get phoneHint => '+47 123 45 678';

  @override
  String get sendOtp => 'Send kode';

  @override
  String get verifyOtp => 'Bekreft kode';

  @override
  String get enterOtp => 'Skriv inn koden vi sendte til';

  @override
  String get resendOtp => 'Send kode på nytt';

  @override
  String resendOtpIn(int seconds) {
    return 'Send kode på nytt om ${seconds}s';
  }

  @override
  String get invalidOtp => 'Ugyldig bekreftelseskode';

  @override
  String get otpSent => 'Bekreftelseskode sendt';

  @override
  String get errorsAuthPhoneAlreadyRegistered =>
      'Dette nummeret er allerede registrert.';

  @override
  String get email => 'E-post';

  @override
  String get enterEmail => 'Skriv inn e-posten din';

  @override
  String get signUpWithApple => 'Registrer med Apple';

  @override
  String get signUpWithGoogle => 'Registrer med Google';

  @override
  String get forgotPassword => 'Glemt passord';

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
  String get driverApplication => 'Sjåførsøknad';

  @override
  String get personalInfo => 'Personlig informasjon';

  @override
  String get vehicleInfo => 'Kjøretøyinformasjon';

  @override
  String get documents => 'Dokumenter';

  @override
  String get otherDocuments => 'Other Documents';

  @override
  String get reviewSubmit => 'Gjennomgå & Send';

  @override
  String get fullName => 'Fullt navn';

  @override
  String get age => 'Fødselsdato';

  @override
  String get dateOfBirth => 'Fødselsdato';

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
  String get city => 'By';

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
  String get vehicleType => 'Kjøretøytype';

  @override
  String get selectVehicleType => 'Velg kjøretøytype';

  @override
  String get car => 'Bil';

  @override
  String get van => 'Varebil';

  @override
  String get motorcycle => 'Motorsykkel';

  @override
  String get bicycle => 'Sykkel';

  @override
  String get scooter => 'Scooter';

  @override
  String get licensePlate => 'Registreringsskilt';

  @override
  String get vehicleModel => 'Kjøretøymodell';

  @override
  String get vehicleYear => 'Kjøretøyår';

  @override
  String get vehicleColor => 'Kjøretøyfarge';

  @override
  String get serviceType => 'Tjenestetype';

  @override
  String get selectServiceType => 'Hvilke tjenester vil du tilby?';

  @override
  String get foodDelivery => 'Matlevering';

  @override
  String get shipping => 'Frakt';

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
  String get uploadDocuments => 'Last opp dokumenter';

  @override
  String get driversLicense => 'Førerkort';

  @override
  String get nationalId => 'Identitetskort';

  @override
  String get healthInsuranceDocument => 'Health Insurance Document';

  @override
  String get addressDocument => 'Address Document';

  @override
  String get bankDocument => 'Bank Document';

  @override
  String get vehicleRegistration => 'Vognkort';

  @override
  String get insurance => 'Forsikring';

  @override
  String get profilePhoto => 'Profilbilde';

  @override
  String get uploadPhoto => 'Last opp bilde';

  @override
  String get takePhoto => 'Ta bilde';

  @override
  String get chooseFromGallery => 'Velg fra galleri';

  @override
  String get submitApplication => 'Send søknad';

  @override
  String get applicationSubmitted => 'Søknad sendt';

  @override
  String get applicationPending => 'Søknaden din er under vurdering';

  @override
  String get applicationApproved => 'Søknad godkjent';

  @override
  String get applicationRejected => 'Søknad avslått';

  @override
  String get pendingApprovalMessage =>
      'Vi gjennomgår dokumentene dine. Dette tar vanligvis 24-48 timer.';

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
  String get home => 'Hjem';

  @override
  String get orders => 'Bestillinger';

  @override
  String get recentOrders => 'Nylige bestillinger';

  @override
  String get earnings => 'Inntekter';

  @override
  String get profile => 'Profil';

  @override
  String get search => 'Søk';

  @override
  String get online => 'Online';

  @override
  String get offline => 'Offline';

  @override
  String get goOnline => 'Gå online';

  @override
  String get goOffline => 'Gå offline';

  @override
  String get tapToGoOnline => 'Trykk for å gå online';

  @override
  String get tapToGoOffline => 'Trykk for å gå offline';

  @override
  String get youAreOnline => 'Du er online og klar til å motta bestillinger';

  @override
  String get youAreOffline =>
      'Du er offline. Gå online for å motta bestillinger';

  @override
  String get newOrder => 'Ny bestilling';

  @override
  String get newOrderTitle => 'Ny bestilling!';

  @override
  String get newOrderSubtitle => 'Aksepter før tiden løper ut';

  @override
  String get orderDetails => 'Bestillingsdetaljer';

  @override
  String get navigate => 'Naviger';

  @override
  String get details => 'Detaljer';

  @override
  String get acceptOrder => 'Aksepter bestilling';

  @override
  String get rejectOrder => 'Avslå bestilling';

  @override
  String get accept => 'Aksepter';

  @override
  String get reject => 'Avslå';

  @override
  String acceptIn(int seconds) {
    return 'Aksepter om ${seconds}s';
  }

  @override
  String get orderAccepted => 'Bestilling akseptert';

  @override
  String get items => 'artikler';

  @override
  String get time => 'Tid';

  @override
  String get orderRejected => 'Bestilling avslått';

  @override
  String get orderCompleted => 'Bestilling fullført';

  @override
  String get orderCancelled => 'Bestilling kansellert';

  @override
  String get pending => 'Venter';

  @override
  String get searchingForDriver => 'Søker sjåfør';

  @override
  String get driverNotificationSent => 'Sjåføroppvarsel sendt';

  @override
  String get rejected => 'Avvist';

  @override
  String get cancelled => 'Kansellert';

  @override
  String get delivered => 'Levert';

  @override
  String get expired => 'Expired';

  @override
  String get restaurantDelivered => 'Restaurant delivered';

  @override
  String get pickup => 'Henting';

  @override
  String get dropoff => 'Levering';

  @override
  String get pickupLocation => 'Hentested';

  @override
  String get dropoffLocation => 'Leveringssted';

  @override
  String get route => 'Rute';

  @override
  String get inProgress => 'Pågår';

  @override
  String get headingToPickup => 'På vei til hentested';

  @override
  String get headingToDropoff => 'På vei til leveringssted';

  @override
  String get atPickupLocation => 'Ved hentested';

  @override
  String get atDropoffLocation => 'Ved leveringssted';

  @override
  String get orderId => 'Bestillings-ID';

  @override
  String get customer => 'Kunde';

  @override
  String get itemsOrdered => 'Artikler';

  @override
  String get callCustomer => 'Ring kunde';

  @override
  String get distance => 'Avstand';

  @override
  String get estimatedTime => 'Beregnet tid';

  @override
  String get yourDistanceTo => 'Din avstand til';

  @override
  String get km => 'km';

  @override
  String get min => 'min';

  @override
  String get startNavigation => 'Start navigasjon';

  @override
  String get arrivedAtPickup => 'Ankommet hentested';

  @override
  String get startDelivery => 'Start levering';

  @override
  String get arrivedAtDropoff => 'Ankommet leveringssted';

  @override
  String get completeOrder => 'Fullfør bestilling';

  @override
  String get markAsDelivered => 'Merk som levert';

  @override
  String get acceptOrderConfirmation =>
      'Er du sikker på at du vil akseptere denne bestillingen?';

  @override
  String get rejectOrderConfirmation =>
      'Er du sikker på at du vil avslå denne bestillingen?';

  @override
  String get startDeliveryConfirmation =>
      'Bekreft at du har hentet bestillingen og starter leveringen?';

  @override
  String get arrivedAtDropoffConfirmation =>
      'Bekreft at du har ankommet leveringsstedet?';

  @override
  String get completeOrderConfirmation =>
      'Bekreft at du har fullført denne leveringen?';

  @override
  String get updatingStatus => 'Oppdaterer status...';

  @override
  String get tip => 'Tips';

  @override
  String get earnings_label => 'Inntekter';

  @override
  String get deliveryFee => 'Leveringsgebyr';

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
  String get total => 'Totalt';

  @override
  String get currentOrders => 'Nåværende bestillinger';

  @override
  String get orderHistory => 'Bestillingshistorikk';

  @override
  String get noOrdersYet => 'Ingen bestillinger ennå';

  @override
  String get noActiveOrders => 'Ingen aktive bestillinger';

  @override
  String get waitingForOrders => 'Venter på nye bestillinger...';

  @override
  String get totalOrders => 'Totale bestillinger';

  @override
  String get totalEarnings => 'Totale inntekter';

  @override
  String get avgTripTime => 'Gjennomsnittlig reisetid';

  @override
  String get completionRate => 'Fullføringsrate';

  @override
  String get rating => 'Vurdering';

  @override
  String get todayEarnings => 'Dagens inntekter';

  @override
  String get weeklyEarnings => 'Ukentlige inntekter';

  @override
  String get monthlyEarnings => 'Månedlige inntekter';

  @override
  String get lastMonthEarnings => 'Forrige måneds inntekter';

  @override
  String get viewPayslips => 'Se lønnslipper';

  @override
  String get payslipsSentEmail => 'Lønnslipper sendes til e-posten din';

  @override
  String get settings => 'Innstillinger';

  @override
  String get language => 'Språk';

  @override
  String get english => 'Engelsk';

  @override
  String get german => 'Tysk';

  @override
  String get french => 'Fransk';

  @override
  String get arabic => 'Arabisk';

  @override
  String get luxembourgish => 'Luxembourgsk';

  @override
  String get italian => 'Italiensk';

  @override
  String get dutch => 'Nederlandsk';

  @override
  String get swedish => 'Svensk';

  @override
  String get norwegian => 'Norsk';

  @override
  String get danish => 'Dansk';

  @override
  String get finnish => 'Finsk';

  @override
  String get theme => 'Tema';

  @override
  String get lightMode => 'Lyst modus';

  @override
  String get darkMode => 'Mørkt modus';

  @override
  String get systemDefault => 'Systemstandard';

  @override
  String get notifications => 'Varsler';

  @override
  String get orderNotifications => 'Bestillingsvarsler';

  @override
  String get promotionalNotifications => 'Kampanjevarsler';

  @override
  String get soundEnabled => 'Lyd aktivert';

  @override
  String get vibrationEnabled => 'Vibrasjon aktivert';

  @override
  String get notificationSoundRepeats => 'Gjenta varslingslyd';

  @override
  String notificationSoundRepeatsEnabledDesc(int count) {
    return 'Spill av signallyden $count gang(er) for hvert varsel.';
  }

  @override
  String get notificationSoundRepeatsDisabledDesc =>
      'Sl? p? lyd f?rst for ? velge hvor mange ganger signalet skal gjentas.';

  @override
  String get notificationSoundRepeatsPickerDesc =>
      'Velg hvor mange ganger signallyden skal gjentas for hvert varsel.';

  @override
  String get notificationRepeatTime => '1 gang';

  @override
  String notificationRepeatTimes(int count) {
    return '$count ganger';
  }

  @override
  String get noNotifications => 'Ingen varsler ennå';

  @override
  String get noNotificationsDesc => 'Varslene dine vises her';

  @override
  String get today => 'I dag';

  @override
  String get yesterday => 'I går';

  @override
  String get earlier => 'Tidligere';

  @override
  String get markAllRead => 'Merk alle som lest';

  @override
  String get clearAll => 'Fjern alle';

  @override
  String get newOrderReceived => 'Ny bestilling mottatt';

  @override
  String get orderAcceptedNotif => 'Bestilling akseptert';

  @override
  String get orderDeliveredNotif => 'Bestilling levert';

  @override
  String get earningsReceived => 'Inntekter mottatt';

  @override
  String get weeklyReportReady => 'Ukesrapporten er klar';

  @override
  String get accountUpdated => 'Konto oppdatert';

  @override
  String get account => 'Konto';

  @override
  String get editProfile => 'Rediger profil';

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
  String get changePassword => 'Endre passord';

  @override
  String get privacyPolicy => 'Personvernregler';

  @override
  String get termsOfService => 'Tjenestevilkår';

  @override
  String get helpSupport => 'Hjelp & Støtte';

  @override
  String get contactUs => 'Kontakt oss';

  @override
  String get logout => 'Logg ut';

  @override
  String get logoutConfirm => 'Er du sikker på at du vil logge ut?';

  @override
  String get deleteAccount => 'Slett konto';

  @override
  String get deleteAccountConfirm =>
      'Er du sikker på at du vil slette kontoen din? Denne handlingen kan ikke angres.';

  @override
  String get networkError => 'Nettverksfeil. Sjekk tilkoblingen din.';

  @override
  String get somethingWentWrong => 'Noe gikk galt. Prøv igjen.';

  @override
  String get sessionExpired => 'Økten er utløpt. Logg inn igjen.';

  @override
  String get locationPermissionDenied => 'Stedstillatelse nektet';

  @override
  String get enableLocationServices => 'Aktiver stedstjenester for å fortsette';

  @override
  String version(String version) {
    return 'Versjon $version';
  }

  @override
  String get goodMorning => 'God morgen';

  @override
  String get goodAfternoon => 'God ettermiddag';

  @override
  String get goodEvening => 'God kveld';

  @override
  String get locationRequired => 'Sted kreves';

  @override
  String get enableLocationAccess =>
      'Aktiver stedstilgang for å motta bestillinger.';

  @override
  String get enable => 'Aktiver';

  @override
  String get pleaseEnableLocationInSettings => 'Aktiver sted i innstillingene.';

  @override
  String get backgroundLocationTitle => 'Tillat posisjon i bakgrunnen';

  @override
  String get backgroundLocationMessage =>
      'For at TaybGo skal kunne sende posisjonen din når appen er i bakgrunnen, åpne innstillingene og velg «Tillat alltid».';

  @override
  String get gpsDisabled => 'GPS deaktivert';

  @override
  String get pleaseEnableGps => 'Aktiver GPS for å motta bestillinger.';

  @override
  String get failedToUpdateStatus => 'Kunne ikke oppdatere status';

  @override
  String get ok => 'OK';

  @override
  String get accountUnderReview => 'Konto under vurdering';

  @override
  String get accountBeingVerified =>
      'Kontoen din verifiseres. Du blir varslet når den er godkjent.';

  @override
  String get receivingOrders => 'Mottar bestillinger';

  @override
  String get goOnlineToStart => 'Gå online for å starte';

  @override
  String get noRecentOrders => 'Ingen nylige bestillinger';

  @override
  String get headToPickup => 'Dra til henting';

  @override
  String get onTheWay => 'På vei';

  @override
  String get atDelivery => 'Ved levering';

  @override
  String get continueText => 'Fortsett';

  @override
  String get week => 'Uke';

  @override
  String get month => 'Måned';

  @override
  String get avgPerOrder => 'Gjennomsnitt/Bestilling';

  @override
  String get allTime => 'Totalt';

  @override
  String get noEarningsData => 'Ingen inntektsdata';

  @override
  String get completeOrdersToSeeEarnings =>
      'Fullfør bestillinger for å se inntektene dine';

  @override
  String get verified => 'Verifisert';

  @override
  String get approved => 'Godkjent';

  @override
  String joinedOn(Object date) {
    return 'Medlem siden $date';
  }

  @override
  String get driver => 'Sjåfør';

  @override
  String get knowledgeBase => 'Kunnskapsbase';

  @override
  String get searchForHelp => 'Søk etter hjelp...';

  @override
  String get noArticlesFound => 'Ingen artikler funnet';

  @override
  String get tryDifferentSearch => 'Prøv et annet søkeord';

  @override
  String get noCategoriesAvailable => 'Ingen kategorier tilgjengelig';

  @override
  String articlesCount(int count) {
    return '$count artikler';
  }

  @override
  String get articleNotFound => 'Artikkel ikke funnet';

  @override
  String get wasArticleHelpful => 'Var denne artikkelen nyttig?';

  @override
  String get thankYouFeedback => 'Takk for tilbakemeldingen!';

  @override
  String get willImproveArticle =>
      'Vi vil jobbe med å forbedre denne artikkelen.';

  @override
  String get relatedArticles => 'Relaterte artikler';

  @override
  String get kbTip => 'Tips';

  @override
  String get kbWarning => 'Advarsel';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nei';

  @override
  String get article => 'Artikkel';

  @override
  String get browseKnowledgeBase => 'Bla i kunnskapsbasen';

  @override
  String sectionsCount(int count) {
    return '$count seksjoner';
  }

  @override
  String minRead(int count) {
    return '$count min lesing';
  }

  @override
  String get tourAccountUnderReviewTitle => 'Konto under vurdering';

  @override
  String get tourAccountUnderReviewDesc =>
      'Kontoen din verifiseres. Du kan utforske appen mens du venter på godkjenning.';

  @override
  String get tourGoOnlineTitle => 'Gå online for å motta bestillinger';

  @override
  String get tourGoOnlineDesc =>
      'Slå på denne bryteren når du er klar til å akseptere leveringer. Du kan gå offline når som helst.';

  @override
  String get tourDailyStatsTitle => 'Din daglige statistikk';

  @override
  String get tourDailyStatsDesc =>
      'Følg bestillingene, inntektene og vurderingen din her. Statistikken oppdateres i sanntid.';

  @override
  String get tourNewOrderTitle => 'Ny bestilling mottatt!';

  @override
  String get tourNewOrderDesc =>
      'Slik ser nye bestillinger ut. Gjennomgå henting, levering, avstand og betaling.';

  @override
  String get tourOrdersTabTitle => 'Bestillinger-fane';

  @override
  String get tourOrdersTabDesc =>
      'Bytt mellom nåværende bestillinger og bestillingshistorikk.';

  @override
  String get tourTotalEarningsTitle => 'Dine totale inntekter';

  @override
  String get tourTotalEarningsDesc =>
      'Følg alle inntektene dine her — grunnlønn, tips og bonuser.';

  @override
  String get tourEarningsBreakdownTitle => 'Inntektsoversikt';

  @override
  String get tourEarningsBreakdownDesc =>
      'Se totale bestillinger og gjennomsnittlige inntekter per bestilling.';

  @override
  String get tourRouteDetailsTitle => 'Rutedetaljer';

  @override
  String get tourRouteDetailsDesc =>
      'Se den fullstendige hente- og leveringsruten med adresser, avstand og beregnet tid.';

  @override
  String get tourYourEarningsTitle => 'Dine inntekter';

  @override
  String get tourYourEarningsDesc =>
      'Se den fullstendige betalingsoversikten — leveringsgebyr, tips og total utbetaling.';

  @override
  String get tourNavActionsTitle => 'Navigasjon & Handlinger';

  @override
  String get tourNavActionsDesc =>
      'Naviger til henting/levering eller oppdater bestillingsstatus underveis.';

  @override
  String get tourTurnByTurnTitle => 'Steg-for-steg navigasjon';

  @override
  String get tourTurnByTurnDesc =>
      'Følg sanntidsanvisninger til hente- eller leveringsstedet ditt.';

  @override
  String get tourTripControlsTitle => 'Turkontroller';

  @override
  String get tourTripControlsDesc =>
      'Bytt mellom hente- og leveringsruter, se destinasjonsdetaljer og inntekter.';

  @override
  String get tourUpdateStatusTitle => 'Oppdater status';

  @override
  String get tourUpdateStatusDesc =>
      'Trykk for å markere viktige milepæler — På vei, Levert eller Fullført.';

  @override
  String get tourAppSettingsTitle => 'Appinnstillinger';

  @override
  String get tourAppSettingsDesc =>
      'Endre språk, tema og få tilgang til kunnskapsbasen for hjelp.';

  @override
  String get tourKnowledgeBaseTitle => 'Kunnskapsbase';

  @override
  String get tourKnowledgeBaseDesc =>
      'Bla gjennom steg-for-steg guider, tips og svar på vanlige spørsmål.';

  @override
  String get tourSkipBtn => 'Hopp over';

  @override
  String get tourBackBtn => 'Tilbake';

  @override
  String get tourNextBtn => 'Neste';

  @override
  String get tourDoneBtn => 'Ferdig';

  @override
  String get tourWelcomeTitle => 'Velkommen til TaybGo!';

  @override
  String get tourWelcomeDesc =>
      'Ta en rask tur for å lære hvordan appen brukes';

  @override
  String get tourSkipForNow => 'Hopp over for nå';

  @override
  String get tourStartBtn => 'Start tur';

  @override
  String get tourCompleteTitle => 'Tur fullført!';

  @override
  String get tourCompleteDesc =>
      'Du er klar til å begynne å akseptere bestillinger og tjene med TaybGo!';

  @override
  String get tourBrowseKb => 'Bla i kunnskapsbasen';

  @override
  String get tourGetStarted => 'Kom i gang';

  @override
  String get selectCountry => 'Velg land';

  @override
  String get searchCountry => 'Søk land...';

  @override
  String get secure => 'Sikker';

  @override
  String get wellSendVerificationCode => 'Vi sender deg en bekreftelseskode';

  @override
  String get byConsentTerms =>
      'Ved å fortsette godtar du våre vilkår og personvernregler';

  @override
  String get otpSentSuccessfully => 'Bekreftelseskode sendt';

  @override
  String resendIn(int seconds) {
    return 'Send på nytt om ${seconds}s';
  }

  @override
  String get resendCode => 'Send kode på nytt';

  @override
  String get verify => 'Bekreft';

  @override
  String get tellUsAboutYourself => 'Fortell oss om deg selv';

  @override
  String get basicInfoSubtitle =>
      'Vi trenger grunnleggende informasjon for å sette opp sjåførkontoen din';

  @override
  String get enterYourFullName => 'Skriv inn ditt fulle navn';

  @override
  String get notAvailable => 'Ikke tilgjengelig';

  @override
  String get verifiedViaOtp => 'Verifisert via OTP';

  @override
  String get selectYourVehicle => 'Velg kjøretøyet ditt';

  @override
  String get vehicleStepSubtitle =>
      'Velg kjøretøytypen du vil bruke for leveringer';

  @override
  String get chooseYourServices => 'Velg dine tjenester';

  @override
  String get servicesStepSubtitle => 'Velg leveringstypene du vil akseptere';

  @override
  String get deliverFoodDesc => 'Lever mat fra restauranter';

  @override
  String get deliverPackagesDesc => 'Lever pakker og forsendelser';

  @override
  String get transportPassengersDesc => 'Transporter passasjerer';

  @override
  String get changeServiceLater =>
      'Du kan endre tjenestepreferansene dine senere i innstillingene';

  @override
  String get back => 'Tilbake';

  @override
  String get completeRegistration => 'Fullfør registrering';

  @override
  String get pleaseEnterYourName => 'Skriv inn navnet ditt';

  @override
  String get pleaseSelectService => 'Velg minst én tjenestetype';

  @override
  String get pleaseUploadDriversLicense => 'Last opp førerkortet ditt';

  @override
  String get pleaseUploadNationalId => 'Last opp ditt nasjonale ID';

  @override
  String pleaseUploadDocument(Object documentName) {
    return 'Last opp $documentName';
  }

  @override
  String get registrationFailed => 'Registrering mislyktes. Prøv igjen.';

  @override
  String get stepPersonal => 'Personlig';

  @override
  String get stepVehicle => 'Kjøretøy';

  @override
  String get stepServices => 'Tjenester';

  @override
  String applicationStepProgress(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String applicationNextStep(String step) {
    return 'Next: $step';
  }

  @override
  String get ecoFriendlyOption => 'Miljøvennlig alternativ';

  @override
  String get fastAndAgile => 'Rask og smidig';

  @override
  String get mostVersatile => 'Mest allsidig';

  @override
  String get largeDeliveries => 'Store leveringer';

  @override
  String get deleteDataWarning =>
      'Dette vil permanent slette alle dataene dine, inkludert profil, vurderinger og bestillingshistorikk.';

  @override
  String get finalConfirmation => 'Siste bekreftelse';

  @override
  String get finalDeleteWarning =>
      'Er du helt sikker? Denne handlingen er irreversibel og du mister alle dataene dine.';

  @override
  String get deleteMyAccount => 'Slett kontoen min';

  @override
  String get deletingAccount => 'Sletter konto...';

  @override
  String get accountDeletedSuccessfully => 'Konto slettet';

  @override
  String failedToDeleteAccount(String error) {
    return 'Kunne ikke slette konto: $error';
  }

  @override
  String get justNow => 'Akkurat nå';

  @override
  String minutesAgo(int minutes) {
    return '${minutes}m siden';
  }

  @override
  String hoursAgo(int hours) {
    return '${hours}t siden';
  }

  @override
  String daysAgo(int days) {
    return '${days}d siden';
  }

  @override
  String get clearAllNotificationsConfirm =>
      'Er du sikker på at du vil fjerne alle varsler?';

  @override
  String get failedToLoadNotifications => 'Kunne ikke laste varsler';

  @override
  String get calculatingRoute => 'Beregner rute...';

  @override
  String get orderNotFound => 'Bestilling ikke funnet';

  @override
  String get goBack => 'Gå tilbake';

  @override
  String get gpsUnavailableTapRetry =>
      'GPS utilgjengelig. Trykk for å prøve igjen.';

  @override
  String get googleMaps => 'Google Maps';

  @override
  String get fetchingLocation => 'Henter plassering...';

  @override
  String secondsAgo(int seconds) {
    return '${seconds}s siden';
  }

  @override
  String get subtotal => 'Delsum';

  @override
  String get orderType => 'Type';

  @override
  String get created => 'Opprettet';

  @override
  String get accepted => 'Akseptert';

  @override
  String get completed => 'Fullført';

  @override
  String get orderPaid => 'Betalt';

  @override
  String get orderPaidDescription => 'Ingen kontantinnsamling nødvendig';

  @override
  String get collectCash => 'Samle inn kontanter';

  @override
  String get collectCashReminder => 'Husk å samle inn betalingen fra kunden';

  @override
  String collectCashAmountReminder(String amount) {
    return 'Collect $amount from the customer before completing.';
  }

  @override
  String get locationPermissionLostWhileOnline =>
      'Posisjonstilgang er deaktivert. Du vil ikke motta bestillinger før den er aktivert.';

  @override
  String get batteryOptimizationTitle => 'Slå av batterioptimalisering';

  @override
  String get batteryOptimizationMessage =>
      'For å holde live-posisjon aktiv i bakgrunnen, sett TaybGo Driver til ubegrenset batteribruk i Android-innstillingene.';

  @override
  String get batteryOptimizationBannerMessage =>
      'Batterioptimalisering kan sette live-posisjon på pause mens du er online. Sett TaybGo Driver til ubegrenset batteribruk.';

  @override
  String get profileUpdatedSuccessfully => 'Profil oppdatert';

  @override
  String get failedToUpdateProfile => 'Kunne ikke oppdatere profil';

  @override
  String get supportTickets => 'Supporthenvendelser';

  @override
  String get supportFilterAll => 'Alle';

  @override
  String get supportFilterOpen => 'Åpne';

  @override
  String get supportFilterInProgress => 'Pågår';

  @override
  String get supportFilterClosed => 'Lukket';

  @override
  String get supportStatusOpen => 'Åpen';

  @override
  String get supportStatusInProgress => 'Pågår';

  @override
  String get supportStatusClosed => 'Lukket';

  @override
  String get supportPriorityLow => 'Lav';

  @override
  String get supportPriorityMedium => 'Middels';

  @override
  String get supportPriorityHigh => 'Høy';

  @override
  String get supportNoTickets => 'Ingen henvendelser ennå';

  @override
  String get supportNoTicketsDesc =>
      'Opprett en henvendelse hvis du trenger hjelp';

  @override
  String get supportCreateTicket => 'Opprett henvendelse';

  @override
  String get supportTicketCreated => 'Henvendelse opprettet';

  @override
  String get supportRelatedOrder => 'Relatert bestilling';

  @override
  String get supportSubject => 'Emne';

  @override
  String get supportSubjectHint => 'Kort beskrivelse av problemet ditt';

  @override
  String get supportSubjectRequired => 'Emne er påkrevd';

  @override
  String get supportMessage => 'Melding';

  @override
  String get supportMessageHint => 'Beskriv problemet ditt i detalj...';

  @override
  String get supportMessageRequired => 'Melding er påkrevd';

  @override
  String get supportSubmitTicket => 'Send henvendelse';

  @override
  String get supportSelectOrder => 'Velg en bestilling (valgfritt)';

  @override
  String get supportNoOrder => 'Ingen spesifikk bestilling';

  @override
  String get supportTicketDetail => 'Henvendelsesdetaljer';

  @override
  String get supportNoMessages => 'Ingen meldinger ennå';

  @override
  String get supportTypeMessage => 'Skriv en melding...';

  @override
  String get supportTicketClosed => 'Denne henvendelsen er lukket';

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
  String get file => 'Fil';

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
  String get changelog => 'Endringslogg';

  @override
  String get changelogTitle => 'Hva er nytt?';

  @override
  String get changelogSubtitle =>
      'En rask oversikt over de siste forbedringene i TaybGo Driver.';

  @override
  String get changelogCurrent => 'Gjeldende';

  @override
  String get changelogBuild => 'Build';

  @override
  String get changelogReleased => 'Utgitt';

  @override
  String get changelogReleaseNotes => 'Versjonsnotater';

  @override
  String get changelogHighlights => 'Høydepunkter';

  @override
  String get changelogFixes => 'Feilrettinger';

  @override
  String get changelogImprovements => 'Forbedringer';

  @override
  String get changelogStability => 'Stabilitet';

  @override
  String get changelogPlatform => 'Plattform';

  @override
  String get changelogRelease => 'Utgivelse';

  @override
  String get changelogDateAug24 => '24 August 2026';

  @override
  String get changelogVersion101618WebPlaces =>
      'Address autocomplete on web now uses the supported Google Maps JavaScript API with compatibility fallback for existing Google Places projects.';

  @override
  String get changelogVersion101618AddressConfig =>
      'Google Places configuration is centralized and supplied through the build environment without duplicating the key in Driver source files.';

  @override
  String get changelogVersion101618ReleaseGuard =>
      'Android release builds now block missing or malformed Places configuration before an unusable APK or App Bundle can be produced.';

  @override
  String get changelogVersion101618Release =>
      'Released TaybGo Driver version 1.0.16+18.';

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
  String get changelogDateAug9 => '9. august 2026';

  @override
  String get changelogDateAug11 => '11. august 2026';

  @override
  String get changelogVersion1013Address =>
      'La til valgfrie, strukturerte sjåføradresser med koordinater og fullstendige adressedetaljer under registrering og profilredigering.';

  @override
  String get changelogVersion1013Status =>
      'Oppdateringer som bare gjelder adresse, bruker nå delvise PATCH-forespørsler og beholder statusen til en godkjent sjåfør.';

  @override
  String get changelogVersion1013Release =>
      'Sjåførappen versjon 1.0.13+15 er lansert.';

  @override
  String get changelogDateMay31 => '31. mai 2026';

  @override
  String get changelogDateMay24 => '24. mai 2026';

  @override
  String get changelogDateMay13 => '13. mai 2026';

  @override
  String get changelogDateMay11 => '11. mai 2026';

  @override
  String get changelogCurrentTaxi =>
      'Valg av taxitjenesten er begrenset til bilsjåfører, og sykkelsjåfører kan ikke lenger aktivere den under registrering eller profilredigering.';

  @override
  String get changelogVersion1113Upload =>
      'Reduserte minnebruken ved opplastinger på nettet for å gjøre dokumentopplastinger mer pålitelige på enheter med lav ytelse.';

  @override
  String get changelogCurrentChangelog =>
      'La til en lokalisert, utvidbar endringslogg i Profil med utgivelseshistorikk, buildnumre, datoer og versjonsnotater.';

  @override
  String get changelogVersion1113Version =>
      'La til appversjon og utgivelsesdato på innloggingsskjermen og på web-startskjermen.';

  @override
  String get changelogCurrentRelease =>
      'Oppdaterte appen til versjon 1.0.12+14 med de nyeste forbedringene i sjåførapplikasjonen.';

  @override
  String get changelogVersion1113Release =>
      'Play Store-bygget ble oppdatert til versjon 1.0.11+13 (versjonskode 13).';

  @override
  String get changelogVersion1112Release =>
      'Sjåførapplikasjonen ble utgitt i versjon 1.0.11+12, og utgivelsesmetadataene ble registrert.';

  @override
  String get changelogVersion1011Documents =>
      'La til validering av obligatoriske dokumenter for bilsjåfører.';

  @override
  String get changelogVersion1011Uploads =>
      'Obligatoriske dokumenter markeres tydeligere, og håndteringen av opplastingsstatus er forbedret.';

  @override
  String get changelogVersion1011Feedback =>
      'Forbedret validering og feilmeldinger ved lagring av profilendringer.';

  @override
  String get changelogVersion1011Release =>
      'Sjåførapplikasjonen ble utgitt i versjon 1.0.10+11.';

  @override
  String get changelogVersion0910Crashlytics =>
      'La til Crashlytics-rapportering for alvorlige feil i release-bygg.';

  @override
  String get changelogVersion0910Notifications =>
      'Forbedret varslenes livssyklus, deduplisering og håndtering av ordremeldinger.';

  @override
  String get changelogVersion0910Platform =>
      'Oppdaterte release-konfigurasjonen for Android, iOS, macOS og web med utviklings- og produksjonsflavors.';

  @override
  String get changelogVersion0910Release =>
      'Sjåførapplikasjonen ble utgitt i versjon 1.0.9+10.';
}

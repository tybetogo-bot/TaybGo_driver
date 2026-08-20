// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get appName => 'TaybGo Kuljettaja';

  @override
  String get welcome => 'Tervetuloa';

  @override
  String get getStarted => 'Aloita';

  @override
  String get next => 'Seuraava';

  @override
  String get skip => 'Ohita';

  @override
  String get done => 'Valmis';

  @override
  String get cancel => 'Peruuta';

  @override
  String get confirm => 'Vahvista';

  @override
  String get save => 'Tallenna';

  @override
  String get edit => 'Muokkaa';

  @override
  String get delete => 'Poista';

  @override
  String get retry => 'Yritä uudelleen';

  @override
  String get loading => 'Ladataan...';

  @override
  String get error => 'Virhe';

  @override
  String get success => 'Onnistui';

  @override
  String get seeAll => 'Näytä kaikki';

  @override
  String get or => 'TAI';

  @override
  String get onboardingTitle1 => 'Aloita ansaitseminen tänään';

  @override
  String get onboardingDesc1 =>
      'Liity tuhansien kuljettajien joukkoon, jotka ansaitsevat omaan tahtiinsa';

  @override
  String get onboardingTitle2 => 'Hyväksy tilauksia helposti';

  @override
  String get onboardingDesc2 =>
      'Saat ilmoituksen uusista tilauksista ja hyväksy yhdellä napautuksella';

  @override
  String get onboardingTitle3 => 'Navigoi & Toimita';

  @override
  String get onboardingDesc3 =>
      'Sisäänrakennettu navigointi auttaa sinua saavuttamaan kohteet nopeammin';

  @override
  String get phoneNumber => 'Puhelinnumero';

  @override
  String get enterPhoneNumber => 'Syötä puhelinnumerosi';

  @override
  String get phoneHint => '+358 40 123 4567';

  @override
  String get sendOtp => 'Lähetä koodi';

  @override
  String get verifyOtp => 'Vahvista koodi';

  @override
  String get enterOtp => 'Syötä lähettämämme koodi';

  @override
  String get resendOtp => 'Lähetä koodi uudelleen';

  @override
  String resendOtpIn(int seconds) {
    return 'Lähetä koodi uudelleen ${seconds}s kuluttua';
  }

  @override
  String get invalidOtp => 'Virheellinen vahvistuskoodi';

  @override
  String get otpSent => 'Vahvistuskoodi lähetetty';

  @override
  String get errorsAuthPhoneAlreadyRegistered =>
      'Tämä numero on jo rekisteröity.';

  @override
  String get email => 'Sähköposti';

  @override
  String get enterEmail => 'Syötä sähköpostisi';

  @override
  String get signUpWithApple => 'Rekisteröidy Applella';

  @override
  String get signUpWithGoogle => 'Rekisteröidy Googlella';

  @override
  String get forgotPassword => 'Unohtunut salasana';

  @override
  String get driverApplication => 'Kuljettajahakemus';

  @override
  String get personalInfo => 'Henkilötiedot';

  @override
  String get vehicleInfo => 'Ajoneuvotiedot';

  @override
  String get documents => 'Asiakirjat';

  @override
  String get otherDocuments => 'Other Documents';

  @override
  String get reviewSubmit => 'Tarkista & Lähetä';

  @override
  String get fullName => 'Koko nimi';

  @override
  String get age => 'Syntymäaika';

  @override
  String get dateOfBirth => 'Syntymäaika';

  @override
  String get address => 'Osoite';

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
  String get city => 'Kaupunki';

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
  String get vehicleType => 'Ajoneuvotyyppi';

  @override
  String get selectVehicleType => 'Valitse ajoneuvotyyppi';

  @override
  String get car => 'Auto';

  @override
  String get van => 'Pakettiauto';

  @override
  String get motorcycle => 'Moottoripyörä';

  @override
  String get bicycle => 'Polkupyörä';

  @override
  String get scooter => 'Skootteri';

  @override
  String get licensePlate => 'Rekisterinumero';

  @override
  String get vehicleModel => 'Ajoneuvomalli';

  @override
  String get vehicleYear => 'Ajoneuvon vuosimalli';

  @override
  String get vehicleColor => 'Ajoneuvon väri';

  @override
  String get serviceType => 'Palvelutyyppi';

  @override
  String get selectServiceType => 'Mitä palveluja tarjoat?';

  @override
  String get foodDelivery => 'Ruokatoimitus';

  @override
  String get shipping => 'Kuljetus';

  @override
  String get taxi => 'Taksi';

  @override
  String get foodOrder => 'Food order';

  @override
  String get shippingOrder => 'Shipping order';

  @override
  String get taxiRide => 'Taxi ride';

  @override
  String get allOrders => 'All';

  @override
  String get uploadDocuments => 'Lataa asiakirjat';

  @override
  String get driversLicense => 'Ajokortti';

  @override
  String get nationalId => 'Henkilökortti';

  @override
  String get healthInsuranceDocument => 'Health Insurance Document';

  @override
  String get addressDocument => 'Address Document';

  @override
  String get bankDocument => 'Bank Document';

  @override
  String get vehicleRegistration => 'Rekisteröintitodistus';

  @override
  String get insurance => 'Vakuutus';

  @override
  String get profilePhoto => 'Profiilikuva';

  @override
  String get uploadPhoto => 'Lataa kuva';

  @override
  String get takePhoto => 'Ota kuva';

  @override
  String get chooseFromGallery => 'Valitse galleriasta';

  @override
  String get submitApplication => 'Lähetä hakemus';

  @override
  String get applicationSubmitted => 'Hakemus lähetetty';

  @override
  String get applicationPending => 'Hakemuksesi on tarkistettavana';

  @override
  String get applicationApproved => 'Hakemus hyväksytty';

  @override
  String get applicationRejected => 'Hakemus hylätty';

  @override
  String get pendingApprovalMessage =>
      'Tarkistamme asiakirjojasi. Tämä kestää yleensä 24-48 tuntia.';

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
  String get home => 'Koti';

  @override
  String get orders => 'Tilaukset';

  @override
  String get recentOrders => 'Viimeaikaiset tilaukset';

  @override
  String get earnings => 'Ansiot';

  @override
  String get profile => 'Profiili';

  @override
  String get search => 'Haku';

  @override
  String get online => 'Online';

  @override
  String get offline => 'Offline';

  @override
  String get goOnline => 'Mene verkkoon';

  @override
  String get goOffline => 'Mene offline-tilaan';

  @override
  String get tapToGoOnline => 'Napauta mennäksesi verkkoon';

  @override
  String get tapToGoOffline => 'Napauta mennäksesi offline-tilaan';

  @override
  String get youAreOnline =>
      'Olet verkossa ja valmis vastaanottamaan tilauksia';

  @override
  String get youAreOffline =>
      'Olet offline-tilassa. Mene verkkoon vastaanottaaksesi tilauksia';

  @override
  String get newOrder => 'Uusi tilaus';

  @override
  String get newOrderTitle => 'Uusi tilaus!';

  @override
  String get newOrderSubtitle => 'Hyväksy ennen ajan loppumista';

  @override
  String get orderDetails => 'Tilauksen tiedot';

  @override
  String get navigate => 'Navigoi';

  @override
  String get details => 'Tiedot';

  @override
  String get acceptOrder => 'Hyväksy tilaus';

  @override
  String get rejectOrder => 'Hylkää tilaus';

  @override
  String get accept => 'Hyväksy';

  @override
  String get reject => 'Hylkää';

  @override
  String acceptIn(int seconds) {
    return 'Hyväksy ${seconds}s kuluttua';
  }

  @override
  String get orderAccepted => 'Tilaus hyväksytty';

  @override
  String get items => 'tuotetta';

  @override
  String get time => 'Aika';

  @override
  String get orderRejected => 'Tilaus hylätty';

  @override
  String get orderCompleted => 'Tilaus valmis';

  @override
  String get orderCancelled => 'Tilaus peruutettu';

  @override
  String get pending => 'Odottaa';

  @override
  String get searchingForDriver => 'Etsitään kuljettajaa';

  @override
  String get driverNotificationSent => 'Kuljettajan ilmoitus lähetetty';

  @override
  String get rejected => 'Hylätty';

  @override
  String get cancelled => 'Peruutettu';

  @override
  String get delivered => 'Toimitettu';

  @override
  String get expired => 'Expired';

  @override
  String get restaurantDelivered => 'Restaurant delivered';

  @override
  String get pickup => 'Nouto';

  @override
  String get dropoff => 'Toimitus';

  @override
  String get pickupLocation => 'Noutopaikka';

  @override
  String get dropoffLocation => 'Toimituspaikka';

  @override
  String get route => 'Reitti';

  @override
  String get inProgress => 'Käynnissä';

  @override
  String get headingToPickup => 'Matkalla noutopaikkaan';

  @override
  String get headingToDropoff => 'Matkalla toimituspaikkaan';

  @override
  String get atPickupLocation => 'Noutopaikalla';

  @override
  String get atDropoffLocation => 'Toimituspaikalla';

  @override
  String get orderId => 'Tilaus-ID';

  @override
  String get customer => 'Asiakas';

  @override
  String get itemsOrdered => 'Tuotteet';

  @override
  String get callCustomer => 'Soita asiakkaalle';

  @override
  String get distance => 'Etäisyys';

  @override
  String get estimatedTime => 'Arvioitu aika';

  @override
  String get yourDistanceTo => 'Etäisyytesi kohteeseen';

  @override
  String get km => 'km';

  @override
  String get min => 'min';

  @override
  String get startNavigation => 'Aloita navigointi';

  @override
  String get arrivedAtPickup => 'Saavuit noutopaikkaan';

  @override
  String get startDelivery => 'Aloita toimitus';

  @override
  String get arrivedAtDropoff => 'Saavuit toimituspaikkaan';

  @override
  String get completeOrder => 'Suorita tilaus loppuun';

  @override
  String get markAsDelivered => 'Merkitse toimitetuksi';

  @override
  String get acceptOrderConfirmation =>
      'Haluatko varmasti hyväksyä tämän tilauksen?';

  @override
  String get rejectOrderConfirmation =>
      'Haluatko varmasti hylätä tämän tilauksen?';

  @override
  String get startDeliveryConfirmation =>
      'Vahvista, että olet noutanut tilauksen ja aloitat toimituksen?';

  @override
  String get arrivedAtDropoffConfirmation =>
      'Vahvista, että olet saapunut toimituspaikkaan?';

  @override
  String get completeOrderConfirmation =>
      'Vahvista, että olet suorittanut tämän toimituksen?';

  @override
  String get updatingStatus => 'Päivitetään tilaa...';

  @override
  String get tip => 'Tippi';

  @override
  String get earnings_label => 'Ansiot';

  @override
  String get deliveryFee => 'Toimitusmaksu';

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
  String get total => 'Yhteensä';

  @override
  String get currentOrders => 'Nykyiset tilaukset';

  @override
  String get orderHistory => 'Tilaushistoria';

  @override
  String get noOrdersYet => 'Ei tilauksia vielä';

  @override
  String get noActiveOrders => 'Ei aktiivisia tilauksia';

  @override
  String get waitingForOrders => 'Odotetaan uusia tilauksia...';

  @override
  String get totalOrders => 'Tilaukset yhteensä';

  @override
  String get totalEarnings => 'Ansiot yhteensä';

  @override
  String get avgTripTime => 'Keskim. matka-aika';

  @override
  String get completionRate => 'Suoritusaste';

  @override
  String get rating => 'Arvosana';

  @override
  String get todayEarnings => 'Tämän päivän ansiot';

  @override
  String get weeklyEarnings => 'Viikkoansiot';

  @override
  String get monthlyEarnings => 'Kuukausiansiot';

  @override
  String get lastMonthEarnings => 'Edellisen kuukauden ansiot';

  @override
  String get viewPayslips => 'Näytä palkkakuitit';

  @override
  String get payslipsSentEmail => 'Palkkakuitit lähetetään sähköpostiisi';

  @override
  String get settings => 'Asetukset';

  @override
  String get language => 'Kieli';

  @override
  String get english => 'Englanti';

  @override
  String get german => 'Saksa';

  @override
  String get french => 'Ranska';

  @override
  String get arabic => 'Arabia';

  @override
  String get luxembourgish => 'Luxemburg';

  @override
  String get italian => 'Italia';

  @override
  String get dutch => 'Hollanti';

  @override
  String get swedish => 'Ruotsi';

  @override
  String get norwegian => 'Norja';

  @override
  String get danish => 'Tanska';

  @override
  String get finnish => 'Suomi';

  @override
  String get theme => 'Teema';

  @override
  String get lightMode => 'Vaalea tila';

  @override
  String get darkMode => 'Tumma tila';

  @override
  String get systemDefault => 'Järjestelmän oletus';

  @override
  String get notifications => 'Ilmoitukset';

  @override
  String get orderNotifications => 'Tilausilmoitukset';

  @override
  String get promotionalNotifications => 'Kampanjailmoitukset';

  @override
  String get soundEnabled => 'Ääni käytössä';

  @override
  String get vibrationEnabled => 'Värinä käytössä';

  @override
  String get notificationSoundRepeats => 'Ilmoitus??nen toistot';

  @override
  String notificationSoundRepeatsEnabledDesc(int count) {
    return 'Toista merkki??ni $count kertaa jokaiselle ilmoitukselle.';
  }

  @override
  String get notificationSoundRepeatsDisabledDesc =>
      'Ota ??ni ensin k?ytt??n valitaksesi, montako kertaa merkki??ni toistetaan.';

  @override
  String get notificationSoundRepeatsPickerDesc =>
      'Valitse, montako kertaa merkki??ni toistetaan jokaiselle ilmoitukselle.';

  @override
  String get notificationRepeatTime => '1 kerran';

  @override
  String notificationRepeatTimes(int count) {
    return '$count kertaa';
  }

  @override
  String get noNotifications => 'Ei ilmoituksia vielä';

  @override
  String get noNotificationsDesc => 'Ilmoituksesi näkyvät täällä';

  @override
  String get today => 'Tänään';

  @override
  String get yesterday => 'Eilen';

  @override
  String get earlier => 'Aiemmin';

  @override
  String get markAllRead => 'Merkitse kaikki luetuiksi';

  @override
  String get clearAll => 'Tyhjennä kaikki';

  @override
  String get newOrderReceived => 'Uusi tilaus vastaanotettu';

  @override
  String get orderAcceptedNotif => 'Tilaus hyväksytty onnistuneesti';

  @override
  String get orderDeliveredNotif => 'Tilaus toimitettu onnistuneesti';

  @override
  String get earningsReceived => 'Ansiot vastaanotettu';

  @override
  String get weeklyReportReady => 'Viikkoraportti on valmis';

  @override
  String get accountUpdated => 'Tili päivitetty';

  @override
  String get account => 'Tili';

  @override
  String get editProfile => 'Muokkaa profiilia';

  @override
  String get changePassword => 'Vaihda salasana';

  @override
  String get privacyPolicy => 'Tietosuojakäytäntö';

  @override
  String get termsOfService => 'Käyttöehdot';

  @override
  String get helpSupport => 'Ohje ja tuki';

  @override
  String get contactUs => 'Ota yhteyttä';

  @override
  String get logout => 'Kirjaudu ulos';

  @override
  String get logoutConfirm => 'Haluatko varmasti kirjautua ulos?';

  @override
  String get deleteAccount => 'Poista tili';

  @override
  String get deleteAccountConfirm =>
      'Haluatko varmasti poistaa tilisi? Tätä toimintoa ei voi peruuttaa.';

  @override
  String get networkError => 'Verkkovirhe. Tarkista yhteytesi.';

  @override
  String get somethingWentWrong => 'Jokin meni pieleen. Yritä uudelleen.';

  @override
  String get sessionExpired => 'Istunto vanhentunut. Kirjaudu uudelleen.';

  @override
  String get locationPermissionDenied => 'Sijaintilupa evätty';

  @override
  String get enableLocationServices =>
      'Ota sijaintipalvelut käyttöön jatkaaksesi';

  @override
  String version(String version) {
    return 'Versio $version';
  }

  @override
  String get goodMorning => 'Hyvää huomenta';

  @override
  String get goodAfternoon => 'Hyvää iltapäivää';

  @override
  String get goodEvening => 'Hyvää iltaa';

  @override
  String get locationRequired => 'Sijainti vaaditaan';

  @override
  String get enableLocationAccess =>
      'Ota sijainnin käyttöoikeus käyttöön vastaanottaaksesi tilauksia.';

  @override
  String get enable => 'Ota käyttöön';

  @override
  String get pleaseEnableLocationInSettings =>
      'Ota sijainti käyttöön asetuksissa.';

  @override
  String get backgroundLocationTitle => 'Salli sijainti taustalla';

  @override
  String get backgroundLocationMessage =>
      'Jotta TaybGo voi lähettää sijaintisi myös taustalla, avaa asetukset ja valitse ”Salli aina”.';

  @override
  String get gpsDisabled => 'GPS pois käytöstä';

  @override
  String get pleaseEnableGps => 'Ota GPS käyttöön vastaanottaaksesi tilauksia.';

  @override
  String get failedToUpdateStatus => 'Tilan päivitys epäonnistui';

  @override
  String get ok => 'OK';

  @override
  String get accountUnderReview => 'Tili tarkistettavana';

  @override
  String get accountBeingVerified =>
      'Tiliäsi tarkistetaan. Saat ilmoituksen kun se on hyväksytty.';

  @override
  String get receivingOrders => 'Vastaanotetaan tilauksia';

  @override
  String get goOnlineToStart => 'Mene verkkoon aloittaaksesi';

  @override
  String get noRecentOrders => 'Ei viimeaikaisia tilauksia';

  @override
  String get headToPickup => 'Suuntaa noutoon';

  @override
  String get onTheWay => 'Matkalla';

  @override
  String get atDelivery => 'Toimituspaikalla';

  @override
  String get continueText => 'Jatka';

  @override
  String get week => 'Viikko';

  @override
  String get month => 'Kuukausi';

  @override
  String get avgPerOrder => 'Keskim./Tilaus';

  @override
  String get allTime => 'Yhteensä';

  @override
  String get noEarningsData => 'Ei ansiotietoja';

  @override
  String get completeOrdersToSeeEarnings =>
      'Suorita tilauksia nähdäksesi ansiosi';

  @override
  String get verified => 'Vahvistettu';

  @override
  String get approved => 'Hyväksytty';

  @override
  String joinedOn(Object date) {
    return 'Liittynyt $date';
  }

  @override
  String get driver => 'Kuljettaja';

  @override
  String get knowledgeBase => 'Tietopankki';

  @override
  String get searchForHelp => 'Hae apua...';

  @override
  String get noArticlesFound => 'Artikkeleita ei löytynyt';

  @override
  String get tryDifferentSearch => 'Kokeile toista hakusanaa';

  @override
  String get noCategoriesAvailable => 'Ei kategorioita saatavilla';

  @override
  String articlesCount(int count) {
    return '$count artikkelia';
  }

  @override
  String get articleNotFound => 'Artikkelia ei löytynyt';

  @override
  String get wasArticleHelpful => 'Oliko tämä artikkeli hyödyllinen?';

  @override
  String get thankYouFeedback => 'Kiitos palautteestasi!';

  @override
  String get willImproveArticle =>
      'Työskentelemme tämän artikkelin parantamiseksi.';

  @override
  String get relatedArticles => 'Aiheeseen liittyvät artikkelit';

  @override
  String get kbTip => 'Vinkki';

  @override
  String get kbWarning => 'Varoitus';

  @override
  String get yes => 'Kyllä';

  @override
  String get no => 'Ei';

  @override
  String get article => 'Artikkeli';

  @override
  String get browseKnowledgeBase => 'Selaa tietopankkia';

  @override
  String sectionsCount(int count) {
    return '$count osiota';
  }

  @override
  String minRead(int count) {
    return '$count min lukuaika';
  }

  @override
  String get tourAccountUnderReviewTitle => 'Tili tarkistettavana';

  @override
  String get tourAccountUnderReviewDesc =>
      'Tiliäsi tarkistetaan. Voit tutustua sovellukseen odottaessasi hyväksyntää.';

  @override
  String get tourGoOnlineTitle => 'Mene verkkoon vastaanottaaksesi tilauksia';

  @override
  String get tourGoOnlineDesc =>
      'Kytke tämä kytkin päälle, kun olet valmis hyväksymään toimituksia. Voit mennä offline-tilaan milloin tahansa.';

  @override
  String get tourDailyStatsTitle => 'Päivittäiset tilastosi';

  @override
  String get tourDailyStatsDesc =>
      'Seuraa tilauksiasi, ansioitasi ja arvosanaasi täällä. Tilastot päivittyvät reaaliajassa.';

  @override
  String get tourNewOrderTitle => 'Uusi tilaus vastaanotettu!';

  @override
  String get tourNewOrderDesc =>
      'Näin uudet tilaukset näkyvät. Tarkista nouto, toimitus, etäisyys ja maksu.';

  @override
  String get tourOrdersTabTitle => 'Tilaukset-välilehti';

  @override
  String get tourOrdersTabDesc =>
      'Vaihda nykyisten tilausten ja tilaushistorian välillä.';

  @override
  String get tourTotalEarningsTitle => 'Kokonaisansiosi';

  @override
  String get tourTotalEarningsDesc =>
      'Seuraa kaikkia ansioitasi täällä — peruspalkka, tipit ja bonukset.';

  @override
  String get tourEarningsBreakdownTitle => 'Ansioerittelyt';

  @override
  String get tourEarningsBreakdownDesc =>
      'Näe tilausten kokonaismäärä ja keskimääräiset ansiot tilausta kohden.';

  @override
  String get tourRouteDetailsTitle => 'Reitin tiedot';

  @override
  String get tourRouteDetailsDesc =>
      'Näe koko nouto- ja toimitusreitti osoitteineen, etäisyyksineen ja arvioituine aikoineen.';

  @override
  String get tourYourEarningsTitle => 'Ansiosi';

  @override
  String get tourYourEarningsDesc =>
      'Näe koko maksuerittely — toimitusmaksu, tippi ja kokonaismaksu.';

  @override
  String get tourNavActionsTitle => 'Navigointi & Toiminnot';

  @override
  String get tourNavActionsDesc =>
      'Navigoi nouto-/toimituspaikkaan tai päivitä tilauksen tilaa matkan aikana.';

  @override
  String get tourTurnByTurnTitle => 'Askel askeleelta -navigointi';

  @override
  String get tourTurnByTurnDesc =>
      'Seuraa reaaliaikaisia ohjeita nouto- tai toimituspaikkaasi.';

  @override
  String get tourTripControlsTitle => 'Matkan hallinta';

  @override
  String get tourTripControlsDesc =>
      'Vaihda nouto- ja toimitusreittien välillä, näe kohteen tiedot ja ansiot.';

  @override
  String get tourUpdateStatusTitle => 'Päivitä tila';

  @override
  String get tourUpdateStatusDesc =>
      'Napauta merkitäksesi avainvaiheet — Matkalla, Toimitettu tai Valmis.';

  @override
  String get tourAppSettingsTitle => 'Sovelluksen asetukset';

  @override
  String get tourAppSettingsDesc =>
      'Vaihda kieltä, teemaa ja käytä tietopankkia avun saamiseksi.';

  @override
  String get tourKnowledgeBaseTitle => 'Tietopankki';

  @override
  String get tourKnowledgeBaseDesc =>
      'Selaa askel askeleelta -oppaita, vinkkejä ja vastauksia yleisiin kysymyksiin.';

  @override
  String get tourSkipBtn => 'Ohita';

  @override
  String get tourBackBtn => 'Takaisin';

  @override
  String get tourNextBtn => 'Seuraava';

  @override
  String get tourDoneBtn => 'Valmis';

  @override
  String get tourWelcomeTitle => 'Tervetuloa TaybGo:hon!';

  @override
  String get tourWelcomeDesc =>
      'Tee nopea kierros oppiaksesi käyttämään sovellusta';

  @override
  String get tourSkipForNow => 'Ohita toistaiseksi';

  @override
  String get tourStartBtn => 'Aloita kierros';

  @override
  String get tourCompleteTitle => 'Kierros valmis!';

  @override
  String get tourCompleteDesc =>
      'Olet valmis aloittamaan tilausten vastaanottamisen ja ansaitsemisen TaybGo:lla!';

  @override
  String get tourBrowseKb => 'Selaa tietopankkia';

  @override
  String get tourGetStarted => 'Aloita';

  @override
  String get selectCountry => 'Valitse maa';

  @override
  String get searchCountry => 'Hae maata...';

  @override
  String get secure => 'Turvallinen';

  @override
  String get wellSendVerificationCode => 'Lähetämme sinulle vahvistuskoodin';

  @override
  String get byConsentTerms =>
      'Jatkamalla hyväksyt käyttöehdot ja tietosuojakäytännön';

  @override
  String get otpSentSuccessfully => 'Vahvistuskoodi lähetetty onnistuneesti';

  @override
  String resendIn(int seconds) {
    return 'Lähetä uudelleen ${seconds}s kuluttua';
  }

  @override
  String get resendCode => 'Lähetä koodi uudelleen';

  @override
  String get verify => 'Vahvista';

  @override
  String get tellUsAboutYourself => 'Kerro meille itsestäsi';

  @override
  String get basicInfoSubtitle =>
      'Tarvitsemme joitain perustietoja kuljettajatilisi perustamiseen';

  @override
  String get enterYourFullName => 'Syötä koko nimesi';

  @override
  String get notAvailable => 'Ei saatavilla';

  @override
  String get verifiedViaOtp => 'Vahvistettu OTP:llä';

  @override
  String get selectYourVehicle => 'Valitse ajoneuvosi';

  @override
  String get vehicleStepSubtitle =>
      'Valitse ajoneuvotyyppi, jota käytät toimituksiin';

  @override
  String get chooseYourServices => 'Valitse palvelusi';

  @override
  String get servicesStepSubtitle =>
      'Valitse toimitustyypit, joita haluat hyväksyä';

  @override
  String get deliverFoodDesc => 'Toimita ruokaa ravintoloista';

  @override
  String get deliverPackagesDesc => 'Toimita paketteja ja lähetyksiä';

  @override
  String get transportPassengersDesc => 'Kuljeta matkustajia';

  @override
  String get changeServiceLater =>
      'Voit muuttaa palveluasetuksiasi myöhemmin asetuksissa';

  @override
  String get back => 'Takaisin';

  @override
  String get completeRegistration => 'Suorita rekisteröinti loppuun';

  @override
  String get pleaseEnterYourName => 'Syötä nimesi';

  @override
  String get pleaseSelectService => 'Valitse vähintään yksi palvelutyyppi';

  @override
  String get pleaseUploadDriversLicense => 'Lataa ajokorttisi';

  @override
  String get pleaseUploadNationalId => 'Lataa henkilötodistuksesi';

  @override
  String pleaseUploadDocument(Object documentName) {
    return 'Lataa $documentName';
  }

  @override
  String get registrationFailed =>
      'Rekisteröinti epäonnistui. Yritä uudelleen.';

  @override
  String get stepPersonal => 'Henkilökohtainen';

  @override
  String get stepVehicle => 'Ajoneuvo';

  @override
  String get stepServices => 'Palvelut';

  @override
  String applicationStepProgress(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String applicationNextStep(String step) {
    return 'Next: $step';
  }

  @override
  String get ecoFriendlyOption => 'Ympäristöystävällinen vaihtoehto';

  @override
  String get fastAndAgile => 'Nopea ja ketterä';

  @override
  String get mostVersatile => 'Monipuolisin';

  @override
  String get largeDeliveries => 'Suuret toimitukset';

  @override
  String get deleteDataWarning =>
      'Tämä poistaa pysyvästi kaikki tietosi, mukaan lukien profiilin, arvosanat ja tilaushistorian.';

  @override
  String get finalConfirmation => 'Viimeinen vahvistus';

  @override
  String get finalDeleteWarning =>
      'Oletko aivan varma? Tätä toimintoa ei voi peruuttaa ja menetät kaikki tietosi.';

  @override
  String get deleteMyAccount => 'Poista tilini';

  @override
  String get deletingAccount => 'Poistetaan tiliä...';

  @override
  String get accountDeletedSuccessfully => 'Tili poistettu onnistuneesti';

  @override
  String failedToDeleteAccount(String error) {
    return 'Tilin poistaminen epäonnistui: $error';
  }

  @override
  String get justNow => 'Juuri nyt';

  @override
  String minutesAgo(int minutes) {
    return '${minutes}min sitten';
  }

  @override
  String hoursAgo(int hours) {
    return '${hours}t sitten';
  }

  @override
  String daysAgo(int days) {
    return '${days}pv sitten';
  }

  @override
  String get clearAllNotificationsConfirm =>
      'Haluatko varmasti tyhjentää kaikki ilmoitukset?';

  @override
  String get failedToLoadNotifications => 'Ilmoitusten lataaminen epäonnistui';

  @override
  String get calculatingRoute => 'Lasketaan reittiä...';

  @override
  String get orderNotFound => 'Tilausta ei löytynyt';

  @override
  String get goBack => 'Takaisin';

  @override
  String get gpsUnavailableTapRetry =>
      'GPS ei saatavilla. Napauta yrittääksesi uudelleen.';

  @override
  String get googleMaps => 'Google Maps';

  @override
  String get fetchingLocation => 'Haetaan sijaintia...';

  @override
  String secondsAgo(int seconds) {
    return '${seconds}s sitten';
  }

  @override
  String get subtotal => 'Välisumma';

  @override
  String get orderType => 'Tyyppi';

  @override
  String get created => 'Luotu';

  @override
  String get accepted => 'Hyväksytty';

  @override
  String get completed => 'Valmis';

  @override
  String get orderPaid => 'Maksettu';

  @override
  String get orderPaidDescription => 'Käteistä ei tarvitse kerätä';

  @override
  String get collectCash => 'Kerää käteinen';

  @override
  String get collectCashReminder => 'Muista kerätä maksu asiakkaalta';

  @override
  String collectCashAmountReminder(String amount) {
    return 'Collect $amount from the customer before completing.';
  }

  @override
  String get locationPermissionLostWhileOnline =>
      'Sijaintioikeus on poistettu käytöstä. Et vastaanota tilauksia ennen kuin se on otettu käyttöön.';

  @override
  String get batteryOptimizationTitle => 'Poista akun optimointi';

  @override
  String get batteryOptimizationMessage =>
      'Jotta reaaliaikainen sijainti pysyy aktiivisena taustalla, aseta TaybGo Driver rajoittamattomaan akun käyttöön Android-asetuksissa.';

  @override
  String get batteryOptimizationBannerMessage =>
      'Akun optimointi voi keskeyttää reaaliaikaisen sijainnin, kun olet online-tilassa. Aseta TaybGo Driver rajoittamattomaan akun käyttöön.';

  @override
  String get profileUpdatedSuccessfully => 'Profiili päivitetty onnistuneesti';

  @override
  String get failedToUpdateProfile => 'Profiilin päivitys epäonnistui';

  @override
  String get supportTickets => 'Tukipyynnöt';

  @override
  String get supportFilterAll => 'Kaikki';

  @override
  String get supportFilterOpen => 'Avoin';

  @override
  String get supportFilterInProgress => 'Käynnissä';

  @override
  String get supportFilterClosed => 'Suljettu';

  @override
  String get supportStatusOpen => 'Avoin';

  @override
  String get supportStatusInProgress => 'Käynnissä';

  @override
  String get supportStatusClosed => 'Suljettu';

  @override
  String get supportPriorityLow => 'Matala';

  @override
  String get supportPriorityMedium => 'Keskitaso';

  @override
  String get supportPriorityHigh => 'Korkea';

  @override
  String get supportNoTickets => 'Ei tukipyyntöjä vielä';

  @override
  String get supportNoTicketsDesc => 'Luo tukipyyntö, jos tarvitset apua';

  @override
  String get supportCreateTicket => 'Luo tukipyyntö';

  @override
  String get supportTicketCreated => 'Tukipyyntö luotu onnistuneesti';

  @override
  String get supportRelatedOrder => 'Liittyvä tilaus';

  @override
  String get supportSubject => 'Aihe';

  @override
  String get supportSubjectHint => 'Lyhyt kuvaus ongelmastasi';

  @override
  String get supportSubjectRequired => 'Aihe on pakollinen';

  @override
  String get supportMessage => 'Viesti';

  @override
  String get supportMessageHint => 'Kuvaile ongelmasi yksityiskohtaisesti...';

  @override
  String get supportMessageRequired => 'Viesti on pakollinen';

  @override
  String get supportSubmitTicket => 'Lähetä tukipyyntö';

  @override
  String get supportSelectOrder => 'Valitse tilaus (valinnainen)';

  @override
  String get supportNoOrder => 'Ei tiettyä tilausta';

  @override
  String get supportTicketDetail => 'Tukipyynnön tiedot';

  @override
  String get supportNoMessages => 'Ei viestejä vielä';

  @override
  String get supportTypeMessage => 'Kirjoita viesti...';

  @override
  String get supportTicketClosed => 'Tämä tukipyyntö on suljettu';

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
  String get file => 'Tiedosto';

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
  String get changelog => 'Muutosloki';

  @override
  String get changelogTitle => 'Mitä uutta?';

  @override
  String get changelogSubtitle =>
      'Tutustu nopeasti TaybGo Driverin uusimpiin parannuksiin.';

  @override
  String get changelogCurrent => 'Nykyinen';

  @override
  String get changelogBuild => 'Koontiversio';

  @override
  String get changelogReleased => 'Julkaistu';

  @override
  String get changelogReleaseNotes => 'Julkaisutiedot';

  @override
  String get changelogHighlights => 'Kohokohdat';

  @override
  String get changelogFixes => 'Korjaukset';

  @override
  String get changelogImprovements => 'Parannukset';

  @override
  String get changelogStability => 'Vakaus';

  @override
  String get changelogPlatform => 'Alusta';

  @override
  String get changelogRelease => 'Julkaisu';

  @override
  String get changelogDateAug20 => '20 August 2026';

  @override
  String get changelogVersion101416ApplicationFlow =>
      'Redesigned the driver application into five focused steps with clearer progress, organized sections, better field guidance, and inline validation.';

  @override
  String get changelogVersion101416Address =>
      'Refactored address entry in registration and Edit Profile around required Google Places search, a clear selected-address summary, complete structured address data, coordinates, and stronger validation.';

  @override
  String get changelogVersion101416Vehicle =>
      'Restored complete vehicle details and added a vehicle-year selector covering 1960 through next year.';

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
  String get changelogDateAug9 => '9. elokuuta 2026';

  @override
  String get changelogDateAug11 => '11. elokuuta 2026';

  @override
  String get changelogVersion1013Address =>
      'Lisättiin valinnaiset jäsennellyt kuljettajan osoitteet koordinaatteineen ja täydellisine osoitetietoineen rekisteröinnin ja profiilin muokkauksen yhteyteen.';

  @override
  String get changelogVersion1013Status =>
      'Pelkkien osoitetietojen päivitykset käyttävät nyt osittaisia PATCH-pyyntöjä ja säilyttävät hyväksytyn kuljettajan tilan.';

  @override
  String get changelogVersion1013Release =>
      'Kuljettajasovelluksen versio 1.0.13+15 julkaistiin.';

  @override
  String get changelogDateMay31 => '31. toukokuuta 2026';

  @override
  String get changelogDateMay24 => '24. toukokuuta 2026';

  @override
  String get changelogDateMay13 => '13. toukokuuta 2026';

  @override
  String get changelogDateMay11 => '11. toukokuuta 2026';

  @override
  String get changelogCurrentTaxi =>
      'Taxi-palvelun valinta rajattiin autonkuljettajille, eivätkä pyöräkuljettajat voi enää ottaa sitä käyttöön rekisteröinnin tai profiilin muokkauksen aikana.';

  @override
  String get changelogVersion1113Upload =>
      'Verkkolatausten muistinkulutusta pienennettiin, jotta asiakirjojen lataaminen olisi luotettavampaa vähätehoisilla laitteilla.';

  @override
  String get changelogCurrentChangelog =>
      'Profiiliin lisättiin lokalisoitu avattava muutosloki, jossa näkyvät julkaisuhistoria, koontiversiot, päivämäärät ja julkaisutiedot.';

  @override
  String get changelogVersion1113Version =>
      'Sovelluksen versio ja julkaisupäivä lisättiin kirjautumisnäyttöön ja verkon aloitusnäyttöön.';

  @override
  String get changelogCurrentRelease =>
      'Sovellus päivitettiin versioon 1.0.12+14 uusimpien kuljettajasovelluksen parannusten kera.';

  @override
  String get changelogVersion1113Release =>
      'Play Kaupan koontiversio päivitettiin versioon 1.0.11+13 (versionumero 13).';

  @override
  String get changelogVersion1112Release =>
      'Kuljettajasovellus julkaistiin versiona 1.0.11+12 ja sen julkaisutiedot tallennettiin.';

  @override
  String get changelogVersion1011Documents =>
      'Autonkuljettajille lisättiin pakollisten asiakirjojen tarkistus.';

  @override
  String get changelogVersion1011Uploads =>
      'Pakolliset asiakirjat merkitään nyt selkeästi ja lataustilan käsittelyä parannettiin.';

  @override
  String get changelogVersion1011Feedback =>
      'Profiilimuutosten tallennuksen tarkistuksia ja virheilmoituksia parannettiin.';

  @override
  String get changelogVersion1011Release =>
      'Kuljettajasovellus julkaistiin versiona 1.0.10+11.';

  @override
  String get changelogVersion0910Crashlytics =>
      'Julkaisuversioiden vakaville virheille lisättiin Crashlytics-raportointi.';

  @override
  String get changelogVersion0910Notifications =>
      'Ilmoitusten elinkaarta, duplikaattien estoa ja tilausilmoitusten käsittelyä parannettiin.';

  @override
  String get changelogVersion0910Platform =>
      'Androidin, iOS:n, macOS:n ja verkon julkaisuasetukset päivitettiin kehitys- ja tuotantoversioille.';

  @override
  String get changelogVersion0910Release =>
      'Kuljettajasovellus julkaistiin versiona 1.0.9+10.';
}

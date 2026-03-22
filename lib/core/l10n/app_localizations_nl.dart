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
  String get reviewSubmit => 'Controleren & Verzenden';

  @override
  String get fullName => 'Volledige naam';

  @override
  String get age => 'Leeftijd';

  @override
  String get dateOfBirth => 'Geboortedatum';

  @override
  String get address => 'Adres';

  @override
  String get city => 'Stad';

  @override
  String get vehicleType => 'Voertuigtype';

  @override
  String get selectVehicleType => 'Selecteer voertuigtype';

  @override
  String get car => 'Auto';

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
  String get uploadDocuments => 'Documenten uploaden';

  @override
  String get driversLicense => 'Rijbewijs';

  @override
  String get nationalId => 'Identiteitskaart';

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
  String get registrationFailed => 'Registratie mislukt. Probeer het opnieuw.';

  @override
  String get stepPersonal => 'Persoonlijk';

  @override
  String get stepVehicle => 'Voertuig';

  @override
  String get stepServices => 'Diensten';

  @override
  String get ecoFriendlyOption => 'Milieuvriendelijke optie';

  @override
  String get fastAndAgile => 'Snel en wendbaar';

  @override
  String get mostVersatile => 'Meest veelzijdig';

  @override
  String get largeDeliveries => 'Grote bezorgingen';

  @override
  String get van => 'Bestelwagen';

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
  String get locationPermissionLostWhileOnline =>
      'Locatietoegang is uitgeschakeld. U ontvangt geen bestellingen totdat dit is ingeschakeld.';

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
  String get enterAge => 'Enter your age';

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
  String get vehicleDetailsTitle => 'Vehicle Details';

  @override
  String get vehicleDetailsSubtitle => 'Tell us more about your vehicle';

  @override
  String get stepDetails => 'Details';

  @override
  String get stepDocuments => 'Docs';

  @override
  String get documentsTitle => 'Upload Documents';

  @override
  String get documentsSubtitle =>
      'Add your documents (optional - you can add them later)';

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
  String get pleaseEnterAge => 'Please enter your age';

  @override
  String get invalidAge => 'Please enter a valid age (18-80)';

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
  String get invalidVehicleYear => 'Please enter a valid year';

  @override
  String get orderAlreadyTaken =>
      'This order was already taken by another driver';

  @override
  String get orderSuggestionExpired => 'This order suggestion has expired';

  @override
  String get failedToAcceptOrder => 'Failed to accept order. Please try again.';

  @override
  String get failedToRejectOrder => 'Failed to reject order';
}

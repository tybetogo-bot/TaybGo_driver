// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get appName => 'TybeToGo Förare';

  @override
  String get welcome => 'Välkommen';

  @override
  String get getStarted => 'Kom igång';

  @override
  String get next => 'Nästa';

  @override
  String get skip => 'Hoppa över';

  @override
  String get done => 'Klar';

  @override
  String get cancel => 'Avbryt';

  @override
  String get confirm => 'Bekräfta';

  @override
  String get save => 'Spara';

  @override
  String get edit => 'Redigera';

  @override
  String get delete => 'Radera';

  @override
  String get retry => 'Försök igen';

  @override
  String get loading => 'Laddar...';

  @override
  String get error => 'Fel';

  @override
  String get success => 'Lyckades';

  @override
  String get seeAll => 'Visa alla';

  @override
  String get or => 'ELLER';

  @override
  String get onboardingTitle1 => 'Börja tjäna idag';

  @override
  String get onboardingDesc1 =>
      'Gå med tusentals förare som tjänar på sitt eget schema';

  @override
  String get onboardingTitle2 => 'Acceptera beställningar enkelt';

  @override
  String get onboardingDesc2 =>
      'Få aviseringar om nya beställningar och acceptera med ett tryck';

  @override
  String get onboardingTitle3 => 'Navigera & Leverera';

  @override
  String get onboardingDesc3 =>
      'Inbyggd navigering hjälper dig att nå destinationer snabbare';

  @override
  String get phoneNumber => 'Telefonnummer';

  @override
  String get enterPhoneNumber => 'Ange ditt telefonnummer';

  @override
  String get phoneHint => '+46 70 123 45 67';

  @override
  String get sendOtp => 'Skicka kod';

  @override
  String get verifyOtp => 'Verifiera kod';

  @override
  String get enterOtp => 'Ange koden vi skickade till';

  @override
  String get resendOtp => 'Skicka kod igen';

  @override
  String resendOtpIn(int seconds) {
    return 'Skicka kod igen om ${seconds}s';
  }

  @override
  String get invalidOtp => 'Ogiltig verifieringskod';

  @override
  String get otpSent => 'Verifieringskod skickad';

  @override
  String get email => 'E-post';

  @override
  String get enterEmail => 'Ange din e-post';

  @override
  String get signUpWithApple => 'Registrera med Apple';

  @override
  String get signUpWithGoogle => 'Registrera med Google';

  @override
  String get forgotPassword => 'Glömt lösenord';

  @override
  String get driverApplication => 'Föraransökan';

  @override
  String get personalInfo => 'Personlig information';

  @override
  String get vehicleInfo => 'Fordonsinformation';

  @override
  String get documents => 'Dokument';

  @override
  String get reviewSubmit => 'Granska & Skicka';

  @override
  String get fullName => 'Fullständigt namn';

  @override
  String get age => 'Ålder';

  @override
  String get dateOfBirth => 'Födelsedatum';

  @override
  String get address => 'Adress';

  @override
  String get city => 'Stad';

  @override
  String get vehicleType => 'Fordonstyp';

  @override
  String get selectVehicleType => 'Välj fordonstyp';

  @override
  String get car => 'Bil';

  @override
  String get motorcycle => 'Motorcykel';

  @override
  String get bicycle => 'Cykel';

  @override
  String get scooter => 'Skoter';

  @override
  String get licensePlate => 'Registreringsskylt';

  @override
  String get vehicleModel => 'Fordonsmodell';

  @override
  String get vehicleYear => 'Fordonsår';

  @override
  String get vehicleColor => 'Fordonsfärg';

  @override
  String get serviceType => 'Tjänstetyp';

  @override
  String get selectServiceType => 'Vilka tjänster kommer du att erbjuda?';

  @override
  String get foodDelivery => 'Matleverans';

  @override
  String get shipping => 'Frakt';

  @override
  String get taxi => 'Taxi';

  @override
  String get uploadDocuments => 'Ladda upp dokument';

  @override
  String get driversLicense => 'Körkort';

  @override
  String get nationalId => 'Identitetskort';

  @override
  String get vehicleRegistration => 'Fordonsregistrering';

  @override
  String get insurance => 'Försäkring';

  @override
  String get profilePhoto => 'Profilbild';

  @override
  String get uploadPhoto => 'Ladda upp foto';

  @override
  String get takePhoto => 'Ta foto';

  @override
  String get chooseFromGallery => 'Välj från galleri';

  @override
  String get submitApplication => 'Skicka ansökan';

  @override
  String get applicationSubmitted => 'Ansökan skickad';

  @override
  String get applicationPending => 'Din ansökan granskas';

  @override
  String get applicationApproved => 'Ansökan godkänd';

  @override
  String get applicationRejected => 'Ansökan avvisad';

  @override
  String get pendingApprovalMessage =>
      'Vi granskar dina dokument. Det tar vanligtvis 24-48 timmar.';

  @override
  String get home => 'Hem';

  @override
  String get orders => 'Beställningar';

  @override
  String get recentOrders => 'Senaste beställningar';

  @override
  String get earnings => 'Inkomster';

  @override
  String get profile => 'Profil';

  @override
  String get search => 'Sök';

  @override
  String get online => 'Online';

  @override
  String get offline => 'Offline';

  @override
  String get goOnline => 'Gå online';

  @override
  String get goOffline => 'Gå offline';

  @override
  String get tapToGoOnline => 'Tryck för att gå online';

  @override
  String get tapToGoOffline => 'Tryck för att gå offline';

  @override
  String get youAreOnline => 'Du är online och redo att ta emot beställningar';

  @override
  String get youAreOffline =>
      'Du är offline. Gå online för att ta emot beställningar';

  @override
  String get newOrder => 'Ny beställning';

  @override
  String get newOrderTitle => 'Ny beställning!';

  @override
  String get newOrderSubtitle => 'Acceptera innan tiden tar slut';

  @override
  String get orderDetails => 'Beställningsdetaljer';

  @override
  String get navigate => 'Navigera';

  @override
  String get details => 'Detaljer';

  @override
  String get acceptOrder => 'Acceptera beställning';

  @override
  String get rejectOrder => 'Avvisa beställning';

  @override
  String get accept => 'Acceptera';

  @override
  String get reject => 'Avvisa';

  @override
  String acceptIn(int seconds) {
    return 'Acceptera om ${seconds}s';
  }

  @override
  String get orderAccepted => 'Beställning accepterad';

  @override
  String get items => 'artiklar';

  @override
  String get time => 'Tid';

  @override
  String get orderRejected => 'Beställning avvisad';

  @override
  String get orderCompleted => 'Beställning slutförd';

  @override
  String get orderCancelled => 'Beställning avbruten';

  @override
  String get pickup => 'Upphämtning';

  @override
  String get dropoff => 'Avlämning';

  @override
  String get pickupLocation => 'Upphämtningsplats';

  @override
  String get dropoffLocation => 'Avlämningsplats';

  @override
  String get route => 'Rutt';

  @override
  String get inProgress => 'Pågår';

  @override
  String get headingToPickup => 'På väg till upphämtningsplats';

  @override
  String get headingToDropoff => 'På väg till avlämningsplats';

  @override
  String get atPickupLocation => 'Vid upphämtningsplats';

  @override
  String get atDropoffLocation => 'Vid avlämningsplats';

  @override
  String get orderId => 'Beställnings-ID';

  @override
  String get customer => 'Kund';

  @override
  String get itemsOrdered => 'Artiklar';

  @override
  String get callCustomer => 'Ring kund';

  @override
  String get distance => 'Avstånd';

  @override
  String get estimatedTime => 'Beräknad tid';

  @override
  String get yourDistanceTo => 'Ditt avstånd till';

  @override
  String get km => 'km';

  @override
  String get min => 'min';

  @override
  String get startNavigation => 'Starta navigering';

  @override
  String get arrivedAtPickup => 'Ankom till upphämtning';

  @override
  String get startDelivery => 'Starta leverans';

  @override
  String get arrivedAtDropoff => 'Ankom till avlämning';

  @override
  String get completeOrder => 'Slutför beställning';

  @override
  String get markAsDelivered => 'Markera som levererad';

  @override
  String get acceptOrderConfirmation =>
      'Är du säker på att du vill acceptera denna beställning?';

  @override
  String get rejectOrderConfirmation =>
      'Är du säker på att du vill avvisa denna beställning?';

  @override
  String get startDeliveryConfirmation =>
      'Bekräfta att du har hämtat beställningen och påbörjar leveransen?';

  @override
  String get arrivedAtDropoffConfirmation =>
      'Bekräfta att du har ankommit till avlämningsplatsen?';

  @override
  String get completeOrderConfirmation =>
      'Bekräfta att du har slutfört denna leverans?';

  @override
  String get updatingStatus => 'Uppdaterar status...';

  @override
  String get tip => 'Dricks';

  @override
  String get earnings_label => 'Inkomster';

  @override
  String get deliveryFee => 'Leveransavgift';

  @override
  String get total => 'Totalt';

  @override
  String get currentOrders => 'Aktuella beställningar';

  @override
  String get orderHistory => 'Beställningshistorik';

  @override
  String get noOrdersYet => 'Inga beställningar ännu';

  @override
  String get noActiveOrders => 'Inga aktiva beställningar';

  @override
  String get waitingForOrders => 'Väntar på nya beställningar...';

  @override
  String get totalOrders => 'Totala beställningar';

  @override
  String get totalEarnings => 'Totala inkomster';

  @override
  String get avgTripTime => 'Genomsn. restid';

  @override
  String get completionRate => 'Slutförandegrad';

  @override
  String get rating => 'Betyg';

  @override
  String get todayEarnings => 'Dagens inkomster';

  @override
  String get weeklyEarnings => 'Veckovis inkomster';

  @override
  String get monthlyEarnings => 'Månadsvis inkomster';

  @override
  String get lastMonthEarnings => 'Förra månadens inkomster';

  @override
  String get viewPayslips => 'Visa lönebesked';

  @override
  String get payslipsSentEmail => 'Lönebesked skickas till din e-post';

  @override
  String get settings => 'Inställningar';

  @override
  String get language => 'Språk';

  @override
  String get english => 'Engelska';

  @override
  String get german => 'Tyska';

  @override
  String get french => 'Franska';

  @override
  String get arabic => 'Arabiska';

  @override
  String get luxembourgish => 'Luxemburgska';

  @override
  String get italian => 'Italienska';

  @override
  String get dutch => 'Nederländska';

  @override
  String get swedish => 'Svenska';

  @override
  String get norwegian => 'Norska';

  @override
  String get danish => 'Danska';

  @override
  String get finnish => 'Finska';

  @override
  String get theme => 'Tema';

  @override
  String get lightMode => 'Ljust läge';

  @override
  String get darkMode => 'Mörkt läge';

  @override
  String get systemDefault => 'Systemstandard';

  @override
  String get notifications => 'Aviseringar';

  @override
  String get orderNotifications => 'Beställningsaviseringar';

  @override
  String get promotionalNotifications => 'Kampanjaviseringar';

  @override
  String get soundEnabled => 'Ljud aktiverat';

  @override
  String get vibrationEnabled => 'Vibration aktiverad';

  @override
  String get noNotifications => 'Inga aviseringar ännu';

  @override
  String get noNotificationsDesc => 'Dina aviseringar visas här';

  @override
  String get today => 'Idag';

  @override
  String get yesterday => 'Igår';

  @override
  String get earlier => 'Tidigare';

  @override
  String get markAllRead => 'Markera alla som lästa';

  @override
  String get clearAll => 'Rensa alla';

  @override
  String get newOrderReceived => 'Ny beställning mottagen';

  @override
  String get orderAcceptedNotif => 'Beställning accepterad';

  @override
  String get orderDeliveredNotif => 'Beställning levererad';

  @override
  String get earningsReceived => 'Inkomster mottagna';

  @override
  String get weeklyReportReady => 'Veckorapporten är klar';

  @override
  String get accountUpdated => 'Konto uppdaterat';

  @override
  String get account => 'Konto';

  @override
  String get editProfile => 'Redigera profil';

  @override
  String get changePassword => 'Ändra lösenord';

  @override
  String get privacyPolicy => 'Integritetspolicy';

  @override
  String get termsOfService => 'Användarvillkor';

  @override
  String get helpSupport => 'Hjälp & Support';

  @override
  String get contactUs => 'Kontakta oss';

  @override
  String get logout => 'Logga ut';

  @override
  String get logoutConfirm => 'Är du säker på att du vill logga ut?';

  @override
  String get deleteAccount => 'Radera konto';

  @override
  String get deleteAccountConfirm =>
      'Är du säker på att du vill radera ditt konto? Denna åtgärd kan inte ångras.';

  @override
  String get networkError => 'Nätverksfel. Kontrollera din anslutning.';

  @override
  String get somethingWentWrong => 'Något gick fel. Försök igen.';

  @override
  String get sessionExpired => 'Sessionen har gått ut. Logga in igen.';

  @override
  String get locationPermissionDenied => 'Platstillstånd nekad';

  @override
  String get enableLocationServices =>
      'Aktivera platstjänster för att fortsätta';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get goodMorning => 'God morgon';

  @override
  String get goodAfternoon => 'God eftermiddag';

  @override
  String get goodEvening => 'God kväll';

  @override
  String get locationRequired => 'Plats krävs';

  @override
  String get enableLocationAccess =>
      'Aktivera platsåtkomst för att ta emot beställningar.';

  @override
  String get enable => 'Aktivera';

  @override
  String get pleaseEnableLocationInSettings =>
      'Aktivera plats i inställningarna.';

  @override
  String get gpsDisabled => 'GPS inaktiverad';

  @override
  String get pleaseEnableGps => 'Aktivera GPS för att ta emot beställningar.';

  @override
  String get failedToUpdateStatus => 'Kunde inte uppdatera status';

  @override
  String get ok => 'OK';

  @override
  String get accountUnderReview => 'Konto granskas';

  @override
  String get accountBeingVerified =>
      'Ditt konto verifieras. Du meddelas när det godkänns.';

  @override
  String get receivingOrders => 'Tar emot beställningar';

  @override
  String get goOnlineToStart => 'Gå online för att starta';

  @override
  String get noRecentOrders => 'Inga senaste beställningar';

  @override
  String get headToPickup => 'Åk till upphämtning';

  @override
  String get onTheWay => 'På väg';

  @override
  String get atDelivery => 'Vid leverans';

  @override
  String get continueText => 'Fortsätt';

  @override
  String get week => 'Vecka';

  @override
  String get month => 'Månad';

  @override
  String get avgPerOrder => 'Genomsn./Beställning';

  @override
  String get allTime => 'Totalt';

  @override
  String get noEarningsData => 'Inga inkomstdata';

  @override
  String get completeOrdersToSeeEarnings =>
      'Slutför beställningar för att se dina inkomster';

  @override
  String get verified => 'Verifierad';

  @override
  String get driver => 'Förare';

  @override
  String get knowledgeBase => 'Kunskapsbank';

  @override
  String get searchForHelp => 'Sök efter hjälp...';

  @override
  String get noArticlesFound => 'Inga artiklar hittades';

  @override
  String get tryDifferentSearch => 'Prova en annan sökterm';

  @override
  String get noCategoriesAvailable => 'Inga kategorier tillgängliga';

  @override
  String articlesCount(int count) {
    return '$count artiklar';
  }

  @override
  String get articleNotFound => 'Artikel hittades inte';

  @override
  String get wasArticleHelpful => 'Var denna artikel hjälpsam?';

  @override
  String get thankYouFeedback => 'Tack för din feedback!';

  @override
  String get willImproveArticle => 'Vi kommer att förbättra denna artikel.';

  @override
  String get relatedArticles => 'Relaterade artiklar';

  @override
  String get kbTip => 'Tips';

  @override
  String get kbWarning => 'Varning';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nej';

  @override
  String get article => 'Artikel';

  @override
  String get browseKnowledgeBase => 'Bläddra i kunskapsbanken';

  @override
  String sectionsCount(int count) {
    return '$count avsnitt';
  }

  @override
  String minRead(int count) {
    return '$count min läsning';
  }

  @override
  String get tourAccountUnderReviewTitle => 'Konto granskas';

  @override
  String get tourAccountUnderReviewDesc =>
      'Ditt konto verifieras. Du kan utforska appen medan du väntar på godkännande.';

  @override
  String get tourGoOnlineTitle => 'Gå online för att ta emot beställningar';

  @override
  String get tourGoOnlineDesc =>
      'Aktivera denna knapp när du är redo att acceptera leveranser. Du kan gå offline när som helst.';

  @override
  String get tourDailyStatsTitle => 'Din dagliga statistik';

  @override
  String get tourDailyStatsDesc =>
      'Följ dina beställningar, inkomster och betyg här. Statistiken uppdateras i realtid.';

  @override
  String get tourNewOrderTitle => 'Ny beställning mottagen!';

  @override
  String get tourNewOrderDesc =>
      'Så här ser nya beställningar ut. Granska upphämtning, avlämning, avstånd och betalning.';

  @override
  String get tourOrdersTabTitle => 'Beställningsflik';

  @override
  String get tourOrdersTabDesc =>
      'Växla mellan aktuella beställningar och beställningshistorik.';

  @override
  String get tourTotalEarningsTitle => 'Dina totala inkomster';

  @override
  String get tourTotalEarningsDesc =>
      'Följ alla dina inkomster här — grundlön, dricks och bonusar.';

  @override
  String get tourEarningsBreakdownTitle => 'Inkomstöversikt';

  @override
  String get tourEarningsBreakdownDesc =>
      'Se dina totala beställningar och genomsnittliga inkomster per beställning.';

  @override
  String get tourRouteDetailsTitle => 'Ruttdetaljer';

  @override
  String get tourRouteDetailsDesc =>
      'Se den fullständiga upphämtnings- och avlämningsrutten med adresser, avstånd och beräknad tid.';

  @override
  String get tourYourEarningsTitle => 'Dina inkomster';

  @override
  String get tourYourEarningsDesc =>
      'Se den fullständiga betalningsöversikten — leveransavgift, dricks och total utbetalning.';

  @override
  String get tourNavActionsTitle => 'Navigering & Åtgärder';

  @override
  String get tourNavActionsDesc =>
      'Navigera till upphämtning/avlämning eller uppdatera beställningsstatus under resan.';

  @override
  String get tourTurnByTurnTitle => 'Steg-för-steg navigering';

  @override
  String get tourTurnByTurnDesc =>
      'Följ realtidsanvisningar till din upphämtnings- eller avlämningsplats.';

  @override
  String get tourTripControlsTitle => 'Reskontroller';

  @override
  String get tourTripControlsDesc =>
      'Växla mellan upphämtnings- och avlämningsrutter, se destinationsdetaljer och inkomster.';

  @override
  String get tourUpdateStatusTitle => 'Uppdatera status';

  @override
  String get tourUpdateStatusDesc =>
      'Tryck för att markera viktiga milstolpar — På väg, Levererad eller Slutförd.';

  @override
  String get tourAppSettingsTitle => 'Appinställningar';

  @override
  String get tourAppSettingsDesc =>
      'Ändra ditt språk, tema och få tillgång till kunskapsbanken för hjälp.';

  @override
  String get tourKnowledgeBaseTitle => 'Kunskapsbank';

  @override
  String get tourKnowledgeBaseDesc =>
      'Bläddra i steg-för-steg guider, tips och svar på vanliga frågor.';

  @override
  String get tourSkipBtn => 'Hoppa över';

  @override
  String get tourBackBtn => 'Tillbaka';

  @override
  String get tourNextBtn => 'Nästa';

  @override
  String get tourDoneBtn => 'Klar';

  @override
  String get tourWelcomeTitle => 'Välkommen till TypeToGo!';

  @override
  String get tourWelcomeDesc =>
      'Ta en snabb rundtur för att lära dig använda appen';

  @override
  String get tourSkipForNow => 'Hoppa över för nu';

  @override
  String get tourStartBtn => 'Starta rundtur';

  @override
  String get tourCompleteTitle => 'Rundtur klar!';

  @override
  String get tourCompleteDesc =>
      'Du är redo att börja acceptera beställningar och tjäna med TypeToGo!';

  @override
  String get tourBrowseKb => 'Bläddra i kunskapsbanken';

  @override
  String get tourGetStarted => 'Kom igång';

  @override
  String get selectCountry => 'Välj land';

  @override
  String get searchCountry => 'Sök land...';

  @override
  String get secure => 'Säker';

  @override
  String get wellSendVerificationCode => 'Vi skickar dig en verifieringskod';

  @override
  String get byConsentTerms =>
      'Genom att fortsätta godkänner du våra villkor och integritetspolicy';

  @override
  String get otpSentSuccessfully => 'Verifieringskod skickad';

  @override
  String resendIn(int seconds) {
    return 'Skicka igen om ${seconds}s';
  }

  @override
  String get resendCode => 'Skicka kod igen';

  @override
  String get verify => 'Verifiera';

  @override
  String get tellUsAboutYourself => 'Berätta om dig själv';

  @override
  String get basicInfoSubtitle =>
      'Vi behöver grundläggande information för att konfigurera ditt förarkonto';

  @override
  String get enterYourFullName => 'Ange ditt fullständiga namn';

  @override
  String get notAvailable => 'Inte tillgänglig';

  @override
  String get verifiedViaOtp => 'Verifierad via OTP';

  @override
  String get selectYourVehicle => 'Välj ditt fordon';

  @override
  String get vehicleStepSubtitle =>
      'Välj den fordonstyp du kommer att använda för leveranser';

  @override
  String get chooseYourServices => 'Välj dina tjänster';

  @override
  String get servicesStepSubtitle => 'Välj de leveranstyper du vill acceptera';

  @override
  String get deliverFoodDesc => 'Leverera mat från restauranger';

  @override
  String get deliverPackagesDesc => 'Leverera paket och försändelser';

  @override
  String get transportPassengersDesc => 'Transportera passagerare';

  @override
  String get changeServiceLater =>
      'Du kan ändra dina tjänstepreferenser senare i inställningarna';

  @override
  String get back => 'Tillbaka';

  @override
  String get completeRegistration => 'Slutför registrering';

  @override
  String get pleaseEnterYourName => 'Ange ditt namn';

  @override
  String get pleaseSelectService => 'Välj minst en tjänstetyp';

  @override
  String get registrationFailed => 'Registrering misslyckades. Försök igen.';

  @override
  String get stepPersonal => 'Personligt';

  @override
  String get stepVehicle => 'Fordon';

  @override
  String get stepServices => 'Tjänster';

  @override
  String get ecoFriendlyOption => 'Miljövänligt alternativ';

  @override
  String get fastAndAgile => 'Snabb och smidig';

  @override
  String get mostVersatile => 'Mest mångsidig';

  @override
  String get largeDeliveries => 'Stora leveranser';

  @override
  String get van => 'Skåpbil';

  @override
  String get deleteDataWarning =>
      'Detta raderar permanent all din data inklusive profil, betyg och beställningshistorik.';

  @override
  String get finalConfirmation => 'Sista bekräftelsen';

  @override
  String get finalDeleteWarning =>
      'Är du helt säker? Denna åtgärd är oåterkallelig och du förlorar all din data.';

  @override
  String get deleteMyAccount => 'Radera mitt konto';

  @override
  String get deletingAccount => 'Raderar konto...';

  @override
  String get accountDeletedSuccessfully => 'Konto raderat';

  @override
  String failedToDeleteAccount(String error) {
    return 'Kunde inte radera konto: $error';
  }

  @override
  String get justNow => 'Just nu';

  @override
  String minutesAgo(int minutes) {
    return '${minutes}m sedan';
  }

  @override
  String hoursAgo(int hours) {
    return '${hours}t sedan';
  }

  @override
  String daysAgo(int days) {
    return '${days}d sedan';
  }

  @override
  String get clearAllNotificationsConfirm =>
      'Är du säker på att du vill rensa alla aviseringar?';

  @override
  String get failedToLoadNotifications => 'Kunde inte ladda aviseringar';

  @override
  String get calculatingRoute => 'Beräknar rutt...';

  @override
  String get orderNotFound => 'Beställning hittades inte';

  @override
  String get goBack => 'Gå tillbaka';

  @override
  String get gpsUnavailableTapRetry =>
      'GPS otillgänglig. Tryck för att försöka igen.';

  @override
  String get googleMaps => 'Google Maps';

  @override
  String get fetchingLocation => 'Hämtar plats...';

  @override
  String secondsAgo(int seconds) {
    return '${seconds}s sedan';
  }

  @override
  String get subtotal => 'Delsumma';

  @override
  String get orderType => 'Typ';

  @override
  String get created => 'Skapad';

  @override
  String get accepted => 'Accepterad';

  @override
  String get completed => 'Slutförd';

  @override
  String get orderPaid => 'Betald';

  @override
  String get orderPaidDescription => 'Ingen kontantinsamling behövs';

  @override
  String get collectCash => 'Samla in kontanter';

  @override
  String get collectCashReminder =>
      'Kom ihåg att samla in betalningen från kunden';

  @override
  String get locationPermissionLostWhileOnline =>
      'Platsåtkomst är inaktiverad. Du kommer inte att ta emot beställningar förrän den är aktiverad.';
}

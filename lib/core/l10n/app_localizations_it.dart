// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appName => 'TaybGo Autista';

  @override
  String get welcome => 'Benvenuto';

  @override
  String get getStarted => 'Inizia';

  @override
  String get next => 'Avanti';

  @override
  String get skip => 'Salta';

  @override
  String get done => 'Fatto';

  @override
  String get cancel => 'Annulla';

  @override
  String get confirm => 'Conferma';

  @override
  String get save => 'Salva';

  @override
  String get edit => 'Modifica';

  @override
  String get delete => 'Elimina';

  @override
  String get retry => 'Riprova';

  @override
  String get loading => 'Caricamento...';

  @override
  String get error => 'Errore';

  @override
  String get success => 'Successo';

  @override
  String get seeAll => 'Vedi tutto';

  @override
  String get or => 'O';

  @override
  String get onboardingTitle1 => 'Inizia a guadagnare oggi';

  @override
  String get onboardingDesc1 =>
      'Unisciti a migliaia di autisti che guadagnano secondo i propri orari';

  @override
  String get onboardingTitle2 => 'Accetta ordini facilmente';

  @override
  String get onboardingDesc2 =>
      'Ricevi notifiche per nuovi ordini e accetta con un tocco';

  @override
  String get onboardingTitle3 => 'Naviga e consegna';

  @override
  String get onboardingDesc3 =>
      'La navigazione integrata ti aiuta a raggiungere le destinazioni più velocemente';

  @override
  String get phoneNumber => 'Numero di telefono';

  @override
  String get enterPhoneNumber => 'Inserisci il tuo numero di telefono';

  @override
  String get phoneHint => '+39 123 456 7890';

  @override
  String get sendOtp => 'Invia codice';

  @override
  String get verifyOtp => 'Verifica codice';

  @override
  String get enterOtp => 'Inserisci il codice inviato a';

  @override
  String get resendOtp => 'Reinvia codice';

  @override
  String resendOtpIn(int seconds) {
    return 'Reinvia codice tra ${seconds}s';
  }

  @override
  String get invalidOtp => 'Codice di verifica non valido';

  @override
  String get otpSent => 'Codice di verifica inviato';

  @override
  String get errorsAuthPhoneAlreadyRegistered =>
      'Questo numero è già registrato.';

  @override
  String get email => 'Email';

  @override
  String get enterEmail => 'Inserisci la tua email';

  @override
  String get signUpWithApple => 'Registrati con Apple';

  @override
  String get signUpWithGoogle => 'Registrati con Google';

  @override
  String get forgotPassword => 'Password dimenticata';

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
  String get driverApplication => 'Candidatura autista';

  @override
  String get personalInfo => 'Informazioni personali';

  @override
  String get vehicleInfo => 'Informazioni sul veicolo';

  @override
  String get documents => 'Documenti';

  @override
  String get otherDocuments => 'Other Documents';

  @override
  String get reviewSubmit => 'Rivedi e invia';

  @override
  String get fullName => 'Nome completo';

  @override
  String get age => 'Data di nascita';

  @override
  String get dateOfBirth => 'Data di nascita';

  @override
  String get address => 'Indirizzo';

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
  String get city => 'Città';

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
  String get vehicleType => 'Tipo di veicolo';

  @override
  String get selectVehicleType => 'Seleziona il tipo di veicolo';

  @override
  String get car => 'Auto';

  @override
  String get van => 'Furgone';

  @override
  String get motorcycle => 'Moto';

  @override
  String get bicycle => 'Bicicletta';

  @override
  String get scooter => 'Scooter';

  @override
  String get licensePlate => 'Targa';

  @override
  String get vehicleModel => 'Modello del veicolo';

  @override
  String get vehicleYear => 'Anno del veicolo';

  @override
  String get vehicleColor => 'Colore del veicolo';

  @override
  String get serviceType => 'Tipo di servizio';

  @override
  String get selectServiceType => 'Quali servizi offrirai?';

  @override
  String get foodDelivery => 'Consegna cibo';

  @override
  String get shipping => 'Spedizioni';

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
  String get uploadDocuments => 'Carica documenti';

  @override
  String get driversLicense => 'Patente di guida';

  @override
  String get nationalId => 'Carta d\'identità';

  @override
  String get healthInsuranceDocument => 'Health Insurance Document';

  @override
  String get addressDocument => 'Address Document';

  @override
  String get bankDocument => 'Bank Document';

  @override
  String get vehicleRegistration => 'Libretto di circolazione';

  @override
  String get insurance => 'Assicurazione';

  @override
  String get profilePhoto => 'Foto profilo';

  @override
  String get uploadPhoto => 'Carica foto';

  @override
  String get takePhoto => 'Scatta foto';

  @override
  String get chooseFromGallery => 'Scegli dalla galleria';

  @override
  String get submitApplication => 'Invia candidatura';

  @override
  String get applicationSubmitted => 'Candidatura inviata';

  @override
  String get applicationPending => 'La tua candidatura è in fase di revisione';

  @override
  String get applicationApproved => 'Candidatura approvata';

  @override
  String get applicationRejected => 'Candidatura rifiutata';

  @override
  String get pendingApprovalMessage =>
      'Stiamo esaminando i tuoi documenti. Di solito ci vogliono 24-48 ore.';

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
  String get orders => 'Ordini';

  @override
  String get recentOrders => 'Ordini recenti';

  @override
  String get earnings => 'Guadagni';

  @override
  String get profile => 'Profilo';

  @override
  String get search => 'Cerca';

  @override
  String get online => 'Online';

  @override
  String get offline => 'Offline';

  @override
  String get goOnline => 'Vai online';

  @override
  String get goOffline => 'Vai offline';

  @override
  String get tapToGoOnline => 'Tocca per andare online';

  @override
  String get tapToGoOffline => 'Tocca per andare offline';

  @override
  String get youAreOnline => 'Sei online e pronto a ricevere ordini';

  @override
  String get youAreOffline => 'Sei offline. Vai online per ricevere ordini';

  @override
  String get newOrder => 'Nuovo ordine';

  @override
  String get newOrderTitle => 'Nuovo ordine!';

  @override
  String get newOrderSubtitle => 'Accetta prima che scada il tempo';

  @override
  String get orderDetails => 'Dettagli ordine';

  @override
  String get navigate => 'Naviga';

  @override
  String get details => 'Dettagli';

  @override
  String get acceptOrder => 'Accetta ordine';

  @override
  String get rejectOrder => 'Rifiuta ordine';

  @override
  String get accept => 'Accetta';

  @override
  String get reject => 'Rifiuta';

  @override
  String acceptIn(int seconds) {
    return 'Accetta tra ${seconds}s';
  }

  @override
  String get orderAccepted => 'Ordine accettato';

  @override
  String get items => 'articoli';

  @override
  String get time => 'Tempo';

  @override
  String get orderRejected => 'Ordine rifiutato';

  @override
  String get orderCompleted => 'Ordine completato';

  @override
  String get orderCancelled => 'Ordine annullato';

  @override
  String get pending => 'In attesa';

  @override
  String get searchingForDriver => 'Autista in ricerca';

  @override
  String get driverNotificationSent => 'Notifica autista inviata';

  @override
  String get rejected => 'Rifiutato';

  @override
  String get cancelled => 'Annullato';

  @override
  String get delivered => 'Consegnato';

  @override
  String get expired => 'Expired';

  @override
  String get restaurantDelivered => 'Restaurant delivered';

  @override
  String get pickup => 'Ritiro';

  @override
  String get dropoff => 'Consegna';

  @override
  String get pickupLocation => 'Luogo di ritiro';

  @override
  String get dropoffLocation => 'Luogo di consegna';

  @override
  String get route => 'Percorso';

  @override
  String get inProgress => 'In corso';

  @override
  String get headingToPickup => 'In direzione del punto di ritiro';

  @override
  String get headingToDropoff => 'In direzione del punto di consegna';

  @override
  String get atPickupLocation => 'Al punto di ritiro';

  @override
  String get atDropoffLocation => 'Al punto di consegna';

  @override
  String get orderId => 'ID ordine';

  @override
  String get customer => 'Cliente';

  @override
  String get itemsOrdered => 'Articoli';

  @override
  String get callCustomer => 'Chiama cliente';

  @override
  String get distance => 'Distanza';

  @override
  String get estimatedTime => 'Tempo stimato';

  @override
  String get yourDistanceTo => 'La tua distanza da';

  @override
  String get km => 'km';

  @override
  String get min => 'min';

  @override
  String get startNavigation => 'Avvia navigazione';

  @override
  String get arrivedAtPickup => 'Arrivato al punto di ritiro';

  @override
  String get startDelivery => 'Inizia consegna';

  @override
  String get arrivedAtDropoff => 'Arrivato al punto di consegna';

  @override
  String get completeOrder => 'Completa ordine';

  @override
  String get markAsDelivered => 'Segna come consegnato';

  @override
  String get acceptOrderConfirmation =>
      'Sei sicuro di voler accettare questo ordine?';

  @override
  String get rejectOrderConfirmation =>
      'Sei sicuro di voler rifiutare questo ordine?';

  @override
  String get startDeliveryConfirmation =>
      'Confermi di aver ritirato l\'ordine e di iniziare la consegna?';

  @override
  String get arrivedAtDropoffConfirmation =>
      'Confermi di essere arrivato al punto di consegna?';

  @override
  String get completeOrderConfirmation =>
      'Confermi di aver completato questa consegna?';

  @override
  String get updatingStatus => 'Aggiornamento stato...';

  @override
  String get tip => 'Mancia';

  @override
  String get earnings_label => 'Guadagni';

  @override
  String get deliveryFee => 'Costo di consegna';

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
  String get total => 'Totale';

  @override
  String get currentOrders => 'Ordini correnti';

  @override
  String get orderHistory => 'Storico ordini';

  @override
  String get noOrdersYet => 'Nessun ordine ancora';

  @override
  String get noActiveOrders => 'Nessun ordine attivo';

  @override
  String get waitingForOrders => 'In attesa di nuovi ordini...';

  @override
  String get totalOrders => 'Ordini totali';

  @override
  String get totalEarnings => 'Guadagni totali';

  @override
  String get avgTripTime => 'Tempo medio viaggio';

  @override
  String get completionRate => 'Tasso di completamento';

  @override
  String get rating => 'Valutazione';

  @override
  String get todayEarnings => 'Guadagni di oggi';

  @override
  String get weeklyEarnings => 'Guadagni settimanali';

  @override
  String get monthlyEarnings => 'Guadagni mensili';

  @override
  String get lastMonthEarnings => 'Guadagni del mese scorso';

  @override
  String get viewPayslips => 'Visualizza buste paga';

  @override
  String get payslipsSentEmail =>
      'Le buste paga vengono inviate alla tua email';

  @override
  String get settings => 'Impostazioni';

  @override
  String get language => 'Lingua';

  @override
  String get english => 'Inglese';

  @override
  String get german => 'Tedesco';

  @override
  String get french => 'Francese';

  @override
  String get arabic => 'Arabo';

  @override
  String get luxembourgish => 'Lussemburghese';

  @override
  String get italian => 'Italiano';

  @override
  String get dutch => 'Olandese';

  @override
  String get swedish => 'Svedese';

  @override
  String get norwegian => 'Norvegese';

  @override
  String get danish => 'Danese';

  @override
  String get finnish => 'Finlandese';

  @override
  String get theme => 'Tema';

  @override
  String get lightMode => 'Modalità chiara';

  @override
  String get darkMode => 'Modalità scura';

  @override
  String get systemDefault => 'Predefinito di sistema';

  @override
  String get notifications => 'Notifiche';

  @override
  String get orderNotifications => 'Notifiche ordini';

  @override
  String get promotionalNotifications => 'Notifiche promozionali';

  @override
  String get soundEnabled => 'Suono attivato';

  @override
  String get vibrationEnabled => 'Vibrazione attivata';

  @override
  String get notificationSoundRepeats => 'Ripetizioni del suono di notifica';

  @override
  String notificationSoundRepeatsEnabledDesc(int count) {
    return 'Riproduce il suono del segnale $count volta/e per ogni notifica.';
  }

  @override
  String get notificationSoundRepeatsDisabledDesc =>
      'Attiva prima il suono per scegliere quante volte ripetere il segnale.';

  @override
  String get notificationSoundRepeatsPickerDesc =>
      'Scegli quante volte il suono del segnale deve ripetersi per ogni notifica.';

  @override
  String get notificationRepeatTime => '1 volta';

  @override
  String notificationRepeatTimes(int count) {
    return '$count volte';
  }

  @override
  String get noNotifications => 'Nessuna notifica ancora';

  @override
  String get noNotificationsDesc => 'Le tue notifiche appariranno qui';

  @override
  String get today => 'Oggi';

  @override
  String get yesterday => 'Ieri';

  @override
  String get earlier => 'Prima';

  @override
  String get markAllRead => 'Segna tutto come letto';

  @override
  String get clearAll => 'Cancella tutto';

  @override
  String get newOrderReceived => 'Nuovo ordine ricevuto';

  @override
  String get orderAcceptedNotif => 'Ordine accettato con successo';

  @override
  String get orderDeliveredNotif => 'Ordine consegnato con successo';

  @override
  String get earningsReceived => 'Guadagni ricevuti';

  @override
  String get weeklyReportReady => 'Report settimanale pronto';

  @override
  String get accountUpdated => 'Account aggiornato';

  @override
  String get account => 'Account';

  @override
  String get editProfile => 'Modifica profilo';

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
  String get changePassword => 'Cambia password';

  @override
  String get privacyPolicy => 'Informativa sulla privacy';

  @override
  String get termsOfService => 'Termini di servizio';

  @override
  String get helpSupport => 'Aiuto e supporto';

  @override
  String get contactUs => 'Contattaci';

  @override
  String get logout => 'Esci';

  @override
  String get logoutConfirm => 'Sei sicuro di voler uscire?';

  @override
  String get deleteAccount => 'Elimina account';

  @override
  String get deleteAccountConfirm =>
      'Sei sicuro di voler eliminare il tuo account? Questa azione non può essere annullata.';

  @override
  String get networkError => 'Errore di rete. Controlla la tua connessione.';

  @override
  String get somethingWentWrong => 'Qualcosa è andato storto. Riprova.';

  @override
  String get sessionExpired => 'Sessione scaduta. Accedi di nuovo.';

  @override
  String get locationPermissionDenied => 'Permesso di localizzazione negato';

  @override
  String get enableLocationServices =>
      'Attiva i servizi di localizzazione per continuare';

  @override
  String version(String version) {
    return 'Versione $version';
  }

  @override
  String get goodMorning => 'Buongiorno';

  @override
  String get goodAfternoon => 'Buon pomeriggio';

  @override
  String get goodEvening => 'Buonasera';

  @override
  String get locationRequired => 'Posizione richiesta';

  @override
  String get enableLocationAccess =>
      'Attiva l\'accesso alla posizione per ricevere ordini.';

  @override
  String get enable => 'Attiva';

  @override
  String get pleaseEnableLocationInSettings =>
      'Attiva la posizione nelle impostazioni.';

  @override
  String get backgroundLocationTitle => 'Consenti posizione in background';

  @override
  String get backgroundLocationMessage =>
      'Per consentire a TaybGo di inviare la tua posizione quando l\'app è in background, apri le impostazioni e seleziona «Consenti sempre».';

  @override
  String get gpsDisabled => 'GPS disattivato';

  @override
  String get pleaseEnableGps => 'Attiva il GPS per ricevere ordini.';

  @override
  String get failedToUpdateStatus => 'Aggiornamento stato fallito';

  @override
  String get ok => 'OK';

  @override
  String get accountUnderReview => 'Account in revisione';

  @override
  String get accountBeingVerified =>
      'Il tuo account è in fase di verifica. Sarai notificato quando approvato.';

  @override
  String get receivingOrders => 'Ricezione ordini';

  @override
  String get goOnlineToStart => 'Vai online per iniziare';

  @override
  String get noRecentOrders => 'Nessun ordine recente';

  @override
  String get headToPickup => 'Vai al ritiro';

  @override
  String get onTheWay => 'In viaggio';

  @override
  String get atDelivery => 'Alla consegna';

  @override
  String get continueText => 'Continua';

  @override
  String get week => 'Settimana';

  @override
  String get month => 'Mese';

  @override
  String get avgPerOrder => 'Media/Ordine';

  @override
  String get allTime => 'Totale';

  @override
  String get noEarningsData => 'Nessun dato sui guadagni';

  @override
  String get completeOrdersToSeeEarnings =>
      'Completa ordini per vedere i tuoi guadagni';

  @override
  String get verified => 'Verificato';

  @override
  String get approved => 'Approvato';

  @override
  String joinedOn(Object date) {
    return 'Iscritto il $date';
  }

  @override
  String get driver => 'Autista';

  @override
  String get knowledgeBase => 'Base di conoscenza';

  @override
  String get searchForHelp => 'Cerca aiuto...';

  @override
  String get noArticlesFound => 'Nessun articolo trovato';

  @override
  String get tryDifferentSearch => 'Prova un termine di ricerca diverso';

  @override
  String get noCategoriesAvailable => 'Nessuna categoria disponibile';

  @override
  String articlesCount(int count) {
    return '$count articoli';
  }

  @override
  String get articleNotFound => 'Articolo non trovato';

  @override
  String get wasArticleHelpful => 'Questo articolo è stato utile?';

  @override
  String get thankYouFeedback => 'Grazie per il tuo feedback!';

  @override
  String get willImproveArticle => 'Lavoreremo per migliorare questo articolo.';

  @override
  String get relatedArticles => 'Articoli correlati';

  @override
  String get kbTip => 'Suggerimento';

  @override
  String get kbWarning => 'Attenzione';

  @override
  String get yes => 'Sì';

  @override
  String get no => 'No';

  @override
  String get article => 'Articolo';

  @override
  String get browseKnowledgeBase => 'Sfoglia la base di conoscenza';

  @override
  String sectionsCount(int count) {
    return '$count sezioni';
  }

  @override
  String minRead(int count) {
    return '$count min di lettura';
  }

  @override
  String get tourAccountUnderReviewTitle => 'Account in revisione';

  @override
  String get tourAccountUnderReviewDesc =>
      'Il tuo account è in fase di verifica. Puoi esplorare l\'app mentre attendi l\'approvazione.';

  @override
  String get tourGoOnlineTitle => 'Vai online per ricevere ordini';

  @override
  String get tourGoOnlineDesc =>
      'Attiva questo interruttore quando sei pronto ad accettare consegne. Puoi andare offline in qualsiasi momento.';

  @override
  String get tourDailyStatsTitle => 'Le tue statistiche giornaliere';

  @override
  String get tourDailyStatsDesc =>
      'Monitora i tuoi ordini, guadagni e valutazione qui. Le statistiche si aggiornano in tempo reale.';

  @override
  String get tourNewOrderTitle => 'Nuovo ordine ricevuto!';

  @override
  String get tourNewOrderDesc =>
      'Ecco come appaiono i nuovi ordini. Controlla ritiro, consegna, distanza e pagamento.';

  @override
  String get tourOrdersTabTitle => 'Scheda ordini';

  @override
  String get tourOrdersTabDesc => 'Passa tra ordini correnti e storico ordini.';

  @override
  String get tourTotalEarningsTitle => 'I tuoi guadagni totali';

  @override
  String get tourTotalEarningsDesc =>
      'Monitora tutti i tuoi guadagni qui — paga base, mance e bonus.';

  @override
  String get tourEarningsBreakdownTitle => 'Dettaglio guadagni';

  @override
  String get tourEarningsBreakdownDesc =>
      'Visualizza il totale ordini e i guadagni medi per ordine.';

  @override
  String get tourRouteDetailsTitle => 'Dettagli percorso';

  @override
  String get tourRouteDetailsDesc =>
      'Visualizza il percorso completo di ritiro e consegna con indirizzi, distanza e tempo stimato.';

  @override
  String get tourYourEarningsTitle => 'I tuoi guadagni';

  @override
  String get tourYourEarningsDesc =>
      'Visualizza il dettaglio completo del pagamento — costo di consegna, mancia e pagamento totale.';

  @override
  String get tourNavActionsTitle => 'Navigazione e azioni';

  @override
  String get tourNavActionsDesc =>
      'Naviga verso il ritiro/consegna o aggiorna lo stato dell\'ordine durante il percorso.';

  @override
  String get tourTurnByTurnTitle => 'Navigazione passo-passo';

  @override
  String get tourTurnByTurnDesc =>
      'Segui le indicazioni in tempo reale verso il punto di ritiro o consegna.';

  @override
  String get tourTripControlsTitle => 'Controlli viaggio';

  @override
  String get tourTripControlsDesc =>
      'Passa tra i percorsi di ritiro e consegna, visualizza dettagli destinazione e guadagni.';

  @override
  String get tourUpdateStatusTitle => 'Aggiorna stato';

  @override
  String get tourUpdateStatusDesc =>
      'Tocca per segnare le tappe chiave — In viaggio, Consegnato o Completato.';

  @override
  String get tourAppSettingsTitle => 'Impostazioni app';

  @override
  String get tourAppSettingsDesc =>
      'Cambia lingua, tema e accedi alla base di conoscenza per aiuto.';

  @override
  String get tourKnowledgeBaseTitle => 'Base di conoscenza';

  @override
  String get tourKnowledgeBaseDesc =>
      'Sfoglia guide passo-passo, suggerimenti e risposte alle domande frequenti.';

  @override
  String get tourSkipBtn => 'Salta';

  @override
  String get tourBackBtn => 'Indietro';

  @override
  String get tourNextBtn => 'Avanti';

  @override
  String get tourDoneBtn => 'Fatto';

  @override
  String get tourWelcomeTitle => 'Benvenuto su TaybGo!';

  @override
  String get tourWelcomeDesc =>
      'Fai un tour veloce per imparare a usare l\'app';

  @override
  String get tourSkipForNow => 'Salta per ora';

  @override
  String get tourStartBtn => 'Inizia il tour';

  @override
  String get tourCompleteTitle => 'Tour completato!';

  @override
  String get tourCompleteDesc =>
      'Sei pronto per iniziare ad accettare ordini e guadagnare con TaybGo!';

  @override
  String get tourBrowseKb => 'Sfoglia la base di conoscenza';

  @override
  String get tourGetStarted => 'Inizia';

  @override
  String get selectCountry => 'Seleziona paese';

  @override
  String get searchCountry => 'Cerca paese...';

  @override
  String get secure => 'Sicuro';

  @override
  String get wellSendVerificationCode => 'Ti invieremo un codice di verifica';

  @override
  String get byConsentTerms =>
      'Continuando, accetti i nostri Termini e Privacy';

  @override
  String get otpSentSuccessfully => 'Codice di verifica inviato con successo';

  @override
  String resendIn(int seconds) {
    return 'Reinvia tra ${seconds}s';
  }

  @override
  String get resendCode => 'Reinvia codice';

  @override
  String get verify => 'Verifica';

  @override
  String get tellUsAboutYourself => 'Parlaci di te';

  @override
  String get basicInfoSubtitle =>
      'Abbiamo bisogno di alcune informazioni di base per configurare il tuo account autista';

  @override
  String get enterYourFullName => 'Inserisci il tuo nome completo';

  @override
  String get notAvailable => 'Non disponibile';

  @override
  String get verifiedViaOtp => 'Verificato tramite OTP';

  @override
  String get selectYourVehicle => 'Seleziona il tuo veicolo';

  @override
  String get vehicleStepSubtitle =>
      'Scegli il tipo di veicolo che userai per le consegne';

  @override
  String get chooseYourServices => 'Scegli i tuoi servizi';

  @override
  String get servicesStepSubtitle =>
      'Seleziona i tipi di consegne che vuoi accettare';

  @override
  String get deliverFoodDesc => 'Consegna cibo dai ristoranti';

  @override
  String get deliverPackagesDesc => 'Consegna pacchi e pacchetti';

  @override
  String get transportPassengersDesc => 'Trasporta passeggeri';

  @override
  String get changeServiceLater =>
      'Puoi modificare le tue preferenze di servizio più tardi nelle impostazioni';

  @override
  String get back => 'Indietro';

  @override
  String get completeRegistration => 'Completa registrazione';

  @override
  String get pleaseEnterYourName => 'Inserisci il tuo nome';

  @override
  String get pleaseSelectService => 'Seleziona almeno un tipo di servizio';

  @override
  String get pleaseUploadDriversLicense => 'Carica la tua patente di guida';

  @override
  String get pleaseUploadNationalId => 'Carica il tuo documento d\'identità';

  @override
  String pleaseUploadDocument(Object documentName) {
    return 'Carica $documentName';
  }

  @override
  String get registrationFailed => 'Registrazione fallita. Riprova.';

  @override
  String get stepPersonal => 'Personale';

  @override
  String get stepVehicle => 'Veicolo';

  @override
  String get stepServices => 'Servizi';

  @override
  String applicationStepProgress(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String applicationNextStep(String step) {
    return 'Next: $step';
  }

  @override
  String get ecoFriendlyOption => 'Opzione ecologica';

  @override
  String get fastAndAgile => 'Veloce e agile';

  @override
  String get mostVersatile => 'Il più versatile';

  @override
  String get largeDeliveries => 'Consegne grandi';

  @override
  String get deleteDataWarning =>
      'Questo eliminerà permanentemente tutti i tuoi dati inclusi profilo, valutazioni e storico ordini.';

  @override
  String get finalConfirmation => 'Conferma finale';

  @override
  String get finalDeleteWarning =>
      'Sei assolutamente sicuro? Questa azione è irreversibile e perderai tutti i tuoi dati.';

  @override
  String get deleteMyAccount => 'Elimina il mio account';

  @override
  String get deletingAccount => 'Eliminazione account...';

  @override
  String get accountDeletedSuccessfully => 'Account eliminato con successo';

  @override
  String failedToDeleteAccount(String error) {
    return 'Eliminazione account fallita: $error';
  }

  @override
  String get justNow => 'Proprio ora';

  @override
  String minutesAgo(int minutes) {
    return '${minutes}m fa';
  }

  @override
  String hoursAgo(int hours) {
    return '${hours}h fa';
  }

  @override
  String daysAgo(int days) {
    return '${days}g fa';
  }

  @override
  String get clearAllNotificationsConfirm =>
      'Sei sicuro di voler cancellare tutte le notifiche?';

  @override
  String get failedToLoadNotifications => 'Caricamento notifiche fallito';

  @override
  String get calculatingRoute => 'Calcolo percorso...';

  @override
  String get orderNotFound => 'Ordine non trovato';

  @override
  String get goBack => 'Torna indietro';

  @override
  String get gpsUnavailableTapRetry =>
      'GPS non disponibile. Tocca per riprovare.';

  @override
  String get googleMaps => 'Google Maps';

  @override
  String get fetchingLocation => 'Rilevamento posizione...';

  @override
  String secondsAgo(int seconds) {
    return '${seconds}s fa';
  }

  @override
  String get subtotal => 'Subtotale';

  @override
  String get orderType => 'Tipo';

  @override
  String get created => 'Creato';

  @override
  String get accepted => 'Accettato';

  @override
  String get completed => 'Completato';

  @override
  String get orderPaid => 'Pagato';

  @override
  String get orderPaidDescription => 'Nessun incasso necessario';

  @override
  String get collectCash => 'Incassa contante';

  @override
  String get collectCashReminder =>
      'Ricorda di riscuotere il pagamento dal cliente';

  @override
  String collectCashAmountReminder(String amount) {
    return 'Collect $amount from the customer before completing.';
  }

  @override
  String get locationPermissionLostWhileOnline =>
      'L\'accesso alla posizione è disabilitato. Non riceverai ordini finché non sarà abilitato.';

  @override
  String get batteryOptimizationTitle => 'Disattiva ottimizzazione batteria';

  @override
  String get batteryOptimizationMessage =>
      'Per mantenere attiva la posizione in tempo reale in background, imposta TaybGo Driver su utilizzo della batteria senza restrizioni nelle impostazioni Android.';

  @override
  String get batteryOptimizationBannerMessage =>
      'L\'ottimizzazione della batteria può mettere in pausa la posizione in tempo reale mentre sei online. Imposta TaybGo Driver su utilizzo della batteria senza restrizioni.';

  @override
  String get profileUpdatedSuccessfully => 'Profilo aggiornato con successo';

  @override
  String get failedToUpdateProfile => 'Aggiornamento profilo fallito';

  @override
  String get supportTickets => 'Ticket di supporto';

  @override
  String get supportFilterAll => 'Tutti';

  @override
  String get supportFilterOpen => 'Aperto';

  @override
  String get supportFilterInProgress => 'In corso';

  @override
  String get supportFilterClosed => 'Chiuso';

  @override
  String get supportStatusOpen => 'Aperto';

  @override
  String get supportStatusInProgress => 'In corso';

  @override
  String get supportStatusClosed => 'Chiuso';

  @override
  String get supportPriorityLow => 'Bassa';

  @override
  String get supportPriorityMedium => 'Media';

  @override
  String get supportPriorityHigh => 'Alta';

  @override
  String get supportNoTickets => 'Nessun ticket ancora';

  @override
  String get supportNoTicketsDesc => 'Crea un ticket se hai bisogno di aiuto';

  @override
  String get supportCreateTicket => 'Crea ticket';

  @override
  String get supportTicketCreated => 'Ticket creato con successo';

  @override
  String get supportRelatedOrder => 'Ordine correlato';

  @override
  String get supportSubject => 'Oggetto';

  @override
  String get supportSubjectHint => 'Breve descrizione del tuo problema';

  @override
  String get supportSubjectRequired => 'L\'oggetto è obbligatorio';

  @override
  String get supportMessage => 'Messaggio';

  @override
  String get supportMessageHint => 'Descrivi il tuo problema in dettaglio...';

  @override
  String get supportMessageRequired => 'Il messaggio è obbligatorio';

  @override
  String get supportSubmitTicket => 'Invia ticket';

  @override
  String get supportSelectOrder => 'Seleziona un ordine (opzionale)';

  @override
  String get supportNoOrder => 'Nessun ordine specifico';

  @override
  String get supportTicketDetail => 'Dettaglio ticket';

  @override
  String get supportNoMessages => 'Nessun messaggio ancora';

  @override
  String get supportTypeMessage => 'Scrivi un messaggio...';

  @override
  String get supportTicketClosed => 'Questo ticket è chiuso';

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
  String get file => 'File';

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
  String get changelog => 'Registro modifiche';

  @override
  String get changelogTitle => 'Novità';

  @override
  String get changelogSubtitle =>
      'Scopri rapidamente gli ultimi miglioramenti di TaybGo Driver.';

  @override
  String get changelogCurrent => 'Attuale';

  @override
  String get changelogBuild => 'Build';

  @override
  String get changelogReleased => 'Rilasciata';

  @override
  String get changelogReleaseNotes => 'Note di rilascio';

  @override
  String get changelogHighlights => 'Punti salienti';

  @override
  String get changelogFixes => 'Correzioni';

  @override
  String get changelogImprovements => 'Miglioramenti';

  @override
  String get changelogStability => 'Stabilità';

  @override
  String get changelogPlatform => 'Piattaforma';

  @override
  String get changelogRelease => 'Rilascio';

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
  String get changelogDateAug9 => '9 agosto 2026';

  @override
  String get changelogDateAug11 => '11 agosto 2026';

  @override
  String get changelogVersion1013Address =>
      'Aggiunti indirizzi strutturati opzionali per i conducenti, con coordinate e dettagli completi, durante la registrazione e la modifica del profilo.';

  @override
  String get changelogVersion1013Status =>
      'Gli aggiornamenti del solo indirizzo usano ora richieste PATCH parziali e mantengono lo stato del conducente approvato.';

  @override
  String get changelogVersion1013Release =>
      'Pubblicata l’app del conducente versione 1.0.13+15.';

  @override
  String get changelogDateMay31 => '31 maggio 2026';

  @override
  String get changelogDateMay24 => '24 maggio 2026';

  @override
  String get changelogDateMay13 => '13 maggio 2026';

  @override
  String get changelogDateMay11 => '11 maggio 2026';

  @override
  String get changelogCurrentTaxi =>
      'La selezione del servizio taxi è stata limitata agli autisti di auto e gli autisti in bicicletta non possono più attivarlo durante la registrazione o la modifica del profilo.';

  @override
  String get changelogVersion1113Upload =>
      'Abbiamo ridotto l\'uso della memoria durante i caricamenti web per rendere più affidabile il caricamento dei documenti sui dispositivi meno potenti.';

  @override
  String get changelogCurrentChangelog =>
      'Nel Profilo è stato aggiunto un registro modifiche localizzato e apribile, con cronologia delle versioni, numeri build, date e note di rilascio.';

  @override
  String get changelogVersion1113Version =>
      'La versione dell\'app e la data di rilascio sono ora visibili nella schermata di accesso e nella schermata iniziale web.';

  @override
  String get changelogCurrentRelease =>
      'L\'app è stata aggiornata alla versione 1.0.12+14 con gli ultimi miglioramenti per gli autisti.';

  @override
  String get changelogVersion1113Release =>
      'La build del Play Store è stata aggiornata alla versione 1.0.11+13 (codice versione 13).';

  @override
  String get changelogVersion1112Release =>
      'L\'app per autisti è stata rilasciata nella versione 1.0.11+12 e i relativi metadati di rilascio sono stati registrati.';

  @override
  String get changelogVersion1011Documents =>
      'Aggiunta la convalida dei documenti obbligatori per gli autisti di auto.';

  @override
  String get changelogVersion1011Uploads =>
      'I documenti obbligatori sono indicati più chiaramente ed è stata migliorata la gestione dello stato di caricamento.';

  @override
  String get changelogVersion1011Feedback =>
      'Migliorati la convalida e i messaggi di errore durante il salvataggio delle modifiche al profilo.';

  @override
  String get changelogVersion1011Release =>
      'L\'app per autisti è stata rilasciata nella versione 1.0.10+11.';

  @override
  String get changelogVersion0910Crashlytics =>
      'Aggiunta la segnalazione Crashlytics degli errori irreversibili nelle build di rilascio.';

  @override
  String get changelogVersion0910Notifications =>
      'Migliorati il ciclo di vita delle notifiche, la deduplicazione e la gestione delle notifiche degli ordini.';

  @override
  String get changelogVersion0910Platform =>
      'Aggiornata la configurazione di rilascio per Android, iOS, macOS e web con flavor di sviluppo e produzione.';

  @override
  String get changelogVersion0910Release =>
      'L\'app per autisti è stata rilasciata nella versione 1.0.9+10.';
}

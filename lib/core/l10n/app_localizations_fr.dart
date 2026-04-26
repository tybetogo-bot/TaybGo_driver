// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'TaybGo Chauffeur';

  @override
  String get welcome => 'Bienvenue';

  @override
  String get getStarted => 'Commencer';

  @override
  String get next => 'Suivant';

  @override
  String get skip => 'Passer';

  @override
  String get done => 'Terminé';

  @override
  String get cancel => 'Annuler';

  @override
  String get confirm => 'Confirmer';

  @override
  String get save => 'Enregistrer';

  @override
  String get edit => 'Modifier';

  @override
  String get delete => 'Supprimer';

  @override
  String get retry => 'Réessayer';

  @override
  String get loading => 'Chargement...';

  @override
  String get error => 'Erreur';

  @override
  String get success => 'Succès';

  @override
  String get seeAll => 'Voir tout';

  @override
  String get or => 'OU';

  @override
  String get onboardingTitle1 => 'Commencez à gagner aujourd\'hui';

  @override
  String get onboardingDesc1 =>
      'Rejoignez des milliers de chauffeurs qui gagnent selon leur propre emploi du temps';

  @override
  String get onboardingTitle2 => 'Acceptez les commandes facilement';

  @override
  String get onboardingDesc2 =>
      'Soyez notifié des nouvelles commandes et acceptez d\'un seul tap';

  @override
  String get onboardingTitle3 => 'Naviguez et livrez';

  @override
  String get onboardingDesc3 =>
      'La navigation intégrée vous aide à atteindre vos destinations plus rapidement';

  @override
  String get phoneNumber => 'Numéro de téléphone';

  @override
  String get enterPhoneNumber => 'Entrez votre numéro de téléphone';

  @override
  String get phoneHint => '+33 1 23 45 67 89';

  @override
  String get sendOtp => 'Envoyer le code';

  @override
  String get verifyOtp => 'Vérifier le code';

  @override
  String get enterOtp => 'Entrez le code envoyé à';

  @override
  String get resendOtp => 'Renvoyer le code';

  @override
  String resendOtpIn(int seconds) {
    return 'Renvoyer le code dans ${seconds}s';
  }

  @override
  String get invalidOtp => 'Code de vérification invalide';

  @override
  String get otpSent => 'Code de vérification envoyé';

  @override
  String get errorsAuthPhoneAlreadyRegistered =>
      'Ce numéro est déjà enregistré.';

  @override
  String get email => 'E-mail';

  @override
  String get enterEmail => 'Entrez votre e-mail';

  @override
  String get signUpWithApple => 'S\'inscrire avec Apple';

  @override
  String get signUpWithGoogle => 'S\'inscrire avec Google';

  @override
  String get forgotPassword => 'Mot de passe oublié';

  @override
  String get driverApplication => 'Candidature chauffeur';

  @override
  String get personalInfo => 'Informations personnelles';

  @override
  String get vehicleInfo => 'Informations sur le véhicule';

  @override
  String get documents => 'Documents';

  @override
  String get otherDocuments => 'Other Documents';

  @override
  String get reviewSubmit => 'Vérifier et soumettre';

  @override
  String get fullName => 'Nom complet';

  @override
  String get age => 'Date de naissance';

  @override
  String get dateOfBirth => 'Date de naissance';

  @override
  String get address => 'Adresse';

  @override
  String get city => 'Ville';

  @override
  String get vehicleType => 'Type de véhicule';

  @override
  String get selectVehicleType => 'Sélectionnez le type de véhicule';

  @override
  String get car => 'Voiture';

  @override
  String get motorcycle => 'Moto';

  @override
  String get bicycle => 'Vélo';

  @override
  String get scooter => 'Scooter';

  @override
  String get licensePlate => 'Plaque d\'immatriculation';

  @override
  String get vehicleModel => 'Modèle du véhicule';

  @override
  String get vehicleYear => 'Année du véhicule';

  @override
  String get vehicleColor => 'Couleur du véhicule';

  @override
  String get serviceType => 'Type de service';

  @override
  String get selectServiceType => 'Quels services allez-vous offrir?';

  @override
  String get foodDelivery => 'Livraison de nourriture';

  @override
  String get shipping => 'Livraison de colis';

  @override
  String get taxi => 'Taxi';

  @override
  String get uploadDocuments => 'Télécharger les documents';

  @override
  String get driversLicense => 'Permis de conduire';

  @override
  String get nationalId => 'Carte d\'identité';

  @override
  String get healthInsuranceDocument => 'Health Insurance Document';

  @override
  String get addressDocument => 'Address Document';

  @override
  String get bankDocument => 'Bank Document';

  @override
  String get vehicleRegistration => 'Carte grise';

  @override
  String get insurance => 'Assurance';

  @override
  String get profilePhoto => 'Photo de profil';

  @override
  String get uploadPhoto => 'Télécharger une photo';

  @override
  String get takePhoto => 'Prendre une photo';

  @override
  String get chooseFromGallery => 'Choisir dans la galerie';

  @override
  String get submitApplication => 'Soumettre la candidature';

  @override
  String get applicationSubmitted => 'Candidature soumise';

  @override
  String get applicationPending => 'Votre candidature est en cours d\'examen';

  @override
  String get applicationApproved => 'Candidature approuvée';

  @override
  String get applicationRejected => 'Candidature rejetée';

  @override
  String get pendingApprovalMessage =>
      'Nous examinons vos documents. Cela prend généralement 24 à 48 heures.';

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
  String get home => 'Accueil';

  @override
  String get orders => 'Commandes';

  @override
  String get recentOrders => 'Commandes Récentes';

  @override
  String get earnings => 'Gains';

  @override
  String get profile => 'Profil';

  @override
  String get search => 'Recherche';

  @override
  String get online => 'En ligne';

  @override
  String get offline => 'Hors ligne';

  @override
  String get goOnline => 'Se connecter';

  @override
  String get goOffline => 'Se déconnecter';

  @override
  String get tapToGoOnline => 'Appuyez pour vous connecter';

  @override
  String get tapToGoOffline => 'Appuyez pour vous déconnecter';

  @override
  String get youAreOnline =>
      'Vous êtes en ligne et prêt à recevoir des commandes';

  @override
  String get youAreOffline =>
      'Vous êtes hors ligne. Connectez-vous pour recevoir des commandes';

  @override
  String get newOrder => 'Nouvelle commande';

  @override
  String get newOrderTitle => 'Nouvelle commande!';

  @override
  String get newOrderSubtitle => 'Acceptez avant la fin du temps';

  @override
  String get orderDetails => 'Détails de la commande';

  @override
  String get navigate => 'Naviguer';

  @override
  String get details => 'Détails';

  @override
  String get acceptOrder => 'Accepter la commande';

  @override
  String get rejectOrder => 'Refuser la commande';

  @override
  String get accept => 'Accepter';

  @override
  String get reject => 'Refuser';

  @override
  String acceptIn(int seconds) {
    return 'Accepter dans ${seconds}s';
  }

  @override
  String get orderAccepted => 'Commande acceptée';

  @override
  String get items => 'articles';

  @override
  String get time => 'Temps';

  @override
  String get orderRejected => 'Commande refusée';

  @override
  String get orderCompleted => 'Commande terminée';

  @override
  String get orderCancelled => 'Commande annulée';

  @override
  String get pending => 'En attente';

  @override
  String get searchingForDriver => 'Recherche d\'un chauffeur';

  @override
  String get driverNotificationSent => 'Notification au chauffeur envoyée';

  @override
  String get rejected => 'Refusé';

  @override
  String get cancelled => 'Annulé';

  @override
  String get delivered => 'Livré';

  @override
  String get pickup => 'Retrait';

  @override
  String get dropoff => 'Livraison';

  @override
  String get pickupLocation => 'Lieu de retrait';

  @override
  String get dropoffLocation => 'Lieu de livraison';

  @override
  String get route => 'Itinéraire';

  @override
  String get inProgress => 'En cours';

  @override
  String get headingToPickup => 'En route vers le point de retrait';

  @override
  String get headingToDropoff => 'En route vers le point de livraison';

  @override
  String get atPickupLocation => 'Au point de retrait';

  @override
  String get atDropoffLocation => 'Au point de livraison';

  @override
  String get orderId => 'ID de commande';

  @override
  String get customer => 'Client';

  @override
  String get itemsOrdered => 'Articles';

  @override
  String get callCustomer => 'Appeler le client';

  @override
  String get distance => 'Distance';

  @override
  String get estimatedTime => 'Temps estimé';

  @override
  String get yourDistanceTo => 'Votre distance à';

  @override
  String get km => 'km';

  @override
  String get min => 'min';

  @override
  String get startNavigation => 'Démarrer la navigation';

  @override
  String get arrivedAtPickup => 'Arrivé au point de retrait';

  @override
  String get startDelivery => 'Commencer la livraison';

  @override
  String get arrivedAtDropoff => 'Arrivé au point de livraison';

  @override
  String get completeOrder => 'Terminer la commande';

  @override
  String get markAsDelivered => 'Marquer comme livré';

  @override
  String get acceptOrderConfirmation =>
      'Êtes-vous sûr de vouloir accepter cette commande?';

  @override
  String get rejectOrderConfirmation =>
      'Êtes-vous sûr de vouloir refuser cette commande?';

  @override
  String get startDeliveryConfirmation =>
      'Confirmez que vous avez récupéré la commande et que vous commencez la livraison?';

  @override
  String get arrivedAtDropoffConfirmation =>
      'Confirmez que vous êtes arrivé au point de livraison?';

  @override
  String get completeOrderConfirmation =>
      'Confirmez que vous avez terminé cette livraison?';

  @override
  String get updatingStatus => 'Mise à jour du statut...';

  @override
  String get tip => 'Pourboire';

  @override
  String get earnings_label => 'Gains';

  @override
  String get deliveryFee => 'Frais de livraison';

  @override
  String get total => 'Total';

  @override
  String get currentOrders => 'Commandes en cours';

  @override
  String get orderHistory => 'Historique des commandes';

  @override
  String get noOrdersYet => 'Pas encore de commandes';

  @override
  String get noActiveOrders => 'Aucune commande active';

  @override
  String get waitingForOrders => 'En attente de nouvelles commandes...';

  @override
  String get totalOrders => 'Total des commandes';

  @override
  String get totalEarnings => 'Gains totaux';

  @override
  String get avgTripTime => 'Temps moyen de trajet';

  @override
  String get completionRate => 'Taux de complétion';

  @override
  String get rating => 'Note';

  @override
  String get todayEarnings => 'Gains d\'aujourd\'hui';

  @override
  String get weeklyEarnings => 'Gains hebdomadaires';

  @override
  String get monthlyEarnings => 'Gains mensuels';

  @override
  String get lastMonthEarnings => 'Gains du mois dernier';

  @override
  String get viewPayslips => 'Voir les fiches de paie';

  @override
  String get payslipsSentEmail => 'Les fiches de paie sont envoyées par e-mail';

  @override
  String get settings => 'Paramètres';

  @override
  String get language => 'Langue';

  @override
  String get english => 'Anglais';

  @override
  String get german => 'Allemand';

  @override
  String get french => 'Français';

  @override
  String get arabic => 'Arabe';

  @override
  String get luxembourgish => 'Luxembourgeois';

  @override
  String get italian => 'Italien';

  @override
  String get dutch => 'Néerlandais';

  @override
  String get swedish => 'Suédois';

  @override
  String get norwegian => 'Norvégien';

  @override
  String get danish => 'Danois';

  @override
  String get finnish => 'Finnois';

  @override
  String get theme => 'Thème';

  @override
  String get lightMode => 'Mode clair';

  @override
  String get darkMode => 'Mode sombre';

  @override
  String get systemDefault => 'Par défaut du système';

  @override
  String get notifications => 'Notifications';

  @override
  String get orderNotifications => 'Notifications de commandes';

  @override
  String get promotionalNotifications => 'Notifications promotionnelles';

  @override
  String get soundEnabled => 'Son activé';

  @override
  String get vibrationEnabled => 'Vibration activée';

  @override
  String get notificationSoundRepeats => 'R?p?titions du son de notification';

  @override
  String notificationSoundRepeatsEnabledDesc(int count) {
    return 'Joue le son du signal $count fois pour chaque notification.';
  }

  @override
  String get notificationSoundRepeatsDisabledDesc =>
      'Activez d?abord le son pour choisir combien de fois le signal se r?p?te.';

  @override
  String get notificationSoundRepeatsPickerDesc =>
      'Choisissez combien de fois le son du signal doit se r?p?ter pour chaque notification.';

  @override
  String get notificationRepeatTime => '1 fois';

  @override
  String notificationRepeatTimes(int count) {
    return '$count fois';
  }

  @override
  String get noNotifications => 'Pas encore de notifications';

  @override
  String get noNotificationsDesc => 'Vos notifications apparaîtront ici';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get yesterday => 'Hier';

  @override
  String get earlier => 'Plus tôt';

  @override
  String get markAllRead => 'Tout marquer comme lu';

  @override
  String get clearAll => 'Tout effacer';

  @override
  String get newOrderReceived => 'Nouvelle commande reçue';

  @override
  String get orderAcceptedNotif => 'Commande acceptée avec succès';

  @override
  String get orderDeliveredNotif => 'Commande livrée avec succès';

  @override
  String get earningsReceived => 'Gains reçus';

  @override
  String get weeklyReportReady => 'Rapport hebdomadaire prêt';

  @override
  String get accountUpdated => 'Compte mis à jour';

  @override
  String get account => 'Compte';

  @override
  String get editProfile => 'Modifier le profil';

  @override
  String get changePassword => 'Changer le mot de passe';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get termsOfService => 'Conditions d\'utilisation';

  @override
  String get helpSupport => 'Aide et support';

  @override
  String get contactUs => 'Nous contacter';

  @override
  String get logout => 'Déconnexion';

  @override
  String get logoutConfirm => 'Êtes-vous sûr de vouloir vous déconnecter?';

  @override
  String get deleteAccount => 'Supprimer le compte';

  @override
  String get deleteAccountConfirm =>
      'Êtes-vous sûr de vouloir supprimer votre compte? Cette action est irréversible.';

  @override
  String get networkError =>
      'Erreur réseau. Veuillez vérifier votre connexion.';

  @override
  String get somethingWentWrong =>
      'Une erreur s\'est produite. Veuillez réessayer.';

  @override
  String get sessionExpired => 'Session expirée. Veuillez vous reconnecter.';

  @override
  String get locationPermissionDenied => 'Permission de localisation refusée';

  @override
  String get enableLocationServices =>
      'Veuillez activer les services de localisation pour continuer';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get goodMorning => 'Bonjour';

  @override
  String get goodAfternoon => 'Bon après-midi';

  @override
  String get goodEvening => 'Bonsoir';

  @override
  String get locationRequired => 'Localisation requise';

  @override
  String get enableLocationAccess =>
      'Activez l\'accès à la localisation pour recevoir des commandes.';

  @override
  String get enable => 'Activer';

  @override
  String get pleaseEnableLocationInSettings =>
      'Veuillez activer la localisation dans les paramètres.';

  @override
  String get backgroundLocationTitle =>
      'Autoriser la localisation en arrière-plan';

  @override
  String get backgroundLocationMessage =>
      'Pour que TaybGo puisse envoyer votre position lorsque l\'application est en arrière-plan, veuillez ouvrir les paramètres et sélectionner « Toujours autoriser ».';

  @override
  String get gpsDisabled => 'GPS désactivé';

  @override
  String get pleaseEnableGps =>
      'Veuillez activer le GPS pour recevoir des commandes.';

  @override
  String get failedToUpdateStatus => 'Échec de la mise à jour du statut';

  @override
  String get ok => 'OK';

  @override
  String get accountUnderReview => 'Compte en cours de vérification';

  @override
  String get accountBeingVerified =>
      'Votre compte est en cours de vérification. Vous serez notifié une fois approuvé.';

  @override
  String get receivingOrders => 'Réception des commandes';

  @override
  String get goOnlineToStart => 'Passez en ligne pour commencer';

  @override
  String get noRecentOrders => 'Aucune commande récente';

  @override
  String get headToPickup => 'Aller au point de retrait';

  @override
  String get onTheWay => 'En route';

  @override
  String get atDelivery => 'À la livraison';

  @override
  String get continueText => 'Continuer';

  @override
  String get week => 'Semaine';

  @override
  String get month => 'Mois';

  @override
  String get avgPerOrder => 'Moy/Commande';

  @override
  String get allTime => 'Total';

  @override
  String get noEarningsData => 'Aucune donnée de revenus';

  @override
  String get completeOrdersToSeeEarnings =>
      'Complétez des commandes pour voir vos revenus';

  @override
  String get verified => 'Vérifié';

  @override
  String get driver => 'Chauffeur';

  @override
  String get knowledgeBase => 'Base de connaissances';

  @override
  String get searchForHelp => 'Rechercher de l\'aide...';

  @override
  String get noArticlesFound => 'Aucun article trouvé';

  @override
  String get tryDifferentSearch => 'Essayez un autre terme de recherche';

  @override
  String get noCategoriesAvailable => 'Aucune catégorie disponible';

  @override
  String articlesCount(int count) {
    return '$count articles';
  }

  @override
  String get articleNotFound => 'Article non trouvé';

  @override
  String get wasArticleHelpful => 'Cet article vous a-t-il été utile ?';

  @override
  String get thankYouFeedback => 'Merci pour votre retour !';

  @override
  String get willImproveArticle =>
      'Nous travaillerons à améliorer cet article.';

  @override
  String get relatedArticles => 'Articles connexes';

  @override
  String get kbTip => 'Conseil';

  @override
  String get kbWarning => 'Avertissement';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get article => 'Article';

  @override
  String get browseKnowledgeBase => 'Parcourir la base de connaissances';

  @override
  String sectionsCount(int count) {
    return '$count sections';
  }

  @override
  String minRead(int count) {
    return '$count min de lecture';
  }

  @override
  String get tourAccountUnderReviewTitle => 'Compte en cours de vérification';

  @override
  String get tourAccountUnderReviewDesc =>
      'Votre compte est en cours de vérification. Vous pouvez explorer l\'application en attendant l\'approbation.';

  @override
  String get tourGoOnlineTitle => 'Passez en ligne pour recevoir des commandes';

  @override
  String get tourGoOnlineDesc =>
      'Activez ce bouton lorsque vous êtes prêt à accepter des livraisons. Vous pouvez passer hors ligne à tout moment.';

  @override
  String get tourDailyStatsTitle => 'Vos statistiques quotidiennes';

  @override
  String get tourDailyStatsDesc =>
      'Suivez vos commandes, revenus et notes ici. Les statistiques se mettent à jour en temps réel.';

  @override
  String get tourNewOrderTitle => 'Nouvelle commande reçue !';

  @override
  String get tourNewOrderDesc =>
      'Voici comment apparaissent les nouvelles commandes. Consultez le ramassage, la livraison, la distance et le paiement.';

  @override
  String get tourOrdersTabTitle => 'Onglet Commandes';

  @override
  String get tourOrdersTabDesc =>
      'Basculez entre les commandes en cours et l\'historique des commandes.';

  @override
  String get tourTotalEarningsTitle => 'Vos revenus totaux';

  @override
  String get tourTotalEarningsDesc =>
      'Suivez tous vos revenus ici — salaire de base, pourboires et bonus.';

  @override
  String get tourEarningsBreakdownTitle => 'Détail des revenus';

  @override
  String get tourEarningsBreakdownDesc =>
      'Consultez le total de vos commandes et les revenus moyens par commande.';

  @override
  String get tourRouteDetailsTitle => 'Détails de l\'itinéraire';

  @override
  String get tourRouteDetailsDesc =>
      'Consultez l\'itinéraire complet de ramassage et de livraison avec adresses, distance et temps estimé.';

  @override
  String get tourYourEarningsTitle => 'Vos revenus';

  @override
  String get tourYourEarningsDesc =>
      'Consultez le détail complet — frais de livraison, pourboire et montant total.';

  @override
  String get tourNavActionsTitle => 'Navigation et actions';

  @override
  String get tourNavActionsDesc =>
      'Naviguez vers le ramassage/livraison ou mettez à jour le statut de la commande au fur et à mesure.';

  @override
  String get tourTurnByTurnTitle => 'Navigation pas à pas';

  @override
  String get tourTurnByTurnDesc =>
      'Suivez les indications en temps réel vers votre lieu de ramassage ou de livraison.';

  @override
  String get tourTripControlsTitle => 'Contrôles du trajet';

  @override
  String get tourTripControlsDesc =>
      'Basculez entre les itinéraires de ramassage et de livraison, consultez les détails de destination et les revenus.';

  @override
  String get tourUpdateStatusTitle => 'Mettre à jour le statut';

  @override
  String get tourUpdateStatusDesc =>
      'Appuyez pour marquer les étapes clés — En route, Livré ou Terminé.';

  @override
  String get tourAppSettingsTitle => 'Paramètres de l\'application';

  @override
  String get tourAppSettingsDesc =>
      'Changez votre langue, thème et accédez à la base de connaissances pour obtenir de l\'aide.';

  @override
  String get tourKnowledgeBaseTitle => 'Base de connaissances';

  @override
  String get tourKnowledgeBaseDesc =>
      'Parcourez les guides étape par étape, les conseils et les réponses aux questions fréquentes.';

  @override
  String get tourSkipBtn => 'Passer';

  @override
  String get tourBackBtn => 'Retour';

  @override
  String get tourNextBtn => 'Suivant';

  @override
  String get tourDoneBtn => 'Terminé';

  @override
  String get tourWelcomeTitle => 'Bienvenue sur TaybGo !';

  @override
  String get tourWelcomeDesc =>
      'Faites une visite rapide pour apprendre à utiliser l\'application';

  @override
  String get tourSkipForNow => 'Passer pour l\'instant';

  @override
  String get tourStartBtn => 'Commencer la visite';

  @override
  String get tourCompleteTitle => 'Visite terminée !';

  @override
  String get tourCompleteDesc =>
      'Vous êtes prêt à accepter des commandes et gagner avec TaybGo !';

  @override
  String get tourBrowseKb => 'Parcourir la base de connaissances';

  @override
  String get tourGetStarted => 'Commencer';

  @override
  String get selectCountry => 'Sélectionner le pays';

  @override
  String get searchCountry => 'Rechercher un pays...';

  @override
  String get secure => 'Sécurisé';

  @override
  String get wellSendVerificationCode =>
      'Nous vous enverrons un code de vérification';

  @override
  String get byConsentTerms =>
      'En continuant, vous acceptez nos Conditions et Politique de confidentialité';

  @override
  String get otpSentSuccessfully => 'Code de vérification envoyé avec succès';

  @override
  String resendIn(int seconds) {
    return 'Renvoyer dans ${seconds}s';
  }

  @override
  String get resendCode => 'Renvoyer le code';

  @override
  String get verify => 'Vérifier';

  @override
  String get tellUsAboutYourself => 'Parlez-nous de vous';

  @override
  String get basicInfoSubtitle =>
      'Nous avons besoin de quelques informations de base pour configurer votre compte chauffeur';

  @override
  String get enterYourFullName => 'Entrez votre nom complet';

  @override
  String get notAvailable => 'Non disponible';

  @override
  String get verifiedViaOtp => 'Vérifié par OTP';

  @override
  String get selectYourVehicle => 'Sélectionnez votre véhicule';

  @override
  String get vehicleStepSubtitle =>
      'Choisissez le type de véhicule que vous utiliserez pour les livraisons';

  @override
  String get chooseYourServices => 'Choisissez vos services';

  @override
  String get servicesStepSubtitle =>
      'Sélectionnez les types de livraisons que vous souhaitez accepter';

  @override
  String get deliverFoodDesc => 'Livrer de la nourriture des restaurants';

  @override
  String get deliverPackagesDesc => 'Livrer des colis et des paquets';

  @override
  String get transportPassengersDesc => 'Transporter des passagers';

  @override
  String get changeServiceLater =>
      'Vous pouvez modifier vos préférences de service plus tard dans les paramètres';

  @override
  String get back => 'Retour';

  @override
  String get completeRegistration => 'Terminer l\'inscription';

  @override
  String get pleaseEnterYourName => 'Veuillez entrer votre nom';

  @override
  String get pleaseSelectService =>
      'Veuillez sélectionner au moins un type de service';

  @override
  String get pleaseUploadDriversLicense =>
      'Veuillez télécharger votre permis de conduire';

  @override
  String get pleaseUploadNationalId =>
      'Veuillez télécharger votre pièce d\'identité';

  @override
  String pleaseUploadDocument(Object documentName) {
    return 'Veuillez télécharger $documentName';
  }

  @override
  String get registrationFailed =>
      'L\'inscription a échoué. Veuillez réessayer.';

  @override
  String get stepPersonal => 'Personnel';

  @override
  String get stepVehicle => 'Véhicule';

  @override
  String get stepServices => 'Services';

  @override
  String get ecoFriendlyOption => 'Option écologique';

  @override
  String get fastAndAgile => 'Rapide et agile';

  @override
  String get mostVersatile => 'Le plus polyvalent';

  @override
  String get largeDeliveries => 'Grandes livraisons';

  @override
  String get van => 'Fourgon';

  @override
  String get deleteDataWarning =>
      'Cela supprimera définitivement toutes vos données, y compris le profil, les évaluations et l\'historique des commandes.';

  @override
  String get finalConfirmation => 'Confirmation finale';

  @override
  String get finalDeleteWarning =>
      'Êtes-vous absolument sûr ? Cette action est irréversible et vous perdrez toutes vos données.';

  @override
  String get deleteMyAccount => 'Supprimer mon compte';

  @override
  String get deletingAccount => 'Suppression du compte...';

  @override
  String get accountDeletedSuccessfully => 'Compte supprimé avec succès';

  @override
  String failedToDeleteAccount(String error) {
    return 'Échec de la suppression du compte : $error';
  }

  @override
  String get justNow => 'À l\'instant';

  @override
  String minutesAgo(int minutes) {
    return 'il y a $minutes min';
  }

  @override
  String hoursAgo(int hours) {
    return 'il y a $hours h';
  }

  @override
  String daysAgo(int days) {
    return 'il y a $days j';
  }

  @override
  String get clearAllNotificationsConfirm =>
      'Êtes-vous sûr de vouloir effacer toutes les notifications ?';

  @override
  String get failedToLoadNotifications =>
      'Échec du chargement des notifications';

  @override
  String get calculatingRoute => 'Calcul de l\'itinéraire...';

  @override
  String get orderNotFound => 'Commande introuvable';

  @override
  String get goBack => 'Retour';

  @override
  String get gpsUnavailableTapRetry =>
      'GPS indisponible. Appuyez pour réessayer.';

  @override
  String get googleMaps => 'Google Maps';

  @override
  String get fetchingLocation => 'Localisation en cours...';

  @override
  String secondsAgo(int seconds) {
    return 'il y a ${seconds}s';
  }

  @override
  String get subtotal => 'Sous-total';

  @override
  String get orderType => 'Type';

  @override
  String get created => 'Créée';

  @override
  String get accepted => 'Acceptée';

  @override
  String get completed => 'Terminée';

  @override
  String get orderPaid => 'Payé';

  @override
  String get orderPaidDescription => 'Aucun encaissement nécessaire';

  @override
  String get collectCash => 'Encaisser';

  @override
  String get collectCashReminder =>
      'N\'oubliez pas d\'encaisser le paiement du client';

  @override
  String get locationPermissionLostWhileOnline =>
      'L\'accès à la localisation est désactivé. Vous ne recevrez pas de commandes tant qu\'il ne sera pas activé.';

  @override
  String get batteryOptimizationTitle =>
      'Desactiver l\'optimisation de la batterie';

  @override
  String get batteryOptimizationMessage =>
      'Pour garder la localisation en direct active en arrière-plan, définissez TaybGo Driver sur une utilisation de batterie sans restriction dans les paramètres Android.';

  @override
  String get batteryOptimizationBannerMessage =>
      'L\'optimisation de la batterie peut mettre en pause la localisation en direct lorsque vous êtes en ligne. Définissez TaybGo Driver sur une utilisation de batterie sans restriction.';

  @override
  String get profileUpdatedSuccessfully => 'Profil mis à jour avec succès';

  @override
  String get failedToUpdateProfile => 'Échec de la mise à jour du profil';

  @override
  String get supportTickets => 'Tickets de support';

  @override
  String get supportFilterAll => 'Tous';

  @override
  String get supportFilterOpen => 'Ouvert';

  @override
  String get supportFilterInProgress => 'En cours';

  @override
  String get supportFilterClosed => 'Fermé';

  @override
  String get supportStatusOpen => 'Ouvert';

  @override
  String get supportStatusInProgress => 'En cours';

  @override
  String get supportStatusClosed => 'Fermé';

  @override
  String get supportPriorityLow => 'Faible';

  @override
  String get supportPriorityMedium => 'Moyen';

  @override
  String get supportPriorityHigh => 'Élevé';

  @override
  String get supportNoTickets => 'Pas encore de tickets';

  @override
  String get supportNoTicketsDesc =>
      'Créez un ticket si vous avez besoin d\'aide';

  @override
  String get supportCreateTicket => 'Créer un ticket';

  @override
  String get supportTicketCreated => 'Ticket créé avec succès';

  @override
  String get supportRelatedOrder => 'Commande associée';

  @override
  String get supportSubject => 'Sujet';

  @override
  String get supportSubjectHint => 'Brève description de votre problème';

  @override
  String get supportSubjectRequired => 'Le sujet est requis';

  @override
  String get supportMessage => 'Message';

  @override
  String get supportMessageHint => 'Décrivez votre problème en détail...';

  @override
  String get supportMessageRequired => 'Le message est requis';

  @override
  String get supportSubmitTicket => 'Soumettre le ticket';

  @override
  String get supportSelectOrder => 'Sélectionner une commande (optionnel)';

  @override
  String get supportNoOrder => 'Aucune commande spécifique';

  @override
  String get supportTicketDetail => 'Détail du ticket';

  @override
  String get supportNoMessages => 'Aucun message pour l\'instant';

  @override
  String get supportTypeMessage => 'Écrire un message...';

  @override
  String get supportTicketClosed => 'Ce ticket est fermé';

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
  String get invalidVehicleYear => 'Please enter a valid year';

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
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'TybeToGo Chauffeur';

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
  String get reviewSubmit => 'Vérifier et soumettre';

  @override
  String get fullName => 'Nom complet';

  @override
  String get age => 'Âge';

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
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_lb.dart';
import 'app_localizations_nb.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_sv.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('da'),
    Locale('de'),
    Locale('en'),
    Locale('fi'),
    Locale('fr'),
    Locale('it'),
    Locale('lb'),
    Locale('nb'),
    Locale('nl'),
    Locale('sv'),
  ];

  /// The app name
  ///
  /// In en, this message translates to:
  /// **'TaybGo Driver'**
  String get appName;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Start Earning Today'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In en, this message translates to:
  /// **'Join thousands of drivers earning on their own schedule'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Accept Orders Easily'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In en, this message translates to:
  /// **'Get notified of new orders and accept with one tap'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Navigate & Deliver'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In en, this message translates to:
  /// **'Built-in navigation helps you reach destinations faster'**
  String get onboardingDesc3;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterPhoneNumber;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'+49 123 456 7890'**
  String get phoneHint;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @verifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOtp;

  /// No description provided for @enterOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter the code we sent to'**
  String get enterOtp;

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendOtp;

  /// No description provided for @resendOtpIn.
  ///
  /// In en, this message translates to:
  /// **'Resend code in {seconds}s'**
  String resendOtpIn(int seconds);

  /// No description provided for @invalidOtp.
  ///
  /// In en, this message translates to:
  /// **'Invalid verification code'**
  String get invalidOtp;

  /// No description provided for @otpSent.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent'**
  String get otpSent;

  /// Generic OTP conflict message shown when the phone number is already registered for another account or role.
  ///
  /// In en, this message translates to:
  /// **'This number is already registered.'**
  String get errorsAuthPhoneAlreadyRegistered;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterEmail;

  /// No description provided for @signUpWithApple.
  ///
  /// In en, this message translates to:
  /// **'Sign up with Apple'**
  String get signUpWithApple;

  /// No description provided for @signUpWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign up with Google'**
  String get signUpWithGoogle;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'I forgot my password'**
  String get forgotPassword;

  /// No description provided for @driverApplication.
  ///
  /// In en, this message translates to:
  /// **'Driver Application'**
  String get driverApplication;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInfo;

  /// No description provided for @vehicleInfo.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Information'**
  String get vehicleInfo;

  /// No description provided for @documents.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documents;

  /// No description provided for @otherDocuments.
  ///
  /// In en, this message translates to:
  /// **'Other Documents'**
  String get otherDocuments;

  /// No description provided for @reviewSubmit.
  ///
  /// In en, this message translates to:
  /// **'Review & Submit'**
  String get reviewSubmit;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Birthdate'**
  String get age;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @addressStepTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved Address'**
  String get addressStepTitle;

  /// No description provided for @addressStepSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Search for your home address and select the correct result from Google.'**
  String get addressStepSubtitle;

  /// No description provided for @addressOptionalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Required — select an address from Google so we can verify your service area.'**
  String get addressOptionalSubtitle;

  /// No description provided for @addressRequired.
  ///
  /// In en, this message translates to:
  /// **'Please search for and select your address.'**
  String get addressRequired;

  /// No description provided for @searchForAddress.
  ///
  /// In en, this message translates to:
  /// **'Search for your address'**
  String get searchForAddress;

  /// No description provided for @searchAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Start typing a street, building, or place name'**
  String get searchAddressHint;

  /// No description provided for @addressSelected.
  ///
  /// In en, this message translates to:
  /// **'Address selected'**
  String get addressSelected;

  /// No description provided for @addressDetails.
  ///
  /// In en, this message translates to:
  /// **'Address details'**
  String get addressDetails;

  /// No description provided for @addressSearchUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Address search is not configured for this build.'**
  String get addressSearchUnavailable;

  /// No description provided for @addressSearchError.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load address results. Check your connection and try again.'**
  String get addressSearchError;

  /// No description provided for @noAddressResults.
  ///
  /// In en, this message translates to:
  /// **'No matching addresses found. Try adding a city or postal code.'**
  String get noAddressResults;

  /// No description provided for @selectAddressSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Please select an address from the Google suggestions.'**
  String get selectAddressSuggestion;

  /// No description provided for @addressCoordinatesMissing.
  ///
  /// In en, this message translates to:
  /// **'This result is missing location details. Please choose another address.'**
  String get addressCoordinatesMissing;

  /// No description provided for @clearAddress.
  ///
  /// In en, this message translates to:
  /// **'Clear address'**
  String get clearAddress;

  /// No description provided for @addressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address label'**
  String get addressLabel;

  /// No description provided for @addressLabelHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Home'**
  String get addressLabelHint;

  /// No description provided for @fullAddress.
  ///
  /// In en, this message translates to:
  /// **'Full address'**
  String get fullAddress;

  /// No description provided for @fullAddressHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 12 King Street, Riyadh'**
  String get fullAddressHint;

  /// No description provided for @latitude.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get latitude;

  /// No description provided for @latitudeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 24.713600'**
  String get latitudeHint;

  /// No description provided for @longitude.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get longitude;

  /// No description provided for @longitudeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 46.675300'**
  String get longitudeHint;

  /// No description provided for @useCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Use current location'**
  String get useCurrentLocation;

  /// No description provided for @streetName.
  ///
  /// In en, this message translates to:
  /// **'Street name'**
  String get streetName;

  /// No description provided for @streetNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. King Street'**
  String get streetNameHint;

  /// No description provided for @houseNumber.
  ///
  /// In en, this message translates to:
  /// **'House number'**
  String get houseNumber;

  /// No description provided for @houseNumberHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 12'**
  String get houseNumberHint;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @cityHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Riyadh'**
  String get cityHint;

  /// No description provided for @postalCode.
  ///
  /// In en, this message translates to:
  /// **'Postal code'**
  String get postalCode;

  /// No description provided for @postalCodeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 12345'**
  String get postalCodeHint;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @countryHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. SA'**
  String get countryHint;

  /// No description provided for @addressRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Label, latitude, longitude, and full address are required together.'**
  String get addressRequiredFields;

  /// No description provided for @invalidLatitude.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid latitude between -90 and 90.'**
  String get invalidLatitude;

  /// No description provided for @invalidLongitude.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid longitude between -180 and 180.'**
  String get invalidLongitude;

  /// No description provided for @locationFetchFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to determine your current location.'**
  String get locationFetchFailed;

  /// No description provided for @vehicleType.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Type'**
  String get vehicleType;

  /// No description provided for @selectVehicleType.
  ///
  /// In en, this message translates to:
  /// **'Select vehicle type'**
  String get selectVehicleType;

  /// No description provided for @car.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get car;

  /// No description provided for @van.
  ///
  /// In en, this message translates to:
  /// **'Van'**
  String get van;

  /// No description provided for @motorcycle.
  ///
  /// In en, this message translates to:
  /// **'Motorcycle'**
  String get motorcycle;

  /// No description provided for @bicycle.
  ///
  /// In en, this message translates to:
  /// **'Bicycle'**
  String get bicycle;

  /// No description provided for @scooter.
  ///
  /// In en, this message translates to:
  /// **'Scooter'**
  String get scooter;

  /// No description provided for @licensePlate.
  ///
  /// In en, this message translates to:
  /// **'License Plate'**
  String get licensePlate;

  /// No description provided for @vehicleModel.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Model'**
  String get vehicleModel;

  /// No description provided for @vehicleYear.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Year'**
  String get vehicleYear;

  /// No description provided for @vehicleColor.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Color'**
  String get vehicleColor;

  /// No description provided for @serviceType.
  ///
  /// In en, this message translates to:
  /// **'Service Type'**
  String get serviceType;

  /// No description provided for @selectServiceType.
  ///
  /// In en, this message translates to:
  /// **'What services will you offer?'**
  String get selectServiceType;

  /// No description provided for @foodDelivery.
  ///
  /// In en, this message translates to:
  /// **'Food Delivery'**
  String get foodDelivery;

  /// No description provided for @shipping.
  ///
  /// In en, this message translates to:
  /// **'Shipping'**
  String get shipping;

  /// No description provided for @taxi.
  ///
  /// In en, this message translates to:
  /// **'Taxi'**
  String get taxi;

  /// No description provided for @foodOrder.
  ///
  /// In en, this message translates to:
  /// **'Food order'**
  String get foodOrder;

  /// No description provided for @shippingOrder.
  ///
  /// In en, this message translates to:
  /// **'Shipping order'**
  String get shippingOrder;

  /// No description provided for @taxiRide.
  ///
  /// In en, this message translates to:
  /// **'Taxi ride'**
  String get taxiRide;

  /// No description provided for @allOrders.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allOrders;

  /// No description provided for @uploadDocuments.
  ///
  /// In en, this message translates to:
  /// **'Upload Documents'**
  String get uploadDocuments;

  /// No description provided for @driversLicense.
  ///
  /// In en, this message translates to:
  /// **'Driver\'s License'**
  String get driversLicense;

  /// No description provided for @nationalId.
  ///
  /// In en, this message translates to:
  /// **'National ID'**
  String get nationalId;

  /// No description provided for @healthInsuranceDocument.
  ///
  /// In en, this message translates to:
  /// **'Health Insurance Document'**
  String get healthInsuranceDocument;

  /// No description provided for @addressDocument.
  ///
  /// In en, this message translates to:
  /// **'Address Document'**
  String get addressDocument;

  /// No description provided for @bankDocument.
  ///
  /// In en, this message translates to:
  /// **'Bank Document'**
  String get bankDocument;

  /// No description provided for @vehicleRegistration.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Registration'**
  String get vehicleRegistration;

  /// No description provided for @insurance.
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get insurance;

  /// No description provided for @profilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Profile Photo'**
  String get profilePhoto;

  /// No description provided for @uploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload Photo'**
  String get uploadPhoto;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// No description provided for @submitApplication.
  ///
  /// In en, this message translates to:
  /// **'Submit Application'**
  String get submitApplication;

  /// No description provided for @applicationSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Application Submitted'**
  String get applicationSubmitted;

  /// No description provided for @applicationPending.
  ///
  /// In en, this message translates to:
  /// **'Your application is under review'**
  String get applicationPending;

  /// No description provided for @applicationApproved.
  ///
  /// In en, this message translates to:
  /// **'Application Approved'**
  String get applicationApproved;

  /// No description provided for @applicationRejected.
  ///
  /// In en, this message translates to:
  /// **'Application Rejected'**
  String get applicationRejected;

  /// No description provided for @pendingApprovalMessage.
  ///
  /// In en, this message translates to:
  /// **'We\'re reviewing your documents. This usually takes 24-48 hours.'**
  String get pendingApprovalMessage;

  /// No description provided for @vehicleChangeWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle changes need approval'**
  String get vehicleChangeWarningTitle;

  /// No description provided for @vehicleChangeWarningMessage.
  ///
  /// In en, this message translates to:
  /// **'Changing your vehicle details will place your account on hold until the administration reviews and approves the update.'**
  String get vehicleChangeWarningMessage;

  /// No description provided for @vehicleChangeWarningNote.
  ///
  /// In en, this message translates to:
  /// **'You won\'t be able to go online or receive new orders while this review is in progress.'**
  String get vehicleChangeWarningNote;

  /// No description provided for @vehicleChangeWarningConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm and save'**
  String get vehicleChangeWarningConfirm;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @recentOrders.
  ///
  /// In en, this message translates to:
  /// **'Recent Orders'**
  String get recentOrders;

  /// No description provided for @earnings.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get earnings;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @goOnline.
  ///
  /// In en, this message translates to:
  /// **'Go Online'**
  String get goOnline;

  /// No description provided for @goOffline.
  ///
  /// In en, this message translates to:
  /// **'Go Offline'**
  String get goOffline;

  /// No description provided for @tapToGoOnline.
  ///
  /// In en, this message translates to:
  /// **'Tap to go online'**
  String get tapToGoOnline;

  /// No description provided for @tapToGoOffline.
  ///
  /// In en, this message translates to:
  /// **'Tap to go offline'**
  String get tapToGoOffline;

  /// No description provided for @youAreOnline.
  ///
  /// In en, this message translates to:
  /// **'You\'re online and ready to receive orders'**
  String get youAreOnline;

  /// No description provided for @youAreOffline.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline. Go online to receive orders'**
  String get youAreOffline;

  /// No description provided for @newOrder.
  ///
  /// In en, this message translates to:
  /// **'New Order'**
  String get newOrder;

  /// No description provided for @newOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'New Order!'**
  String get newOrderTitle;

  /// No description provided for @newOrderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Accept before time runs out'**
  String get newOrderSubtitle;

  /// No description provided for @orderDetails.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get orderDetails;

  /// No description provided for @navigate.
  ///
  /// In en, this message translates to:
  /// **'Navigate'**
  String get navigate;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @acceptOrder.
  ///
  /// In en, this message translates to:
  /// **'Accept Order'**
  String get acceptOrder;

  /// No description provided for @rejectOrder.
  ///
  /// In en, this message translates to:
  /// **'Reject Order'**
  String get rejectOrder;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @acceptIn.
  ///
  /// In en, this message translates to:
  /// **'Accept in {seconds}s'**
  String acceptIn(int seconds);

  /// No description provided for @orderAccepted.
  ///
  /// In en, this message translates to:
  /// **'Order accepted!'**
  String get orderAccepted;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get items;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @orderRejected.
  ///
  /// In en, this message translates to:
  /// **'Order rejected'**
  String get orderRejected;

  /// No description provided for @orderCompleted.
  ///
  /// In en, this message translates to:
  /// **'Order Completed'**
  String get orderCompleted;

  /// No description provided for @orderCancelled.
  ///
  /// In en, this message translates to:
  /// **'Order Cancelled'**
  String get orderCancelled;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @searchingForDriver.
  ///
  /// In en, this message translates to:
  /// **'Searching for driver'**
  String get searchingForDriver;

  /// No description provided for @driverNotificationSent.
  ///
  /// In en, this message translates to:
  /// **'Driver notification sent'**
  String get driverNotificationSent;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered;

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// No description provided for @restaurantDelivered.
  ///
  /// In en, this message translates to:
  /// **'Restaurant delivered'**
  String get restaurantDelivered;

  /// No description provided for @pickup.
  ///
  /// In en, this message translates to:
  /// **'Pickup'**
  String get pickup;

  /// No description provided for @dropoff.
  ///
  /// In en, this message translates to:
  /// **'Drop-off'**
  String get dropoff;

  /// No description provided for @pickupLocation.
  ///
  /// In en, this message translates to:
  /// **'Pickup Location'**
  String get pickupLocation;

  /// No description provided for @dropoffLocation.
  ///
  /// In en, this message translates to:
  /// **'Drop-off Location'**
  String get dropoffLocation;

  /// No description provided for @route.
  ///
  /// In en, this message translates to:
  /// **'Route'**
  String get route;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// No description provided for @headingToPickup.
  ///
  /// In en, this message translates to:
  /// **'Heading to pickup location'**
  String get headingToPickup;

  /// No description provided for @headingToDropoff.
  ///
  /// In en, this message translates to:
  /// **'Heading to drop-off location'**
  String get headingToDropoff;

  /// No description provided for @atPickupLocation.
  ///
  /// In en, this message translates to:
  /// **'At pickup location'**
  String get atPickupLocation;

  /// No description provided for @atDropoffLocation.
  ///
  /// In en, this message translates to:
  /// **'At drop-off location'**
  String get atDropoffLocation;

  /// No description provided for @orderId.
  ///
  /// In en, this message translates to:
  /// **'Order ID'**
  String get orderId;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// No description provided for @itemsOrdered.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get itemsOrdered;

  /// No description provided for @callCustomer.
  ///
  /// In en, this message translates to:
  /// **'Call Customer'**
  String get callCustomer;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @estimatedTime.
  ///
  /// In en, this message translates to:
  /// **'Est. Time'**
  String get estimatedTime;

  /// No description provided for @yourDistanceTo.
  ///
  /// In en, this message translates to:
  /// **'Your distance to'**
  String get yourDistanceTo;

  /// No description provided for @km.
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get km;

  /// No description provided for @min.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get min;

  /// No description provided for @startNavigation.
  ///
  /// In en, this message translates to:
  /// **'Start Navigation'**
  String get startNavigation;

  /// No description provided for @arrivedAtPickup.
  ///
  /// In en, this message translates to:
  /// **'Arrived at Pickup'**
  String get arrivedAtPickup;

  /// No description provided for @startDelivery.
  ///
  /// In en, this message translates to:
  /// **'Start Delivery'**
  String get startDelivery;

  /// No description provided for @arrivedAtDropoff.
  ///
  /// In en, this message translates to:
  /// **'Arrived at Drop-off'**
  String get arrivedAtDropoff;

  /// No description provided for @completeOrder.
  ///
  /// In en, this message translates to:
  /// **'Complete Order'**
  String get completeOrder;

  /// No description provided for @markAsDelivered.
  ///
  /// In en, this message translates to:
  /// **'Mark as Delivered'**
  String get markAsDelivered;

  /// No description provided for @acceptOrderConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to accept this order?'**
  String get acceptOrderConfirmation;

  /// No description provided for @rejectOrderConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reject this order?'**
  String get rejectOrderConfirmation;

  /// No description provided for @startDeliveryConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Confirm that you have picked up the order and are starting delivery?'**
  String get startDeliveryConfirmation;

  /// No description provided for @arrivedAtDropoffConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Confirm that you have arrived at the drop-off location?'**
  String get arrivedAtDropoffConfirmation;

  /// No description provided for @completeOrderConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Confirm that you have completed this delivery?'**
  String get completeOrderConfirmation;

  /// No description provided for @updatingStatus.
  ///
  /// In en, this message translates to:
  /// **'Updating status...'**
  String get updatingStatus;

  /// No description provided for @tip.
  ///
  /// In en, this message translates to:
  /// **'Tip'**
  String get tip;

  /// No description provided for @earnings_label.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get earnings_label;

  /// No description provided for @deliveryFee.
  ///
  /// In en, this message translates to:
  /// **'Delivery Fee'**
  String get deliveryFee;

  /// No description provided for @driverDeliveryFee.
  ///
  /// In en, this message translates to:
  /// **'Driver delivery fee'**
  String get driverDeliveryFee;

  /// No description provided for @requiredVehicle.
  ///
  /// In en, this message translates to:
  /// **'Required vehicle'**
  String get requiredVehicle;

  /// No description provided for @packageDetails.
  ///
  /// In en, this message translates to:
  /// **'Package details'**
  String get packageDetails;

  /// No description provided for @packageSize.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get packageSize;

  /// No description provided for @packageWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get packageWeight;

  /// No description provided for @packageContents.
  ///
  /// In en, this message translates to:
  /// **'Contents'**
  String get packageContents;

  /// No description provided for @rideDetails.
  ///
  /// In en, this message translates to:
  /// **'Ride details'**
  String get rideDetails;

  /// No description provided for @deliveryInstructions.
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get deliveryInstructions;

  /// No description provided for @typeDetailsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Additional details will appear when provided by dispatch.'**
  String get typeDetailsUnavailable;

  /// No description provided for @headToPassenger.
  ///
  /// In en, this message translates to:
  /// **'Head to passenger'**
  String get headToPassenger;

  /// No description provided for @passengerDroppedOff.
  ///
  /// In en, this message translates to:
  /// **'Passenger dropped off'**
  String get passengerDroppedOff;

  /// No description provided for @completeRide.
  ///
  /// In en, this message translates to:
  /// **'Complete ride'**
  String get completeRide;

  /// No description provided for @acceptRide.
  ///
  /// In en, this message translates to:
  /// **'Accept ride'**
  String get acceptRide;

  /// No description provided for @acceptShippingOrder.
  ///
  /// In en, this message translates to:
  /// **'Accept shipment'**
  String get acceptShippingOrder;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @currentOrders.
  ///
  /// In en, this message translates to:
  /// **'Current Orders'**
  String get currentOrders;

  /// No description provided for @orderHistory.
  ///
  /// In en, this message translates to:
  /// **'Order History'**
  String get orderHistory;

  /// No description provided for @noOrdersYet.
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get noOrdersYet;

  /// No description provided for @noActiveOrders.
  ///
  /// In en, this message translates to:
  /// **'No active orders'**
  String get noActiveOrders;

  /// No description provided for @waitingForOrders.
  ///
  /// In en, this message translates to:
  /// **'Waiting for new orders...'**
  String get waitingForOrders;

  /// No description provided for @totalOrders.
  ///
  /// In en, this message translates to:
  /// **'Total Orders'**
  String get totalOrders;

  /// No description provided for @totalEarnings.
  ///
  /// In en, this message translates to:
  /// **'Total Earnings'**
  String get totalEarnings;

  /// No description provided for @avgTripTime.
  ///
  /// In en, this message translates to:
  /// **'Avg. Trip Time'**
  String get avgTripTime;

  /// No description provided for @completionRate.
  ///
  /// In en, this message translates to:
  /// **'Completion Rate'**
  String get completionRate;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @todayEarnings.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Earnings'**
  String get todayEarnings;

  /// No description provided for @weeklyEarnings.
  ///
  /// In en, this message translates to:
  /// **'Weekly Earnings'**
  String get weeklyEarnings;

  /// No description provided for @monthlyEarnings.
  ///
  /// In en, this message translates to:
  /// **'Monthly Earnings'**
  String get monthlyEarnings;

  /// No description provided for @lastMonthEarnings.
  ///
  /// In en, this message translates to:
  /// **'Last Month\'s Earnings'**
  String get lastMonthEarnings;

  /// No description provided for @viewPayslips.
  ///
  /// In en, this message translates to:
  /// **'View Payslips'**
  String get viewPayslips;

  /// No description provided for @payslipsSentEmail.
  ///
  /// In en, this message translates to:
  /// **'Payslips are sent to your email'**
  String get payslipsSentEmail;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @german.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get german;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @luxembourgish.
  ///
  /// In en, this message translates to:
  /// **'Luxembourgish'**
  String get luxembourgish;

  /// No description provided for @italian.
  ///
  /// In en, this message translates to:
  /// **'Italian'**
  String get italian;

  /// No description provided for @dutch.
  ///
  /// In en, this message translates to:
  /// **'Dutch'**
  String get dutch;

  /// No description provided for @swedish.
  ///
  /// In en, this message translates to:
  /// **'Swedish'**
  String get swedish;

  /// No description provided for @norwegian.
  ///
  /// In en, this message translates to:
  /// **'Norwegian'**
  String get norwegian;

  /// No description provided for @danish.
  ///
  /// In en, this message translates to:
  /// **'Danish'**
  String get danish;

  /// No description provided for @finnish.
  ///
  /// In en, this message translates to:
  /// **'Finnish'**
  String get finnish;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @orderNotifications.
  ///
  /// In en, this message translates to:
  /// **'Order Notifications'**
  String get orderNotifications;

  /// No description provided for @promotionalNotifications.
  ///
  /// In en, this message translates to:
  /// **'Promotional Notifications'**
  String get promotionalNotifications;

  /// No description provided for @soundEnabled.
  ///
  /// In en, this message translates to:
  /// **'Sound Enabled'**
  String get soundEnabled;

  /// No description provided for @vibrationEnabled.
  ///
  /// In en, this message translates to:
  /// **'Vibration Enabled'**
  String get vibrationEnabled;

  /// No description provided for @notificationSoundRepeats.
  ///
  /// In en, this message translates to:
  /// **'Notification sound repeats'**
  String get notificationSoundRepeats;

  /// No description provided for @notificationSoundRepeatsEnabledDesc.
  ///
  /// In en, this message translates to:
  /// **'Play the signal sound {count} time(s) for each notification.'**
  String notificationSoundRepeatsEnabledDesc(int count);

  /// No description provided for @notificationSoundRepeatsDisabledDesc.
  ///
  /// In en, this message translates to:
  /// **'Enable sound first to choose how many times the signal repeats.'**
  String get notificationSoundRepeatsDisabledDesc;

  /// No description provided for @notificationSoundRepeatsPickerDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose how many times the signal sound should repeat for each notification.'**
  String get notificationSoundRepeatsPickerDesc;

  /// No description provided for @notificationRepeatTime.
  ///
  /// In en, this message translates to:
  /// **'1 time'**
  String get notificationRepeatTime;

  /// No description provided for @notificationRepeatTimes.
  ///
  /// In en, this message translates to:
  /// **'{count} times'**
  String notificationRepeatTimes(int count);

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get noNotifications;

  /// No description provided for @noNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'You\'ll see your notifications here'**
  String get noNotificationsDesc;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @earlier.
  ///
  /// In en, this message translates to:
  /// **'Earlier'**
  String get earlier;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get markAllRead;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clearAll;

  /// No description provided for @newOrderReceived.
  ///
  /// In en, this message translates to:
  /// **'New order received'**
  String get newOrderReceived;

  /// No description provided for @orderAcceptedNotif.
  ///
  /// In en, this message translates to:
  /// **'Order accepted successfully'**
  String get orderAcceptedNotif;

  /// No description provided for @orderDeliveredNotif.
  ///
  /// In en, this message translates to:
  /// **'Order delivered successfully'**
  String get orderDeliveredNotif;

  /// No description provided for @earningsReceived.
  ///
  /// In en, this message translates to:
  /// **'Earnings received'**
  String get earningsReceived;

  /// No description provided for @weeklyReportReady.
  ///
  /// In en, this message translates to:
  /// **'Weekly report is ready'**
  String get weeklyReportReady;

  /// No description provided for @accountUpdated.
  ///
  /// In en, this message translates to:
  /// **'Account updated'**
  String get accountUpdated;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirm;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This action cannot be undone.'**
  String get deleteAccountConfirm;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection.'**
  String get networkError;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get somethingWentWrong;

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Session expired. Please login again.'**
  String get sessionExpired;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied'**
  String get locationPermissionDenied;

  /// No description provided for @enableLocationServices.
  ///
  /// In en, this message translates to:
  /// **'Please enable location services to continue'**
  String get enableLocationServices;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String version(String version);

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get goodEvening;

  /// No description provided for @locationRequired.
  ///
  /// In en, this message translates to:
  /// **'Location Required'**
  String get locationRequired;

  /// No description provided for @enableLocationAccess.
  ///
  /// In en, this message translates to:
  /// **'Enable location access to receive orders.'**
  String get enableLocationAccess;

  /// No description provided for @enable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get enable;

  /// No description provided for @pleaseEnableLocationInSettings.
  ///
  /// In en, this message translates to:
  /// **'Please enable location in settings.'**
  String get pleaseEnableLocationInSettings;

  /// No description provided for @backgroundLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Allow background location'**
  String get backgroundLocationTitle;

  /// No description provided for @backgroundLocationMessage.
  ///
  /// In en, this message translates to:
  /// **'So TaybGo can keep sending your location when the app is in the background, please open settings and select \"Allow all the time\".'**
  String get backgroundLocationMessage;

  /// No description provided for @gpsDisabled.
  ///
  /// In en, this message translates to:
  /// **'GPS Disabled'**
  String get gpsDisabled;

  /// No description provided for @pleaseEnableGps.
  ///
  /// In en, this message translates to:
  /// **'Please enable GPS to receive orders.'**
  String get pleaseEnableGps;

  /// No description provided for @failedToUpdateStatus.
  ///
  /// In en, this message translates to:
  /// **'Failed to update status'**
  String get failedToUpdateStatus;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @accountUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Account Under Review'**
  String get accountUnderReview;

  /// No description provided for @accountBeingVerified.
  ///
  /// In en, this message translates to:
  /// **'Your account is being verified. You\'ll be notified when approved.'**
  String get accountBeingVerified;

  /// No description provided for @receivingOrders.
  ///
  /// In en, this message translates to:
  /// **'Receiving orders'**
  String get receivingOrders;

  /// No description provided for @goOnlineToStart.
  ///
  /// In en, this message translates to:
  /// **'Go online to start'**
  String get goOnlineToStart;

  /// No description provided for @noRecentOrders.
  ///
  /// In en, this message translates to:
  /// **'No recent orders'**
  String get noRecentOrders;

  /// No description provided for @headToPickup.
  ///
  /// In en, this message translates to:
  /// **'Head to pickup'**
  String get headToPickup;

  /// No description provided for @onTheWay.
  ///
  /// In en, this message translates to:
  /// **'On the way'**
  String get onTheWay;

  /// No description provided for @atDelivery.
  ///
  /// In en, this message translates to:
  /// **'At delivery'**
  String get atDelivery;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @week.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get week;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @avgPerOrder.
  ///
  /// In en, this message translates to:
  /// **'Avg/Order'**
  String get avgPerOrder;

  /// No description provided for @allTime.
  ///
  /// In en, this message translates to:
  /// **'All Time'**
  String get allTime;

  /// No description provided for @noEarningsData.
  ///
  /// In en, this message translates to:
  /// **'No earnings data'**
  String get noEarningsData;

  /// No description provided for @completeOrdersToSeeEarnings.
  ///
  /// In en, this message translates to:
  /// **'Complete orders to see your earnings'**
  String get completeOrdersToSeeEarnings;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// No description provided for @joinedOn.
  ///
  /// In en, this message translates to:
  /// **'Joined {date}'**
  String joinedOn(Object date);

  /// No description provided for @driver.
  ///
  /// In en, this message translates to:
  /// **'Driver'**
  String get driver;

  /// No description provided for @knowledgeBase.
  ///
  /// In en, this message translates to:
  /// **'Knowledge Base'**
  String get knowledgeBase;

  /// No description provided for @searchForHelp.
  ///
  /// In en, this message translates to:
  /// **'Search for help...'**
  String get searchForHelp;

  /// No description provided for @noArticlesFound.
  ///
  /// In en, this message translates to:
  /// **'No articles found'**
  String get noArticlesFound;

  /// No description provided for @tryDifferentSearch.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term'**
  String get tryDifferentSearch;

  /// No description provided for @noCategoriesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No categories available'**
  String get noCategoriesAvailable;

  /// No description provided for @articlesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} articles'**
  String articlesCount(int count);

  /// No description provided for @articleNotFound.
  ///
  /// In en, this message translates to:
  /// **'Article not found'**
  String get articleNotFound;

  /// No description provided for @wasArticleHelpful.
  ///
  /// In en, this message translates to:
  /// **'Was this article helpful?'**
  String get wasArticleHelpful;

  /// No description provided for @thankYouFeedback.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your feedback!'**
  String get thankYouFeedback;

  /// No description provided for @willImproveArticle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll work on improving this article.'**
  String get willImproveArticle;

  /// No description provided for @relatedArticles.
  ///
  /// In en, this message translates to:
  /// **'Related Articles'**
  String get relatedArticles;

  /// No description provided for @kbTip.
  ///
  /// In en, this message translates to:
  /// **'Tip'**
  String get kbTip;

  /// No description provided for @kbWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get kbWarning;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @article.
  ///
  /// In en, this message translates to:
  /// **'Article'**
  String get article;

  /// No description provided for @browseKnowledgeBase.
  ///
  /// In en, this message translates to:
  /// **'Browse Knowledge Base'**
  String get browseKnowledgeBase;

  /// No description provided for @sectionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} sections'**
  String sectionsCount(int count);

  /// No description provided for @minRead.
  ///
  /// In en, this message translates to:
  /// **'{count} min read'**
  String minRead(int count);

  /// No description provided for @tourAccountUnderReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Under Review'**
  String get tourAccountUnderReviewTitle;

  /// No description provided for @tourAccountUnderReviewDesc.
  ///
  /// In en, this message translates to:
  /// **'Your account is being verified. You can explore the app while waiting for approval.'**
  String get tourAccountUnderReviewDesc;

  /// No description provided for @tourGoOnlineTitle.
  ///
  /// In en, this message translates to:
  /// **'Go Online to Receive Orders'**
  String get tourGoOnlineTitle;

  /// No description provided for @tourGoOnlineDesc.
  ///
  /// In en, this message translates to:
  /// **'Toggle this switch when you\'re ready to accept deliveries. You can go offline anytime.'**
  String get tourGoOnlineDesc;

  /// No description provided for @tourDailyStatsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Daily Stats'**
  String get tourDailyStatsTitle;

  /// No description provided for @tourDailyStatsDesc.
  ///
  /// In en, this message translates to:
  /// **'Track your orders, earnings, and rating here. Stats update in real-time.'**
  String get tourDailyStatsDesc;

  /// No description provided for @tourNewOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'New Order Received!'**
  String get tourNewOrderTitle;

  /// No description provided for @tourNewOrderDesc.
  ///
  /// In en, this message translates to:
  /// **'This is how new orders appear. Review the pickup, dropoff, distance, and payment.'**
  String get tourNewOrderDesc;

  /// No description provided for @tourOrdersTabTitle.
  ///
  /// In en, this message translates to:
  /// **'Orders Tab'**
  String get tourOrdersTabTitle;

  /// No description provided for @tourOrdersTabDesc.
  ///
  /// In en, this message translates to:
  /// **'Switch between Current Orders and Order History.'**
  String get tourOrdersTabDesc;

  /// No description provided for @tourTotalEarningsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Total Earnings'**
  String get tourTotalEarningsTitle;

  /// No description provided for @tourTotalEarningsDesc.
  ///
  /// In en, this message translates to:
  /// **'Track all your earnings here â€” base pay, tips, and bonuses.'**
  String get tourTotalEarningsDesc;

  /// No description provided for @tourEarningsBreakdownTitle.
  ///
  /// In en, this message translates to:
  /// **'Earnings Breakdown'**
  String get tourEarningsBreakdownTitle;

  /// No description provided for @tourEarningsBreakdownDesc.
  ///
  /// In en, this message translates to:
  /// **'See your total orders and average earnings per order.'**
  String get tourEarningsBreakdownDesc;

  /// No description provided for @tourRouteDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Route Details'**
  String get tourRouteDetailsTitle;

  /// No description provided for @tourRouteDetailsDesc.
  ///
  /// In en, this message translates to:
  /// **'See the full pickup and dropoff route with addresses, distance, and estimated time.'**
  String get tourRouteDetailsDesc;

  /// No description provided for @tourYourEarningsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Earnings'**
  String get tourYourEarningsTitle;

  /// No description provided for @tourYourEarningsDesc.
  ///
  /// In en, this message translates to:
  /// **'View the full payment breakdown â€” delivery fee, tip, and total payout.'**
  String get tourYourEarningsDesc;

  /// No description provided for @tourNavActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Navigation & Actions'**
  String get tourNavActionsTitle;

  /// No description provided for @tourNavActionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Navigate to pickup/dropoff or update the order status as you progress.'**
  String get tourNavActionsDesc;

  /// No description provided for @tourTurnByTurnTitle.
  ///
  /// In en, this message translates to:
  /// **'Turn-by-Turn Navigation'**
  String get tourTurnByTurnTitle;

  /// No description provided for @tourTurnByTurnDesc.
  ///
  /// In en, this message translates to:
  /// **'Follow real-time directions to your pickup or dropoff location.'**
  String get tourTurnByTurnDesc;

  /// No description provided for @tourTripControlsTitle.
  ///
  /// In en, this message translates to:
  /// **'Trip Controls'**
  String get tourTripControlsTitle;

  /// No description provided for @tourTripControlsDesc.
  ///
  /// In en, this message translates to:
  /// **'Switch between pickup and dropoff routes, view destination details and earnings.'**
  String get tourTripControlsDesc;

  /// No description provided for @tourUpdateStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Status'**
  String get tourUpdateStatusTitle;

  /// No description provided for @tourUpdateStatusDesc.
  ///
  /// In en, this message translates to:
  /// **'Tap to mark key milestones â€” On The Way, Delivered, or Complete.'**
  String get tourUpdateStatusDesc;

  /// No description provided for @tourAppSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get tourAppSettingsTitle;

  /// No description provided for @tourAppSettingsDesc.
  ///
  /// In en, this message translates to:
  /// **'Change your language, theme, and access the Knowledge Base for help.'**
  String get tourAppSettingsDesc;

  /// No description provided for @tourKnowledgeBaseTitle.
  ///
  /// In en, this message translates to:
  /// **'Knowledge Base'**
  String get tourKnowledgeBaseTitle;

  /// No description provided for @tourKnowledgeBaseDesc.
  ///
  /// In en, this message translates to:
  /// **'Browse step-by-step guides, tips, and answers to common questions.'**
  String get tourKnowledgeBaseDesc;

  /// No description provided for @tourSkipBtn.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get tourSkipBtn;

  /// No description provided for @tourBackBtn.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get tourBackBtn;

  /// No description provided for @tourNextBtn.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get tourNextBtn;

  /// No description provided for @tourDoneBtn.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get tourDoneBtn;

  /// No description provided for @tourWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to TaybGo!'**
  String get tourWelcomeTitle;

  /// No description provided for @tourWelcomeDesc.
  ///
  /// In en, this message translates to:
  /// **'Take a quick tour to learn how to use the app'**
  String get tourWelcomeDesc;

  /// No description provided for @tourSkipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get tourSkipForNow;

  /// No description provided for @tourStartBtn.
  ///
  /// In en, this message translates to:
  /// **'Take Tour'**
  String get tourStartBtn;

  /// No description provided for @tourCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Tour Complete!'**
  String get tourCompleteTitle;

  /// No description provided for @tourCompleteDesc.
  ///
  /// In en, this message translates to:
  /// **'You\'re all set to start accepting orders and earning with TaybGo!'**
  String get tourCompleteDesc;

  /// No description provided for @tourBrowseKb.
  ///
  /// In en, this message translates to:
  /// **'Browse Knowledge Base'**
  String get tourBrowseKb;

  /// No description provided for @tourGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get tourGetStarted;

  /// No description provided for @selectCountry.
  ///
  /// In en, this message translates to:
  /// **'Select Country'**
  String get selectCountry;

  /// No description provided for @searchCountry.
  ///
  /// In en, this message translates to:
  /// **'Search country...'**
  String get searchCountry;

  /// No description provided for @secure.
  ///
  /// In en, this message translates to:
  /// **'Secure'**
  String get secure;

  /// No description provided for @wellSendVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send you a verification code'**
  String get wellSendVerificationCode;

  /// No description provided for @byConsentTerms.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our Terms & Privacy'**
  String get byConsentTerms;

  /// No description provided for @otpSentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'OTP sent successfully'**
  String get otpSentSuccessfully;

  /// No description provided for @resendIn.
  ///
  /// In en, this message translates to:
  /// **'Resend in {seconds}s'**
  String resendIn(int seconds);

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendCode;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @tellUsAboutYourself.
  ///
  /// In en, this message translates to:
  /// **'Tell us about yourself'**
  String get tellUsAboutYourself;

  /// No description provided for @basicInfoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We need some basic information to set up your driver account'**
  String get basicInfoSubtitle;

  /// No description provided for @enterYourFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterYourFullName;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get notAvailable;

  /// No description provided for @verifiedViaOtp.
  ///
  /// In en, this message translates to:
  /// **'Verified via OTP'**
  String get verifiedViaOtp;

  /// No description provided for @selectYourVehicle.
  ///
  /// In en, this message translates to:
  /// **'Select your vehicle'**
  String get selectYourVehicle;

  /// No description provided for @vehicleStepSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the type of vehicle you\'ll use for deliveries'**
  String get vehicleStepSubtitle;

  /// No description provided for @chooseYourServices.
  ///
  /// In en, this message translates to:
  /// **'Choose your services'**
  String get chooseYourServices;

  /// No description provided for @servicesStepSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select the types of deliveries you want to accept'**
  String get servicesStepSubtitle;

  /// No description provided for @deliverFoodDesc.
  ///
  /// In en, this message translates to:
  /// **'Deliver food from restaurants'**
  String get deliverFoodDesc;

  /// No description provided for @deliverPackagesDesc.
  ///
  /// In en, this message translates to:
  /// **'Deliver packages and parcels'**
  String get deliverPackagesDesc;

  /// No description provided for @transportPassengersDesc.
  ///
  /// In en, this message translates to:
  /// **'Transport passengers'**
  String get transportPassengersDesc;

  /// No description provided for @changeServiceLater.
  ///
  /// In en, this message translates to:
  /// **'You can change your service preferences later in settings'**
  String get changeServiceLater;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @completeRegistration.
  ///
  /// In en, this message translates to:
  /// **'Complete Registration'**
  String get completeRegistration;

  /// No description provided for @pleaseEnterYourName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get pleaseEnterYourName;

  /// No description provided for @pleaseSelectService.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one service type'**
  String get pleaseSelectService;

  /// No description provided for @pleaseUploadDriversLicense.
  ///
  /// In en, this message translates to:
  /// **'Please upload your driver\'s license'**
  String get pleaseUploadDriversLicense;

  /// No description provided for @pleaseUploadNationalId.
  ///
  /// In en, this message translates to:
  /// **'Please upload your national ID'**
  String get pleaseUploadNationalId;

  /// No description provided for @pleaseUploadDocument.
  ///
  /// In en, this message translates to:
  /// **'Please upload {documentName}'**
  String pleaseUploadDocument(Object documentName);

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed. Please try again.'**
  String get registrationFailed;

  /// No description provided for @stepPersonal.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get stepPersonal;

  /// No description provided for @stepVehicle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get stepVehicle;

  /// No description provided for @stepServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get stepServices;

  /// No description provided for @applicationStepProgress.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String applicationStepProgress(int current, int total);

  /// No description provided for @applicationNextStep.
  ///
  /// In en, this message translates to:
  /// **'Next: {step}'**
  String applicationNextStep(String step);

  /// No description provided for @ecoFriendlyOption.
  ///
  /// In en, this message translates to:
  /// **'Eco-friendly option'**
  String get ecoFriendlyOption;

  /// No description provided for @fastAndAgile.
  ///
  /// In en, this message translates to:
  /// **'Fast and agile'**
  String get fastAndAgile;

  /// No description provided for @mostVersatile.
  ///
  /// In en, this message translates to:
  /// **'Most versatile'**
  String get mostVersatile;

  /// No description provided for @largeDeliveries.
  ///
  /// In en, this message translates to:
  /// **'Large deliveries'**
  String get largeDeliveries;

  /// No description provided for @deleteDataWarning.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete all your data including profile, ratings, and order history.'**
  String get deleteDataWarning;

  /// No description provided for @finalConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Final Confirmation'**
  String get finalConfirmation;

  /// No description provided for @finalDeleteWarning.
  ///
  /// In en, this message translates to:
  /// **'Are you absolutely sure? This action is irreversible and you will lose all your data.'**
  String get finalDeleteWarning;

  /// No description provided for @deleteMyAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete My Account'**
  String get deleteMyAccount;

  /// No description provided for @deletingAccount.
  ///
  /// In en, this message translates to:
  /// **'Deleting account...'**
  String get deletingAccount;

  /// No description provided for @accountDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Account deleted successfully'**
  String get accountDeletedSuccessfully;

  /// No description provided for @failedToDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete account: {error}'**
  String failedToDeleteAccount(String error);

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes}m ago'**
  String minutesAgo(int minutes);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours}h ago'**
  String hoursAgo(int hours);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days}d ago'**
  String daysAgo(int days);

  /// No description provided for @clearAllNotificationsConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear all notifications?'**
  String get clearAllNotificationsConfirm;

  /// No description provided for @failedToLoadNotifications.
  ///
  /// In en, this message translates to:
  /// **'Failed to load notifications'**
  String get failedToLoadNotifications;

  /// No description provided for @calculatingRoute.
  ///
  /// In en, this message translates to:
  /// **'Calculating route...'**
  String get calculatingRoute;

  /// No description provided for @orderNotFound.
  ///
  /// In en, this message translates to:
  /// **'Order not found'**
  String get orderNotFound;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @gpsUnavailableTapRetry.
  ///
  /// In en, this message translates to:
  /// **'GPS unavailable. Tap to retry.'**
  String get gpsUnavailableTapRetry;

  /// No description provided for @googleMaps.
  ///
  /// In en, this message translates to:
  /// **'Google Maps'**
  String get googleMaps;

  /// No description provided for @fetchingLocation.
  ///
  /// In en, this message translates to:
  /// **'Fetching location...'**
  String get fetchingLocation;

  /// No description provided for @secondsAgo.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s ago'**
  String secondsAgo(int seconds);

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @orderType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get orderType;

  /// No description provided for @created.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// No description provided for @accepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get accepted;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @orderPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get orderPaid;

  /// No description provided for @orderPaidDescription.
  ///
  /// In en, this message translates to:
  /// **'No cash collection needed'**
  String get orderPaidDescription;

  /// No description provided for @collectCash.
  ///
  /// In en, this message translates to:
  /// **'Collect Cash'**
  String get collectCash;

  /// No description provided for @collectCashReminder.
  ///
  /// In en, this message translates to:
  /// **'Remember to collect payment from the customer'**
  String get collectCashReminder;

  /// No description provided for @collectCashAmountReminder.
  ///
  /// In en, this message translates to:
  /// **'Collect {amount} from the customer before completing.'**
  String collectCashAmountReminder(String amount);

  /// No description provided for @locationPermissionLostWhileOnline.
  ///
  /// In en, this message translates to:
  /// **'Location access is disabled. You won\'t receive orders until it\'s enabled.'**
  String get locationPermissionLostWhileOnline;

  /// No description provided for @batteryOptimizationTitle.
  ///
  /// In en, this message translates to:
  /// **'Disable battery optimization'**
  String get batteryOptimizationTitle;

  /// No description provided for @batteryOptimizationMessage.
  ///
  /// In en, this message translates to:
  /// **'To keep live location active in the background, set TaybGo Driver to unrestricted battery use in Android settings.'**
  String get batteryOptimizationMessage;

  /// No description provided for @batteryOptimizationBannerMessage.
  ///
  /// In en, this message translates to:
  /// **'Battery optimization can pause live location while you\'re online. Set TaybGo Driver to unrestricted battery use.'**
  String get batteryOptimizationBannerMessage;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @failedToUpdateProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile'**
  String get failedToUpdateProfile;

  /// No description provided for @supportTickets.
  ///
  /// In en, this message translates to:
  /// **'Support Tickets'**
  String get supportTickets;

  /// No description provided for @supportFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get supportFilterAll;

  /// No description provided for @supportFilterOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get supportFilterOpen;

  /// No description provided for @supportFilterInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get supportFilterInProgress;

  /// No description provided for @supportFilterClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get supportFilterClosed;

  /// No description provided for @supportStatusOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get supportStatusOpen;

  /// No description provided for @supportStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get supportStatusInProgress;

  /// No description provided for @supportStatusClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get supportStatusClosed;

  /// No description provided for @supportPriorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get supportPriorityLow;

  /// No description provided for @supportPriorityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get supportPriorityMedium;

  /// No description provided for @supportPriorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get supportPriorityHigh;

  /// No description provided for @supportNoTickets.
  ///
  /// In en, this message translates to:
  /// **'No tickets yet'**
  String get supportNoTickets;

  /// No description provided for @supportNoTicketsDesc.
  ///
  /// In en, this message translates to:
  /// **'Create a ticket if you need help'**
  String get supportNoTicketsDesc;

  /// No description provided for @supportCreateTicket.
  ///
  /// In en, this message translates to:
  /// **'Create Ticket'**
  String get supportCreateTicket;

  /// No description provided for @supportTicketCreated.
  ///
  /// In en, this message translates to:
  /// **'Ticket created successfully'**
  String get supportTicketCreated;

  /// No description provided for @supportRelatedOrder.
  ///
  /// In en, this message translates to:
  /// **'Related Order'**
  String get supportRelatedOrder;

  /// No description provided for @supportSubject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get supportSubject;

  /// No description provided for @supportSubjectHint.
  ///
  /// In en, this message translates to:
  /// **'Brief description of your issue'**
  String get supportSubjectHint;

  /// No description provided for @supportSubjectRequired.
  ///
  /// In en, this message translates to:
  /// **'Subject is required'**
  String get supportSubjectRequired;

  /// No description provided for @supportMessage.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get supportMessage;

  /// No description provided for @supportMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Describe your issue in detail...'**
  String get supportMessageHint;

  /// No description provided for @supportMessageRequired.
  ///
  /// In en, this message translates to:
  /// **'Message is required'**
  String get supportMessageRequired;

  /// No description provided for @supportSubmitTicket.
  ///
  /// In en, this message translates to:
  /// **'Submit Ticket'**
  String get supportSubmitTicket;

  /// No description provided for @supportSelectOrder.
  ///
  /// In en, this message translates to:
  /// **'Select an order (optional)'**
  String get supportSelectOrder;

  /// No description provided for @supportNoOrder.
  ///
  /// In en, this message translates to:
  /// **'No specific order'**
  String get supportNoOrder;

  /// No description provided for @supportTicketDetail.
  ///
  /// In en, this message translates to:
  /// **'Ticket Detail'**
  String get supportTicketDetail;

  /// No description provided for @supportNoMessages.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get supportNoMessages;

  /// No description provided for @supportTypeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get supportTypeMessage;

  /// No description provided for @supportTicketClosed.
  ///
  /// In en, this message translates to:
  /// **'This ticket is closed'**
  String get supportTicketClosed;

  /// No description provided for @enterAge.
  ///
  /// In en, this message translates to:
  /// **'Select your birthdate'**
  String get enterAge;

  /// No description provided for @carSize.
  ///
  /// In en, this message translates to:
  /// **'Car Size'**
  String get carSize;

  /// No description provided for @selectCarSize.
  ///
  /// In en, this message translates to:
  /// **'Select car size'**
  String get selectCarSize;

  /// No description provided for @carSizeX.
  ///
  /// In en, this message translates to:
  /// **'Standard (X)'**
  String get carSizeX;

  /// No description provided for @carSizeComfort.
  ///
  /// In en, this message translates to:
  /// **'Comfort'**
  String get carSizeComfort;

  /// No description provided for @carSizeXL.
  ///
  /// In en, this message translates to:
  /// **'XL'**
  String get carSizeXL;

  /// No description provided for @carSizeBlack.
  ///
  /// In en, this message translates to:
  /// **'Black'**
  String get carSizeBlack;

  /// No description provided for @vehicleMake.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Make'**
  String get vehicleMake;

  /// No description provided for @enterVehicleMake.
  ///
  /// In en, this message translates to:
  /// **'e.g. Toyota, BMW'**
  String get enterVehicleMake;

  /// No description provided for @enterVehicleModel.
  ///
  /// In en, this message translates to:
  /// **'e.g. Corolla, 3 Series'**
  String get enterVehicleModel;

  /// No description provided for @enterVehiclePlateNumber.
  ///
  /// In en, this message translates to:
  /// **'e.g. W-AB 1234'**
  String get enterVehiclePlateNumber;

  /// No description provided for @enterVehicleColor.
  ///
  /// In en, this message translates to:
  /// **'e.g. White, Black'**
  String get enterVehicleColor;

  /// No description provided for @enterVehicleYear.
  ///
  /// In en, this message translates to:
  /// **'e.g. 2020'**
  String get enterVehicleYear;

  /// No description provided for @selectVehicleYear.
  ///
  /// In en, this message translates to:
  /// **'Select vehicle year'**
  String get selectVehicleYear;

  /// No description provided for @vehicleDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Details'**
  String get vehicleDetailsTitle;

  /// No description provided for @vehicleDetailsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us more about your vehicle'**
  String get vehicleDetailsSubtitle;

  /// No description provided for @stepDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get stepDetails;

  /// No description provided for @stepDocuments.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get stepDocuments;

  /// No description provided for @documentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Upload Documents'**
  String get documentsTitle;

  /// No description provided for @documentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload all required documents to complete your application'**
  String get documentsSubtitle;

  /// No description provided for @tapToUpload.
  ///
  /// In en, this message translates to:
  /// **'Tap to upload'**
  String get tapToUpload;

  /// No description provided for @uploadingFile.
  ///
  /// In en, this message translates to:
  /// **'Uploading...'**
  String get uploadingFile;

  /// No description provided for @uploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Upload failed. Tap to retry.'**
  String get uploadFailed;

  /// No description provided for @uploaded.
  ///
  /// In en, this message translates to:
  /// **'Uploaded'**
  String get uploaded;

  /// No description provided for @changePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get changePhoto;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @file.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get file;

  /// No description provided for @pleaseEnterAge.
  ///
  /// In en, this message translates to:
  /// **'Please select your birthdate'**
  String get pleaseEnterAge;

  /// No description provided for @invalidAge.
  ///
  /// In en, this message translates to:
  /// **'Drivers must be between 18 and 80 years old'**
  String get invalidAge;

  /// No description provided for @pleaseSelectCarSize.
  ///
  /// In en, this message translates to:
  /// **'Please select a car size'**
  String get pleaseSelectCarSize;

  /// No description provided for @pleaseEnterPlateNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter your vehicle plate number'**
  String get pleaseEnterPlateNumber;

  /// No description provided for @pleaseEnterVehicleColor.
  ///
  /// In en, this message translates to:
  /// **'Please enter your vehicle color'**
  String get pleaseEnterVehicleColor;

  /// No description provided for @pleaseEnterVehicleMake.
  ///
  /// In en, this message translates to:
  /// **'Please enter your vehicle make'**
  String get pleaseEnterVehicleMake;

  /// No description provided for @pleaseEnterVehicleModel.
  ///
  /// In en, this message translates to:
  /// **'Please enter your vehicle model'**
  String get pleaseEnterVehicleModel;

  /// No description provided for @pleaseEnterVehicleYear.
  ///
  /// In en, this message translates to:
  /// **'Please enter your vehicle year'**
  String get pleaseEnterVehicleYear;

  /// No description provided for @invalidVehicleYear.
  ///
  /// In en, this message translates to:
  /// **'Please select a valid vehicle year'**
  String get invalidVehicleYear;

  /// No description provided for @dropOrder.
  ///
  /// In en, this message translates to:
  /// **'Drop Order'**
  String get dropOrder;

  /// No description provided for @dropOrderDescription.
  ///
  /// In en, this message translates to:
  /// **'Return this accepted order to dispatch so another driver can take it.'**
  String get dropOrderDescription;

  /// No description provided for @dropOrderConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to drop this order? It will be removed from your active orders.'**
  String get dropOrderConfirmation;

  /// No description provided for @dropOrderWarning.
  ///
  /// In en, this message translates to:
  /// **'This action is only available before pickup.'**
  String get dropOrderWarning;

  /// No description provided for @keepOrder.
  ///
  /// In en, this message translates to:
  /// **'Keep Order'**
  String get keepOrder;

  /// No description provided for @orderDroppedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Order returned to dispatch'**
  String get orderDroppedSuccessfully;

  /// No description provided for @failedToDropOrder.
  ///
  /// In en, this message translates to:
  /// **'Failed to drop order. Please try again.'**
  String get failedToDropOrder;

  /// No description provided for @orderAlreadyTaken.
  ///
  /// In en, this message translates to:
  /// **'This order was already taken by another driver'**
  String get orderAlreadyTaken;

  /// No description provided for @orderSuggestionExpired.
  ///
  /// In en, this message translates to:
  /// **'This order suggestion has expired'**
  String get orderSuggestionExpired;

  /// No description provided for @failedToAcceptOrder.
  ///
  /// In en, this message translates to:
  /// **'Failed to accept order. Please try again.'**
  String get failedToAcceptOrder;

  /// No description provided for @failedToRejectOrder.
  ///
  /// In en, this message translates to:
  /// **'Failed to reject order'**
  String get failedToRejectOrder;

  /// No description provided for @changelog.
  ///
  /// In en, this message translates to:
  /// **'Changelog'**
  String get changelog;

  /// No description provided for @changelogTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s new'**
  String get changelogTitle;

  /// No description provided for @changelogSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A quick look at the latest improvements in TaybGo Driver.'**
  String get changelogSubtitle;

  /// No description provided for @changelogCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get changelogCurrent;

  /// No description provided for @changelogBuild.
  ///
  /// In en, this message translates to:
  /// **'Build'**
  String get changelogBuild;

  /// No description provided for @changelogReleased.
  ///
  /// In en, this message translates to:
  /// **'Released'**
  String get changelogReleased;

  /// No description provided for @changelogReleaseNotes.
  ///
  /// In en, this message translates to:
  /// **'Release notes'**
  String get changelogReleaseNotes;

  /// No description provided for @changelogHighlights.
  ///
  /// In en, this message translates to:
  /// **'Highlights'**
  String get changelogHighlights;

  /// No description provided for @changelogFixes.
  ///
  /// In en, this message translates to:
  /// **'Fixes'**
  String get changelogFixes;

  /// No description provided for @changelogImprovements.
  ///
  /// In en, this message translates to:
  /// **'Improvements'**
  String get changelogImprovements;

  /// No description provided for @changelogStability.
  ///
  /// In en, this message translates to:
  /// **'Stability'**
  String get changelogStability;

  /// No description provided for @changelogPlatform.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get changelogPlatform;

  /// No description provided for @changelogRelease.
  ///
  /// In en, this message translates to:
  /// **'Release'**
  String get changelogRelease;

  /// No description provided for @changelogDateAug20.
  ///
  /// In en, this message translates to:
  /// **'20 August 2026'**
  String get changelogDateAug20;

  /// No description provided for @changelogVersion101416ApplicationFlow.
  ///
  /// In en, this message translates to:
  /// **'Redesigned the driver application into five focused steps with clearer progress, organized sections, better field guidance, and inline validation.'**
  String get changelogVersion101416ApplicationFlow;

  /// No description provided for @changelogVersion101416Address.
  ///
  /// In en, this message translates to:
  /// **'Refactored address entry in registration and Edit Profile around required Google Places search, a clear selected-address summary, complete structured address data, coordinates, and stronger validation.'**
  String get changelogVersion101416Address;

  /// No description provided for @changelogVersion101416Vehicle.
  ///
  /// In en, this message translates to:
  /// **'Restored complete vehicle details and added a vehicle-year selector covering 1960 through next year.'**
  String get changelogVersion101416Vehicle;

  /// No description provided for @changelogVersion101416Documents.
  ///
  /// In en, this message translates to:
  /// **'Improved required-document presentation, upload states, and registration error feedback.'**
  String get changelogVersion101416Documents;

  /// No description provided for @changelogVersion101416DriverFee.
  ///
  /// In en, this message translates to:
  /// **'Incoming orders now show the driver\'s delivery fee instead of the customer total; paid order details show only that fee, while unpaid orders also show the amount to collect.'**
  String get changelogVersion101416DriverFee;

  /// No description provided for @changelogVersion101416OrderTypes.
  ///
  /// In en, this message translates to:
  /// **'Added type-aware Food, Shipping, and Taxi experiences with package, vehicle, car-class, instruction, status, and action details where provided by the API.'**
  String get changelogVersion101416OrderTypes;

  /// No description provided for @changelogVersion101416History.
  ///
  /// In en, this message translates to:
  /// **'Added Food, Shipping, and Taxi filters to order history with clearer type badges and references.'**
  String get changelogVersion101416History;

  /// No description provided for @changelogVersion101416Earnings.
  ///
  /// In en, this message translates to:
  /// **'Connected home and earnings summaries to driver earnings data, kept All Time as the default, and added date and order-type filters.'**
  String get changelogVersion101416Earnings;

  /// No description provided for @changelogVersion101416Reliability.
  ///
  /// In en, this message translates to:
  /// **'Improved accepted-order refresh, active-order detail loading, API status handling, and fallback behavior when optional type-specific data is unavailable.'**
  String get changelogVersion101416Reliability;

  /// No description provided for @changelogVersion101416Release.
  ///
  /// In en, this message translates to:
  /// **'Released driver app version 1.0.14+16.'**
  String get changelogVersion101416Release;

  /// No description provided for @changelogDateAug9.
  ///
  /// In en, this message translates to:
  /// **'9 August 2026'**
  String get changelogDateAug9;

  /// No description provided for @changelogDateAug11.
  ///
  /// In en, this message translates to:
  /// **'11 August 2026'**
  String get changelogDateAug11;

  /// No description provided for @changelogVersion1013Address.
  ///
  /// In en, this message translates to:
  /// **'Added optional structured driver addresses with coordinates and full-address details during registration and profile editing.'**
  String get changelogVersion1013Address;

  /// No description provided for @changelogVersion1013Status.
  ///
  /// In en, this message translates to:
  /// **'Address-only profile updates now use partial PATCH payloads and preserve an approved driver\'s status.'**
  String get changelogVersion1013Status;

  /// No description provided for @changelogVersion1013Release.
  ///
  /// In en, this message translates to:
  /// **'Released driver app version 1.0.13+15.'**
  String get changelogVersion1013Release;

  /// No description provided for @changelogDateMay31.
  ///
  /// In en, this message translates to:
  /// **'31 May 2026'**
  String get changelogDateMay31;

  /// No description provided for @changelogDateMay24.
  ///
  /// In en, this message translates to:
  /// **'24 May 2026'**
  String get changelogDateMay24;

  /// No description provided for @changelogDateMay13.
  ///
  /// In en, this message translates to:
  /// **'13 May 2026'**
  String get changelogDateMay13;

  /// No description provided for @changelogDateMay11.
  ///
  /// In en, this message translates to:
  /// **'11 May 2026'**
  String get changelogDateMay11;

  /// No description provided for @changelogCurrentTaxi.
  ///
  /// In en, this message translates to:
  /// **'Restricted Taxi service selection to car drivers and prevented bicycle drivers from enabling it during registration and profile editing.'**
  String get changelogCurrentTaxi;

  /// No description provided for @changelogVersion1113Upload.
  ///
  /// In en, this message translates to:
  /// **'Reduced web upload memory usage to make document uploads more reliable on low-end devices.'**
  String get changelogVersion1113Upload;

  /// No description provided for @changelogCurrentChangelog.
  ///
  /// In en, this message translates to:
  /// **'Added a localized, expandable changelog to Profile with release history, build numbers, dates, and release notes.'**
  String get changelogCurrentChangelog;

  /// No description provided for @changelogVersion1113Version.
  ///
  /// In en, this message translates to:
  /// **'Added the app version and release date to the sign-in screen and web splash screen.'**
  String get changelogVersion1113Version;

  /// No description provided for @changelogCurrentRelease.
  ///
  /// In en, this message translates to:
  /// **'Updated the app to version 1.0.12+14 with today\'s driver-app improvements.'**
  String get changelogCurrentRelease;

  /// No description provided for @changelogVersion1113Release.
  ///
  /// In en, this message translates to:
  /// **'Updated the Play Store build to version 1.0.11+13 (version code 13).'**
  String get changelogVersion1113Release;

  /// No description provided for @changelogVersion1112Release.
  ///
  /// In en, this message translates to:
  /// **'Released driver app version 1.0.11+12 and recorded its release metadata.'**
  String get changelogVersion1112Release;

  /// No description provided for @changelogVersion1011Documents.
  ///
  /// In en, this message translates to:
  /// **'Added required-document validation for car drivers.'**
  String get changelogVersion1011Documents;

  /// No description provided for @changelogVersion1011Uploads.
  ///
  /// In en, this message translates to:
  /// **'Marked required documents clearly and improved upload-state handling.'**
  String get changelogVersion1011Uploads;

  /// No description provided for @changelogVersion1011Feedback.
  ///
  /// In en, this message translates to:
  /// **'Improved validation and error feedback when saving profile changes.'**
  String get changelogVersion1011Feedback;

  /// No description provided for @changelogVersion1011Release.
  ///
  /// In en, this message translates to:
  /// **'Released driver app version 1.0.10+11.'**
  String get changelogVersion1011Release;

  /// No description provided for @changelogVersion0910Crashlytics.
  ///
  /// In en, this message translates to:
  /// **'Added Crashlytics reporting for fatal errors in release builds.'**
  String get changelogVersion0910Crashlytics;

  /// No description provided for @changelogVersion0910Notifications.
  ///
  /// In en, this message translates to:
  /// **'Improved notification lifecycle, deduplication, and order-notification handling.'**
  String get changelogVersion0910Notifications;

  /// No description provided for @changelogVersion0910Platform.
  ///
  /// In en, this message translates to:
  /// **'Refreshed Android, iOS, macOS, and web release configuration with development and production flavors.'**
  String get changelogVersion0910Platform;

  /// No description provided for @changelogVersion0910Release.
  ///
  /// In en, this message translates to:
  /// **'Released driver app version 1.0.9+10.'**
  String get changelogVersion0910Release;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'da',
    'de',
    'en',
    'fi',
    'fr',
    'it',
    'lb',
    'nb',
    'nl',
    'sv',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'da':
      return AppLocalizationsDa();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'fi':
      return AppLocalizationsFi();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'lb':
      return AppLocalizationsLb();
    case 'nb':
      return AppLocalizationsNb();
    case 'nl':
      return AppLocalizationsNl();
    case 'sv':
      return AppLocalizationsSv();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

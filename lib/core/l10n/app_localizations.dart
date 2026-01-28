import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

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
    Locale('de'),
    Locale('en'),
    Locale('fr'),
  ];

  /// The app name
  ///
  /// In en, this message translates to:
  /// **'TybeToGo Driver'**
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
  /// **'Age'**
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

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

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
  /// **'Order Accepted'**
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
  /// **'Order Rejected'**
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
  /// **'Track all your earnings here — base pay, tips, and bonuses.'**
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
  /// **'View the full payment breakdown — delivery fee, tip, and total payout.'**
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
  /// **'Tap to mark key milestones — On The Way, Delivered, or Complete.'**
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
  /// **'Welcome to TypeToGo!'**
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
  /// **'You\'re all set to start accepting orders and earning with TypeToGo!'**
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
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

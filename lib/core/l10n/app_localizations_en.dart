// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'TaybGo Driver';

  @override
  String get welcome => 'Welcome';

  @override
  String get getStarted => 'Get Started';

  @override
  String get next => 'Next';

  @override
  String get skip => 'Skip';

  @override
  String get done => 'Done';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get save => 'Save';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get retry => 'Retry';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get seeAll => 'See all';

  @override
  String get or => 'OR';

  @override
  String get onboardingTitle1 => 'Start Earning Today';

  @override
  String get onboardingDesc1 =>
      'Join thousands of drivers earning on their own schedule';

  @override
  String get onboardingTitle2 => 'Accept Orders Easily';

  @override
  String get onboardingDesc2 =>
      'Get notified of new orders and accept with one tap';

  @override
  String get onboardingTitle3 => 'Navigate & Deliver';

  @override
  String get onboardingDesc3 =>
      'Built-in navigation helps you reach destinations faster';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get enterPhoneNumber => 'Enter your phone number';

  @override
  String get phoneHint => '+49 123 456 7890';

  @override
  String get sendOtp => 'Send OTP';

  @override
  String get verifyOtp => 'Verify OTP';

  @override
  String get enterOtp => 'Enter the code we sent to';

  @override
  String get resendOtp => 'Resend Code';

  @override
  String resendOtpIn(int seconds) {
    return 'Resend code in ${seconds}s';
  }

  @override
  String get invalidOtp => 'Invalid verification code';

  @override
  String get otpSent => 'Verification code sent';

  @override
  String get errorsAuthPhoneAlreadyRegistered =>
      'This number is already registered.';

  @override
  String get email => 'Email';

  @override
  String get enterEmail => 'Enter your email';

  @override
  String get signUpWithApple => 'Sign up with Apple';

  @override
  String get signUpWithGoogle => 'Sign up with Google';

  @override
  String get forgotPassword => 'I forgot my password';

  @override
  String get driverApplication => 'Driver Application';

  @override
  String get personalInfo => 'Personal Information';

  @override
  String get vehicleInfo => 'Vehicle Information';

  @override
  String get documents => 'Documents';

  @override
  String get otherDocuments => 'Other Documents';

  @override
  String get reviewSubmit => 'Review & Submit';

  @override
  String get fullName => 'Full Name';

  @override
  String get age => 'Birthdate';

  @override
  String get dateOfBirth => 'Date of Birth';

  @override
  String get address => 'Address';

  @override
  String get addressStepTitle => 'Saved Address';

  @override
  String get addressStepSubtitle =>
      'Add an optional address for your driver profile.';

  @override
  String get addressOptionalSubtitle =>
      'Optional. If you add an address, complete the required fields.';

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
  String get city => 'City';

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
  String get vehicleType => 'Vehicle Type';

  @override
  String get selectVehicleType => 'Select vehicle type';

  @override
  String get car => 'Car';

  @override
  String get motorcycle => 'Motorcycle';

  @override
  String get bicycle => 'Bicycle';

  @override
  String get scooter => 'Scooter';

  @override
  String get licensePlate => 'License Plate';

  @override
  String get vehicleModel => 'Vehicle Model';

  @override
  String get vehicleYear => 'Vehicle Year';

  @override
  String get vehicleColor => 'Vehicle Color';

  @override
  String get serviceType => 'Service Type';

  @override
  String get selectServiceType => 'What services will you offer?';

  @override
  String get foodDelivery => 'Food Delivery';

  @override
  String get shipping => 'Shipping';

  @override
  String get taxi => 'Taxi';

  @override
  String get uploadDocuments => 'Upload Documents';

  @override
  String get driversLicense => 'Driver\'s License';

  @override
  String get nationalId => 'National ID';

  @override
  String get healthInsuranceDocument => 'Health Insurance Document';

  @override
  String get addressDocument => 'Address Document';

  @override
  String get bankDocument => 'Bank Document';

  @override
  String get vehicleRegistration => 'Vehicle Registration';

  @override
  String get insurance => 'Insurance';

  @override
  String get profilePhoto => 'Profile Photo';

  @override
  String get uploadPhoto => 'Upload Photo';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get chooseFromGallery => 'Choose from Gallery';

  @override
  String get submitApplication => 'Submit Application';

  @override
  String get applicationSubmitted => 'Application Submitted';

  @override
  String get applicationPending => 'Your application is under review';

  @override
  String get applicationApproved => 'Application Approved';

  @override
  String get applicationRejected => 'Application Rejected';

  @override
  String get pendingApprovalMessage =>
      'We\'re reviewing your documents. This usually takes 24-48 hours.';

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
  String get orders => 'Orders';

  @override
  String get recentOrders => 'Recent Orders';

  @override
  String get earnings => 'Earnings';

  @override
  String get profile => 'Profile';

  @override
  String get search => 'Search';

  @override
  String get online => 'Online';

  @override
  String get offline => 'Offline';

  @override
  String get goOnline => 'Go Online';

  @override
  String get goOffline => 'Go Offline';

  @override
  String get tapToGoOnline => 'Tap to go online';

  @override
  String get tapToGoOffline => 'Tap to go offline';

  @override
  String get youAreOnline => 'You\'re online and ready to receive orders';

  @override
  String get youAreOffline => 'You\'re offline. Go online to receive orders';

  @override
  String get newOrder => 'New Order';

  @override
  String get newOrderTitle => 'New Order!';

  @override
  String get newOrderSubtitle => 'Accept before time runs out';

  @override
  String get orderDetails => 'Order Details';

  @override
  String get navigate => 'Navigate';

  @override
  String get details => 'Details';

  @override
  String get acceptOrder => 'Accept Order';

  @override
  String get rejectOrder => 'Reject Order';

  @override
  String get accept => 'Accept';

  @override
  String get reject => 'Reject';

  @override
  String acceptIn(int seconds) {
    return 'Accept in ${seconds}s';
  }

  @override
  String get orderAccepted => 'Order accepted!';

  @override
  String get items => 'items';

  @override
  String get time => 'Time';

  @override
  String get orderRejected => 'Order rejected';

  @override
  String get orderCompleted => 'Order Completed';

  @override
  String get orderCancelled => 'Order Cancelled';

  @override
  String get pending => 'Pending';

  @override
  String get searchingForDriver => 'Searching for driver';

  @override
  String get driverNotificationSent => 'Driver notification sent';

  @override
  String get rejected => 'Rejected';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get delivered => 'Delivered';

  @override
  String get pickup => 'Pickup';

  @override
  String get dropoff => 'Drop-off';

  @override
  String get pickupLocation => 'Pickup Location';

  @override
  String get dropoffLocation => 'Drop-off Location';

  @override
  String get route => 'Route';

  @override
  String get inProgress => 'In Progress';

  @override
  String get headingToPickup => 'Heading to pickup location';

  @override
  String get headingToDropoff => 'Heading to drop-off location';

  @override
  String get atPickupLocation => 'At pickup location';

  @override
  String get atDropoffLocation => 'At drop-off location';

  @override
  String get orderId => 'Order ID';

  @override
  String get customer => 'Customer';

  @override
  String get itemsOrdered => 'Items';

  @override
  String get callCustomer => 'Call Customer';

  @override
  String get distance => 'Distance';

  @override
  String get estimatedTime => 'Est. Time';

  @override
  String get yourDistanceTo => 'Your distance to';

  @override
  String get km => 'km';

  @override
  String get min => 'min';

  @override
  String get startNavigation => 'Start Navigation';

  @override
  String get arrivedAtPickup => 'Arrived at Pickup';

  @override
  String get startDelivery => 'Start Delivery';

  @override
  String get arrivedAtDropoff => 'Arrived at Drop-off';

  @override
  String get completeOrder => 'Complete Order';

  @override
  String get markAsDelivered => 'Mark as Delivered';

  @override
  String get acceptOrderConfirmation =>
      'Are you sure you want to accept this order?';

  @override
  String get rejectOrderConfirmation =>
      'Are you sure you want to reject this order?';

  @override
  String get startDeliveryConfirmation =>
      'Confirm that you have picked up the order and are starting delivery?';

  @override
  String get arrivedAtDropoffConfirmation =>
      'Confirm that you have arrived at the drop-off location?';

  @override
  String get completeOrderConfirmation =>
      'Confirm that you have completed this delivery?';

  @override
  String get updatingStatus => 'Updating status...';

  @override
  String get tip => 'Tip';

  @override
  String get earnings_label => 'Earnings';

  @override
  String get deliveryFee => 'Delivery Fee';

  @override
  String get total => 'Total';

  @override
  String get currentOrders => 'Current Orders';

  @override
  String get orderHistory => 'Order History';

  @override
  String get noOrdersYet => 'No orders yet';

  @override
  String get noActiveOrders => 'No active orders';

  @override
  String get waitingForOrders => 'Waiting for new orders...';

  @override
  String get totalOrders => 'Total Orders';

  @override
  String get totalEarnings => 'Total Earnings';

  @override
  String get avgTripTime => 'Avg. Trip Time';

  @override
  String get completionRate => 'Completion Rate';

  @override
  String get rating => 'Rating';

  @override
  String get todayEarnings => 'Today\'s Earnings';

  @override
  String get weeklyEarnings => 'Weekly Earnings';

  @override
  String get monthlyEarnings => 'Monthly Earnings';

  @override
  String get lastMonthEarnings => 'Last Month\'s Earnings';

  @override
  String get viewPayslips => 'View Payslips';

  @override
  String get payslipsSentEmail => 'Payslips are sent to your email';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get german => 'German';

  @override
  String get french => 'French';

  @override
  String get arabic => 'Arabic';

  @override
  String get luxembourgish => 'Luxembourgish';

  @override
  String get italian => 'Italian';

  @override
  String get dutch => 'Dutch';

  @override
  String get swedish => 'Swedish';

  @override
  String get norwegian => 'Norwegian';

  @override
  String get danish => 'Danish';

  @override
  String get finnish => 'Finnish';

  @override
  String get theme => 'Theme';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get systemDefault => 'System Default';

  @override
  String get notifications => 'Notifications';

  @override
  String get orderNotifications => 'Order Notifications';

  @override
  String get promotionalNotifications => 'Promotional Notifications';

  @override
  String get soundEnabled => 'Sound Enabled';

  @override
  String get vibrationEnabled => 'Vibration Enabled';

  @override
  String get notificationSoundRepeats => 'Notification sound repeats';

  @override
  String notificationSoundRepeatsEnabledDesc(int count) {
    return 'Play the signal sound $count time(s) for each notification.';
  }

  @override
  String get notificationSoundRepeatsDisabledDesc =>
      'Enable sound first to choose how many times the signal repeats.';

  @override
  String get notificationSoundRepeatsPickerDesc =>
      'Choose how many times the signal sound should repeat for each notification.';

  @override
  String get notificationRepeatTime => '1 time';

  @override
  String notificationRepeatTimes(int count) {
    return '$count times';
  }

  @override
  String get noNotifications => 'No notifications yet';

  @override
  String get noNotificationsDesc => 'You\'ll see your notifications here';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get earlier => 'Earlier';

  @override
  String get markAllRead => 'Mark all as read';

  @override
  String get clearAll => 'Clear all';

  @override
  String get newOrderReceived => 'New order received';

  @override
  String get orderAcceptedNotif => 'Order accepted successfully';

  @override
  String get orderDeliveredNotif => 'Order delivered successfully';

  @override
  String get earningsReceived => 'Earnings received';

  @override
  String get weeklyReportReady => 'Weekly report is ready';

  @override
  String get accountUpdated => 'Account updated';

  @override
  String get account => 'Account';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get changePassword => 'Change Password';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirm => 'Are you sure you want to logout?';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get deleteAccountConfirm =>
      'Are you sure you want to delete your account? This action cannot be undone.';

  @override
  String get networkError => 'Network error. Please check your connection.';

  @override
  String get somethingWentWrong => 'Something went wrong. Please try again.';

  @override
  String get sessionExpired => 'Session expired. Please login again.';

  @override
  String get locationPermissionDenied => 'Location permission denied';

  @override
  String get enableLocationServices =>
      'Please enable location services to continue';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get goodMorning => 'Good morning';

  @override
  String get goodAfternoon => 'Good afternoon';

  @override
  String get goodEvening => 'Good evening';

  @override
  String get locationRequired => 'Location Required';

  @override
  String get enableLocationAccess =>
      'Enable location access to receive orders.';

  @override
  String get enable => 'Enable';

  @override
  String get pleaseEnableLocationInSettings =>
      'Please enable location in settings.';

  @override
  String get backgroundLocationTitle => 'Allow background location';

  @override
  String get backgroundLocationMessage =>
      'So TaybGo can keep sending your location when the app is in the background, please open settings and select \"Allow all the time\".';

  @override
  String get gpsDisabled => 'GPS Disabled';

  @override
  String get pleaseEnableGps => 'Please enable GPS to receive orders.';

  @override
  String get failedToUpdateStatus => 'Failed to update status';

  @override
  String get ok => 'OK';

  @override
  String get accountUnderReview => 'Account Under Review';

  @override
  String get accountBeingVerified =>
      'Your account is being verified. You\'ll be notified when approved.';

  @override
  String get receivingOrders => 'Receiving orders';

  @override
  String get goOnlineToStart => 'Go online to start';

  @override
  String get noRecentOrders => 'No recent orders';

  @override
  String get headToPickup => 'Head to pickup';

  @override
  String get onTheWay => 'On the way';

  @override
  String get atDelivery => 'At delivery';

  @override
  String get continueText => 'Continue';

  @override
  String get week => 'Week';

  @override
  String get month => 'Month';

  @override
  String get avgPerOrder => 'Avg/Order';

  @override
  String get allTime => 'All Time';

  @override
  String get noEarningsData => 'No earnings data';

  @override
  String get completeOrdersToSeeEarnings =>
      'Complete orders to see your earnings';

  @override
  String get verified => 'Verified';

  @override
  String get approved => 'Approved';

  @override
  String joinedOn(Object date) {
    return 'Joined $date';
  }

  @override
  String get driver => 'Driver';

  @override
  String get knowledgeBase => 'Knowledge Base';

  @override
  String get searchForHelp => 'Search for help...';

  @override
  String get noArticlesFound => 'No articles found';

  @override
  String get tryDifferentSearch => 'Try a different search term';

  @override
  String get noCategoriesAvailable => 'No categories available';

  @override
  String articlesCount(int count) {
    return '$count articles';
  }

  @override
  String get articleNotFound => 'Article not found';

  @override
  String get wasArticleHelpful => 'Was this article helpful?';

  @override
  String get thankYouFeedback => 'Thank you for your feedback!';

  @override
  String get willImproveArticle => 'We\'ll work on improving this article.';

  @override
  String get relatedArticles => 'Related Articles';

  @override
  String get kbTip => 'Tip';

  @override
  String get kbWarning => 'Warning';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get article => 'Article';

  @override
  String get browseKnowledgeBase => 'Browse Knowledge Base';

  @override
  String sectionsCount(int count) {
    return '$count sections';
  }

  @override
  String minRead(int count) {
    return '$count min read';
  }

  @override
  String get tourAccountUnderReviewTitle => 'Account Under Review';

  @override
  String get tourAccountUnderReviewDesc =>
      'Your account is being verified. You can explore the app while waiting for approval.';

  @override
  String get tourGoOnlineTitle => 'Go Online to Receive Orders';

  @override
  String get tourGoOnlineDesc =>
      'Toggle this switch when you\'re ready to accept deliveries. You can go offline anytime.';

  @override
  String get tourDailyStatsTitle => 'Your Daily Stats';

  @override
  String get tourDailyStatsDesc =>
      'Track your orders, earnings, and rating here. Stats update in real-time.';

  @override
  String get tourNewOrderTitle => 'New Order Received!';

  @override
  String get tourNewOrderDesc =>
      'This is how new orders appear. Review the pickup, dropoff, distance, and payment.';

  @override
  String get tourOrdersTabTitle => 'Orders Tab';

  @override
  String get tourOrdersTabDesc =>
      'Switch between Current Orders and Order History.';

  @override
  String get tourTotalEarningsTitle => 'Your Total Earnings';

  @override
  String get tourTotalEarningsDesc =>
      'Track all your earnings here â€” base pay, tips, and bonuses.';

  @override
  String get tourEarningsBreakdownTitle => 'Earnings Breakdown';

  @override
  String get tourEarningsBreakdownDesc =>
      'See your total orders and average earnings per order.';

  @override
  String get tourRouteDetailsTitle => 'Route Details';

  @override
  String get tourRouteDetailsDesc =>
      'See the full pickup and dropoff route with addresses, distance, and estimated time.';

  @override
  String get tourYourEarningsTitle => 'Your Earnings';

  @override
  String get tourYourEarningsDesc =>
      'View the full payment breakdown â€” delivery fee, tip, and total payout.';

  @override
  String get tourNavActionsTitle => 'Navigation & Actions';

  @override
  String get tourNavActionsDesc =>
      'Navigate to pickup/dropoff or update the order status as you progress.';

  @override
  String get tourTurnByTurnTitle => 'Turn-by-Turn Navigation';

  @override
  String get tourTurnByTurnDesc =>
      'Follow real-time directions to your pickup or dropoff location.';

  @override
  String get tourTripControlsTitle => 'Trip Controls';

  @override
  String get tourTripControlsDesc =>
      'Switch between pickup and dropoff routes, view destination details and earnings.';

  @override
  String get tourUpdateStatusTitle => 'Update Status';

  @override
  String get tourUpdateStatusDesc =>
      'Tap to mark key milestones â€” On The Way, Delivered, or Complete.';

  @override
  String get tourAppSettingsTitle => 'App Settings';

  @override
  String get tourAppSettingsDesc =>
      'Change your language, theme, and access the Knowledge Base for help.';

  @override
  String get tourKnowledgeBaseTitle => 'Knowledge Base';

  @override
  String get tourKnowledgeBaseDesc =>
      'Browse step-by-step guides, tips, and answers to common questions.';

  @override
  String get tourSkipBtn => 'Skip';

  @override
  String get tourBackBtn => 'Back';

  @override
  String get tourNextBtn => 'Next';

  @override
  String get tourDoneBtn => 'Done';

  @override
  String get tourWelcomeTitle => 'Welcome to TaybGo!';

  @override
  String get tourWelcomeDesc => 'Take a quick tour to learn how to use the app';

  @override
  String get tourSkipForNow => 'Skip for now';

  @override
  String get tourStartBtn => 'Take Tour';

  @override
  String get tourCompleteTitle => 'Tour Complete!';

  @override
  String get tourCompleteDesc =>
      'You\'re all set to start accepting orders and earning with TaybGo!';

  @override
  String get tourBrowseKb => 'Browse Knowledge Base';

  @override
  String get tourGetStarted => 'Get Started';

  @override
  String get selectCountry => 'Select Country';

  @override
  String get searchCountry => 'Search country...';

  @override
  String get secure => 'Secure';

  @override
  String get wellSendVerificationCode => 'We\'ll send you a verification code';

  @override
  String get byConsentTerms =>
      'By continuing, you agree to our Terms & Privacy';

  @override
  String get otpSentSuccessfully => 'OTP sent successfully';

  @override
  String resendIn(int seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get resendCode => 'Resend code';

  @override
  String get verify => 'Verify';

  @override
  String get tellUsAboutYourself => 'Tell us about yourself';

  @override
  String get basicInfoSubtitle =>
      'We need some basic information to set up your driver account';

  @override
  String get enterYourFullName => 'Enter your full name';

  @override
  String get notAvailable => 'Not available';

  @override
  String get verifiedViaOtp => 'Verified via OTP';

  @override
  String get selectYourVehicle => 'Select your vehicle';

  @override
  String get vehicleStepSubtitle =>
      'Choose the type of vehicle you\'ll use for deliveries';

  @override
  String get chooseYourServices => 'Choose your services';

  @override
  String get servicesStepSubtitle =>
      'Select the types of deliveries you want to accept';

  @override
  String get deliverFoodDesc => 'Deliver food from restaurants';

  @override
  String get deliverPackagesDesc => 'Deliver packages and parcels';

  @override
  String get transportPassengersDesc => 'Transport passengers';

  @override
  String get changeServiceLater =>
      'You can change your service preferences later in settings';

  @override
  String get back => 'Back';

  @override
  String get completeRegistration => 'Complete Registration';

  @override
  String get pleaseEnterYourName => 'Please enter your name';

  @override
  String get pleaseSelectService => 'Please select at least one service type';

  @override
  String get pleaseUploadDriversLicense =>
      'Please upload your driver\'s license';

  @override
  String get pleaseUploadNationalId => 'Please upload your national ID';

  @override
  String pleaseUploadDocument(Object documentName) {
    return 'Please upload $documentName';
  }

  @override
  String get registrationFailed => 'Registration failed. Please try again.';

  @override
  String get stepPersonal => 'Personal';

  @override
  String get stepVehicle => 'Vehicle';

  @override
  String get stepServices => 'Services';

  @override
  String get ecoFriendlyOption => 'Eco-friendly option';

  @override
  String get fastAndAgile => 'Fast and agile';

  @override
  String get mostVersatile => 'Most versatile';

  @override
  String get largeDeliveries => 'Large deliveries';

  @override
  String get van => 'Van';

  @override
  String get deleteDataWarning =>
      'This will permanently delete all your data including profile, ratings, and order history.';

  @override
  String get finalConfirmation => 'Final Confirmation';

  @override
  String get finalDeleteWarning =>
      'Are you absolutely sure? This action is irreversible and you will lose all your data.';

  @override
  String get deleteMyAccount => 'Delete My Account';

  @override
  String get deletingAccount => 'Deleting account...';

  @override
  String get accountDeletedSuccessfully => 'Account deleted successfully';

  @override
  String failedToDeleteAccount(String error) {
    return 'Failed to delete account: $error';
  }

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(int minutes) {
    return '${minutes}m ago';
  }

  @override
  String hoursAgo(int hours) {
    return '${hours}h ago';
  }

  @override
  String daysAgo(int days) {
    return '${days}d ago';
  }

  @override
  String get clearAllNotificationsConfirm =>
      'Are you sure you want to clear all notifications?';

  @override
  String get failedToLoadNotifications => 'Failed to load notifications';

  @override
  String get calculatingRoute => 'Calculating route...';

  @override
  String get orderNotFound => 'Order not found';

  @override
  String get goBack => 'Go Back';

  @override
  String get gpsUnavailableTapRetry => 'GPS unavailable. Tap to retry.';

  @override
  String get googleMaps => 'Google Maps';

  @override
  String get fetchingLocation => 'Fetching location...';

  @override
  String secondsAgo(int seconds) {
    return '${seconds}s ago';
  }

  @override
  String get subtotal => 'Subtotal';

  @override
  String get orderType => 'Type';

  @override
  String get created => 'Created';

  @override
  String get accepted => 'Accepted';

  @override
  String get completed => 'Completed';

  @override
  String get orderPaid => 'Paid';

  @override
  String get orderPaidDescription => 'No cash collection needed';

  @override
  String get collectCash => 'Collect Cash';

  @override
  String get collectCashReminder =>
      'Remember to collect payment from the customer';

  @override
  String get locationPermissionLostWhileOnline =>
      'Location access is disabled. You won\'t receive orders until it\'s enabled.';

  @override
  String get batteryOptimizationTitle => 'Disable battery optimization';

  @override
  String get batteryOptimizationMessage =>
      'To keep live location active in the background, set TaybGo Driver to unrestricted battery use in Android settings.';

  @override
  String get batteryOptimizationBannerMessage =>
      'Battery optimization can pause live location while you\'re online. Set TaybGo Driver to unrestricted battery use.';

  @override
  String get profileUpdatedSuccessfully => 'Profile updated successfully';

  @override
  String get failedToUpdateProfile => 'Failed to update profile';

  @override
  String get supportTickets => 'Support Tickets';

  @override
  String get supportFilterAll => 'All';

  @override
  String get supportFilterOpen => 'Open';

  @override
  String get supportFilterInProgress => 'In Progress';

  @override
  String get supportFilterClosed => 'Closed';

  @override
  String get supportStatusOpen => 'Open';

  @override
  String get supportStatusInProgress => 'In Progress';

  @override
  String get supportStatusClosed => 'Closed';

  @override
  String get supportPriorityLow => 'Low';

  @override
  String get supportPriorityMedium => 'Medium';

  @override
  String get supportPriorityHigh => 'High';

  @override
  String get supportNoTickets => 'No tickets yet';

  @override
  String get supportNoTicketsDesc => 'Create a ticket if you need help';

  @override
  String get supportCreateTicket => 'Create Ticket';

  @override
  String get supportTicketCreated => 'Ticket created successfully';

  @override
  String get supportRelatedOrder => 'Related Order';

  @override
  String get supportSubject => 'Subject';

  @override
  String get supportSubjectHint => 'Brief description of your issue';

  @override
  String get supportSubjectRequired => 'Subject is required';

  @override
  String get supportMessage => 'Message';

  @override
  String get supportMessageHint => 'Describe your issue in detail...';

  @override
  String get supportMessageRequired => 'Message is required';

  @override
  String get supportSubmitTicket => 'Submit Ticket';

  @override
  String get supportSelectOrder => 'Select an order (optional)';

  @override
  String get supportNoOrder => 'No specific order';

  @override
  String get supportTicketDetail => 'Ticket Detail';

  @override
  String get supportNoMessages => 'No messages yet';

  @override
  String get supportTypeMessage => 'Type a message...';

  @override
  String get supportTicketClosed => 'This ticket is closed';

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

  @override
  String get changelog => 'Changelog';

  @override
  String get changelogTitle => 'What\'s new';

  @override
  String get changelogSubtitle =>
      'A quick look at the latest improvements in TaybGo Driver.';

  @override
  String get changelogCurrent => 'Current';

  @override
  String get changelogBuild => 'Build';

  @override
  String get changelogReleased => 'Released';

  @override
  String get changelogReleaseNotes => 'Release notes';

  @override
  String get changelogHighlights => 'Highlights';

  @override
  String get changelogFixes => 'Fixes';

  @override
  String get changelogImprovements => 'Improvements';

  @override
  String get changelogStability => 'Stability';

  @override
  String get changelogPlatform => 'Platform';

  @override
  String get changelogRelease => 'Release';

  @override
  String get changelogDateAug9 => '9 August 2026';

  @override
  String get changelogDateAug11 => '11 August 2026';

  @override
  String get changelogVersion1013Address =>
      'Added optional structured driver addresses with coordinates and full-address details during registration and profile editing.';

  @override
  String get changelogVersion1013Status =>
      'Address-only profile updates now use partial PATCH payloads and preserve an approved driver\'s status.';

  @override
  String get changelogVersion1013Release =>
      'Released driver app version 1.0.13+15.';

  @override
  String get changelogDateMay31 => '31 May 2026';

  @override
  String get changelogDateMay24 => '24 May 2026';

  @override
  String get changelogDateMay13 => '13 May 2026';

  @override
  String get changelogDateMay11 => '11 May 2026';

  @override
  String get changelogCurrentTaxi =>
      'Restricted Taxi service selection to car drivers and prevented bicycle drivers from enabling it during registration and profile editing.';

  @override
  String get changelogVersion1113Upload =>
      'Reduced web upload memory usage to make document uploads more reliable on low-end devices.';

  @override
  String get changelogCurrentChangelog =>
      'Added a localized, expandable changelog to Profile with release history, build numbers, dates, and release notes.';

  @override
  String get changelogVersion1113Version =>
      'Added the app version and release date to the sign-in screen and web splash screen.';

  @override
  String get changelogCurrentRelease =>
      'Updated the app to version 1.0.12+14 with today\'s driver-app improvements.';

  @override
  String get changelogVersion1113Release =>
      'Updated the Play Store build to version 1.0.11+13 (version code 13).';

  @override
  String get changelogVersion1112Release =>
      'Released driver app version 1.0.11+12 and recorded its release metadata.';

  @override
  String get changelogVersion1011Documents =>
      'Added required-document validation for car drivers.';

  @override
  String get changelogVersion1011Uploads =>
      'Marked required documents clearly and improved upload-state handling.';

  @override
  String get changelogVersion1011Feedback =>
      'Improved validation and error feedback when saving profile changes.';

  @override
  String get changelogVersion1011Release =>
      'Released driver app version 1.0.10+11.';

  @override
  String get changelogVersion0910Crashlytics =>
      'Added Crashlytics reporting for fatal errors in release builds.';

  @override
  String get changelogVersion0910Notifications =>
      'Improved notification lifecycle, deduplication, and order-notification handling.';

  @override
  String get changelogVersion0910Platform =>
      'Refreshed Android, iOS, macOS, and web release configuration with development and production flavors.';

  @override
  String get changelogVersion0910Release =>
      'Released driver app version 1.0.9+10.';
}

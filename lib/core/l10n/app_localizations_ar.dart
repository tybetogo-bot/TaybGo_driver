// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'TaybGo سائق';

  @override
  String get welcome => 'مرحباً';

  @override
  String get getStarted => 'ابدأ الآن';

  @override
  String get next => 'التالي';

  @override
  String get skip => 'تخطي';

  @override
  String get done => 'تم';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'تأكيد';

  @override
  String get save => 'حفظ';

  @override
  String get edit => 'تعديل';

  @override
  String get delete => 'حذف';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get error => 'خطأ';

  @override
  String get success => 'نجح';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get or => 'أو';

  @override
  String get onboardingTitle1 => 'ابدأ الكسب اليوم';

  @override
  String get onboardingDesc1 =>
      'انضم إلى آلاف السائقين الذين يكسبون وفق جدولهم الخاص';

  @override
  String get onboardingTitle2 => 'قبول الطلبات بسهولة';

  @override
  String get onboardingDesc2 =>
      'احصل على إشعار بالطلبات الجديدة واقبلها بنقرة واحدة';

  @override
  String get onboardingTitle3 => 'تنقل وتوصيل';

  @override
  String get onboardingDesc3 =>
      'الملاحة المدمجة تساعدك على الوصول إلى الوجهات بشكل أسرع';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get enterPhoneNumber => 'أدخل رقم هاتفك';

  @override
  String get phoneHint => '+49 123 456 7890';

  @override
  String get sendOtp => 'إرسال رمز التحقق';

  @override
  String get verifyOtp => 'التحقق من الرمز';

  @override
  String get enterOtp => 'أدخل الرمز الذي أرسلناه إلى';

  @override
  String get resendOtp => 'إعادة إرسال الرمز';

  @override
  String resendOtpIn(int seconds) {
    return 'إعادة إرسال الرمز في $seconds ث';
  }

  @override
  String get invalidOtp => 'رمز التحقق غير صحيح';

  @override
  String get otpSent => 'تم إرسال رمز التحقق';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get enterEmail => 'أدخل بريدك الإلكتروني';

  @override
  String get signUpWithApple => 'التسجيل باستخدام Apple';

  @override
  String get signUpWithGoogle => 'التسجيل باستخدام Google';

  @override
  String get forgotPassword => 'نسيت كلمة المرور';

  @override
  String get driverApplication => 'طلب السائق';

  @override
  String get personalInfo => 'المعلومات الشخصية';

  @override
  String get vehicleInfo => 'معلومات المركبة';

  @override
  String get documents => 'الوثائق';

  @override
  String get reviewSubmit => 'المراجعة والإرسال';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get age => 'العمر';

  @override
  String get dateOfBirth => 'تاريخ الميلاد';

  @override
  String get address => 'العنوان';

  @override
  String get city => 'المدينة';

  @override
  String get vehicleType => 'نوع المركبة';

  @override
  String get selectVehicleType => 'اختر نوع المركبة';

  @override
  String get car => 'سيارة';

  @override
  String get motorcycle => 'دراجة نارية';

  @override
  String get bicycle => 'دراجة هوائية';

  @override
  String get scooter => 'سكوتر';

  @override
  String get licensePlate => 'لوحة الترخيص';

  @override
  String get vehicleModel => 'موديل المركبة';

  @override
  String get vehicleYear => 'سنة المركبة';

  @override
  String get vehicleColor => 'لون المركبة';

  @override
  String get serviceType => 'نوع الخدمة';

  @override
  String get selectServiceType => 'ما الخدمات التي ستقدمها؟';

  @override
  String get foodDelivery => 'توصيل الطعام';

  @override
  String get shipping => 'الشحن';

  @override
  String get taxi => 'تاكسي';

  @override
  String get uploadDocuments => 'رفع الوثائق';

  @override
  String get driversLicense => 'رخصة القيادة';

  @override
  String get nationalId => 'الهوية الوطنية';

  @override
  String get vehicleRegistration => 'تسجيل المركبة';

  @override
  String get insurance => 'التأمين';

  @override
  String get profilePhoto => 'صورة الملف الشخصي';

  @override
  String get uploadPhoto => 'رفع صورة';

  @override
  String get takePhoto => 'التقاط صورة';

  @override
  String get chooseFromGallery => 'اختيار من المعرض';

  @override
  String get submitApplication => 'إرسال الطلب';

  @override
  String get applicationSubmitted => 'تم إرسال الطلب';

  @override
  String get applicationPending => 'طلبك قيد المراجعة';

  @override
  String get applicationApproved => 'تمت الموافقة على الطلب';

  @override
  String get applicationRejected => 'تم رفض الطلب';

  @override
  String get pendingApprovalMessage =>
      'نحن نراجع وثائقك. عادة ما يستغرق هذا 24-48 ساعة.';

  @override
  String get home => 'الرئيسية';

  @override
  String get orders => 'الطلبات';

  @override
  String get recentOrders => 'الطلبات الأخيرة';

  @override
  String get earnings => 'الأرباح';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get search => 'بحث';

  @override
  String get online => 'متصل';

  @override
  String get offline => 'غير متصل';

  @override
  String get goOnline => 'الاتصال';

  @override
  String get goOffline => 'قطع الاتصال';

  @override
  String get tapToGoOnline => 'انقر للاتصال';

  @override
  String get tapToGoOffline => 'انقر لقطع الاتصال';

  @override
  String get youAreOnline => 'أنت متصل وجاهز لاستقبال الطلبات';

  @override
  String get youAreOffline => 'أنت غير متصل. اتصل لاستقبال الطلبات';

  @override
  String get newOrder => 'طلب جديد';

  @override
  String get newOrderTitle => 'طلب جديد!';

  @override
  String get newOrderSubtitle => 'اقبل قبل انتهاء الوقت';

  @override
  String get orderDetails => 'تفاصيل الطلب';

  @override
  String get navigate => 'التنقل';

  @override
  String get details => 'التفاصيل';

  @override
  String get acceptOrder => 'قبول الطلب';

  @override
  String get rejectOrder => 'رفض الطلب';

  @override
  String get accept => 'قبول';

  @override
  String get reject => 'رفض';

  @override
  String acceptIn(int seconds) {
    return 'قبول في $seconds ث';
  }

  @override
  String get orderAccepted => 'تم قبول الطلب';

  @override
  String get items => 'العناصر';

  @override
  String get time => 'الوقت';

  @override
  String get orderRejected => 'تم رفض الطلب';

  @override
  String get orderCompleted => 'تم إكمال الطلب';

  @override
  String get orderCancelled => 'تم إلغاء الطلب';

  @override
  String get pickup => 'الاستلام';

  @override
  String get dropoff => 'التسليم';

  @override
  String get pickupLocation => 'موقع الاستلام';

  @override
  String get dropoffLocation => 'موقع التسليم';

  @override
  String get route => 'المسار';

  @override
  String get inProgress => 'قيد التنفيذ';

  @override
  String get headingToPickup => 'في الطريق إلى موقع الاستلام';

  @override
  String get headingToDropoff => 'في الطريق إلى موقع التسليم';

  @override
  String get atPickupLocation => 'في موقع الاستلام';

  @override
  String get atDropoffLocation => 'في موقع التسليم';

  @override
  String get orderId => 'رقم الطلب';

  @override
  String get customer => 'العميل';

  @override
  String get itemsOrdered => 'العناصر';

  @override
  String get callCustomer => 'الاتصال بالعميل';

  @override
  String get distance => 'المسافة';

  @override
  String get estimatedTime => 'الوقت المقدر';

  @override
  String get yourDistanceTo => 'المسافة إلى';

  @override
  String get km => 'كم';

  @override
  String get min => 'دقيقة';

  @override
  String get startNavigation => 'بدء الملاحة';

  @override
  String get arrivedAtPickup => 'وصلت إلى موقع الاستلام';

  @override
  String get startDelivery => 'بدء التوصيل';

  @override
  String get arrivedAtDropoff => 'وصلت إلى موقع التسليم';

  @override
  String get completeOrder => 'إكمال الطلب';

  @override
  String get markAsDelivered => 'تحديد كمسلم';

  @override
  String get acceptOrderConfirmation => 'هل أنت متأكد أنك تريد قبول هذا الطلب؟';

  @override
  String get rejectOrderConfirmation => 'هل أنت متأكد أنك تريد رفض هذا الطلب؟';

  @override
  String get startDeliveryConfirmation =>
      'تأكيد أنك قد استلمت الطلب وبدأت التوصيل؟';

  @override
  String get arrivedAtDropoffConfirmation => 'تأكيد أنك وصلت إلى موقع التسليم؟';

  @override
  String get completeOrderConfirmation => 'تأكيد أنك أكملت هذا التوصيل؟';

  @override
  String get updatingStatus => 'جاري تحديث الحالة...';

  @override
  String get tip => 'إكرامية';

  @override
  String get earnings_label => 'الأرباح';

  @override
  String get deliveryFee => 'رسوم التوصيل';

  @override
  String get total => 'المجموع';

  @override
  String get currentOrders => 'الطلبات الحالية';

  @override
  String get orderHistory => 'سجل الطلبات';

  @override
  String get noOrdersYet => 'لا توجد طلبات بعد';

  @override
  String get noActiveOrders => 'لا توجد طلبات نشطة';

  @override
  String get waitingForOrders => 'في انتظار طلبات جديدة...';

  @override
  String get totalOrders => 'إجمالي الطلبات';

  @override
  String get totalEarnings => 'إجمالي الأرباح';

  @override
  String get avgTripTime => 'متوسط وقت الرحلة';

  @override
  String get completionRate => 'معدل الإكمال';

  @override
  String get rating => 'التقييم';

  @override
  String get todayEarnings => 'أرباح اليوم';

  @override
  String get weeklyEarnings => 'الأرباح الأسبوعية';

  @override
  String get monthlyEarnings => 'الأرباح الشهرية';

  @override
  String get lastMonthEarnings => 'أرباح الشهر الماضي';

  @override
  String get viewPayslips => 'عرض قسائم الرواتب';

  @override
  String get payslipsSentEmail =>
      'يتم إرسال قسائم الرواتب إلى بريدك الإلكتروني';

  @override
  String get settings => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get english => 'الإنجليزية';

  @override
  String get german => 'الألمانية';

  @override
  String get french => 'الفرنسية';

  @override
  String get arabic => 'العربية';

  @override
  String get luxembourgish => 'اللوكسمبورغية';

  @override
  String get italian => 'الإيطالية';

  @override
  String get dutch => 'الهولندية';

  @override
  String get swedish => 'السويدية';

  @override
  String get norwegian => 'النرويجية';

  @override
  String get danish => 'الدنماركية';

  @override
  String get finnish => 'الفنلندية';

  @override
  String get theme => 'المظهر';

  @override
  String get lightMode => 'الوضع الفاتح';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get systemDefault => 'النظام الافتراضي';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get orderNotifications => 'إشعارات الطلبات';

  @override
  String get promotionalNotifications => 'الإشعارات الترويجية';

  @override
  String get soundEnabled => 'الصوت مفعل';

  @override
  String get vibrationEnabled => 'الاهتزاز مفعل';

  @override
  String get noNotifications => 'لا توجد إشعارات بعد';

  @override
  String get noNotificationsDesc => 'سترى إشعاراتك هنا';

  @override
  String get today => 'اليوم';

  @override
  String get yesterday => 'أمس';

  @override
  String get earlier => 'سابقاً';

  @override
  String get markAllRead => 'تحديد الكل كمقروء';

  @override
  String get clearAll => 'مسح الكل';

  @override
  String get newOrderReceived => 'تم استلام طلب جديد';

  @override
  String get orderAcceptedNotif => 'تم قبول الطلب بنجاح';

  @override
  String get orderDeliveredNotif => 'تم تسليم الطلب بنجاح';

  @override
  String get earningsReceived => 'تم استلام الأرباح';

  @override
  String get weeklyReportReady => 'التقرير الأسبوعي جاهز';

  @override
  String get accountUpdated => 'تم تحديث الحساب';

  @override
  String get account => 'الحساب';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get termsOfService => 'شروط الخدمة';

  @override
  String get helpSupport => 'المساعدة والدعم';

  @override
  String get contactUs => 'اتصل بنا';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get logoutConfirm => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get deleteAccount => 'حذف الحساب';

  @override
  String get deleteAccountConfirm =>
      'هل أنت متأكد أنك تريد حذف حسابك؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get networkError => 'خطأ في الشبكة. يرجى التحقق من اتصالك.';

  @override
  String get somethingWentWrong => 'حدث خطأ ما. يرجى المحاولة مرة أخرى.';

  @override
  String get sessionExpired => 'انتهت الجلسة. يرجى تسجيل الدخول مرة أخرى.';

  @override
  String get locationPermissionDenied => 'تم رفض إذن الموقع';

  @override
  String get enableLocationServices => 'يرجى تمكين خدمات الموقع للمتابعة';

  @override
  String version(String version) {
    return 'الإصدار $version';
  }

  @override
  String get goodMorning => 'صباح الخير';

  @override
  String get goodAfternoon => 'مساء الخير';

  @override
  String get goodEvening => 'مساء الخير';

  @override
  String get locationRequired => 'الموقع مطلوب';

  @override
  String get enableLocationAccess =>
      'قم بتمكين الوصول إلى الموقع لاستقبال الطلبات.';

  @override
  String get enable => 'تفعيل';

  @override
  String get pleaseEnableLocationInSettings =>
      'يرجى تمكين الموقع في الإعدادات.';

  @override
  String get gpsDisabled => 'GPS معطل';

  @override
  String get pleaseEnableGps => 'يرجى تمكين GPS لاستقبال الطلبات.';

  @override
  String get failedToUpdateStatus => 'فشل تحديث الحالة';

  @override
  String get ok => 'حسناً';

  @override
  String get accountUnderReview => 'الحساب قيد المراجعة';

  @override
  String get accountBeingVerified =>
      'يتم التحقق من حسابك. سيتم إشعارك عند الموافقة.';

  @override
  String get receivingOrders => 'استقبال الطلبات';

  @override
  String get goOnlineToStart => 'اتصل للبدء';

  @override
  String get noRecentOrders => 'لا توجد طلبات حديثة';

  @override
  String get headToPickup => 'توجه إلى الاستلام';

  @override
  String get onTheWay => 'في الطريق';

  @override
  String get atDelivery => 'في موقع التسليم';

  @override
  String get continueText => 'متابعة';

  @override
  String get week => 'الأسبوع';

  @override
  String get month => 'الشهر';

  @override
  String get avgPerOrder => 'متوسط/طلب';

  @override
  String get allTime => 'كل الوقت';

  @override
  String get noEarningsData => 'لا توجد بيانات أرباح';

  @override
  String get completeOrdersToSeeEarnings => 'أكمل الطلبات لرؤية أرباحك';

  @override
  String get verified => 'موثق';

  @override
  String get driver => 'سائق';

  @override
  String get knowledgeBase => 'قاعدة المعرفة';

  @override
  String get searchForHelp => 'البحث عن مساعدة...';

  @override
  String get noArticlesFound => 'لم يتم العثور على مقالات';

  @override
  String get tryDifferentSearch => 'جرب مصطلح بحث مختلف';

  @override
  String get noCategoriesAvailable => 'لا توجد فئات متاحة';

  @override
  String articlesCount(int count) {
    return '$count مقالات';
  }

  @override
  String get articleNotFound => 'المقالة غير موجودة';

  @override
  String get wasArticleHelpful => 'هل كانت هذه المقالة مفيدة؟';

  @override
  String get thankYouFeedback => 'شكراً على ملاحظاتك!';

  @override
  String get willImproveArticle => 'سنعمل على تحسين هذه المقالة.';

  @override
  String get relatedArticles => 'مقالات ذات صلة';

  @override
  String get kbTip => 'نصيحة';

  @override
  String get kbWarning => 'تحذير';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get article => 'مقالة';

  @override
  String get browseKnowledgeBase => 'تصفح قاعدة المعرفة';

  @override
  String sectionsCount(int count) {
    return '$count أقسام';
  }

  @override
  String minRead(int count) {
    return '$count دقيقة قراءة';
  }

  @override
  String get tourAccountUnderReviewTitle => 'الحساب قيد المراجعة';

  @override
  String get tourAccountUnderReviewDesc =>
      'يتم التحقق من حسابك. يمكنك استكشاف التطبيق أثناء انتظار الموافقة.';

  @override
  String get tourGoOnlineTitle => 'اتصل لاستقبال الطلبات';

  @override
  String get tourGoOnlineDesc =>
      'قم بتبديل هذا المفتاح عندما تكون جاهزاً لقبول التوصيلات. يمكنك قطع الاتصال في أي وقت.';

  @override
  String get tourDailyStatsTitle => 'إحصائياتك اليومية';

  @override
  String get tourDailyStatsDesc =>
      'تتبع طلباتك وأرباحك وتقييمك هنا. تحدث الإحصائيات في الوقت الفعلي.';

  @override
  String get tourNewOrderTitle => 'تم استلام طلب جديد!';

  @override
  String get tourNewOrderDesc =>
      'هكذا تظهر الطلبات الجديدة. راجع الاستلام والتسليم والمسافة والدفع.';

  @override
  String get tourOrdersTabTitle => 'تبويب الطلبات';

  @override
  String get tourOrdersTabDesc => 'التبديل بين الطلبات الحالية وسجل الطلبات.';

  @override
  String get tourTotalEarningsTitle => 'إجمالي أرباحك';

  @override
  String get tourTotalEarningsDesc =>
      'تتبع جميع أرباحك هنا - الأجر الأساسي والإكراميات والمكافآت.';

  @override
  String get tourEarningsBreakdownTitle => 'تفصيل الأرباح';

  @override
  String get tourEarningsBreakdownDesc =>
      'شاهد إجمالي طلباتك ومتوسط الأرباح لكل طلب.';

  @override
  String get tourRouteDetailsTitle => 'تفاصيل المسار';

  @override
  String get tourRouteDetailsDesc =>
      'شاهد مسار الاستلام والتسليم الكامل مع العناوين والمسافة والوقت المقدر.';

  @override
  String get tourYourEarningsTitle => 'أرباحك';

  @override
  String get tourYourEarningsDesc =>
      'عرض التفصيل الكامل للدفع - رسوم التوصيل والإكرامية وإجمالي الدفع.';

  @override
  String get tourNavActionsTitle => 'الملاحة والإجراءات';

  @override
  String get tourNavActionsDesc =>
      'انتقل إلى الاستلام/التسليم أو قم بتحديث حالة الطلب أثناء التقدم.';

  @override
  String get tourTurnByTurnTitle => 'الملاحة خطوة بخطوة';

  @override
  String get tourTurnByTurnDesc =>
      'اتبع الاتجاهات في الوقت الفعلي إلى موقع الاستلام أو التسليم.';

  @override
  String get tourTripControlsTitle => 'عناصر التحكم في الرحلة';

  @override
  String get tourTripControlsDesc =>
      'التبديل بين مسارات الاستلام والتسليم، وعرض تفاصيل الوجهة والأرباح.';

  @override
  String get tourUpdateStatusTitle => 'تحديث الحالة';

  @override
  String get tourUpdateStatusDesc =>
      'انقر لتحديد المعالم الرئيسية - في الطريق، تم التسليم، أو مكتمل.';

  @override
  String get tourAppSettingsTitle => 'إعدادات التطبيق';

  @override
  String get tourAppSettingsDesc =>
      'قم بتغيير اللغة والمظهر والوصول إلى قاعدة المعرفة للمساعدة.';

  @override
  String get tourKnowledgeBaseTitle => 'قاعدة المعرفة';

  @override
  String get tourKnowledgeBaseDesc =>
      'تصفح الأدلة التفصيلية والنصائح والإجابات على الأسئلة الشائعة.';

  @override
  String get tourSkipBtn => 'تخطي';

  @override
  String get tourBackBtn => 'رجوع';

  @override
  String get tourNextBtn => 'التالي';

  @override
  String get tourDoneBtn => 'تم';

  @override
  String get tourWelcomeTitle => 'مرحباً بك في TypeToGo!';

  @override
  String get tourWelcomeDesc => 'قم بجولة سريعة لتتعلم كيفية استخدام التطبيق';

  @override
  String get tourSkipForNow => 'تخطي الآن';

  @override
  String get tourStartBtn => 'بدء الجولة';

  @override
  String get tourCompleteTitle => 'اكتملت الجولة!';

  @override
  String get tourCompleteDesc =>
      'أنت جاهز تماماً لبدء قبول الطلبات والكسب مع TypeToGo!';

  @override
  String get tourBrowseKb => 'تصفح قاعدة المعرفة';

  @override
  String get tourGetStarted => 'ابدأ';

  @override
  String get selectCountry => 'اختر الدولة';

  @override
  String get searchCountry => 'ابحث عن دولة...';

  @override
  String get secure => 'آمن';

  @override
  String get wellSendVerificationCode => 'سنرسل لك رمز التحقق';

  @override
  String get byConsentTerms =>
      'بالمتابعة، فإنك توافق على الشروط وسياسة الخصوصية';

  @override
  String get otpSentSuccessfully => 'تم إرسال رمز التحقق بنجاح';

  @override
  String resendIn(int seconds) {
    return 'إعادة الإرسال في $seconds ث';
  }

  @override
  String get resendCode => 'إعادة إرسال الرمز';

  @override
  String get verify => 'تحقق';

  @override
  String get tellUsAboutYourself => 'أخبرنا عن نفسك';

  @override
  String get basicInfoSubtitle =>
      'نحتاج بعض المعلومات الأساسية لإعداد حساب السائق الخاص بك';

  @override
  String get enterYourFullName => 'أدخل اسمك الكامل';

  @override
  String get notAvailable => 'غير متاح';

  @override
  String get verifiedViaOtp => 'تم التحقق عبر رمز OTP';

  @override
  String get selectYourVehicle => 'اختر مركبتك';

  @override
  String get vehicleStepSubtitle => 'اختر نوع المركبة التي ستستخدمها للتوصيل';

  @override
  String get chooseYourServices => 'اختر خدماتك';

  @override
  String get servicesStepSubtitle => 'اختر أنواع التوصيلات التي تريد قبولها';

  @override
  String get deliverFoodDesc => 'توصيل الطعام من المطاعم';

  @override
  String get deliverPackagesDesc => 'توصيل الطرود والحزم';

  @override
  String get transportPassengersDesc => 'نقل الركاب';

  @override
  String get changeServiceLater =>
      'يمكنك تغيير تفضيلات الخدمة لاحقاً في الإعدادات';

  @override
  String get back => 'رجوع';

  @override
  String get completeRegistration => 'إكمال التسجيل';

  @override
  String get pleaseEnterYourName => 'يرجى إدخال اسمك';

  @override
  String get pleaseSelectService => 'يرجى اختيار نوع خدمة واحد على الأقل';

  @override
  String get registrationFailed => 'فشل التسجيل. يرجى المحاولة مرة أخرى.';

  @override
  String get stepPersonal => 'شخصي';

  @override
  String get stepVehicle => 'المركبة';

  @override
  String get stepServices => 'الخدمات';

  @override
  String get ecoFriendlyOption => 'خيار صديق للبيئة';

  @override
  String get fastAndAgile => 'سريع ورشيق';

  @override
  String get mostVersatile => 'الأكثر تنوعاً';

  @override
  String get largeDeliveries => 'توصيلات كبيرة';

  @override
  String get van => 'شاحنة صغيرة';

  @override
  String get deleteDataWarning =>
      'سيؤدي هذا إلى حذف جميع بياناتك نهائياً بما في ذلك الملف الشخصي والتقييمات وسجل الطلبات.';

  @override
  String get finalConfirmation => 'تأكيد نهائي';

  @override
  String get finalDeleteWarning =>
      'هل أنت متأكد تماماً؟ هذا الإجراء لا يمكن التراجع عنه وستفقد جميع بياناتك.';

  @override
  String get deleteMyAccount => 'حذف حسابي';

  @override
  String get deletingAccount => 'جاري حذف الحساب...';

  @override
  String get accountDeletedSuccessfully => 'تم حذف الحساب بنجاح';

  @override
  String failedToDeleteAccount(String error) {
    return 'فشل حذف الحساب: $error';
  }

  @override
  String get justNow => 'الآن';

  @override
  String minutesAgo(int minutes) {
    return 'منذ $minutes دقيقة';
  }

  @override
  String hoursAgo(int hours) {
    return 'منذ $hours ساعة';
  }

  @override
  String daysAgo(int days) {
    return 'منذ $days يوم';
  }

  @override
  String get clearAllNotificationsConfirm =>
      'هل أنت متأكد أنك تريد مسح جميع الإشعارات؟';

  @override
  String get failedToLoadNotifications => 'فشل تحميل الإشعارات';

  @override
  String get calculatingRoute => 'جاري حساب المسار...';

  @override
  String get orderNotFound => 'الطلب غير موجود';

  @override
  String get goBack => 'رجوع';

  @override
  String get gpsUnavailableTapRetry => 'GPS غير متاح. انقر للمحاولة مرة أخرى.';

  @override
  String get googleMaps => 'خرائط جوجل';

  @override
  String get fetchingLocation => 'جاري تحديد الموقع...';

  @override
  String secondsAgo(int seconds) {
    return 'منذ $seconds ث';
  }

  @override
  String get subtotal => 'المجموع الفرعي';

  @override
  String get orderType => 'النوع';

  @override
  String get created => 'تم الإنشاء';

  @override
  String get accepted => 'تم القبول';

  @override
  String get completed => 'مكتمل';

  @override
  String get orderPaid => 'مدفوع';

  @override
  String get orderPaidDescription => 'لا حاجة لتحصيل نقدي';

  @override
  String get collectCash => 'تحصيل نقدي';

  @override
  String get collectCashReminder => 'تذكّر تحصيل المبلغ من العميل';

  @override
  String get locationPermissionLostWhileOnline =>
      'الوصول إلى الموقع معطل. لن تتلقى طلبات حتى يتم تفعيله.';

  @override
  String get profileUpdatedSuccessfully => 'تم تحديث الملف الشخصي بنجاح';

  @override
  String get failedToUpdateProfile => 'فشل تحديث الملف الشخصي';

  @override
  String get supportTickets => 'تذاكر الدعم';

  @override
  String get supportFilterAll => 'الكل';

  @override
  String get supportFilterOpen => 'مفتوحة';

  @override
  String get supportFilterInProgress => 'قيد التنفيذ';

  @override
  String get supportFilterClosed => 'مغلقة';

  @override
  String get supportStatusOpen => 'مفتوحة';

  @override
  String get supportStatusInProgress => 'قيد التنفيذ';

  @override
  String get supportStatusClosed => 'مغلقة';

  @override
  String get supportPriorityLow => 'منخفضة';

  @override
  String get supportPriorityMedium => 'متوسطة';

  @override
  String get supportPriorityHigh => 'عالية';

  @override
  String get supportNoTickets => 'لا توجد تذاكر بعد';

  @override
  String get supportNoTicketsDesc => 'أنشئ تذكرة إذا كنت بحاجة إلى مساعدة';

  @override
  String get supportCreateTicket => 'إنشاء تذكرة';

  @override
  String get supportTicketCreated => 'تم إنشاء التذكرة بنجاح';

  @override
  String get supportRelatedOrder => 'الطلب المرتبط';

  @override
  String get supportSubject => 'الموضوع';

  @override
  String get supportSubjectHint => 'وصف مختصر لمشكلتك';

  @override
  String get supportSubjectRequired => 'الموضوع مطلوب';

  @override
  String get supportMessage => 'الرسالة';

  @override
  String get supportMessageHint => 'صف مشكلتك بالتفصيل...';

  @override
  String get supportMessageRequired => 'الرسالة مطلوبة';

  @override
  String get supportSubmitTicket => 'إرسال التذكرة';

  @override
  String get supportSelectOrder => 'اختر طلبًا (اختياري)';

  @override
  String get supportNoOrder => 'لا يوجد طلب محدد';

  @override
  String get supportTicketDetail => 'تفاصيل التذكرة';

  @override
  String get supportNoMessages => 'لا توجد رسائل بعد';

  @override
  String get supportTypeMessage => 'اكتب رسالة...';

  @override
  String get supportTicketClosed => 'هذه التذكرة مغلقة';

  @override
  String get enterAge => 'أدخل عمرك';

  @override
  String get carSize => 'حجم السيارة';

  @override
  String get selectCarSize => 'اختر حجم السيارة';

  @override
  String get carSizeX => 'عادي (X)';

  @override
  String get carSizeComfort => 'مريح';

  @override
  String get carSizeXL => 'XL';

  @override
  String get carSizeBlack => 'بلاك';

  @override
  String get vehicleMake => 'ماركة المركبة';

  @override
  String get enterVehicleMake => 'مثال: تويوتا، بي إم دبليو';

  @override
  String get enterVehicleModel => 'مثال: كورولا، الفئة الثالثة';

  @override
  String get enterVehiclePlateNumber => 'مثال: W-AB 1234';

  @override
  String get enterVehicleColor => 'مثال: أبيض، أسود';

  @override
  String get enterVehicleYear => 'مثال: 2020';

  @override
  String get vehicleDetailsTitle => 'تفاصيل المركبة';

  @override
  String get vehicleDetailsSubtitle => 'أخبرنا المزيد عن مركبتك';

  @override
  String get stepDetails => 'التفاصيل';

  @override
  String get stepDocuments => 'الوثائق';

  @override
  String get documentsTitle => 'رفع الوثائق';

  @override
  String get documentsSubtitle => 'أضف وثائقك (اختياري - يمكنك إضافتها لاحقاً)';

  @override
  String get tapToUpload => 'انقر للرفع';

  @override
  String get uploadingFile => 'جاري الرفع...';

  @override
  String get uploadFailed => 'فشل الرفع. انقر للمحاولة مرة أخرى.';

  @override
  String get uploaded => 'تم الرفع';

  @override
  String get changePhoto => 'تغيير';

  @override
  String get camera => 'الكاميرا';

  @override
  String get gallery => 'المعرض';

  @override
  String get pleaseEnterAge => 'يرجى إدخال عمرك';

  @override
  String get invalidAge => 'يرجى إدخال عمر صحيح (18-80)';

  @override
  String get pleaseSelectCarSize => 'يرجى اختيار حجم السيارة';

  @override
  String get pleaseEnterPlateNumber => 'يرجى إدخال رقم لوحة المركبة';

  @override
  String get pleaseEnterVehicleColor => 'يرجى إدخال لون المركبة';

  @override
  String get pleaseEnterVehicleMake => 'يرجى إدخال ماركة المركبة';

  @override
  String get pleaseEnterVehicleModel => 'يرجى إدخال موديل المركبة';

  @override
  String get pleaseEnterVehicleYear => 'يرجى إدخال سنة المركبة';

  @override
  String get invalidVehicleYear => 'يرجى إدخال سنة صحيحة';
}

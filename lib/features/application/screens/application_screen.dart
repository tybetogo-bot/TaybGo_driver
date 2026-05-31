import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/l10n/framework_locale_support.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/driver_provider.dart';
import '../../../core/services/cloudinary_service.dart';
import '../../../core/services/driver_registration_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/birthdate_utils.dart';
import '../utils/document_picker.dart';

enum _RegistrationStep { personal, vehicle, details, services, documents }

enum _DocumentPickAction { camera, gallery, file }

class ApplicationScreen extends StatefulWidget {
  const ApplicationScreen({super.key});

  @override
  State<ApplicationScreen> createState() => _ApplicationScreenState();
}

class _ApplicationScreenState extends State<ApplicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();

  // Current step (0-indexed)
  int _currentStep = 0;

  // Text controllers
  final _nameController = TextEditingController();
  final _birthdateController = TextEditingController();
  final _plateNumberController = TextEditingController();
  final _vehicleColorController = TextEditingController();
  final _vehicleMakeController = TextEditingController();
  final _vehicleModelController = TextEditingController();
  final _vehicleYearController = TextEditingController();
  // Document upload state
  final CloudinaryService _cloudinaryService = CloudinaryService();
  final ImagePicker _imagePicker = ImagePicker();

  Uint8List? _drivingLicenseBytes;
  String? _drivingLicenseUrl;
  bool _drivingLicenseUploading = false;

  Uint8List? _idDocumentBytes;
  String? _idDocumentUrl;
  bool _idDocumentUploading = false;

  Uint8List? _otherDocumentsBytes;
  String? _otherDocumentsUrl;
  bool _otherDocumentsUploading = false;

  Uint8List? _healthInsuranceDocumentBytes;
  String? _healthInsuranceDocumentUrl;
  bool _healthInsuranceDocumentUploading = false;

  Uint8List? _addressDocumentBytes;
  String? _addressDocumentUrl;
  bool _addressDocumentUploading = false;

  Uint8List? _bankDocumentBytes;
  String? _bankDocumentUrl;
  bool _bankDocumentUploading = false;

  // Form state
  String _selectedVehicle = 'CAR';
  String? _selectedCarSize;
  bool _acceptsFood = true;
  bool _acceptsShipping = false;
  bool _acceptsTaxi = false;

  bool get _isBicycle => _selectedVehicle == 'BIKE';
  bool get _isMotorcycle => _selectedVehicle == 'MOTOR';
  bool get _requiresDrivingLicense => !_isBicycle;
  bool get _requiresFullVehicleDetails =>
      _selectedVehicle == 'CAR' || _selectedVehicle == 'VAN';
  bool get _shouldShowPlateNumberField =>
      _requiresFullVehicleDetails || _isMotorcycle;

  List<_RegistrationStep> get _visibleSteps {
    final steps = <_RegistrationStep>[
      _RegistrationStep.personal,
      _RegistrationStep.vehicle,
    ];

    if (_requiresFullVehicleDetails || _isMotorcycle) {
      steps.add(_RegistrationStep.details);
    }

    steps.addAll([_RegistrationStep.services, _RegistrationStep.documents]);

    return steps;
  }

  int get _totalSteps => _visibleSteps.length;

  _RegistrationStep get _currentVisibleStep {
    final steps = _visibleSteps;
    final safeIndex = _currentStep.clamp(0, steps.length - 1).toInt();
    return steps[safeIndex];
  }

  // Loading state
  bool _isLoading = false;
  String? _error;
  DateTime? _selectedBirthdate;

  List<Map<String, dynamic>> _getVehicleTypes(AppLocalizations l10n) => [
    {
      'value': 'BIKE',
      'label': l10n.bicycle,
      'icon': Icons.pedal_bike,
      'description': l10n.ecoFriendlyOption,
    },
    {
      'value': 'CAR',
      'label': l10n.car,
      'icon': Icons.directions_car,
      'description': l10n.mostVersatile,
    },
  ];

  List<Map<String, String>> _getCarSizes(AppLocalizations l10n) => [
    {'value': 'X', 'label': l10n.carSizeX},
    {'value': 'COMFORT', 'label': l10n.carSizeComfort},
    {'value': 'XL', 'label': l10n.carSizeXL},
    {'value': 'BLACK', 'label': l10n.carSizeBlack},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _birthdateController.dispose();
    _plateNumberController.dispose();
    _vehicleColorController.dispose();
    _vehicleMakeController.dispose();
    _vehicleModelController.dispose();
    _vehicleYearController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  String? _validateCurrentStep(AppLocalizations l10n) {
    switch (_currentVisibleStep) {
      case _RegistrationStep.personal:
        if (_nameController.text.trim().isEmpty) {
          return l10n.pleaseEnterYourName;
        }
        if (_selectedBirthdate == null) {
          return l10n.pleaseEnterAge;
        }
        if (!BirthdateUtils.isWithinDriverAgeRange(_selectedBirthdate!)) {
          return l10n.invalidAge;
        }
        return null;
      case _RegistrationStep.vehicle:
        return null; // Always has a selection
      case _RegistrationStep.details:
        if (_isBicycle) {
          return null;
        }
        if (_isMotorcycle) {
          if (_plateNumberController.text.trim().isEmpty) {
            return l10n.pleaseEnterPlateNumber;
          }
          return null;
        }
        if (_selectedCarSize == null) {
          return l10n.pleaseSelectCarSize;
        }
        if (_plateNumberController.text.trim().isEmpty) {
          return l10n.pleaseEnterPlateNumber;
        }
        if (_vehicleColorController.text.trim().isEmpty) {
          return l10n.pleaseEnterVehicleColor;
        }
        if (_vehicleMakeController.text.trim().isEmpty) {
          return l10n.pleaseEnterVehicleMake;
        }
        if (_vehicleModelController.text.trim().isEmpty) {
          return l10n.pleaseEnterVehicleModel;
        }
        if (_vehicleYearController.text.trim().isEmpty) {
          return l10n.pleaseEnterVehicleYear;
        }
        final year = int.tryParse(_vehicleYearController.text.trim());
        if (year == null || year < 1990 || year > DateTime.now().year + 1) {
          return l10n.invalidVehicleYear;
        }
        return null;
      case _RegistrationStep.services:
        if (!_acceptsFood && !_acceptsShipping && !_acceptsTaxi) {
          return l10n.pleaseSelectService;
        }
        return null;
      case _RegistrationStep.documents:
        final requiredDocuments = <MapEntry<String, String?>>[
          if (_requiresDrivingLicense)
            MapEntry(l10n.driversLicense, _drivingLicenseUrl),
          MapEntry(l10n.nationalId, _idDocumentUrl),
          MapEntry(l10n.healthInsuranceDocument, _healthInsuranceDocumentUrl),
          MapEntry(l10n.addressDocument, _addressDocumentUrl),
          MapEntry(l10n.bankDocument, _bankDocumentUrl),
        ];
        for (final document in requiredDocuments) {
          if (document.value == null) {
            return l10n.pleaseUploadDocument(document.key);
          }
        }
        return null;
    }
  }

  void _nextStep() {
    final l10n = AppLocalizations.of(context)!;
    final error = _validateCurrentStep(l10n);
    if (error != null) {
      setState(() => _error = error);
      return;
    }

    setState(() => _error = null);

    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
        _error = null;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _selectBirthdate() async {
    final latestBirthdate = BirthdateUtils.latestEligibleBirthdate();
    final earliestBirthdate = BirthdateUtils.earliestEligibleBirthdate();

    var initialDate = _selectedBirthdate ?? latestBirthdate;
    if (initialDate.isAfter(latestBirthdate)) {
      initialDate = latestBirthdate;
    }
    if (initialDate.isBefore(earliestBirthdate)) {
      initialDate = earliestBirthdate;
    }

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: earliestBirthdate,
      lastDate: latestBirthdate,
    );

    if (pickedDate == null || !mounted) return;

    setState(() {
      _selectedBirthdate = pickedDate;
      _birthdateController.text = _formatBirthdateForDisplay(pickedDate);
      _error = null;
    });
  }

  String _formatBirthdateForDisplay(DateTime birthdate) {
    return DateFormat.yMMMd(
      FrameworkLocaleSupport.dateFormattingLocale(
        Localizations.localeOf(context),
      ),
    ).format(birthdate);
  }

  String? _controllerValueOrNull(TextEditingController controller) {
    final value = controller.text.trim();
    return value.isEmpty ? null : value;
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    final error = _validateCurrentStep(l10n);
    if (error != null) {
      setState(() => _error = error);
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    // Try to get phone from AuthProvider first, fallback to DriverProvider profile
    final authProvider = context.read<AuthProvider>();
    final authPhone = authProvider.phoneNumber;
    final profilePhone = context.read<DriverProvider>().profile?.phone;
    final phone = authPhone ?? profilePhone ?? '';

    // Use the shared ApiClient from AuthProvider to ensure tokens are included
    final apiClient = authProvider.authService.apiClient;
    final carSize = _requiresFullVehicleDetails ? _selectedCarSize : null;
    final plateNumber = _shouldShowPlateNumberField
        ? _controllerValueOrNull(_plateNumberController)
        : null;
    final vehicleColor = _requiresFullVehicleDetails
        ? _controllerValueOrNull(_vehicleColorController)
        : null;
    final vehicleMake = _requiresFullVehicleDetails
        ? _controllerValueOrNull(_vehicleMakeController)
        : null;
    final vehicleModel = _requiresFullVehicleDetails
        ? _controllerValueOrNull(_vehicleModelController)
        : null;
    final vehicleYear = _requiresFullVehicleDetails
        ? int.tryParse(_vehicleYearController.text.trim())
        : null;

    // Debug: Check if token is available
    final token = await apiClient.tokenStorage.getAccessToken();
    debugPrint('[ApplicationScreen] Token available: ${token != null}');
    debugPrint('[ApplicationScreen] Token length: ${token?.length ?? 0}');

    final registrationService = DriverRegistrationService(apiClient: apiClient);

    try {
      final result = await registrationService.registerDriver(
        name: _nameController.text.trim(),
        phone: phone,
        birthdate: _selectedBirthdate!,
        vehicleType: _selectedVehicle,
        carSize: carSize,
        vehiclePlateNumber: plateNumber,
        vehicleColor: vehicleColor,
        vehicleMake: vehicleMake,
        vehicleModel: vehicleModel,
        vehicleYear: vehicleYear,
        acceptsFood: _acceptsFood,
        acceptsShipping: _acceptsShipping,
        acceptsTaxi: _acceptsTaxi,
        drivingLicense: _requiresDrivingLicense ? _drivingLicenseUrl : null,
        idDocument: _idDocumentUrl,
        healthInsuranceDocument: _healthInsuranceDocumentUrl,
        addressDocument: _addressDocumentUrl,
        bankDocument: _bankDocumentUrl,
        otherDocuments: _otherDocumentsUrl,
      );

      if (!mounted) return;

      if (result.success) {
        // Mark user as no longer new
        context.read<AuthProvider>().clearNewUserFlag();
        // Refresh driver profile to get verification status
        await context.read<DriverProvider>().fetchProfile();
        if (!mounted) return;
        // Go directly to home (banner will show if not verified)
        context.go(RouteConstants.home);
      } else {
        setState(() {
          _error = result.message;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = AppLocalizations.of(context)!.registrationFailed;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final secondaryColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final surfaceColor = isDark
        ? AppColors.darkSurface
        : AppColors.lightSurface;
    final backgroundColor = isDark ? AppColors.darkBg : AppColors.lightBg;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () async {
            if (_currentStep > 0) {
              _previousStep();
            } else {
              final router = GoRouter.of(context);
              await _performLogout(context);
              router.go(RouteConstants.phone);
            }
          },
        ),
        title: Text(
          l10n.driverApplication,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Step Indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: _buildStepIndicator(textColor, secondaryColor),
            ),

            // Page Content
            Expanded(
              child: Form(
                key: _formKey,
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: _buildStepPages(
                    textColor,
                    secondaryColor,
                    surfaceColor,
                    l10n,
                  ),
                ),
              ),
            ),

            // Error message
            if (_error != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: AppColors.error,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _error!,
                          style: const TextStyle(
                            color: AppColors.error,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Bottom Navigation
            Padding(
              padding: const EdgeInsets.all(24),
              child: _buildBottomButtons(textColor, secondaryColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(Color textColor, Color secondaryColor) {
    final l10n = AppLocalizations.of(context)!;
    final steps = _visibleSteps;

    return Row(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final isActive = index == _currentStep;
        final isCompleted = index < _currentStep;
        final label = _stepLabel(step, l10n);

        return Expanded(
          child: Row(
            children: [
              // Step circle
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isActive || isCompleted
                      ? AppColors.primary
                      : AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: isActive ? Colors.white : AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 4),
              // Step label
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isActive ? textColor : secondaryColor,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 11,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Connector line
              if (index < steps.length - 1)
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? AppColors.primary
                          : AppColors.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  String _stepLabel(_RegistrationStep step, AppLocalizations l10n) {
    switch (step) {
      case _RegistrationStep.personal:
        return l10n.stepPersonal;
      case _RegistrationStep.vehicle:
        return l10n.stepVehicle;
      case _RegistrationStep.details:
        return l10n.stepDetails;
      case _RegistrationStep.services:
        return l10n.stepServices;
      case _RegistrationStep.documents:
        return l10n.stepDocuments;
    }
  }

  List<Widget> _buildStepPages(
    Color textColor,
    Color secondaryColor,
    Color surfaceColor,
    AppLocalizations l10n,
  ) {
    final pages = <Widget>[];

    for (final step in _visibleSteps) {
      switch (step) {
        case _RegistrationStep.personal:
          pages.add(
            _buildPersonalInfoStep(textColor, secondaryColor, surfaceColor),
          );
          break;
        case _RegistrationStep.vehicle:
          pages.add(
            _buildVehicleStep(textColor, secondaryColor, surfaceColor, l10n),
          );
          break;
        case _RegistrationStep.details:
          pages.add(
            _buildVehicleDetailsStep(
              textColor,
              secondaryColor,
              surfaceColor,
              l10n,
            ),
          );
          break;
        case _RegistrationStep.services:
          pages.add(
            _buildServicesStep(textColor, secondaryColor, surfaceColor, l10n),
          );
          break;
        case _RegistrationStep.documents:
          pages.add(
            _buildDocumentsStep(textColor, secondaryColor, surfaceColor, l10n),
          );
          break;
      }
    }

    return pages;
  }

  Widget _buildPersonalInfoStep(
    Color textColor,
    Color secondaryColor,
    Color surfaceColor,
  ) {
    final authPhone = context.watch<AuthProvider>().phoneNumber;
    final profilePhone = context.watch<DriverProvider>().profile?.phone;
    final phone = authPhone ?? profilePhone ?? '';
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            l10n.tellUsAboutYourself,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.basicInfoSubtitle,
            style: TextStyle(fontSize: 15, color: secondaryColor),
          ),
          const SizedBox(height: 32),

          // Name field
          _buildTextField(
            controller: _nameController,
            label: l10n.fullName,
            hint: l10n.enterYourFullName,
            icon: Icons.person_outline,
            surfaceColor: surfaceColor,
            textColor: textColor,
            secondaryColor: secondaryColor,
            isRequired: true,
          ),
          const SizedBox(height: 20),

          // Birthdate field
          _buildTextField(
            controller: _birthdateController,
            label: l10n.age,
            hint: l10n.enterAge,
            icon: Icons.calendar_today_outlined,
            surfaceColor: surfaceColor,
            textColor: textColor,
            secondaryColor: secondaryColor,
            isRequired: true,
            readOnly: true,
            onTap: _selectBirthdate,
            suffixIcon: const Icon(
              Icons.calendar_month_outlined,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 20),

          // Phone (read-only)
          Text(
            l10n.phoneNumber,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: secondaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.phone,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        phone.isNotEmpty ? phone : l10n.notAvailable,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                      Text(
                        l10n.verifiedViaOtp,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.verified, color: AppColors.success, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleStep(
    Color textColor,
    Color secondaryColor,
    Color surfaceColor,
    AppLocalizations l10n,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            l10n.selectYourVehicle,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.vehicleStepSubtitle,
            style: TextStyle(fontSize: 15, color: secondaryColor),
          ),
          const SizedBox(height: 24),

          // Vehicle cards
          ...List.generate(_getVehicleTypes(l10n).length, (index) {
            final vehicle = _getVehicleTypes(l10n)[index];
            final isSelected = _selectedVehicle == vehicle['value'];

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildVehicleCard(
                vehicle: vehicle,
                isSelected: isSelected,
                onTap: () => setState(() {
                  _selectedVehicle = vehicle['value'];
                  _error = null;
                  if (_isBicycle) {
                    _selectedCarSize = null;
                    _plateNumberController.clear();
                    _vehicleColorController.clear();
                    _vehicleMakeController.clear();
                    _vehicleModelController.clear();
                    _vehicleYearController.clear();
                  } else if (_isMotorcycle) {
                    _selectedCarSize = null;
                    _vehicleColorController.clear();
                    _vehicleMakeController.clear();
                    _vehicleModelController.clear();
                    _vehicleYearController.clear();
                  }
                }),
                textColor: textColor,
                secondaryColor: secondaryColor,
                surfaceColor: surfaceColor,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildVehicleDetailsStep(
    Color textColor,
    Color secondaryColor,
    Color surfaceColor,
    AppLocalizations l10n,
  ) {
    final carSizes = _getCarSizes(l10n);
    final showFullVehicleDetails = _requiresFullVehicleDetails;
    final showPlateNumberField = _shouldShowPlateNumberField;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            l10n.vehicleDetailsTitle,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.vehicleDetailsSubtitle,
            style: TextStyle(fontSize: 15, color: secondaryColor),
          ),
          const SizedBox(height: 24),

          if (showFullVehicleDetails) ...[
            // Car size dropdown
            Row(
              children: [
                Text(
                  l10n.carSize,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: secondaryColor,
                  ),
                ),
                const Text(
                  ' *',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: DropdownButtonFormField<String>(
                initialValue: _selectedCarSize,
                decoration: InputDecoration(
                  hintText: l10n.selectCarSize,
                  hintStyle: TextStyle(
                    color: secondaryColor.withValues(alpha: 0.6),
                  ),
                  prefixIcon: Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.straighten,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                dropdownColor: surfaceColor,
                style: TextStyle(color: textColor, fontSize: 16),
                items: carSizes.map((size) {
                  return DropdownMenuItem<String>(
                    value: size['value'],
                    child: Text(size['label']!),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedCarSize = value),
              ),
            ),
            const SizedBox(height: 16),

            // Vehicle make
            _buildTextField(
              controller: _vehicleMakeController,
              label: l10n.vehicleMake,
              hint: l10n.enterVehicleMake,
              icon: Icons.factory_outlined,
              surfaceColor: surfaceColor,
              textColor: textColor,
              secondaryColor: secondaryColor,
              isRequired: true,
            ),
            const SizedBox(height: 16),

            // Vehicle model
            _buildTextField(
              controller: _vehicleModelController,
              label: l10n.vehicleModel,
              hint: l10n.enterVehicleModel,
              icon: Icons.directions_car_outlined,
              surfaceColor: surfaceColor,
              textColor: textColor,
              secondaryColor: secondaryColor,
              isRequired: true,
            ),
            const SizedBox(height: 16),

            // Vehicle year
            _buildTextField(
              controller: _vehicleYearController,
              label: l10n.vehicleYear,
              hint: l10n.enterVehicleYear,
              icon: Icons.calendar_today_outlined,
              surfaceColor: surfaceColor,
              textColor: textColor,
              secondaryColor: secondaryColor,
              keyboardType: TextInputType.number,
              isRequired: true,
            ),
            const SizedBox(height: 16),

            // Vehicle color
            _buildTextField(
              controller: _vehicleColorController,
              label: l10n.vehicleColor,
              hint: l10n.enterVehicleColor,
              icon: Icons.palette_outlined,
              surfaceColor: surfaceColor,
              textColor: textColor,
              secondaryColor: secondaryColor,
              isRequired: true,
            ),
            const SizedBox(height: 16),
          ],

          if (showPlateNumberField) ...[
            // Plate number
            _buildTextField(
              controller: _plateNumberController,
              label: l10n.licensePlate,
              hint: l10n.enterVehiclePlateNumber,
              icon: Icons.pin_outlined,
              surfaceColor: surfaceColor,
              textColor: textColor,
              secondaryColor: secondaryColor,
              isRequired: true,
            ),
            const SizedBox(height: 24),
          ] else
            const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildServicesStep(
    Color textColor,
    Color secondaryColor,
    Color surfaceColor,
    AppLocalizations l10n,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            l10n.chooseYourServices,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.servicesStepSubtitle,
            style: TextStyle(fontSize: 15, color: secondaryColor),
          ),
          const SizedBox(height: 24),

          _buildServiceCard(
            title: l10n.foodDelivery,
            description: l10n.deliverFoodDesc,
            icon: Icons.restaurant_outlined,
            isSelected: _acceptsFood,
            onTap: () => setState(() => _acceptsFood = !_acceptsFood),
            textColor: textColor,
            secondaryColor: secondaryColor,
            surfaceColor: surfaceColor,
          ),
          const SizedBox(height: 12),
          _buildServiceCard(
            title: l10n.shipping,
            description: l10n.deliverPackagesDesc,
            icon: Icons.inventory_2_outlined,
            isSelected: _acceptsShipping,
            onTap: () => setState(() => _acceptsShipping = !_acceptsShipping),
            textColor: textColor,
            secondaryColor: secondaryColor,
            surfaceColor: surfaceColor,
          ),
          const SizedBox(height: 12),
          _buildServiceCard(
            title: l10n.taxi,
            description: l10n.transportPassengersDesc,
            icon: Icons.local_taxi_outlined,
            isSelected: _acceptsTaxi,
            onTap: () => setState(() => _acceptsTaxi = !_acceptsTaxi),
            textColor: textColor,
            secondaryColor: secondaryColor,
            surfaceColor: surfaceColor,
          ),

          const SizedBox(height: 24),

          // Info card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.info, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.changeServiceLater,
                    style: TextStyle(fontSize: 13, color: textColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<PickedDocument?> _pickImageWithSource(ImageSource source) async {
    final picked = await _imagePicker.pickImage(
      source: source,
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 80,
    );
    if (picked == null) return null;

    final bytes = await picked.readAsBytes();
    return PickedDocument(
      bytes: bytes,
      fileName: picked.name,
      isImage: true,
      previewBytes: bytes,
    );
  }

  Future<PickedDocument?> _pickFile({required bool imagesOnly}) async {
    return pickDocument(imagesOnly: imagesOnly);
  }

  Future<_DocumentPickAction?> _pickDocumentFromChooser(
    AppLocalizations l10n,
    String label,
  ) async {
    return showModalBottomSheet<_DocumentPickAction>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final sheetBg = isDark ? AppColors.darkSurface : AppColors.lightSurface;
        return Container(
          color: sheetBg,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  if (!kIsWeb) ...[
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            Navigator.pop(ctx, _DocumentPickAction.camera),
                        icon: const Icon(Icons.camera_alt_outlined),
                        label: Text(l10n.camera),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          Navigator.pop(ctx, _DocumentPickAction.gallery),
                      icon: const Icon(Icons.photo_library_outlined),
                      label: Text(l10n.gallery),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pop(ctx, _DocumentPickAction.file),
                  icon: const Icon(Icons.insert_drive_file_outlined),
                  label: Text(l10n.file),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickAndUpload({
    required String label,
    required String folder,
    required void Function(Uint8List? bytes) setBytes,
    required void Function(String? url) setUrl,
    required void Function(bool loading) setLoading,
  }) async {
    final l10n = AppLocalizations.of(context)!;

    // On web, skip the bottom sheet entirely and call the picker directly.
    // Two reasons:
    //  1. image_picker's camera source doesn't work on web.
    //  2. Navigator.pop(context) before opening the picker breaks the
    //     browser's user-activation chain (especially iOS Safari) and the
    //     <input> click gets blocked silently. iOS Safari's native
    //     <input type="file"> already shows Photo Library / Take Photo /
    //     Browse in its own sheet, so we don't lose any UX.
    final PickedDocument? picked;
    if (kIsWeb) {
      picked = await _pickFile(imagesOnly: false);
    } else {
      final action = await _pickDocumentFromChooser(l10n, label);
      if (action == null) return;

      picked = switch (action) {
        _DocumentPickAction.camera => await _pickImageWithSource(
          ImageSource.camera,
        ),
        _DocumentPickAction.gallery => await _pickImageWithSource(
          ImageSource.gallery,
        ),
        _DocumentPickAction.file => await _pickFile(imagesOnly: false),
      };
    }
    if (picked == null) return;
    final document = picked;

    setState(() {
      setBytes(document.previewBytes);
      setLoading(true);
      _error = null;
    });

    final url = await _cloudinaryService.uploadFile(
      document.bytes,
      fileName: document.fileName,
      folder: folder,
      resourceType: document.isImage ? 'auto' : 'raw',
    );

    if (!mounted) return;
    setState(() {
      setLoading(false);
      if (url != null) {
        setUrl(url);
      } else {
        _error = l10n.uploadFailed;
      }
    });
  }

  Widget _buildDocumentsStep(
    Color textColor,
    Color secondaryColor,
    Color surfaceColor,
    AppLocalizations l10n,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            l10n.documentsTitle,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.documentsSubtitle,
            style: TextStyle(fontSize: 15, color: secondaryColor),
          ),
          const SizedBox(height: 24),

          if (_requiresDrivingLicense) ...[
            _buildUploadCard(
              label: l10n.driversLicense,
              icon: Icons.badge_outlined,
              bytes: _drivingLicenseBytes,
              url: _drivingLicenseUrl,
              isUploading: _drivingLicenseUploading,
              onTap: () => _pickAndUpload(
                label: l10n.driversLicense,
                folder: 'driver_licenses',
                setBytes: (b) => _drivingLicenseBytes = b,
                setUrl: (u) => _drivingLicenseUrl = u,
                setLoading: (l) => _drivingLicenseUploading = l,
              ),
              textColor: textColor,
              secondaryColor: secondaryColor,
              surfaceColor: surfaceColor,
              l10n: l10n,
              isRequired: true,
            ),
            const SizedBox(height: 16),
          ],

          // ID document
          _buildUploadCard(
            label: l10n.nationalId,
            icon: Icons.credit_card_outlined,
            bytes: _idDocumentBytes,
            url: _idDocumentUrl,
            isUploading: _idDocumentUploading,
            onTap: () => _pickAndUpload(
              label: l10n.nationalId,
              folder: 'id_documents',
              setBytes: (b) => _idDocumentBytes = b,
              setUrl: (u) => _idDocumentUrl = u,
              setLoading: (l) => _idDocumentUploading = l,
            ),
            textColor: textColor,
            secondaryColor: secondaryColor,
            surfaceColor: surfaceColor,
            l10n: l10n,
            isRequired: true,
          ),
          const SizedBox(height: 16),

          _buildUploadCard(
            label: l10n.healthInsuranceDocument,
            icon: Icons.health_and_safety_outlined,
            bytes: _healthInsuranceDocumentBytes,
            url: _healthInsuranceDocumentUrl,
            isUploading: _healthInsuranceDocumentUploading,
            onTap: () => _pickAndUpload(
              label: l10n.healthInsuranceDocument,
              folder: 'health_insurance_documents',
              setBytes: (b) => _healthInsuranceDocumentBytes = b,
              setUrl: (u) => _healthInsuranceDocumentUrl = u,
              setLoading: (l) => _healthInsuranceDocumentUploading = l,
            ),
            textColor: textColor,
            secondaryColor: secondaryColor,
            surfaceColor: surfaceColor,
            l10n: l10n,
            isRequired: true,
          ),
          const SizedBox(height: 16),

          _buildUploadCard(
            label: l10n.addressDocument,
            icon: Icons.home_outlined,
            bytes: _addressDocumentBytes,
            url: _addressDocumentUrl,
            isUploading: _addressDocumentUploading,
            onTap: () => _pickAndUpload(
              label: l10n.addressDocument,
              folder: 'address_documents',
              setBytes: (b) => _addressDocumentBytes = b,
              setUrl: (u) => _addressDocumentUrl = u,
              setLoading: (l) => _addressDocumentUploading = l,
            ),
            textColor: textColor,
            secondaryColor: secondaryColor,
            surfaceColor: surfaceColor,
            l10n: l10n,
            isRequired: true,
          ),
          const SizedBox(height: 16),

          _buildUploadCard(
            label: l10n.bankDocument,
            icon: Icons.account_balance_outlined,
            bytes: _bankDocumentBytes,
            url: _bankDocumentUrl,
            isUploading: _bankDocumentUploading,
            onTap: () => _pickAndUpload(
              label: l10n.bankDocument,
              folder: 'bank_documents',
              setBytes: (b) => _bankDocumentBytes = b,
              setUrl: (u) => _bankDocumentUrl = u,
              setLoading: (l) => _bankDocumentUploading = l,
            ),
            textColor: textColor,
            secondaryColor: secondaryColor,
            surfaceColor: surfaceColor,
            l10n: l10n,
            isRequired: true,
          ),
          const SizedBox(height: 24),

          // Other documents
          _buildUploadCard(
            label: l10n.otherDocuments,
            icon: Icons.description_outlined,
            bytes: _otherDocumentsBytes,
            url: _otherDocumentsUrl,
            isUploading: _otherDocumentsUploading,
            onTap: () => _pickAndUpload(
              label: l10n.otherDocuments,
              folder: 'other_documents',
              setBytes: (b) => _otherDocumentsBytes = b,
              setUrl: (u) => _otherDocumentsUrl = u,
              setLoading: (l) => _otherDocumentsUploading = l,
            ),
            textColor: textColor,
            secondaryColor: secondaryColor,
            surfaceColor: surfaceColor,
            l10n: l10n,
          ),
          const SizedBox(height: 16),

          // Info card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.info, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.documentsSubtitle,
                    style: TextStyle(fontSize: 13, color: textColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadCard({
    required String label,
    required IconData icon,
    required Uint8List? bytes,
    required String? url,
    required bool isUploading,
    required VoidCallback onTap,
    required Color textColor,
    required Color secondaryColor,
    required Color surfaceColor,
    required AppLocalizations l10n,
    bool isRequired = false,
  }) {
    final previewBytes = bytes;
    final hasBytes = previewBytes != null && previewBytes.isNotEmpty;
    final isUploaded = url != null;

    return GestureDetector(
      onTap: isUploading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isUploaded
              ? AppColors.success.withValues(alpha: 0.05)
              : surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUploaded
                ? AppColors.success
                : hasBytes
                ? AppColors.primary
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon or thumbnail
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isUploaded
                    ? AppColors.success.withValues(alpha: 0.15)
                    : AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: hasBytes
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(
                        previewBytes,
                        fit: BoxFit.cover,
                        // Decode to a thumbnail-sized bitmap, not the full
                        // image. Full-res decodes across several documents can
                        // exhaust memory and reload the tab on low-end web.
                        cacheWidth: 200,
                      ),
                    )
                  : Icon(
                      icon,
                      color: isUploaded ? AppColors.success : AppColors.primary,
                      size: 28,
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      if (isRequired)
                        const Text(
                          ' *',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.error,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (isUploading)
                    Row(
                      children: [
                        const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.uploadingFile,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    )
                  else if (isUploaded)
                    Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.success,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          l10n.uploaded,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.success,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '· ${l10n.changePhoto}',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      l10n.tapToUpload,
                      style: TextStyle(fontSize: 13, color: secondaryColor),
                    ),
                ],
              ),
            ),
            Icon(
              isUploaded ? Icons.check_circle : Icons.cloud_upload_outlined,
              color: isUploaded
                  ? AppColors.success
                  : secondaryColor.withValues(alpha: 0.5),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Color surfaceColor,
    required Color textColor,
    required Color secondaryColor,
    TextInputType keyboardType = TextInputType.text,
    bool isRequired = false,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: secondaryColor,
              ),
            ),
            if (isRequired)
              const Text(
                ' *',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.error,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            readOnly: readOnly,
            onTap: onTap,
            style: TextStyle(color: textColor, fontSize: 16),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: secondaryColor.withValues(alpha: 0.6),
              ),
              prefixIcon: Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppColors.primary, size: 20),
              ),
              suffixIcon: suffixIcon,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleCard({
    required Map<String, dynamic> vehicle,
    required bool isSelected,
    required VoidCallback onTap,
    required Color textColor,
    required Color secondaryColor,
    required Color surfaceColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.05)
              : surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.15)
                    : AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(vehicle['icon'], color: AppColors.primary, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vehicle['label'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    vehicle['description'],
                    style: TextStyle(fontSize: 13, color: secondaryColor),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : secondaryColor.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard({
    required String title,
    required String description,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    required Color textColor,
    required Color secondaryColor,
    required Color surfaceColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.05)
              : surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.15)
                    : AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: TextStyle(fontSize: 13, color: secondaryColor),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : surfaceColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : secondaryColor.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtons(Color textColor, Color secondaryColor) {
    final isLastStep = _currentStep == _totalSteps - 1;

    return Row(
      children: [
        // Cancel button (first step) / Back button (other steps)
        if (_currentStep == 0)
          Expanded(
            child: OutlinedButton(
              onPressed: () async {
                final router = GoRouter.of(context);
                await _performLogout(context);
                router.go(RouteConstants.phone);
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: secondaryColor.withValues(alpha: 0.3)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        if (_currentStep > 0)
          Expanded(
            child: OutlinedButton(
              onPressed: _previousStep,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: secondaryColor.withValues(alpha: 0.3)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.back,
                style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        const SizedBox(width: 12),

        // Next/Submit button
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: _isLoading ? null : (isLastStep ? _submit : _nextStep),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isLastStep
                            ? AppLocalizations.of(context)!.completeRegistration
                            : AppLocalizations.of(context)!.continueText,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      if (!isLastStep) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, size: 20),
                      ],
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _performLogout(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final authProvider = context.read<AuthProvider>();
    NavigatorState? dialogNavigator;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        dialogNavigator = Navigator.of(ctx);
        return Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(l10n.loading),
                ],
              ),
            ),
          ),
        );
      },
    );

    try {
      await authProvider.logout();
    } finally {
      if (dialogNavigator?.mounted ?? false) {
        dialogNavigator!.pop();
      }
    }
  }
}

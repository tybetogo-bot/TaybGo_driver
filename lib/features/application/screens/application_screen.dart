import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/driver_provider.dart';
import '../../../core/providers/notification_provider.dart';
import '../../../core/providers/order_provider.dart';
import '../../../core/providers/tour_provider.dart';
import '../../../core/services/cloudinary_service.dart';
import '../../../core/services/driver_registration_service.dart';
import '../../../core/theme/app_colors.dart';

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
  static const int _totalSteps = 5;

  // Text controllers
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
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

  // Form state
  String _selectedVehicle = 'CAR';
  String? _selectedCarSize;
  bool _acceptsFood = true;
  bool _acceptsShipping = false;
  bool _acceptsTaxi = false;

  // Loading state
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> _getVehicleTypes(AppLocalizations l10n) => [
    {'value': 'BIKE', 'label': l10n.bicycle, 'icon': Icons.pedal_bike, 'description': l10n.ecoFriendlyOption},
    {'value': 'MOTOR', 'label': l10n.motorcycle, 'icon': Icons.two_wheeler, 'description': l10n.fastAndAgile},
    {'value': 'CAR', 'label': l10n.car, 'icon': Icons.directions_car, 'description': l10n.mostVersatile},
    {'value': 'VAN', 'label': l10n.van, 'icon': Icons.airport_shuttle, 'description': l10n.largeDeliveries},
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
    _ageController.dispose();
    _plateNumberController.dispose();
    _vehicleColorController.dispose();
    _vehicleMakeController.dispose();
    _vehicleModelController.dispose();
    _vehicleYearController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  String? _validateCurrentStep(AppLocalizations l10n) {
    switch (_currentStep) {
      case 0: // Personal info
        if (_nameController.text.trim().isEmpty) {
          return l10n.pleaseEnterYourName;
        }
        if (_ageController.text.trim().isEmpty) {
          return l10n.pleaseEnterAge;
        }
        final age = int.tryParse(_ageController.text.trim());
        if (age == null || age < 18 || age > 80) {
          return l10n.invalidAge;
        }
        return null;
      case 1: // Vehicle type
        return null; // Always has a selection
      case 2: // Vehicle details
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
      case 3: // Services
        if (!_acceptsFood && !_acceptsShipping && !_acceptsTaxi) {
          return l10n.pleaseSelectService;
        }
        return null;
      case 4: // Documents (optional)
        return null;
      default:
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

    // Debug: Check if token is available
    final token = await apiClient.tokenStorage.getAccessToken();
    debugPrint('[ApplicationScreen] Token available: ${token != null}');
    debugPrint('[ApplicationScreen] Token length: ${token?.length ?? 0}');

    final registrationService = DriverRegistrationService(apiClient: apiClient);

    try {
      final result = await registrationService.registerDriver(
        name: _nameController.text.trim(),
        phone: phone,
        age: int.parse(_ageController.text.trim()),
        vehicleType: _selectedVehicle,
        carSize: _selectedCarSize!,
        vehiclePlateNumber: _plateNumberController.text.trim(),
        vehicleColor: _vehicleColorController.text.trim(),
        vehicleMake: _vehicleMakeController.text.trim(),
        vehicleModel: _vehicleModelController.text.trim(),
        vehicleYear: int.parse(_vehicleYearController.text.trim()),
        acceptsFood: _acceptsFood,
        acceptsShipping: _acceptsShipping,
        acceptsTaxi: _acceptsTaxi,
        drivingLicense: _drivingLicenseUrl,
        idDocument: _idDocumentUrl,
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
    final secondaryColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
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
              context.read<DriverProvider>().clearProfile();
              context.read<OrderProvider>().clearAll();
              context.read<NotificationProvider>().clearAll();
              context.read<TourProvider>().resetTour();
              final auth = context.read<AuthProvider>();
              final router = GoRouter.of(context);
              await auth.logout();
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
                  children: [
                    _buildPersonalInfoStep(textColor, secondaryColor, surfaceColor),
                    _buildVehicleStep(textColor, secondaryColor, surfaceColor, l10n),
                    _buildVehicleDetailsStep(textColor, secondaryColor, surfaceColor, l10n),
                    _buildServicesStep(textColor, secondaryColor, surfaceColor, l10n),
                    _buildDocumentsStep(textColor, secondaryColor, surfaceColor, l10n),
                  ],
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
                      const Icon(Icons.error_outline, color: AppColors.error, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _error!,
                          style: const TextStyle(color: AppColors.error, fontSize: 14),
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
    final steps = [l10n.stepPersonal, l10n.stepVehicle, l10n.stepDetails, l10n.stepServices, l10n.stepDocuments];

    return Row(
      children: List.generate(steps.length, (index) {
        final isActive = index == _currentStep;
        final isCompleted = index < _currentStep;

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
                  steps[index],
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

  Widget _buildPersonalInfoStep(Color textColor, Color secondaryColor, Color surfaceColor) {
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
          ),
          const SizedBox(height: 20),

          // Age field
          _buildTextField(
            controller: _ageController,
            label: l10n.age,
            hint: l10n.enterAge,
            icon: Icons.cake_outlined,
            surfaceColor: surfaceColor,
            textColor: textColor,
            secondaryColor: secondaryColor,
            keyboardType: TextInputType.number,
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
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.phone, color: AppColors.primary, size: 20),
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
                        style: const TextStyle(fontSize: 12, color: AppColors.success),
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

  Widget _buildVehicleStep(Color textColor, Color secondaryColor, Color surfaceColor, AppLocalizations l10n) {
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
                onTap: () => setState(() => _selectedVehicle = vehicle['value']),
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

  Widget _buildVehicleDetailsStep(Color textColor, Color secondaryColor, Color surfaceColor, AppLocalizations l10n) {
    final carSizes = _getCarSizes(l10n);

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

          // Car size dropdown
          Text(
            l10n.carSize,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: secondaryColor,
            ),
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
                hintStyle: TextStyle(color: secondaryColor.withValues(alpha: 0.6)),
                prefixIcon: Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.straighten, color: AppColors.primary, size: 20),
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
                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
          ),
          const SizedBox(height: 16),

          // Plate number
          _buildTextField(
            controller: _plateNumberController,
            label: l10n.licensePlate,
            hint: l10n.enterVehiclePlateNumber,
            icon: Icons.pin_outlined,
            surfaceColor: surfaceColor,
            textColor: textColor,
            secondaryColor: secondaryColor,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildServicesStep(Color textColor, Color secondaryColor, Color surfaceColor, AppLocalizations l10n) {
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

  Future<void> _pickAndUpload({
    required String label,
    required String folder,
    required void Function(Uint8List? bytes) setBytes,
    required void Function(String? url) setUrl,
    required void Function(bool loading) setLoading,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final source = await showModalBottomSheet<ImageSource>(
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
              Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(ctx, ImageSource.camera),
                      icon: const Icon(Icons.camera_alt_outlined),
                      label: Text(l10n.camera),
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(ctx, ImageSource.gallery),
                      icon: const Icon(Icons.photo_library_outlined),
                      label: Text(l10n.gallery),
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );

    if (source == null) return;

    try {
      // Constrain dimensions/quality so a full-resolution photo isn't decoded
      // into memory. On web an oversized image can exhaust the tab's heap and
      // crash/reload the app; this keeps every platform's footprint small.
      final picked = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 80,
      );
      if (picked == null) return;

      // Read bytes once — works on web (no filesystem) and native alike.
      final bytes = await picked.readAsBytes();
      if (!mounted) return;
      setState(() {
        setBytes(bytes);
        setLoading(true);
        _error = null;
      });

      final url = await _cloudinaryService.uploadImage(
        bytes,
        filename: picked.name,
        folder: folder,
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
    } catch (e) {
      debugPrint('[ApplicationScreen] Pick/upload error: $e');
      if (!mounted) return;
      setState(() {
        setLoading(false);
        _error = l10n.uploadFailed;
      });
    }
  }

  Widget _buildDocumentsStep(Color textColor, Color secondaryColor, Color surfaceColor, AppLocalizations l10n) {
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

          // Driving license
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
          ),
          const SizedBox(height: 16),

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
          ),
          const SizedBox(height: 16),

          // Other documents
          _buildUploadCard(
            label: l10n.documents,
            icon: Icons.description_outlined,
            bytes: _otherDocumentsBytes,
            url: _otherDocumentsUrl,
            isUploading: _otherDocumentsUploading,
            onTap: () => _pickAndUpload(
              label: l10n.documents,
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
  }) {
    final hasFile = bytes != null;
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
                : hasFile
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
              child: hasFile
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(
                        bytes,
                        fit: BoxFit.cover,
                        width: 56,
                        height: 56,
                        // Decode only as large as the thumbnail needs (2x for
                        // crisp rendering) instead of the full picked image.
                        cacheWidth: 112,
                        cacheHeight: 112,
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
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (isUploading)
                    Row(
                      children: [
                        const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.uploadingFile,
                          style: TextStyle(fontSize: 13, color: AppColors.primary),
                        ),
                      ],
                    )
                  else if (isUploaded)
                    Row(
                      children: [
                        const Icon(Icons.check_circle, color: AppColors.success, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          l10n.uploaded,
                          style: const TextStyle(fontSize: 13, color: AppColors.success),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '· ${l10n.changePhoto}',
                          style: TextStyle(fontSize: 13, color: AppColors.primary),
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
              color: isUploaded ? AppColors.success : secondaryColor.withValues(alpha: 0.5),
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
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: secondaryColor,
          ),
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
            style: TextStyle(color: textColor, fontSize: 16),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: secondaryColor.withValues(alpha: 0.6)),
              prefixIcon: Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppColors.primary, size: 20),
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
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
          color: isSelected ? AppColors.primary.withValues(alpha: 0.05) : surfaceColor,
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
              child: Icon(
                vehicle['icon'],
                color: AppColors.primary,
                size: 28,
              ),
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
                    style: TextStyle(
                      fontSize: 13,
                      color: secondaryColor,
                    ),
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
                  color: isSelected ? AppColors.primary : secondaryColor.withValues(alpha: 0.3),
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
          color: isSelected ? AppColors.primary.withValues(alpha: 0.05) : surfaceColor,
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
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 24,
              ),
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
                    style: TextStyle(
                      fontSize: 13,
                      color: secondaryColor,
                    ),
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
                  color: isSelected ? AppColors.primary : secondaryColor.withValues(alpha: 0.3),
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
                context.read<DriverProvider>().clearProfile();
                context.read<OrderProvider>().clearAll();
                context.read<NotificationProvider>().clearAll();
                context.read<TourProvider>().resetTour();
                final auth = context.read<AuthProvider>();
                final router = GoRouter.of(context);
                await auth.logout();
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
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
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
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
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
                        isLastStep ? AppLocalizations.of(context)!.completeRegistration : AppLocalizations.of(context)!.continueText,
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
}

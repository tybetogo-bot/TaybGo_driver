import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/driver_provider.dart';
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
  static const int _totalSteps = 3;

  // Text controllers
  final _nameController = TextEditingController();

  // Form state
  String _selectedVehicle = 'CAR';
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

  @override
  void dispose() {
    _nameController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 0) {
      // Validate personal info
      if (_nameController.text.trim().isEmpty) {
        setState(() => _error = AppLocalizations.of(context)!.pleaseEnterYourName);
        return;
      }
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
    // Must select at least one service
    if (!_acceptsFood && !_acceptsShipping && !_acceptsTaxi) {
      setState(() => _error = AppLocalizations.of(context)!.pleaseSelectService);
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
        age: 25, // Default age since we removed the field
        vehicleType: _selectedVehicle,
        acceptsFood: _acceptsFood,
        acceptsShipping: _acceptsShipping,
        acceptsTaxi: _acceptsTaxi,
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
          onPressed: () {
            if (_currentStep > 0) {
              _previousStep();
            } else if (context.canPop()) {
              context.pop();
            } else {
              context.go(RouteConstants.phone);
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                    _buildServicesStep(textColor, secondaryColor, surfaceColor, l10n),
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
    final steps = [l10n.stepPersonal, l10n.stepVehicle, l10n.stepServices];

    return Row(
      children: List.generate(steps.length, (index) {
        final isActive = index == _currentStep;
        final isCompleted = index < _currentStep;

        return Expanded(
          child: Row(
            children: [
              // Step circle
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isActive || isCompleted
                      ? AppColors.primary
                      : AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(Icons.check, color: Colors.white, size: 18)
                      : Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: isActive ? Colors.white : AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 8),
              // Step label
              Expanded(
                child: Text(
                  steps[index],
                  style: TextStyle(
                    color: isActive ? textColor : secondaryColor,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
              ),
              // Connector line
              if (index < steps.length - 1)
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
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

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          // Header
          Text(
            AppLocalizations.of(context)!.tellUsAboutYourself,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.basicInfoSubtitle,
            style: TextStyle(fontSize: 15, color: secondaryColor),
          ),
          const SizedBox(height: 32),

          // Name field
          _buildTextField(
            controller: _nameController,
            label: AppLocalizations.of(context)!.fullName,
            hint: AppLocalizations.of(context)!.enterYourFullName,
            icon: Icons.person_outline,
            surfaceColor: surfaceColor,
            textColor: textColor,
            secondaryColor: secondaryColor,
          ),
          const SizedBox(height: 20),

          // Phone (read-only)
          Text(
            AppLocalizations.of(context)!.phoneNumber,
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
                        phone.isNotEmpty ? phone : AppLocalizations.of(context)!.notAvailable,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.verifiedViaOtp,
                        style: TextStyle(fontSize: 12, color: AppColors.success),
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
          // Header
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

  Widget _buildServicesStep(Color textColor, Color secondaryColor, Color surfaceColor, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          // Header
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

          // Service cards
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
        // Back button (hidden on first step)
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
        if (_currentStep > 0) const SizedBox(width: 12),

        // Next/Submit button
        Expanded(
          flex: _currentStep > 0 ? 2 : 1,
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

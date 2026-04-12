import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import '../../../core/models/driver_profile.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/l10n/framework_locale_support.dart';
import '../../../core/providers/driver_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/birthdate_utils.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Personal info controllers
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _birthdateController;

  // Vehicle info controllers
  late TextEditingController _vehiclePlateNumberController;
  late TextEditingController _vehicleColorController;
  late TextEditingController _vehicleMakeController;
  late TextEditingController _vehicleModelController;
  late TextEditingController _vehicleYearController;

  // Document status
  String? _drivingLicenseUrl;
  String? _idDocumentUrl;
  String? _otherDocumentsUrl;
  String? _healthInsuranceDocumentUrl;
  String? _addressDocumentUrl;
  String? _bankDocumentUrl;

  // Service toggles
  late bool _acceptsFood;
  late bool _acceptsShipping;
  late bool _acceptsTaxi;

  // Vehicle type & car size
  String? _selectedVehicleType;
  String? _selectedCarSize;

  late final DriverProvider _driverProvider;
  bool _profileInitialized = false;

  bool _isSaving = false;
  DateTime? _selectedBirthdate;

  @override
  void initState() {
    super.initState();
    _driverProvider = context.read<DriverProvider>();
    _driverProvider.addListener(_handleDriverProfileChanged);
    final profile = _driverProvider.profile;

    // Initialize personal info
    _nameController = TextEditingController(text: profile?.fullName ?? '');
    _phoneController = TextEditingController(text: profile?.phone ?? '');
    _selectedBirthdate = profile?.birthdate;
    _birthdateController = TextEditingController();
    _syncBirthdateController();

    // Initialize vehicle info
    _selectedVehicleType = profile?.vehicleType;
    _selectedCarSize = profile?.carSize;
    _vehiclePlateNumberController = TextEditingController(
      text: profile?.vehiclePlateNumber ?? '',
    );
    _vehicleColorController = TextEditingController(
      text: profile?.vehicleColor ?? '',
    );
    _vehicleMakeController = TextEditingController(
      text: profile?.vehicleMake ?? '',
    );
    _vehicleModelController = TextEditingController(
      text: profile?.vehicleModel ?? '',
    );
    _vehicleYearController = TextEditingController(
      text: profile?.vehicleYear != null && profile!.vehicleYear! > 0
          ? profile.vehicleYear.toString()
          : '',
    );

    // Initialize document URLs from existing profile
    _drivingLicenseUrl = profile?.drivingLicense;
    _idDocumentUrl = profile?.idDocument;
    _otherDocumentsUrl = profile?.otherDocuments;
    _healthInsuranceDocumentUrl = profile?.healthInsuranceDocument;
    _addressDocumentUrl = profile?.addressDocument;
    _bankDocumentUrl = profile?.bankDocument;
    debugPrint(
      '[EditProfile] Init documents: '
      'license=$_drivingLicenseUrl, '
      'id=$_idDocumentUrl, '
      'other=$_otherDocumentsUrl, '
      'health=$_healthInsuranceDocumentUrl, '
      'address=$_addressDocumentUrl, '
      'bank=$_bankDocumentUrl',
    );

    // Initialize service toggles
    _acceptsFood = profile?.acceptsFood ?? false;
    _acceptsShipping = profile?.acceptsShipping ?? false;
    _acceptsTaxi = profile?.acceptsTaxi ?? false;

    if (profile != null) {
      _profileInitialized = true;
    }
  }

  @override
  void dispose() {
    _driverProvider.removeListener(_handleDriverProfileChanged);
    _nameController.dispose();
    _phoneController.dispose();
    _birthdateController.dispose();
    _vehiclePlateNumberController.dispose();
    _vehicleColorController.dispose();
    _vehicleMakeController.dispose();
    _vehicleModelController.dispose();
    _vehicleYearController.dispose();
    super.dispose();
  }

  void _handleDriverProfileChanged() {
    if (!mounted) return;

    final profile = _driverProvider.profile;
    if (profile == null) return;

    if (!_profileInitialized) {
      setState(() {
        _applyProfile(profile);
      });
      return;
    }

    final needsDocumentSync =
        _drivingLicenseUrl == null ||
        _idDocumentUrl == null ||
        _otherDocumentsUrl == null ||
        _healthInsuranceDocumentUrl == null ||
        _addressDocumentUrl == null ||
        _bankDocumentUrl == null;
    if (!needsDocumentSync) return;

    setState(() {
      _mergeDocumentUrls(profile);
    });
  }

  void _applyProfile(DriverProfile profile) {
    _nameController.text = profile.fullName;
    _phoneController.text = profile.phone;
    _selectedBirthdate = profile.birthdate;
    _syncBirthdateController();

    _selectedVehicleType = profile.vehicleType;
    _selectedCarSize = profile.carSize;
    _vehiclePlateNumberController.text = profile.vehiclePlateNumber ?? '';
    _vehicleColorController.text = profile.vehicleColor ?? '';
    _vehicleMakeController.text = profile.vehicleMake ?? '';
    _vehicleModelController.text = profile.vehicleModel ?? '';
    _vehicleYearController.text =
        profile.vehicleYear != null && profile.vehicleYear! > 0
        ? profile.vehicleYear.toString()
        : '';

    _drivingLicenseUrl = profile.drivingLicense;
    _idDocumentUrl = profile.idDocument;
    _otherDocumentsUrl = profile.otherDocuments;
    _healthInsuranceDocumentUrl = profile.healthInsuranceDocument;
    _addressDocumentUrl = profile.addressDocument;
    _bankDocumentUrl = profile.bankDocument;

    _acceptsFood = profile.acceptsFood;
    _acceptsShipping = profile.acceptsShipping;
    _acceptsTaxi = profile.acceptsTaxi;

    _profileInitialized = true;

    debugPrint(
      '[EditProfile] Profile synced: '
      'license=$_drivingLicenseUrl, '
      'id=$_idDocumentUrl, '
      'other=$_otherDocumentsUrl, '
      'health=$_healthInsuranceDocumentUrl, '
      'address=$_addressDocumentUrl, '
      'bank=$_bankDocumentUrl',
    );
  }

  void _mergeDocumentUrls(DriverProfile profile) {
    _drivingLicenseUrl ??= profile.drivingLicense;
    _idDocumentUrl ??= profile.idDocument;
    _otherDocumentsUrl ??= profile.otherDocuments;
    _healthInsuranceDocumentUrl ??= profile.healthInsuranceDocument;
    _addressDocumentUrl ??= profile.addressDocument;
    _bankDocumentUrl ??= profile.bankDocument;
  }

  void _syncBirthdateController() {
    _birthdateController.text = _selectedBirthdate == null
        ? ''
        : _formatBirthdateForDisplay(_selectedBirthdate!);
  }

  String _formatBirthdateForDisplay(DateTime birthdate) {
    return intl.DateFormat.yMMMd(
      FrameworkLocaleSupport.dateFormattingLocale(
        Localizations.localeOf(context),
      ),
    ).format(birthdate);
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
      _syncBirthdateController();
    });
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    if (_hasVehicleDataChanges()) {
      final confirmed = await _showVehicleChangeWarningDialog();
      if (!confirmed || !mounted) return;
    }

    setState(() => _isSaving = true);

    final driverProvider = context.read<DriverProvider>();
    final l10n = AppLocalizations.of(context)!;

    final success = await driverProvider.updateUserProfile(
      name: _nameController.text.trim().isNotEmpty
          ? _nameController.text.trim()
          : null,
      phone: _phoneController.text.trim().isNotEmpty
          ? _phoneController.text.trim()
          : null,
      birthdate: _selectedBirthdate,
      vehicleType: _selectedVehicleType,
      carSize: _selectedCarSize,
      vehiclePlateNumber: _vehiclePlateNumberController.text.trim().isNotEmpty
          ? _vehiclePlateNumberController.text.trim()
          : null,
      vehicleColor: _vehicleColorController.text.trim().isNotEmpty
          ? _vehicleColorController.text.trim()
          : null,
      vehicleMake: _vehicleMakeController.text.trim().isNotEmpty
          ? _vehicleMakeController.text.trim()
          : null,
      vehicleModel: _vehicleModelController.text.trim().isNotEmpty
          ? _vehicleModelController.text.trim()
          : null,
      vehicleYear: _vehicleYearController.text.trim().isNotEmpty
          ? int.tryParse(_vehicleYearController.text.trim())
          : null,
      acceptsFood: _acceptsFood,
      acceptsShipping: _acceptsShipping,
      acceptsTaxi: _acceptsTaxi,
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.profileUpdatedSuccessfully),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(driverProvider.error ?? l10n.failedToUpdateProfile),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
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
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final hintColor = isDark ? AppColors.darkTextHint : AppColors.lightTextHint;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.edit, color: AppColors.primary, size: 18),
            ),
            const SizedBox(width: 10),
            Text(l10n.editProfile),
          ],
        ),
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.arrow_back, color: textColor, size: 18),
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Center(
                child: Consumer<DriverProvider>(
                  builder: (context, provider, _) {
                    final profile = provider.profile;
                    return Column(
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: profile?.avatarUrl != null
                              ? ClipOval(
                                  child: Image.network(
                                    profile!.avatarUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                              Icons.person,
                                              size: 40,
                                              color: AppColors.primary,
                                            ),
                                  ),
                                )
                              : const Icon(
                                  Icons.person,
                                  size: 40,
                                  color: AppColors.primary,
                                ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          profile?.fullName ?? l10n.driver,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 28),

              // Personal Information Section
              _buildSectionHeader(
                'Personal Information',
                Icons.person,
                textColor,
              ),
              const SizedBox(height: 16),

              // Name
              _buildFieldLabel(
                Icons.person_outline,
                l10n.fullName,
                secondaryColor,
              ),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _nameController,
                hint: l10n.enterYourFullName,
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                textColor: textColor,
                hintColor: hintColor,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.pleaseEnterYourName;
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Phone Number
              _buildFieldLabel(
                Icons.phone_outlined,
                l10n.phoneNumber,
                secondaryColor,
              ),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _phoneController,
                hint: l10n.phoneHint,
                keyboardType: TextInputType.phone,
                textDirection: TextDirection.ltr,
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                textColor: textColor,
                hintColor: hintColor,
              ),

              const SizedBox(height: 16),

              // Birthdate
              _buildFieldLabel(
                Icons.calendar_today_outlined,
                l10n.age,
                secondaryColor,
              ),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _birthdateController,
                hint: l10n.enterAge,
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                textColor: textColor,
                hintColor: hintColor,
                readOnly: true,
                onTap: _selectBirthdate,
                suffixIcon: const Icon(
                  Icons.calendar_month_outlined,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 28),

              // Vehicle Information Section
              _buildSectionHeader(
                'Vehicle Information',
                Icons.directions_car,
                textColor,
              ),
              const SizedBox(height: 16),

              // Vehicle Type Dropdown
              _buildFieldLabel(
                Icons.category_outlined,
                'Vehicle Type',
                secondaryColor,
              ),
              const SizedBox(height: 8),
              _buildDropdown(
                value: _selectedVehicleType,
                items: ['CAR', 'BIKE'],
                hint: 'Select vehicle type',
                onChanged: (value) {
                  setState(() => _selectedVehicleType = value);
                },
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                textColor: textColor,
                hintColor: hintColor,
              ),

              const SizedBox(height: 16),

              // Car Size Dropdown
              _buildFieldLabel(
                Icons.straighten_outlined,
                'Car Size',
                secondaryColor,
              ),
              const SizedBox(height: 8),
              _buildDropdown(
                value: _selectedCarSize,
                items: ['X', 'S', 'M', 'L', 'XL'],
                hint: 'Select car size',
                onChanged: (value) {
                  setState(() => _selectedCarSize = value);
                },
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                textColor: textColor,
                hintColor: hintColor,
              ),

              const SizedBox(height: 16),

              // Vehicle Plate Number
              _buildFieldLabel(
                Icons.pin_outlined,
                'Plate Number',
                secondaryColor,
              ),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _vehiclePlateNumberController,
                hint: 'Enter plate number',
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                textColor: textColor,
                hintColor: hintColor,
              ),

              const SizedBox(height: 16),

              // Vehicle Color
              _buildFieldLabel(Icons.palette_outlined, 'Color', secondaryColor),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _vehicleColorController,
                hint: 'Enter vehicle color',
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                textColor: textColor,
                hintColor: hintColor,
              ),

              const SizedBox(height: 16),

              // Vehicle Make
              _buildFieldLabel(Icons.factory_outlined, 'Make', secondaryColor),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _vehicleMakeController,
                hint: 'Enter vehicle make (e.g., Toyota)',
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                textColor: textColor,
                hintColor: hintColor,
              ),

              const SizedBox(height: 16),

              // Vehicle Model
              _buildFieldLabel(
                Icons.car_rental_outlined,
                'Model',
                secondaryColor,
              ),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _vehicleModelController,
                hint: 'Enter vehicle model (e.g., Camry)',
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                textColor: textColor,
                hintColor: hintColor,
              ),

              const SizedBox(height: 16),

              // Vehicle Year
              _buildFieldLabel(
                Icons.calendar_today_outlined,
                'Year',
                secondaryColor,
              ),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _vehicleYearController,
                hint: 'Enter vehicle year',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                textColor: textColor,
                hintColor: hintColor,
              ),

              const SizedBox(height: 28),

              // Services Section
              _buildSectionHeader(
                'Services Offered',
                Icons.local_shipping_outlined,
                textColor,
              ),
              const SizedBox(height: 16),

              // Service Toggles
              _buildServiceToggle(
                'Food Delivery',
                Icons.restaurant_outlined,
                _acceptsFood,
                (value) => setState(() => _acceptsFood = value),
                surfaceColor,
                textColor,
              ),
              const SizedBox(height: 12),

              _buildServiceToggle(
                'Shipping',
                Icons.inventory_2_outlined,
                _acceptsShipping,
                (value) => setState(() => _acceptsShipping = value),
                surfaceColor,
                textColor,
              ),
              const SizedBox(height: 12),

              _buildServiceToggle(
                'Taxi Service',
                Icons.local_taxi_outlined,
                _acceptsTaxi,
                (value) => setState(() => _acceptsTaxi = value),
                surfaceColor,
                textColor,
              ),

              const SizedBox(height: 28),

              // Documents Section
              _buildSectionHeader(
                l10n.documents,
                Icons.description_outlined,
                textColor,
              ),
              const SizedBox(height: 16),

              _buildDocumentStatusCard(
                label: l10n.driversLicense,
                icon: Icons.badge_outlined,
                url: _drivingLicenseUrl,
                textColor: textColor,
                secondaryColor: secondaryColor,
                surfaceColor: surfaceColor,
                l10n: l10n,
              ),

              const SizedBox(height: 12),

              _buildDocumentStatusCard(
                label: l10n.nationalId,
                icon: Icons.credit_card_outlined,
                url: _idDocumentUrl,
                textColor: textColor,
                secondaryColor: secondaryColor,
                surfaceColor: surfaceColor,
                l10n: l10n,
              ),

              const SizedBox(height: 12),

              _buildDocumentStatusCard(
                label: l10n.documents,
                icon: Icons.description_outlined,
                url: _otherDocumentsUrl,
                textColor: textColor,
                secondaryColor: secondaryColor,
                surfaceColor: surfaceColor,
                l10n: l10n,
              ),

              const SizedBox(height: 12),

              _buildDocumentStatusCard(
                label: l10n.healthInsuranceDocument,
                icon: Icons.health_and_safety_outlined,
                url: _healthInsuranceDocumentUrl,
                textColor: textColor,
                secondaryColor: secondaryColor,
                surfaceColor: surfaceColor,
                l10n: l10n,
              ),

              const SizedBox(height: 12),

              _buildDocumentStatusCard(
                label: l10n.addressDocument,
                icon: Icons.home_outlined,
                url: _addressDocumentUrl,
                textColor: textColor,
                secondaryColor: secondaryColor,
                surfaceColor: surfaceColor,
                l10n: l10n,
              ),

              const SizedBox(height: 12),

              _buildDocumentStatusCard(
                label: l10n.bankDocument,
                icon: Icons.account_balance_outlined,
                url: _bankDocumentUrl,
                textColor: textColor,
                secondaryColor: secondaryColor,
                surfaceColor: surfaceColor,
                l10n: l10n,
              ),

              const SizedBox(height: 36),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.primary.withValues(
                      alpha: 0.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          l10n.save,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color textColor) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildFieldLabel(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required Color surfaceColor,
    required Color borderColor,
    required Color textColor,
    required Color hintColor,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
    TextDirection? textDirection,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      readOnly: readOnly,
      onTap: onTap,
      textDirection: textDirection,
      style: TextStyle(fontSize: 15, color: textColor),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 14, color: hintColor),
        filled: true,
        fillColor: surfaceColor,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required String hint,
    required void Function(String?) onChanged,
    required Color surfaceColor,
    required Color borderColor,
    required Color textColor,
    required Color hintColor,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 14, color: hintColor),
        filled: true,
        fillColor: surfaceColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      dropdownColor: surfaceColor,
      style: TextStyle(fontSize: 15, color: textColor),
      items: items.map((item) {
        return DropdownMenuItem(value: item, child: Text(item));
      }).toList(),
      onChanged: onChanged,
    );
  }

  bool _hasVehicleDataChanges() {
    final profile = _driverProvider.profile;
    if (profile == null) return false;

    return _normalizeVehicleText(_selectedVehicleType) !=
            _normalizeVehicleText(profile.vehicleType) ||
        _normalizeVehicleText(_selectedCarSize) !=
            _normalizeVehicleText(profile.carSize) ||
        _normalizeVehicleText(_vehiclePlateNumberController.text) !=
            _normalizeVehicleText(profile.vehiclePlateNumber) ||
        _normalizeVehicleText(_vehicleColorController.text) !=
            _normalizeVehicleText(profile.vehicleColor) ||
        _normalizeVehicleText(_vehicleMakeController.text) !=
            _normalizeVehicleText(profile.vehicleMake) ||
        _normalizeVehicleText(_vehicleModelController.text) !=
            _normalizeVehicleText(profile.vehicleModel) ||
        _normalizeVehicleYear(
              int.tryParse(_vehicleYearController.text.trim()),
            ) !=
            _normalizeVehicleYear(profile.vehicleYear);
  }

  String? _normalizeVehicleText(String? value) {
    final normalized = value?.trim();
    if (normalized == null || normalized.isEmpty) return null;
    return normalized.toLowerCase();
  }

  int? _normalizeVehicleYear(int? value) {
    if (value == null || value <= 0) return null;
    return value;
  }

  Future<bool> _showVehicleChangeWarningDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? AppColors.darkSurface : AppColors.lightBg;
    final titleColor = isDark ? AppColors.darkText : AppColors.lightText;
    final bodyColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.34 : 0.12),
                  blurRadius: 28,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.warning.withValues(alpha: 0.22),
                        AppColors.primary.withValues(alpha: 0.08),
                      ],
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.14),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.warning.withValues(alpha: 0.22),
                        ),
                      ),
                      child: const Icon(
                        Icons.shield_outlined,
                        color: AppColors.warning,
                        size: 34,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.vehicleChangeWarningTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: titleColor,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.vehicleChangeWarningMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.5,
                          height: 1.5,
                          color: bodyColor,
                        ),
                      ),
                      const SizedBox(height: 22),
                      _buildDialogNote(
                        icon: Icons.pause_circle_outline_rounded,
                        iconColor: AppColors.warning,
                        borderColor: borderColor,
                        backgroundColor: AppColors.warning.withValues(
                          alpha: isDark ? 0.12 : 0.08,
                        ),
                        text: l10n.vehicleChangeWarningNote,
                        textColor: titleColor,
                      ),
                      const SizedBox(height: 12),
                      _buildDialogNote(
                        icon: Icons.admin_panel_settings_outlined,
                        iconColor: AppColors.primary,
                        borderColor: borderColor,
                        backgroundColor: AppColors.primary.withValues(
                          alpha: isDark ? 0.14 : 0.08,
                        ),
                        text: l10n.accountBeingVerified,
                        textColor: titleColor,
                      ),
                      const SizedBox(height: 22),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(false),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: titleColor,
                                side: BorderSide(color: borderColor),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Text(
                                l10n.cancel,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Text(
                                l10n.vehicleChangeWarningConfirm,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    return confirmed ?? false;
  }

  Widget _buildDialogNote({
    required IconData icon,
    required Color iconColor,
    required Color borderColor,
    required Color backgroundColor,
    required String text,
    required Color textColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor.withValues(alpha: 0.7)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13.5,
                height: 1.45,
                fontWeight: FontWeight.w500,
                color: textColor.withValues(alpha: 0.95),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentStatusCard({
    required String label,
    required IconData icon,
    required String? url,
    required Color textColor,
    required Color secondaryColor,
    required Color surfaceColor,
    required AppLocalizations l10n,
  }) {
    final isUploaded = url != null && url.isNotEmpty;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isUploaded
            ? AppColors.success.withValues(alpha: 0.04)
            : surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUploaded
              ? AppColors.success.withValues(alpha: 0.65)
              : secondaryColor.withValues(alpha: 0.14),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: isUploaded
                  ? AppColors.success.withValues(alpha: 0.1)
                  : AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isUploaded ? Icons.check_circle_outline : icon,
              color: isUploaded ? AppColors.success : AppColors.primary,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  isUploaded ? l10n.uploaded : l10n.notAvailable,
                  style: TextStyle(
                    fontSize: 12,
                    color: isUploaded ? AppColors.success : secondaryColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            isUploaded
                ? Icons.verified_rounded
                : Icons.remove_circle_outline_rounded,
            color: isUploaded ? AppColors.success : secondaryColor,
            size: 18,
          ),
        ],
      ),
    );
  }

  Widget _buildServiceToggle(
    String title,
    IconData icon,
    bool value,
    void Function(bool) onChanged,
    Color surfaceColor,
    Color textColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/models/driver_address.dart';
import '../../../core/models/driver_profile.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/l10n/framework_locale_support.dart';
import '../../../core/providers/driver_provider.dart';
import '../../../core/services/cloudinary_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/birthdate_utils.dart';
import '../../application/utils/document_picker.dart';

enum _DocumentPickAction { camera, gallery, file }

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  static String _digitsOnly(String value) {
    return value.replaceAll(RegExp(r'\D'), '');
  }

  static const List<Map<String, String>> _vehicleTypeOptions = [
    {'value': 'CAR', 'labelKey': 'car'},
    {'value': 'BIKE', 'labelKey': 'bicycle'},
  ];

  static const List<Map<String, String>> _carSizeOptions = [
    {'value': 'X', 'labelKey': 'carSizeX'},
    {'value': 'COMFORT', 'labelKey': 'carSizeComfort'},
    {'value': 'XL', 'labelKey': 'carSizeXL'},
    {'value': 'BLACK', 'labelKey': 'carSizeBlack'},
  ];

  // Personal info controllers
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _birthdateController;

  // Vehicle info controllers
  late TextEditingController _vehiclePlateNumberController;
  late TextEditingController _vehicleColorController;
  late TextEditingController _vehicleMakeController;
  late TextEditingController _vehicleModelController;

  // Document status
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

  // Service toggles
  late bool _acceptsFood;
  late bool _acceptsShipping;
  late bool _acceptsTaxi;

  // Vehicle type & car size
  String? _selectedVehicleType;
  String? _selectedCarSize;
  int? _selectedVehicleYear;

  int get _maximumVehicleYear => DateTime.now().year + 1;
  List<int> get _vehicleYears => List<int>.generate(
    _maximumVehicleYear - 1960 + 1,
    (index) => _maximumVehicleYear - index,
  );

  late final DriverProvider _driverProvider;
  final CloudinaryService _cloudinaryService = CloudinaryService();
  final ImagePicker _imagePicker = ImagePicker();
  bool _profileInitialized = false;

  bool _isSaving = false;
  DateTime? _selectedBirthdate;

  @override
  void initState() {
    super.initState();
    _driverProvider = context.read<DriverProvider>();
    _driverProvider.addListener(_handleDriverProfileChanged);
    final profile = _driverProvider.profile;
    if (profile == null) {
      unawaited(_driverProvider.fetchProfile());
    }

    // Initialize personal info
    _nameController = TextEditingController(text: profile?.fullName ?? '');
    _phoneController = TextEditingController(
      text: _digitsOnly(profile?.phone ?? ''),
    );
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
    _selectedVehicleYear = _validVehicleYear(profile?.vehicleYear);

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
    _acceptsTaxi =
        _isCarVehicleType(profile?.vehicleType) &&
        (profile?.acceptsTaxi ?? false);

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
    _phoneController.text = _digitsOnly(profile.phone);
    _selectedBirthdate = profile.birthdate;
    _syncBirthdateController();

    _selectedVehicleType = profile.vehicleType;
    _selectedCarSize = profile.carSize;
    _vehiclePlateNumberController.text = profile.vehiclePlateNumber ?? '';
    _vehicleColorController.text = profile.vehicleColor ?? '';
    _vehicleMakeController.text = profile.vehicleMake ?? '';
    _vehicleModelController.text = profile.vehicleModel ?? '';
    _selectedVehicleYear = _validVehicleYear(profile.vehicleYear);

    _drivingLicenseUrl = profile.drivingLicense;
    _idDocumentUrl = profile.idDocument;
    _otherDocumentsUrl = profile.otherDocuments;
    _healthInsuranceDocumentUrl = profile.healthInsuranceDocument;
    _addressDocumentUrl = profile.addressDocument;
    _bankDocumentUrl = profile.bankDocument;

    _acceptsFood = profile.acceptsFood;
    _acceptsShipping = profile.acceptsShipping;
    _acceptsTaxi =
        _isCarVehicleType(profile.vehicleType) && profile.acceptsTaxi;

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

  String _localizedOptionLabel(AppLocalizations l10n, String labelKey) {
    switch (labelKey) {
      case 'car':
        return l10n.car;
      case 'bicycle':
        return l10n.bicycle;
      case 'carSizeX':
        return l10n.carSizeX;
      case 'carSizeComfort':
        return l10n.carSizeComfort;
      case 'carSizeXL':
        return l10n.carSizeXL;
      case 'carSizeBlack':
        return l10n.carSizeBlack;
      default:
        return labelKey;
    }
  }

  List<DropdownMenuItem<String>> _buildDropdownItems(
    AppLocalizations l10n,
    List<Map<String, String>> options,
  ) {
    return options.map((option) {
      final value = option['value']!;
      final label = _localizedOptionLabel(l10n, option['labelKey']!);
      return DropdownMenuItem<String>(value: value, child: Text(label));
    }).toList();
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

  bool _sameDate(DateTime? first, DateTime? second) {
    if (first == null || second == null) return first == second;
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  String? _nameUpdate() {
    final profile = _driverProvider.profile;
    final value = _nameController.text.trim();
    if (profile == null || value == profile.fullName.trim()) return null;
    return value.isEmpty ? null : value;
  }

  String? _phoneUpdate() {
    final profile = _driverProvider.profile;
    final value = _digitsOnly(_phoneController.text);
    if (profile == null || value == _digitsOnly(profile.phone)) return null;
    return value.isEmpty ? null : value;
  }

  DateTime? _birthdateUpdate() {
    final profile = _driverProvider.profile;
    if (profile == null || _sameDate(_selectedBirthdate, profile.birthdate)) {
      return null;
    }
    return _selectedBirthdate;
  }

  bool _hasServiceChanges() {
    final profile = _driverProvider.profile;
    if (profile == null) return false;
    return _acceptsFood != profile.acceptsFood ||
        _acceptsShipping != profile.acceptsShipping ||
        _acceptsTaxi != profile.acceptsTaxi;
  }

  String? _changedDocumentValue(String? value, String? original) {
    if (_normalizeDocumentUrl(value) == _normalizeDocumentUrl(original)) {
      return null;
    }
    return _normalizeDocumentUrl(value);
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context)!;
    final hasVehicleChanges = _hasVehicleDataChanges();
    final hasDocumentChanges = _hasDocumentChanges();
    final hasServiceChanges = _hasServiceChanges();
    final requiredDocumentsError = _validateCarRequiredDocuments(l10n);
    if (requiredDocumentsError != null) {
      _showErrorSnackBar(requiredDocumentsError);
      return;
    }

    final requiresApproval = hasVehicleChanges || hasDocumentChanges;
    if (requiresApproval) {
      final confirmed = await _showProfileApprovalWarningDialog();
      if (!confirmed || !mounted) return;
    }

    setState(() => _isSaving = true);

    final driverProvider = context.read<DriverProvider>();
    final isCarType = _isCarVehicleType(_selectedVehicleType);

    final success = await driverProvider.updateUserProfile(
      name: _nameUpdate(),
      phone: _phoneUpdate(),
      birthdate: _birthdateUpdate(),
      vehicleType: hasVehicleChanges ? _selectedVehicleType : null,
      clearCarDetails: hasVehicleChanges && !isCarType,
      carSize: hasVehicleChanges && isCarType ? _selectedCarSize : null,
      vehiclePlateNumber:
          hasVehicleChanges &&
              isCarType &&
              _vehiclePlateNumberController.text.trim().isNotEmpty
          ? _vehiclePlateNumberController.text.trim()
          : null,
      vehicleColor:
          hasVehicleChanges &&
              isCarType &&
              _vehicleColorController.text.trim().isNotEmpty
          ? _vehicleColorController.text.trim()
          : null,
      vehicleMake:
          hasVehicleChanges &&
              isCarType &&
              _vehicleMakeController.text.trim().isNotEmpty
          ? _vehicleMakeController.text.trim()
          : null,
      vehicleModel:
          hasVehicleChanges &&
              isCarType &&
              _vehicleModelController.text.trim().isNotEmpty
          ? _vehicleModelController.text.trim()
          : null,
      vehicleYear: hasVehicleChanges && isCarType ? _selectedVehicleYear : null,
      acceptsFood: hasServiceChanges ? _acceptsFood : null,
      acceptsShipping: hasServiceChanges ? _acceptsShipping : null,
      acceptsTaxi: hasServiceChanges
          ? (isCarType ? _acceptsTaxi : false)
          : null,
      drivingLicense: _changedDocumentValue(
        _drivingLicenseUrl,
        _driverProvider.profile?.drivingLicense,
      ),
      idDocument: _changedDocumentValue(
        _idDocumentUrl,
        _driverProvider.profile?.idDocument,
      ),
      otherDocuments: _changedDocumentValue(
        _otherDocumentsUrl,
        _driverProvider.profile?.otherDocuments,
      ),
      healthInsuranceDocument: _changedDocumentValue(
        _healthInsuranceDocumentUrl,
        _driverProvider.profile?.healthInsuranceDocument,
      ),
      addressDocument: _changedDocumentValue(
        _addressDocumentUrl,
        _driverProvider.profile?.addressDocument,
      ),
      bankDocument: _changedDocumentValue(
        _bankDocumentUrl,
        _driverProvider.profile?.bankDocument,
      ),
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
      _showErrorSnackBar(driverProvider.error ?? l10n.failedToUpdateProfile);
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
    final vehicleTypeItems = _buildDropdownItems(l10n, _vehicleTypeOptions);
    final carSizeItems = _buildDropdownItems(l10n, _carSizeOptions);

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
              _buildSectionHeader(l10n.personalInfo, Icons.person, textColor),
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
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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

              _buildSectionHeader(
                l10n.currentAddress,
                Icons.home_outlined,
                textColor,
              ),
              const SizedBox(height: 16),
              Consumer<DriverProvider>(
                builder: (context, provider, _) => _buildCurrentAddressCard(
                  provider.profile?.address,
                  textColor,
                  secondaryColor,
                  surfaceColor,
                  borderColor,
                  l10n,
                ),
              ),

              const SizedBox(height: 28),

              // Vehicle Information Section
              _buildSectionHeader(
                l10n.vehicleInfo,
                Icons.directions_car,
                textColor,
              ),
              const SizedBox(height: 16),

              // Vehicle Type Dropdown
              _buildFieldLabel(
                Icons.category_outlined,
                l10n.vehicleType,
                secondaryColor,
              ),
              const SizedBox(height: 8),
              _buildDropdown(
                value: _selectedVehicleType,
                items: vehicleTypeItems,
                hint: l10n.selectVehicleType,
                onChanged: (value) {
                  setState(() {
                    _selectedVehicleType = value;
                    if (!_isCarVehicleType(value)) {
                      _acceptsTaxi = false;
                    }
                  });
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.selectVehicleType;
                  }
                  return null;
                },
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                textColor: textColor,
                hintColor: hintColor,
              ),

              if (_isCarVehicleType(_selectedVehicleType)) ...[
                const SizedBox(height: 16),

                // Car Size Dropdown
                _buildFieldLabel(
                  Icons.straighten_outlined,
                  l10n.carSize,
                  secondaryColor,
                ),
                const SizedBox(height: 8),
                _buildDropdown(
                  value: _selectedCarSize,
                  items: carSizeItems,
                  hint: l10n.selectCarSize,
                  onChanged: (value) {
                    setState(() => _selectedCarSize = value);
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.pleaseSelectCarSize;
                    }
                    return null;
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
                  l10n.licensePlate,
                  secondaryColor,
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _vehiclePlateNumberController,
                  hint: l10n.enterVehiclePlateNumber,
                  surfaceColor: surfaceColor,
                  borderColor: borderColor,
                  textColor: textColor,
                  hintColor: hintColor,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.pleaseEnterPlateNumber;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Vehicle Color
                _buildFieldLabel(
                  Icons.palette_outlined,
                  l10n.vehicleColor,
                  secondaryColor,
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _vehicleColorController,
                  hint: l10n.enterVehicleColor,
                  surfaceColor: surfaceColor,
                  borderColor: borderColor,
                  textColor: textColor,
                  hintColor: hintColor,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.pleaseEnterVehicleColor;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Vehicle Make
                _buildFieldLabel(
                  Icons.factory_outlined,
                  l10n.vehicleMake,
                  secondaryColor,
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _vehicleMakeController,
                  hint: l10n.enterVehicleMake,
                  surfaceColor: surfaceColor,
                  borderColor: borderColor,
                  textColor: textColor,
                  hintColor: hintColor,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.pleaseEnterVehicleMake;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Vehicle Model
                _buildFieldLabel(
                  Icons.car_rental_outlined,
                  l10n.vehicleModel,
                  secondaryColor,
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _vehicleModelController,
                  hint: l10n.enterVehicleModel,
                  surfaceColor: surfaceColor,
                  borderColor: borderColor,
                  textColor: textColor,
                  hintColor: hintColor,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.pleaseEnterVehicleModel;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Vehicle Year
                _buildFieldLabel(
                  Icons.calendar_today_outlined,
                  l10n.vehicleYear,
                  secondaryColor,
                ),
                const SizedBox(height: 8),
                _buildVehicleYearDropdown(
                  surfaceColor: surfaceColor,
                  borderColor: borderColor,
                  textColor: textColor,
                  hintColor: hintColor,
                  l10n: l10n,
                ),
              ],

              const SizedBox(height: 28),

              // Services Section
              _buildSectionHeader(
                l10n.chooseYourServices,
                Icons.local_shipping_outlined,
                textColor,
              ),
              const SizedBox(height: 16),

              // Service Toggles
              _buildServiceToggle(
                l10n.foodDelivery,
                Icons.restaurant_outlined,
                _acceptsFood,
                (value) => setState(() => _acceptsFood = value),
                surfaceColor,
                textColor,
              ),
              const SizedBox(height: 12),

              _buildServiceToggle(
                l10n.shipping,
                Icons.inventory_2_outlined,
                _acceptsShipping,
                (value) => setState(() => _acceptsShipping = value),
                surfaceColor,
                textColor,
              ),
              if (_isCarVehicleType(_selectedVehicleType)) ...[
                const SizedBox(height: 12),
                _buildServiceToggle(
                  l10n.taxi,
                  Icons.local_taxi_outlined,
                  _acceptsTaxi,
                  (value) => setState(() => _acceptsTaxi = value),
                  surfaceColor,
                  textColor,
                ),
              ],

              const SizedBox(height: 28),

              // Documents Section
              _buildSectionHeader(
                l10n.documents,
                Icons.description_outlined,
                textColor,
              ),
              const SizedBox(height: 16),

              _buildDocumentUploadCard(
                label: l10n.driversLicense,
                icon: Icons.badge_outlined,
                bytes: _drivingLicenseBytes,
                url: _drivingLicenseUrl,
                isUploading: _drivingLicenseUploading,
                onTap: () => _pickAndUpload(
                  label: l10n.driversLicense,
                  folder: 'driver_licenses',
                  setBytes: (bytes) => _drivingLicenseBytes = bytes,
                  setUrl: (url) => _drivingLicenseUrl = url,
                  setLoading: (loading) => _drivingLicenseUploading = loading,
                ),
                textColor: textColor,
                secondaryColor: secondaryColor,
                surfaceColor: surfaceColor,
                l10n: l10n,
                isRequired: _requiresCarRegistrationDocuments,
              ),

              const SizedBox(height: 12),

              _buildDocumentUploadCard(
                label: l10n.nationalId,
                icon: Icons.credit_card_outlined,
                bytes: _idDocumentBytes,
                url: _idDocumentUrl,
                isUploading: _idDocumentUploading,
                onTap: () => _pickAndUpload(
                  label: l10n.nationalId,
                  folder: 'id_documents',
                  setBytes: (bytes) => _idDocumentBytes = bytes,
                  setUrl: (url) => _idDocumentUrl = url,
                  setLoading: (loading) => _idDocumentUploading = loading,
                ),
                textColor: textColor,
                secondaryColor: secondaryColor,
                surfaceColor: surfaceColor,
                l10n: l10n,
                isRequired: _requiresCarRegistrationDocuments,
              ),

              const SizedBox(height: 12),

              _buildDocumentUploadCard(
                label: l10n.otherDocuments,
                icon: Icons.description_outlined,
                bytes: _otherDocumentsBytes,
                url: _otherDocumentsUrl,
                isUploading: _otherDocumentsUploading,
                onTap: () => _pickAndUpload(
                  label: l10n.otherDocuments,
                  folder: 'other_documents',
                  setBytes: (bytes) => _otherDocumentsBytes = bytes,
                  setUrl: (url) => _otherDocumentsUrl = url,
                  setLoading: (loading) => _otherDocumentsUploading = loading,
                ),
                textColor: textColor,
                secondaryColor: secondaryColor,
                surfaceColor: surfaceColor,
                l10n: l10n,
              ),

              const SizedBox(height: 12),

              _buildDocumentUploadCard(
                label: l10n.healthInsuranceDocument,
                icon: Icons.health_and_safety_outlined,
                bytes: _healthInsuranceDocumentBytes,
                url: _healthInsuranceDocumentUrl,
                isUploading: _healthInsuranceDocumentUploading,
                onTap: () => _pickAndUpload(
                  label: l10n.healthInsuranceDocument,
                  folder: 'health_insurance_documents',
                  setBytes: (bytes) => _healthInsuranceDocumentBytes = bytes,
                  setUrl: (url) => _healthInsuranceDocumentUrl = url,
                  setLoading: (loading) =>
                      _healthInsuranceDocumentUploading = loading,
                ),
                textColor: textColor,
                secondaryColor: secondaryColor,
                surfaceColor: surfaceColor,
                l10n: l10n,
                isRequired: _requiresCarRegistrationDocuments,
              ),

              const SizedBox(height: 12),

              _buildDocumentUploadCard(
                label: l10n.addressDocument,
                icon: Icons.home_outlined,
                bytes: _addressDocumentBytes,
                url: _addressDocumentUrl,
                isUploading: _addressDocumentUploading,
                onTap: () => _pickAndUpload(
                  label: l10n.addressDocument,
                  folder: 'address_documents',
                  setBytes: (bytes) => _addressDocumentBytes = bytes,
                  setUrl: (url) => _addressDocumentUrl = url,
                  setLoading: (loading) => _addressDocumentUploading = loading,
                ),
                textColor: textColor,
                secondaryColor: secondaryColor,
                surfaceColor: surfaceColor,
                l10n: l10n,
                isRequired: _requiresCarRegistrationDocuments,
              ),

              const SizedBox(height: 12),

              _buildDocumentUploadCard(
                label: l10n.bankDocument,
                icon: Icons.account_balance_outlined,
                bytes: _bankDocumentBytes,
                url: _bankDocumentUrl,
                isUploading: _bankDocumentUploading,
                onTap: () => _pickAndUpload(
                  label: l10n.bankDocument,
                  folder: 'bank_documents',
                  setBytes: (bytes) => _bankDocumentBytes = bytes,
                  setUrl: (url) => _bankDocumentUrl = url,
                  setLoading: (loading) => _bankDocumentUploading = loading,
                ),
                textColor: textColor,
                secondaryColor: secondaryColor,
                surfaceColor: surfaceColor,
                l10n: l10n,
                isRequired: _requiresCarRegistrationDocuments,
              ),

              const SizedBox(height: 36),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSaveActionDisabled ? null : _saveProfile,
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

  Widget _buildCurrentAddressCard(
    DriverAddress? address,
    Color textColor,
    Color secondaryColor,
    Color surfaceColor,
    Color borderColor,
    AppLocalizations l10n,
  ) {
    final fullAddress = address?.fullAddress?.toString().trim();
    final area = [
      address?.postalCode,
      address?.city,
      address?.country,
    ].whereType<String>().where((value) => value.trim().isNotEmpty).join(' · ');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.location_on_rounded,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullAddress == null || fullAddress.isEmpty
                          ? l10n.noAddressAdded
                          : fullAddress,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.35,
                      ),
                    ),
                    if (area.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        area,
                        style: TextStyle(color: secondaryColor, fontSize: 12),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: () => context.push(RouteConstants.editAddress),
            icon: const Icon(Icons.edit_outlined, size: 17),
            label: Text(l10n.editAddress),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: BorderSide(
                color: AppColors.primary.withValues(alpha: 0.45),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
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
    required List<DropdownMenuItem<String>> items,
    required String hint,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),
      dropdownColor: surfaceColor,
      style: TextStyle(fontSize: 15, color: textColor),
      items: items,
      onChanged: onChanged,
      validator: validator,
    );
  }

  Widget _buildVehicleYearDropdown({
    required Color surfaceColor,
    required Color borderColor,
    required Color textColor,
    required Color hintColor,
    required AppLocalizations l10n,
  }) {
    return DropdownButtonFormField<int>(
      key: ValueKey(_selectedVehicleYear),
      initialValue: _selectedVehicleYear,
      menuMaxHeight: 320,
      decoration: InputDecoration(
        hintText: l10n.selectVehicleYear,
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),
      dropdownColor: surfaceColor,
      style: TextStyle(fontSize: 15, color: textColor),
      items: _vehicleYears
          .map(
            (year) => DropdownMenuItem<int>(
              value: year,
              child: Text(year.toString()),
            ),
          )
          .toList(),
      onChanged: (value) => setState(() => _selectedVehicleYear = value),
      validator: (value) {
        if (value == null) return l10n.pleaseEnterVehicleYear;
        if (value < 1960 || value > _maximumVehicleYear) {
          return l10n.invalidVehicleYear;
        }
        return null;
      },
    );
  }

  bool get _isAnyDocumentUploading =>
      _drivingLicenseUploading ||
      _idDocumentUploading ||
      _otherDocumentsUploading ||
      _healthInsuranceDocumentUploading ||
      _addressDocumentUploading ||
      _bankDocumentUploading;

  bool get _isSaveActionDisabled => _isSaving || _isAnyDocumentUploading;

  bool get _requiresCarRegistrationDocuments =>
      _isCarVehicleType(_selectedVehicleType);

  String? _validateCarRequiredDocuments(AppLocalizations l10n) {
    if (!_requiresCarRegistrationDocuments) return null;

    final requiredDocuments = <MapEntry<String, String?>>[
      MapEntry(l10n.driversLicense, _drivingLicenseUrl),
      MapEntry(l10n.nationalId, _idDocumentUrl),
      MapEntry(l10n.healthInsuranceDocument, _healthInsuranceDocumentUrl),
      MapEntry(l10n.addressDocument, _addressDocumentUrl),
      MapEntry(l10n.bankDocument, _bankDocumentUrl),
    ];

    for (final document in requiredDocuments) {
      if (_normalizeDocumentUrl(document.value) == null) {
        return l10n.pleaseUploadDocument(document.key);
      }
    }

    return null;
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
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
        _normalizeVehicleYear(_selectedVehicleYear) !=
            _normalizeVehicleYear(profile.vehicleYear);
  }

  bool _hasDocumentChanges() {
    final profile = _driverProvider.profile;
    if (profile == null) return false;

    return _normalizeDocumentUrl(_drivingLicenseUrl) !=
            _normalizeDocumentUrl(profile.drivingLicense) ||
        _normalizeDocumentUrl(_idDocumentUrl) !=
            _normalizeDocumentUrl(profile.idDocument) ||
        _normalizeDocumentUrl(_otherDocumentsUrl) !=
            _normalizeDocumentUrl(profile.otherDocuments) ||
        _normalizeDocumentUrl(_healthInsuranceDocumentUrl) !=
            _normalizeDocumentUrl(profile.healthInsuranceDocument) ||
        _normalizeDocumentUrl(_addressDocumentUrl) !=
            _normalizeDocumentUrl(profile.addressDocument) ||
        _normalizeDocumentUrl(_bankDocumentUrl) !=
            _normalizeDocumentUrl(profile.bankDocument);
  }

  String? _normalizeDocumentUrl(String? value) {
    final normalized = value?.trim();
    if (normalized == null || normalized.isEmpty) return null;
    return normalized;
  }

  String? _normalizeVehicleText(String? value) {
    final normalized = value?.trim();
    if (normalized == null || normalized.isEmpty) return null;
    return normalized.toLowerCase();
  }

  bool _isCarVehicleType(String? value) =>
      _normalizeVehicleText(value) == 'car';

  int? _normalizeVehicleYear(int? value) {
    if (value == null || value <= 0) return null;
    return value;
  }

  int? _validVehicleYear(int? value) {
    if (value == null || value < 1960 || value > _maximumVehicleYear) {
      return null;
    }
    return value;
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

    if (picked == null || !mounted) return;
    final document = picked;

    setState(() {
      setBytes(document.previewBytes);
      setLoading(true);
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.uploadFailed),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    });
  }

  Future<bool> _showProfileApprovalWarningDialog() async {
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

  Widget _buildDocumentUploadCard({
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
    final isUploaded = _normalizeDocumentUrl(url) != null;

    return GestureDetector(
      onTap: isUploading || _isSaving ? null : onTap,
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
                : secondaryColor.withValues(alpha: 0.14),
            width: isUploaded || hasBytes ? 2 : 1,
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
                      Flexible(
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                      ),
                      if (isRequired)
                        const Text(
                          ' *',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
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
                          style: const TextStyle(
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
                          style: const TextStyle(
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

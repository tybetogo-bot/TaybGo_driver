import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/providers/driver_provider.dart';
import '../../../core/theme/app_colors.dart';

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
  late TextEditingController _ageController;

  // Vehicle info controllers
  late TextEditingController _vehiclePlateNumberController;
  late TextEditingController _vehicleColorController;
  late TextEditingController _vehicleMakeController;
  late TextEditingController _vehicleModelController;
  late TextEditingController _vehicleYearController;

  // Document controllers
  late TextEditingController _drivingLicenseController;
  late TextEditingController _idDocumentController;
  late TextEditingController _otherDocumentsController;

  // Service toggles
  late bool _acceptsFood;
  late bool _acceptsShipping;
  late bool _acceptsTaxi;

  // Vehicle type & car size
  String? _selectedVehicleType;
  String? _selectedCarSize;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final profile = context.read<DriverProvider>().profile;

    // Initialize personal info
    _nameController = TextEditingController(text: profile?.fullName ?? '');
    _phoneController = TextEditingController(text: profile?.phone ?? '');
    _ageController = TextEditingController(
      text: profile?.age != null && profile!.age! > 0 ? profile.age.toString() : '',
    );

    // Initialize vehicle info
    _selectedVehicleType = profile?.vehicleType;
    _selectedCarSize = profile?.carSize;
    _vehiclePlateNumberController = TextEditingController(
      text: profile?.vehiclePlateNumber ?? '',
    );
    _vehicleColorController = TextEditingController(text: profile?.vehicleColor ?? '');
    _vehicleMakeController = TextEditingController(text: profile?.vehicleMake ?? '');
    _vehicleModelController = TextEditingController(text: profile?.vehicleModel ?? '');
    _vehicleYearController = TextEditingController(
      text: profile?.vehicleYear != null && profile!.vehicleYear! > 0
          ? profile.vehicleYear.toString()
          : '',
    );

    // Initialize document controllers
    _drivingLicenseController = TextEditingController(text: profile?.drivingLicense ?? '');
    _idDocumentController = TextEditingController(text: profile?.idDocument ?? '');
    _otherDocumentsController = TextEditingController(text: profile?.otherDocuments ?? '');

    // Initialize service toggles
    _acceptsFood = profile?.acceptsFood ?? false;
    _acceptsShipping = profile?.acceptsShipping ?? false;
    _acceptsTaxi = profile?.acceptsTaxi ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _vehiclePlateNumberController.dispose();
    _vehicleColorController.dispose();
    _vehicleMakeController.dispose();
    _vehicleModelController.dispose();
    _vehicleYearController.dispose();
    _drivingLicenseController.dispose();
    _idDocumentController.dispose();
    _otherDocumentsController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final driverProvider = context.read<DriverProvider>();
    final l10n = AppLocalizations.of(context)!;

    final success = await driverProvider.updateUserProfile(
      name: _nameController.text.trim().isNotEmpty ? _nameController.text.trim() : null,
      phone: _phoneController.text.trim().isNotEmpty ? _phoneController.text.trim() : null,
      age: _ageController.text.trim().isNotEmpty ? int.tryParse(_ageController.text.trim()) : null,
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
      drivingLicense: _drivingLicenseController.text.trim().isNotEmpty
          ? _drivingLicenseController.text.trim()
          : null,
      idDocument: _idDocumentController.text.trim().isNotEmpty
          ? _idDocumentController.text.trim()
          : null,
      otherDocuments: _otherDocumentsController.text.trim().isNotEmpty
          ? _otherDocumentsController.text.trim()
          : null,
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.profileUpdatedSuccessfully),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(driverProvider.error ?? l10n.failedToUpdateProfile),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final secondaryColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final hintColor =
        isDark ? AppColors.darkTextHint : AppColors.lightTextHint;
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
                                    errorBuilder: (context, error, stackTrace) =>
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
              _buildFieldLabel(Icons.person_outline, l10n.fullName, secondaryColor),
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
              _buildFieldLabel(Icons.phone_outlined, l10n.phoneNumber, secondaryColor),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _phoneController,
                hint: l10n.phoneHint,
                keyboardType: TextInputType.phone,
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                textColor: textColor,
                hintColor: hintColor,
              ),

              const SizedBox(height: 16),

              // Age
              _buildFieldLabel(Icons.cake_outlined, 'Age', secondaryColor),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _ageController,
                hint: 'Enter your age',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                textColor: textColor,
                hintColor: hintColor,
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
              _buildFieldLabel(Icons.category_outlined, 'Vehicle Type', secondaryColor),
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
              _buildFieldLabel(Icons.straighten_outlined, 'Car Size', secondaryColor),
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
              _buildFieldLabel(Icons.pin_outlined, 'Plate Number', secondaryColor),
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
              _buildFieldLabel(Icons.car_rental_outlined, 'Model', secondaryColor),
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
              _buildFieldLabel(Icons.calendar_today_outlined, 'Year', secondaryColor),
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

              // Driving License
              _buildFieldLabel(Icons.drive_eta_outlined, 'Driving License', secondaryColor),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _drivingLicenseController,
                hint: 'Enter driving license number or URL',
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                textColor: textColor,
                hintColor: hintColor,
              ),

              const SizedBox(height: 16),

              // ID Document
              _buildFieldLabel(Icons.badge_outlined, 'ID Document', secondaryColor),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _idDocumentController,
                hint: 'Enter ID document number or URL',
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                textColor: textColor,
                hintColor: hintColor,
              ),

              const SizedBox(height: 16),

              // Other Documents
              _buildFieldLabel(Icons.folder_outlined, 'Other Documents', secondaryColor),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _otherDocumentsController,
                hint: 'Enter other document details or URL',
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                textColor: textColor,
                hintColor: hintColor,
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
                    disabledBackgroundColor:
                        AppColors.primary.withValues(alpha: 0.5),
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
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      style: TextStyle(fontSize: 15, color: textColor),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 14, color: hintColor),
        filled: true,
        fillColor: surfaceColor,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
      value: value,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 14, color: hintColor),
        filled: true,
        fillColor: surfaceColor,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
        return DropdownMenuItem(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
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
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

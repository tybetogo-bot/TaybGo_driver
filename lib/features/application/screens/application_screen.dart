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
  final _registrationService = DriverRegistrationService();

  // Text controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();

  // Focus nodes for "next" action
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _ageFocus = FocusNode();

  // Form state
  String _selectedVehicle = 'BIKE';
  bool _acceptsFood = true;
  bool _acceptsShipping = false;
  bool _acceptsTaxi = false;

  // Documents section
  bool _documentsExpanded = false;

  // Loading state
  bool _isLoading = false;
  String? _error;

  final List<Map<String, String>> _vehicleTypes = [
    {'value': 'BIKE', 'label': 'Bicycle'},
    {'value': 'MOTOR', 'label': 'Motorcycle'},
    {'value': 'CAR', 'label': 'Car'},
    {'value': 'VAN', 'label': 'Van'},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _ageFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Must select at least one service
    if (!_acceptsFood && !_acceptsShipping && !_acceptsTaxi) {
      setState(() => _error = 'Please select at least one service type');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    // Try to get phone from AuthProvider first, fallback to DriverProvider profile
    final authPhone = context.read<AuthProvider>().phoneNumber;
    final profilePhone = context.read<DriverProvider>().profile?.phone;
    final phone = authPhone ?? profilePhone ?? '';

    try {
      final result = await _registrationService.registerDriver(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: phone,
        age: int.parse(_ageController.text.trim()),
        vehicleType: _selectedVehicle,
        acceptsFood: _acceptsFood,
        acceptsShipping: _acceptsShipping,
        acceptsTaxi: _acceptsTaxi,
      );

      if (!mounted) return;

      if (result.success) {
        context.go(RouteConstants.pendingApproval);
      } else {
        setState(() {
          _error = result.message;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Registration failed. Please try again.';
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
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final l10n = AppLocalizations.of(context)!;

    // Try to get phone from AuthProvider first, fallback to DriverProvider profile
    final authPhone = context.watch<AuthProvider>().phoneNumber;
    final profilePhone = context.watch<DriverProvider>().profile?.phone;
    final phone = authPhone ?? profilePhone ?? '';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(RouteConstants.phone);
            }
          },
        ),
        title: Text(l10n.driverApplication),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Join Our Team',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Fill in your details to get started',
                style: TextStyle(fontSize: 14, color: secondaryColor),
              ),
              const SizedBox(height: 24),

              // Error message
              if (_error != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
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
                const SizedBox(height: 16),
              ],

              // Name field
              _buildLabel(l10n.fullName, secondaryColor),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                focusNode: _nameFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => _emailFocus.requestFocus(),
                decoration: _inputDecoration('Enter your full name', surfaceColor, borderColor),
                validator: (v) => v == null || v.trim().isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 16),

              // Email field
              _buildLabel(l10n.email, secondaryColor),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                focusNode: _emailFocus,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => _ageFocus.requestFocus(),
                decoration: _inputDecoration('Enter your email', surfaceColor, borderColor),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Email is required';
                  if (!v.contains('@') || !v.contains('.')) return 'Enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Phone (read-only from auth)
              _buildLabel('Phone', secondaryColor),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  children: [
                    Icon(Icons.phone, size: 20, color: secondaryColor),
                    const SizedBox(width: 12),
                    Text(
                      phone.isNotEmpty ? phone : 'Not available',
                      style: TextStyle(fontSize: 16, color: textColor),
                    ),
                    const Spacer(),
                    Icon(Icons.lock_outline, size: 16, color: secondaryColor),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Age field
              _buildLabel(l10n.age, secondaryColor),
              const SizedBox(height: 8),
              TextFormField(
                controller: _ageController,
                focusNode: _ageFocus,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                decoration: _inputDecoration('Enter your age', surfaceColor, borderColor),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Age is required';
                  final age = int.tryParse(v.trim());
                  if (age == null) return 'Enter a valid age';
                  if (age < 18) return 'You must be at least 18 years old';
                  if (age > 70) return 'Age must be 70 or less';
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Vehicle type dropdown
              _buildLabel(l10n.vehicleInfo, secondaryColor),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedVehicle,
                    isExpanded: true,
                    icon: Icon(Icons.keyboard_arrow_down, color: secondaryColor),
                    items: _vehicleTypes.map((v) {
                      return DropdownMenuItem<String>(
                        value: v['value'],
                        child: Row(
                          children: [
                            Icon(_getVehicleIcon(v['value']!), size: 20, color: AppColors.primary),
                            const SizedBox(width: 12),
                            Text(v['label']!),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => _selectedVehicle = v);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Services section
              _buildLabel(l10n.serviceType, secondaryColor),
              const SizedBox(height: 8),
              _buildServiceToggle(
                l10n.foodDelivery,
                Icons.restaurant_outlined,
                _acceptsFood,
                (v) => setState(() => _acceptsFood = v),
                surfaceColor,
                textColor,
                borderColor,
              ),
              const SizedBox(height: 8),
              _buildServiceToggle(
                l10n.shipping,
                Icons.local_shipping_outlined,
                _acceptsShipping,
                (v) => setState(() => _acceptsShipping = v),
                surfaceColor,
                textColor,
                borderColor,
              ),
              const SizedBox(height: 8),
              _buildServiceToggle(
                l10n.taxi,
                Icons.local_taxi_outlined,
                _acceptsTaxi,
                (v) => setState(() => _acceptsTaxi = v),
                surfaceColor,
                textColor,
                borderColor,
              ),
              const SizedBox(height: 24),

              // Documents section (collapsed)
              Container(
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    initiallyExpanded: _documentsExpanded,
                    onExpansionChanged: (v) => setState(() => _documentsExpanded = v),
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                    leading: Icon(Icons.folder_outlined, color: secondaryColor),
                    title: Text(
                      l10n.documents,
                      style: TextStyle(fontSize: 16, color: textColor),
                    ),
                    subtitle: Text(
                      'Optional - can be uploaded later',
                      style: TextStyle(fontSize: 12, color: secondaryColor),
                    ),
                    trailing: Icon(
                      _documentsExpanded ? Icons.expand_less : Icons.expand_more,
                      color: secondaryColor,
                    ),
                    children: [
                      const Divider(height: 1),
                      _buildDocumentTile(
                        l10n.driversLicense,
                        Icons.badge_outlined,
                        secondaryColor,
                        textColor,
                      ),
                      _buildDocumentTile(
                        l10n.nationalId,
                        Icons.credit_card_outlined,
                        secondaryColor,
                        textColor,
                      ),
                      _buildDocumentTile(
                        'Other Documents',
                        Icons.description_outlined,
                        secondaryColor,
                        textColor,
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Submit button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(l10n.submitApplication),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, Color color) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color,
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, Color fillColor, Color borderColor) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: fillColor,
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
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  IconData _getVehicleIcon(String type) {
    switch (type) {
      case 'BIKE':
        return Icons.pedal_bike;
      case 'MOTOR':
        return Icons.two_wheeler;
      case 'CAR':
        return Icons.directions_car;
      case 'VAN':
        return Icons.airport_shuttle;
      default:
        return Icons.directions_car;
    }
  }

  Widget _buildServiceToggle(
    String label,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
    Color surfaceColor,
    Color textColor,
    Color borderColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: value ? AppColors.primary : borderColor, width: value ? 2 : 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: value ? AppColors.primary : textColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: textColor,
                fontWeight: value ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentTile(String title, IconData icon, Color secondaryColor, Color textColor) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: Icon(icon, color: secondaryColor, size: 22),
      title: Text(title, style: TextStyle(fontSize: 15, color: textColor)),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'Upload',
          style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w500),
        ),
      ),
      onTap: () {
        // TODO: Implement document upload
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Document upload coming soon')),
        );
      },
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/config/google_places_config.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/models/driver_address.dart';
import '../../../core/providers/driver_provider.dart';
import '../../../core/services/google_places_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/google_places_address_picker.dart';

class EditAddressScreen extends StatefulWidget {
  const EditAddressScreen({super.key});

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  static const _existingAddressSelectionId = 'existing-profile-address';

  final _placesSearchController = TextEditingController();
  final _addressLabelController = TextEditingController();
  final _addressLatitudeController = TextEditingController();
  final _addressLongitudeController = TextEditingController();
  final _fullAddressController = TextEditingController();
  final _streetNameController = TextEditingController();
  final _houseNumberController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _countryController = TextEditingController();

  late final DriverProvider _driverProvider;
  GooglePlacesService? _placesService;
  DriverAddress? _selectedGoogleAddress;
  String? _selectedGooglePlaceId;
  bool _initializedFromProfile = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (GooglePlacesConfig.isConfigured) {
      _placesService = GooglePlacesService(
        apiKey: GooglePlacesConfig.apiKey.trim(),
      );
    }
    _driverProvider = context.read<DriverProvider>();
    _driverProvider.addListener(_handleProfileChanged);
    final profile = _driverProvider.profile;
    if (profile != null) {
      _applyAddress(profile.address);
      _initializedFromProfile = true;
    } else {
      unawaited(_driverProvider.fetchProfile());
    }
  }

  @override
  void dispose() {
    _driverProvider.removeListener(_handleProfileChanged);
    _placesSearchController.dispose();
    _addressLabelController.dispose();
    _addressLatitudeController.dispose();
    _addressLongitudeController.dispose();
    _fullAddressController.dispose();
    _streetNameController.dispose();
    _houseNumberController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    _placesService?.close();
    super.dispose();
  }

  void _handleProfileChanged() {
    if (!mounted || _initializedFromProfile) return;
    final profile = _driverProvider.profile;
    if (profile == null) return;
    setState(() {
      _applyAddress(profile.address);
      _initializedFromProfile = true;
    });
  }

  void _applyAddress(DriverAddress? address) {
    _placesSearchController.text = address?.fullAddress ?? '';
    _addressLabelController.text = address?.label ?? '';
    _addressLatitudeController.text = address?.lat ?? '';
    _addressLongitudeController.text = address?.lng ?? '';
    _fullAddressController.text = address?.fullAddress ?? '';
    _streetNameController.text = address?.streetName ?? '';
    _houseNumberController.text = address?.houseNumber ?? '';
    _cityController.text = address?.city ?? '';
    _postalCodeController.text = address?.postalCode ?? '';
    _countryController.text = address?.country ?? '';
    _selectedGoogleAddress = address;
    _selectedGooglePlaceId = address == null
        ? null
        : _existingAddressSelectionId;
  }

  String? _controllerValue(TextEditingController controller) {
    final value = controller.text.trim();
    return value.isEmpty ? null : value;
  }

  DriverAddress? _addressFromFields() {
    final address = DriverAddress(
      label: _controllerValue(_addressLabelController),
      lat: _controllerValue(_addressLatitudeController),
      lng: _controllerValue(_addressLongitudeController),
      fullAddress: _controllerValue(_fullAddressController),
      streetName: _controllerValue(_streetNameController),
      houseNumber: _controllerValue(_houseNumberController),
      city: _controllerValue(_cityController),
      postalCode: _controllerValue(_postalCodeController),
      country: _controllerValue(_countryController),
    );
    return address.hasAnyValue ? address : null;
  }

  String? _validateAddress(AppLocalizations l10n) {
    if (_placesSearchController.text.trim().isEmpty) {
      return l10n.addressRequired;
    }
    if (_selectedGooglePlaceId == null) {
      return l10n.selectAddressSuggestion;
    }

    final address = _addressFromFields();
    if (address == null) return l10n.addressRequired;
    if (address.label == null ||
        address.lat == null ||
        address.lng == null ||
        address.fullAddress == null) {
      return l10n.addressCoordinatesMissing;
    }

    final latitude = double.tryParse(address.lat!);
    if (latitude == null || latitude < -90 || latitude > 90) {
      return l10n.invalidLatitude;
    }
    final longitude = double.tryParse(address.lng!);
    if (longitude == null || longitude < -180 || longitude > 180) {
      return l10n.invalidLongitude;
    }
    return null;
  }

  void _handleGooglePlaceSelection(GooglePlaceAddressSelection selection) {
    final source = selection.address;
    final address = DriverAddress(
      label: source.label ?? AppLocalizations.of(context)!.home,
      lat: source.lat,
      lng: source.lng,
      fullAddress: source.fullAddress,
      streetName: source.streetName,
      houseNumber: source.houseNumber,
      city: source.city,
      postalCode: source.postalCode,
      country: source.country,
    );
    setState(() {
      _selectedGooglePlaceId = selection.placeId;
      _selectedGoogleAddress = address;
      _addressLabelController.text = address.label!;
      _addressLatitudeController.text = address.lat ?? '';
      _addressLongitudeController.text = address.lng ?? '';
      _fullAddressController.text = address.fullAddress ?? '';
      _streetNameController.text = address.streetName ?? '';
      _houseNumberController.text = address.houseNumber ?? '';
      _cityController.text = address.city ?? '';
      _postalCodeController.text = address.postalCode ?? '';
      _countryController.text = address.country ?? '';
    });
  }

  void _clearAddress() {
    _placesSearchController.clear();
    setState(() {
      _selectedGoogleAddress = null;
      _selectedGooglePlaceId = null;
      _addressLabelController.clear();
      _addressLatitudeController.clear();
      _addressLongitudeController.clear();
      _fullAddressController.clear();
      _streetNameController.clear();
      _houseNumberController.clear();
      _cityController.clear();
      _postalCodeController.clear();
      _countryController.clear();
    });
  }

  void _handleAddressQueryChanged(String _) {
    setState(() {
      if (_selectedGooglePlaceId != null) {
        _selectedGoogleAddress = null;
        _selectedGooglePlaceId = null;
        _addressLatitudeController.clear();
        _addressLongitudeController.clear();
        _fullAddressController.clear();
        _streetNameController.clear();
        _houseNumberController.clear();
        _cityController.clear();
        _postalCodeController.clear();
        _countryController.clear();
      }
    });
  }

  void _handleAddressDetailsChanged() {
    setState(() => _selectedGoogleAddress = _addressFromFields());
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String? _changedValue(String? value, String? original) {
    if (value?.trim() == original?.trim()) return null;
    return value?.trim().isEmpty == true ? null : value?.trim();
  }

  DriverAddress? _buildAddressUpdate() {
    final entered = _addressFromFields();
    if (entered == null) return null;
    final existing = _driverProvider.profile?.address;
    if (existing == null) return entered;

    final update = DriverAddress(
      label: _changedValue(entered.label, existing.label),
      lat: _changedValue(entered.lat, existing.lat),
      lng: _changedValue(entered.lng, existing.lng),
      fullAddress: _changedValue(entered.fullAddress, existing.fullAddress),
      streetName: _changedValue(entered.streetName, existing.streetName),
      houseNumber: _changedValue(entered.houseNumber, existing.houseNumber),
      city: _changedValue(entered.city, existing.city),
      postalCode: _changedValue(entered.postalCode, existing.postalCode),
      country: _changedValue(entered.country, existing.country),
    );
    return update.hasAnyValue ? update : null;
  }

  Future<void> _saveAddress() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final l10n = AppLocalizations.of(context)!;
    final error = _validateAddress(l10n);
    if (error != null) {
      _showError(error);
      return;
    }

    final update = _buildAddressUpdate();
    if (update == null) {
      context.pop();
      return;
    }

    setState(() => _isSaving = true);
    final success = await _driverProvider.updateProfile(address: update);
    if (!mounted) return;
    setState(() => _isSaving = false);

    if (!success) {
      _showError(_driverProvider.error ?? l10n.failedToUpdateAddress);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.addressUpdatedSuccessfully),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
    context.pop();
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
      appBar: AppBar(title: Text(l10n.editAddress)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.addressStepTitle,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.addressStepSubtitle,
                          style: TextStyle(color: secondaryColor, fontSize: 15),
                        ),
                        const SizedBox(height: 24),
                        GooglePlacesAddressPicker(
                          service: _placesService,
                          searchController: _placesSearchController,
                          selectedAddress: _selectedGoogleAddress,
                          labelController: _addressLabelController,
                          houseNumberController: _houseNumberController,
                          postalCodeController: _postalCodeController,
                          textColor: textColor,
                          secondaryColor: secondaryColor,
                          surfaceColor: surfaceColor,
                          borderColor: borderColor,
                          hintColor: hintColor,
                          onSelection: _handleGooglePlaceSelection,
                          onClear: _clearAddress,
                          onError: (error) {
                            debugPrint(
                              '[EditAddressScreen] Google Places error: $error',
                            );
                            _showError(l10n.addressSearchError);
                          },
                          onQueryChanged: _handleAddressQueryChanged,
                          onDetailsChanged: _handleAddressDetailsChanged,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _isSaving ? null : _saveAddress,
                      icon: _isSaving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.check_rounded),
                      label: Text(l10n.saveAddress),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

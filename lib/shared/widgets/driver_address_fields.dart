import 'package:flutter/material.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';

class DriverAddressFields extends StatelessWidget {
  final TextEditingController labelController;
  final TextEditingController latitudeController;
  final TextEditingController longitudeController;
  final TextEditingController fullAddressController;
  final TextEditingController streetNameController;
  final TextEditingController houseNumberController;
  final TextEditingController cityController;
  final TextEditingController postalCodeController;
  final TextEditingController countryController;
  final Color textColor;
  final Color secondaryColor;
  final Color surfaceColor;
  final Color borderColor;
  final Color hintColor;
  final bool isLoadingLocation;
  final VoidCallback onUseCurrentLocation;

  const DriverAddressFields({
    super.key,
    required this.labelController,
    required this.latitudeController,
    required this.longitudeController,
    required this.fullAddressController,
    required this.streetNameController,
    required this.houseNumberController,
    required this.cityController,
    required this.postalCodeController,
    required this.countryController,
    required this.textColor,
    required this.secondaryColor,
    required this.surfaceColor,
    required this.borderColor,
    required this.hintColor,
    required this.isLoadingLocation,
    required this.onUseCurrentLocation,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.addressOptionalSubtitle,
          style: TextStyle(fontSize: 13, color: secondaryColor),
        ),
        const SizedBox(height: 16),
        _buildField(
          controller: labelController,
          label: l10n.addressLabel,
          hint: l10n.addressLabelHint,
          icon: Icons.bookmark_outline,
        ),
        const SizedBox(height: 12),
        _buildField(
          controller: fullAddressController,
          label: l10n.fullAddress,
          hint: l10n.fullAddressHint,
          icon: Icons.location_on_outlined,
          maxLines: 2,
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildField(
                controller: latitudeController,
                label: l10n.latitude,
                hint: l10n.latitudeHint,
                icon: Icons.north,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                textDirection: TextDirection.ltr,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildField(
                controller: longitudeController,
                label: l10n.longitude,
                hint: l10n.longitudeHint,
                icon: Icons.east,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                textDirection: TextDirection.ltr,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: isLoadingLocation ? null : onUseCurrentLocation,
            icon: isLoadingLocation
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.my_location_outlined),
            label: Text(l10n.useCurrentLocation),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 13),
              side: BorderSide(color: AppColors.primary.withValues(alpha: 0.5)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildField(
                controller: streetNameController,
                label: l10n.streetName,
                hint: l10n.streetNameHint,
                icon: Icons.signpost_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildField(
                controller: houseNumberController,
                label: l10n.houseNumber,
                hint: l10n.houseNumberHint,
                icon: Icons.home_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildField(
                controller: cityController,
                label: l10n.city,
                hint: l10n.cityHint,
                icon: Icons.location_city_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildField(
                controller: postalCodeController,
                label: l10n.postalCode,
                hint: l10n.postalCodeHint,
                icon: Icons.markunread_mailbox_outlined,
                textDirection: TextDirection.ltr,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildField(
          controller: countryController,
          label: l10n.country,
          hint: l10n.countryHint,
          icon: Icons.public_outlined,
          textDirection: TextDirection.ltr,
        ),
      ],
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    TextDirection? textDirection,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textDirection: textDirection,
      maxLines: maxLines,
      style: TextStyle(fontSize: 14, color: textColor),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 19, color: secondaryColor),
        hintStyle: TextStyle(fontSize: 13, color: hintColor),
        labelStyle: TextStyle(fontSize: 13, color: secondaryColor),
        floatingLabelStyle: const TextStyle(color: AppColors.primary),
        filled: true,
        fillColor: surfaceColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
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
    );
  }
}

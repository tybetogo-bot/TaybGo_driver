import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/models/driver_address.dart';
import '../../core/services/google_places_service.dart';
import '../../core/theme/app_colors.dart';

class GooglePlacesAddressPicker extends StatefulWidget {
  const GooglePlacesAddressPicker({
    super.key,
    required this.service,
    required this.searchController,
    required this.selectedAddress,
    required this.labelController,
    required this.houseNumberController,
    required this.postalCodeController,
    required this.textColor,
    required this.secondaryColor,
    required this.surfaceColor,
    required this.borderColor,
    required this.hintColor,
    required this.onSelection,
    required this.onClear,
    required this.onError,
    required this.onQueryChanged,
    required this.onDetailsChanged,
  });

  final GooglePlacesService? service;
  final TextEditingController searchController;
  final DriverAddress? selectedAddress;
  final TextEditingController labelController;
  final TextEditingController houseNumberController;
  final TextEditingController postalCodeController;
  final Color textColor;
  final Color secondaryColor;
  final Color surfaceColor;
  final Color borderColor;
  final Color hintColor;
  final ValueChanged<GooglePlaceAddressSelection> onSelection;
  final VoidCallback onClear;
  final ValueChanged<Object> onError;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onDetailsChanged;

  @override
  State<GooglePlacesAddressPicker> createState() =>
      _GooglePlacesAddressPickerState();
}

class _GooglePlacesAddressPickerState extends State<GooglePlacesAddressPicker> {
  Timer? _debounce;
  List<GooglePlaceSuggestion> _suggestions = const [];
  bool _isSearching = false;
  bool _isResolving = false;
  bool _showNoResults = false;
  int _requestGeneration = 0;
  late String _sessionToken;

  @override
  void initState() {
    super.initState();
    _sessionToken = _newSessionToken();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _handleQueryChanged(String value) {
    widget.onQueryChanged(value);
    _debounce?.cancel();
    final query = value.trim();
    if (query.length < 3) {
      setState(() {
        _suggestions = const [];
        _isSearching = false;
        _showNoResults = false;
      });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 350), () {
      unawaited(_search(query));
    });
  }

  Future<void> _search(String query) async {
    final service = widget.service;
    if (service == null || !mounted) return;
    final generation = ++_requestGeneration;
    setState(() {
      _isSearching = true;
      _showNoResults = false;
    });

    try {
      final locale = Localizations.localeOf(context);
      final results = await service.autocomplete(
        input: query,
        sessionToken: _sessionToken,
        languageCode: locale.languageCode,
        regionCode: locale.countryCode?.toLowerCase(),
      );
      if (!mounted || generation != _requestGeneration) return;
      setState(() {
        _suggestions = results;
        _isSearching = false;
        _showNoResults = results.isEmpty;
      });
    } catch (error) {
      if (!mounted || generation != _requestGeneration) return;
      setState(() {
        _suggestions = const [];
        _isSearching = false;
        _showNoResults = false;
      });
      widget.onError(error);
    }
  }

  Future<void> _selectSuggestion(GooglePlaceSuggestion suggestion) async {
    final service = widget.service;
    if (service == null || _isResolving) return;
    setState(() => _isResolving = true);

    try {
      final locale = Localizations.localeOf(context);
      final l10n = AppLocalizations.of(context)!;
      final selection = await service.resolveAddress(
        suggestion: suggestion,
        sessionToken: _sessionToken,
        label: widget.labelController.text.trim().isEmpty
            ? l10n.home
            : widget.labelController.text,
        languageCode: locale.languageCode,
        regionCode: locale.countryCode?.toLowerCase(),
      );
      if (!mounted) return;
      widget.searchController.value = TextEditingValue(
        text: selection.address.fullAddress ?? suggestion.fullText,
        selection: TextSelection.collapsed(
          offset: (selection.address.fullAddress ?? suggestion.fullText).length,
        ),
      );
      setState(() {
        _isResolving = false;
        _suggestions = const [];
        _showNoResults = false;
        _sessionToken = _newSessionToken();
      });
      widget.onSelection(selection);
    } catch (error) {
      if (!mounted) return;
      setState(() => _isResolving = false);
      widget.onError(error);
    }
  }

  void _clear() {
    _debounce?.cancel();
    _requestGeneration++;
    widget.searchController.clear();
    setState(() {
      _suggestions = const [];
      _isSearching = false;
      _isResolving = false;
      _showNoResults = false;
      _sessionToken = _newSessionToken();
    });
    widget.onClear();
  }

  String _newSessionToken() {
    final random = Random.secure();
    final values = List<int>.generate(4, (_) => random.nextInt(0x100000000));
    return values
        .map((value) => value.toRadixString(16).padLeft(8, '0'))
        .join();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.addressOptionalSubtitle,
          style: TextStyle(fontSize: 13, color: widget.secondaryColor),
        ),
        const SizedBox(height: 16),
        if (widget.service == null)
          _StatusCard(
            icon: Icons.key_off_outlined,
            message: l10n.addressSearchUnavailable,
            color: AppColors.warning,
            textColor: widget.textColor,
          )
        else ...[
          TextFormField(
            controller: widget.searchController,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.search,
            onChanged: _handleQueryChanged,
            style: TextStyle(color: widget.textColor, fontSize: 15),
            decoration: InputDecoration(
              labelText: l10n.searchForAddress,
              hintText: l10n.searchAddressHint,
              prefixIcon: const Icon(
                Icons.location_searching_rounded,
                color: AppColors.primary,
              ),
              suffixIcon: _isSearching || _isResolving
                  ? const Padding(
                      padding: EdgeInsets.all(14),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : widget.searchController.text.isNotEmpty
                  ? IconButton(
                      tooltip: l10n.clearAddress,
                      onPressed: _clear,
                      icon: const Icon(Icons.close_rounded),
                    )
                  : null,
              labelStyle: TextStyle(color: widget.secondaryColor),
              hintStyle: TextStyle(color: widget.hintColor, fontSize: 14),
              filled: true,
              fillColor: widget.surfaceColor,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18,
              ),
              border: _border(widget.borderColor),
              enabledBorder: _border(widget.borderColor),
              focusedBorder: _border(AppColors.primary, width: 1.5),
            ),
          ),
          if (_suggestions.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: widget.surfaceColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: widget.borderColor),
              ),
              child: Column(
                children: [
                  for (var index = 0; index < _suggestions.length; index++) ...[
                    _SuggestionTile(
                      suggestion: _suggestions[index],
                      textColor: widget.textColor,
                      secondaryColor: widget.secondaryColor,
                      onTap: () => _selectSuggestion(_suggestions[index]),
                    ),
                    if (index < _suggestions.length - 1)
                      Divider(height: 1, color: widget.borderColor),
                  ],
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                    child: Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Text(
                        'Powered by Google',
                        style: TextStyle(
                          color: widget.secondaryColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else if (_showNoResults) ...[
            const SizedBox(height: 10),
            _StatusCard(
              icon: Icons.search_off_rounded,
              message: l10n.noAddressResults,
              color: widget.secondaryColor,
              textColor: widget.textColor,
            ),
          ],
        ],
        if (widget.selectedAddress != null) ...[
          const SizedBox(height: 16),
          _SelectedAddressCard(
            address: widget.selectedAddress!,
            textColor: widget.textColor,
            secondaryColor: widget.secondaryColor,
            onClear: _clear,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.addressDetails,
            style: TextStyle(
              color: widget.textColor,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          _AddressDetailField(
            controller: widget.labelController,
            label: l10n.addressLabel,
            hint: l10n.addressLabelHint,
            icon: Icons.bookmark_outline_rounded,
            textColor: widget.textColor,
            secondaryColor: widget.secondaryColor,
            hintColor: widget.hintColor,
            surfaceColor: widget.surfaceColor,
            borderColor: widget.borderColor,
            onChanged: widget.onDetailsChanged,
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _AddressDetailField(
                  controller: widget.houseNumberController,
                  label: l10n.houseNumber,
                  hint: l10n.houseNumberHint,
                  icon: Icons.home_outlined,
                  textColor: widget.textColor,
                  secondaryColor: widget.secondaryColor,
                  hintColor: widget.hintColor,
                  surfaceColor: widget.surfaceColor,
                  borderColor: widget.borderColor,
                  onChanged: widget.onDetailsChanged,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _AddressDetailField(
                  controller: widget.postalCodeController,
                  label: l10n.postalCode,
                  hint: l10n.postalCodeHint,
                  icon: Icons.markunread_mailbox_outlined,
                  textColor: widget.textColor,
                  secondaryColor: widget.secondaryColor,
                  hintColor: widget.hintColor,
                  surfaceColor: widget.surfaceColor,
                  borderColor: widget.borderColor,
                  onChanged: widget.onDetailsChanged,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  const _SuggestionTile({
    required this.suggestion,
    required this.textColor,
    required this.secondaryColor,
    required this.onTap,
  });

  final GooglePlaceSuggestion suggestion;
  final Color textColor;
  final Color secondaryColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.location_on_outlined, color: AppColors.primary),
      ),
      title: Text(
        suggestion.primaryText,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
      ),
      subtitle: suggestion.secondaryText == null
          ? null
          : Text(
              suggestion.secondaryText!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: secondaryColor, fontSize: 12),
            ),
      trailing: const Icon(Icons.chevron_right_rounded),
    );
  }
}

class _SelectedAddressCard extends StatelessWidget {
  const _SelectedAddressCard({
    required this.address,
    required this.textColor,
    required this.secondaryColor,
    required this.onClear,
  });

  final DriverAddress address;
  final Color textColor;
  final Color secondaryColor;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final area = [
      address.postalCode,
      address.city,
      address.country,
    ].whereType<String>().where((value) => value.trim().isNotEmpty).join(' · ');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.14),
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
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.success,
                      size: 17,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      l10n.addressSelected,
                      style: const TextStyle(
                        color: AppColors.success,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  address.fullAddress ?? '',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
                if (area.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    area,
                    style: TextStyle(color: secondaryColor, fontSize: 13),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            tooltip: l10n.clearAddress,
            onPressed: onClear,
            icon: Icon(Icons.close_rounded, color: secondaryColor),
          ),
        ],
      ),
    );
  }
}

class _AddressDetailField extends StatelessWidget {
  const _AddressDetailField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.textColor,
    required this.secondaryColor,
    required this.hintColor,
    required this.surfaceColor,
    required this.borderColor,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final Color textColor;
  final Color secondaryColor;
  final Color hintColor;
  final Color surfaceColor;
  final Color borderColor;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.next,
      onChanged: (_) => onChanged(),
      style: TextStyle(color: textColor, fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
        labelStyle: TextStyle(color: secondaryColor, fontSize: 13),
        hintStyle: TextStyle(color: hintColor, fontSize: 13),
        filled: true,
        fillColor: surfaceColor,
        border: _border(borderColor),
        enabledBorder: _border(borderColor),
        focusedBorder: _border(AppColors.primary, width: 1.5),
      ),
    );
  }

  OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.icon,
    required this.message,
    required this.color,
    required this.textColor,
  });

  final IconData icon;
  final String message;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(message, style: TextStyle(color: textColor)),
          ),
        ],
      ),
    );
  }
}

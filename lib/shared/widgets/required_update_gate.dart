import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/config/app_config.dart';
import '../../core/config/public_app_config.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/providers/public_config_provider.dart';
import '../../core/theme/app_colors.dart';

class RequiredUpdateGate extends StatelessWidget {
  const RequiredUpdateGate({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final config = context.watch<PublicConfigProvider>().config;
    if (config?.forceUpdate != true) return child;
    return _RequiredUpdateScreen(config: config!);
  }
}

class _RequiredUpdateScreen extends StatefulWidget {
  const _RequiredUpdateScreen({required this.config});

  final PublicAppConfig config;

  @override
  State<_RequiredUpdateScreen> createState() => _RequiredUpdateScreenState();
}

class _RequiredUpdateScreenState extends State<_RequiredUpdateScreen> {
  bool _isOpening = false;
  String? _error;

  Uri? get _updateUri {
    final value = widget.config.updateUrl;
    if (value == null) return null;
    final parsed = Uri.tryParse(value);
    if (parsed == null) return null;
    return parsed.hasScheme
        ? parsed
        : Uri.parse(AppConfig.baseUrl).resolveUri(parsed);
  }

  Future<void> _openUpdate() async {
    final l10n = AppLocalizations.of(context)!;
    final uri = _updateUri;
    if (uri == null || (uri.scheme != 'http' && uri.scheme != 'https')) {
      setState(() => _error = l10n.invalidUpdateUrl);
      return;
    }

    setState(() {
      _isOpening = true;
      _error = null;
    });
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!mounted) return;
    setState(() {
      _isOpening = false;
      if (!opened) _error = l10n.couldNotOpenLink;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final secondaryColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  children: [
                    Container(
                      width: 112,
                      height: 112,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.system_update_alt_rounded,
                        size: 58,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      l10n.updateRequiredTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.updateRequiredMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: secondaryColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      l10n.latestVersionLabel(widget.config.latestVersion),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 18),
                      Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.error),
                      ),
                    ],
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _isOpening ? null : _openUpdate,
                        icon: _isOpening
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.open_in_new_rounded),
                        label: Text(l10n.updateNow),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton.icon(
                      onPressed: context.read<PublicConfigProvider>().refresh,
                      icon: const Icon(Icons.refresh_rounded),
                      label: Text(l10n.checkAgain),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

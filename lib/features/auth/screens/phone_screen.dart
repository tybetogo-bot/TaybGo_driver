import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/locale_provider.dart';

class _Country {
  final String name;
  final String code;
  final String dialCode;
  final String flag;

  const _Country(this.name, this.code, this.dialCode, this.flag);
}

const _countries = [
  _Country('Afghanistan', 'AF', '+93', '\u{1F1E6}\u{1F1EB}'),
  _Country('Albania', 'AL', '+355', '\u{1F1E6}\u{1F1F1}'),
  _Country('Algeria', 'DZ', '+213', '\u{1F1E9}\u{1F1FF}'),
  _Country('Andorra', 'AD', '+376', '\u{1F1E6}\u{1F1E9}'),
  _Country('Angola', 'AO', '+244', '\u{1F1E6}\u{1F1F4}'),
  _Country('Antigua and Barbuda', 'AG', '+1268', '\u{1F1E6}\u{1F1EC}'),
  _Country('Argentina', 'AR', '+54', '\u{1F1E6}\u{1F1F7}'),
  _Country('Armenia', 'AM', '+374', '\u{1F1E6}\u{1F1F2}'),
  _Country('Australia', 'AU', '+61', '\u{1F1E6}\u{1F1FA}'),
  _Country('Austria', 'AT', '+43', '\u{1F1E6}\u{1F1F9}'),
  _Country('Azerbaijan', 'AZ', '+994', '\u{1F1E6}\u{1F1FF}'),
  _Country('Bahamas', 'BS', '+1242', '\u{1F1E7}\u{1F1F8}'),
  _Country('Bahrain', 'BH', '+973', '\u{1F1E7}\u{1F1ED}'),
  _Country('Bangladesh', 'BD', '+880', '\u{1F1E7}\u{1F1E9}'),
  _Country('Barbados', 'BB', '+1246', '\u{1F1E7}\u{1F1E7}'),
  _Country('Belarus', 'BY', '+375', '\u{1F1E7}\u{1F1FE}'),
  _Country('Belgium', 'BE', '+32', '\u{1F1E7}\u{1F1EA}'),
  _Country('Belize', 'BZ', '+501', '\u{1F1E7}\u{1F1FF}'),
  _Country('Benin', 'BJ', '+229', '\u{1F1E7}\u{1F1EF}'),
  _Country('Bhutan', 'BT', '+975', '\u{1F1E7}\u{1F1F9}'),
  _Country('Bolivia', 'BO', '+591', '\u{1F1E7}\u{1F1F4}'),
  _Country('Bosnia and Herzegovina', 'BA', '+387', '\u{1F1E7}\u{1F1E6}'),
  _Country('Botswana', 'BW', '+267', '\u{1F1E7}\u{1F1FC}'),
  _Country('Brazil', 'BR', '+55', '\u{1F1E7}\u{1F1F7}'),
  _Country('Brunei', 'BN', '+673', '\u{1F1E7}\u{1F1F3}'),
  _Country('Bulgaria', 'BG', '+359', '\u{1F1E7}\u{1F1EC}'),
  _Country('Burkina Faso', 'BF', '+226', '\u{1F1E7}\u{1F1EB}'),
  _Country('Burundi', 'BI', '+257', '\u{1F1E7}\u{1F1EE}'),
  _Country('Cabo Verde', 'CV', '+238', '\u{1F1E8}\u{1F1FB}'),
  _Country('Cambodia', 'KH', '+855', '\u{1F1F0}\u{1F1ED}'),
  _Country('Cameroon', 'CM', '+237', '\u{1F1E8}\u{1F1F2}'),
  _Country('Canada', 'CA', '+1', '\u{1F1E8}\u{1F1E6}'),
  _Country('Central African Republic', 'CF', '+236', '\u{1F1E8}\u{1F1EB}'),
  _Country('Chad', 'TD', '+235', '\u{1F1F9}\u{1F1E9}'),
  _Country('Chile', 'CL', '+56', '\u{1F1E8}\u{1F1F1}'),
  _Country('China', 'CN', '+86', '\u{1F1E8}\u{1F1F3}'),
  _Country('Colombia', 'CO', '+57', '\u{1F1E8}\u{1F1F4}'),
  _Country('Comoros', 'KM', '+269', '\u{1F1F0}\u{1F1F2}'),
  _Country('Congo (DRC)', 'CD', '+243', '\u{1F1E8}\u{1F1E9}'),
  _Country('Congo (Republic)', 'CG', '+242', '\u{1F1E8}\u{1F1EC}'),
  _Country('Costa Rica', 'CR', '+506', '\u{1F1E8}\u{1F1F7}'),
  _Country("C\u00f4te d'Ivoire", 'CI', '+225', '\u{1F1E8}\u{1F1EE}'),
  _Country('Croatia', 'HR', '+385', '\u{1F1ED}\u{1F1F7}'),
  _Country('Cuba', 'CU', '+53', '\u{1F1E8}\u{1F1FA}'),
  _Country('Cyprus', 'CY', '+357', '\u{1F1E8}\u{1F1FE}'),
  _Country('Czech Republic', 'CZ', '+420', '\u{1F1E8}\u{1F1FF}'),
  _Country('Denmark', 'DK', '+45', '\u{1F1E9}\u{1F1F0}'),
  _Country('Djibouti', 'DJ', '+253', '\u{1F1E9}\u{1F1EF}'),
  _Country('Dominica', 'DM', '+1767', '\u{1F1E9}\u{1F1F2}'),
  _Country('Dominican Republic', 'DO', '+1809', '\u{1F1E9}\u{1F1F4}'),
  _Country('Ecuador', 'EC', '+593', '\u{1F1EA}\u{1F1E8}'),
  _Country('Egypt', 'EG', '+20', '\u{1F1EA}\u{1F1EC}'),
  _Country('El Salvador', 'SV', '+503', '\u{1F1F8}\u{1F1FB}'),
  _Country('Equatorial Guinea', 'GQ', '+240', '\u{1F1EC}\u{1F1F6}'),
  _Country('Eritrea', 'ER', '+291', '\u{1F1EA}\u{1F1F7}'),
  _Country('Estonia', 'EE', '+372', '\u{1F1EA}\u{1F1EA}'),
  _Country('Eswatini', 'SZ', '+268', '\u{1F1F8}\u{1F1FF}'),
  _Country('Ethiopia', 'ET', '+251', '\u{1F1EA}\u{1F1F9}'),
  _Country('Fiji', 'FJ', '+679', '\u{1F1EB}\u{1F1EF}'),
  _Country('Finland', 'FI', '+358', '\u{1F1EB}\u{1F1EE}'),
  _Country('France', 'FR', '+33', '\u{1F1EB}\u{1F1F7}'),
  _Country('Gabon', 'GA', '+241', '\u{1F1EC}\u{1F1E6}'),
  _Country('Gambia', 'GM', '+220', '\u{1F1EC}\u{1F1F2}'),
  _Country('Georgia', 'GE', '+995', '\u{1F1EC}\u{1F1EA}'),
  _Country('Germany', 'DE', '+49', '\u{1F1E9}\u{1F1EA}'),
  _Country('Ghana', 'GH', '+233', '\u{1F1EC}\u{1F1ED}'),
  _Country('Greece', 'GR', '+30', '\u{1F1EC}\u{1F1F7}'),
  _Country('Grenada', 'GD', '+1473', '\u{1F1EC}\u{1F1E9}'),
  _Country('Guatemala', 'GT', '+502', '\u{1F1EC}\u{1F1F9}'),
  _Country('Guinea', 'GN', '+224', '\u{1F1EC}\u{1F1F3}'),
  _Country('Guinea-Bissau', 'GW', '+245', '\u{1F1EC}\u{1F1FC}'),
  _Country('Guyana', 'GY', '+592', '\u{1F1EC}\u{1F1FE}'),
  _Country('Haiti', 'HT', '+509', '\u{1F1ED}\u{1F1F9}'),
  _Country('Honduras', 'HN', '+504', '\u{1F1ED}\u{1F1F3}'),
  _Country('Hong Kong', 'HK', '+852', '\u{1F1ED}\u{1F1F0}'),
  _Country('Hungary', 'HU', '+36', '\u{1F1ED}\u{1F1FA}'),
  _Country('Iceland', 'IS', '+354', '\u{1F1EE}\u{1F1F8}'),
  _Country('India', 'IN', '+91', '\u{1F1EE}\u{1F1F3}'),
  _Country('Indonesia', 'ID', '+62', '\u{1F1EE}\u{1F1E9}'),
  _Country('Iran', 'IR', '+98', '\u{1F1EE}\u{1F1F7}'),
  _Country('Iraq', 'IQ', '+964', '\u{1F1EE}\u{1F1F6}'),
  _Country('Ireland', 'IE', '+353', '\u{1F1EE}\u{1F1EA}'),
  _Country('Israel', 'IL', '+972', '\u{1F1EE}\u{1F1F1}'),
  _Country('Italy', 'IT', '+39', '\u{1F1EE}\u{1F1F9}'),
  _Country('Jamaica', 'JM', '+1876', '\u{1F1EF}\u{1F1F2}'),
  _Country('Japan', 'JP', '+81', '\u{1F1EF}\u{1F1F5}'),
  _Country('Jordan', 'JO', '+962', '\u{1F1EF}\u{1F1F4}'),
  _Country('Kazakhstan', 'KZ', '+7', '\u{1F1F0}\u{1F1FF}'),
  _Country('Kenya', 'KE', '+254', '\u{1F1F0}\u{1F1EA}'),
  _Country('Kiribati', 'KI', '+686', '\u{1F1F0}\u{1F1EE}'),
  _Country('Kosovo', 'XK', '+383', '\u{1F1FD}\u{1F1F0}'),
  _Country('Kuwait', 'KW', '+965', '\u{1F1F0}\u{1F1FC}'),
  _Country('Kyrgyzstan', 'KG', '+996', '\u{1F1F0}\u{1F1EC}'),
  _Country('Laos', 'LA', '+856', '\u{1F1F1}\u{1F1E6}'),
  _Country('Latvia', 'LV', '+371', '\u{1F1F1}\u{1F1FB}'),
  _Country('Lebanon', 'LB', '+961', '\u{1F1F1}\u{1F1E7}'),
  _Country('Lesotho', 'LS', '+266', '\u{1F1F1}\u{1F1F8}'),
  _Country('Liberia', 'LR', '+231', '\u{1F1F1}\u{1F1F7}'),
  _Country('Libya', 'LY', '+218', '\u{1F1F1}\u{1F1FE}'),
  _Country('Liechtenstein', 'LI', '+423', '\u{1F1F1}\u{1F1EE}'),
  _Country('Lithuania', 'LT', '+370', '\u{1F1F1}\u{1F1F9}'),
  _Country('Luxembourg', 'LU', '+352', '\u{1F1F1}\u{1F1FA}'),
  _Country('Macau', 'MO', '+853', '\u{1F1F2}\u{1F1F4}'),
  _Country('Madagascar', 'MG', '+261', '\u{1F1F2}\u{1F1EC}'),
  _Country('Malawi', 'MW', '+265', '\u{1F1F2}\u{1F1FC}'),
  _Country('Malaysia', 'MY', '+60', '\u{1F1F2}\u{1F1FE}'),
  _Country('Maldives', 'MV', '+960', '\u{1F1F2}\u{1F1FB}'),
  _Country('Mali', 'ML', '+223', '\u{1F1F2}\u{1F1F1}'),
  _Country('Malta', 'MT', '+356', '\u{1F1F2}\u{1F1F9}'),
  _Country('Marshall Islands', 'MH', '+692', '\u{1F1F2}\u{1F1ED}'),
  _Country('Mauritania', 'MR', '+222', '\u{1F1F2}\u{1F1F7}'),
  _Country('Mauritius', 'MU', '+230', '\u{1F1F2}\u{1F1FA}'),
  _Country('Mexico', 'MX', '+52', '\u{1F1F2}\u{1F1FD}'),
  _Country('Micronesia', 'FM', '+691', '\u{1F1EB}\u{1F1F2}'),
  _Country('Moldova', 'MD', '+373', '\u{1F1F2}\u{1F1E9}'),
  _Country('Monaco', 'MC', '+377', '\u{1F1F2}\u{1F1E8}'),
  _Country('Mongolia', 'MN', '+976', '\u{1F1F2}\u{1F1F3}'),
  _Country('Montenegro', 'ME', '+382', '\u{1F1F2}\u{1F1EA}'),
  _Country('Morocco', 'MA', '+212', '\u{1F1F2}\u{1F1E6}'),
  _Country('Mozambique', 'MZ', '+258', '\u{1F1F2}\u{1F1FF}'),
  _Country('Myanmar', 'MM', '+95', '\u{1F1F2}\u{1F1F2}'),
  _Country('Namibia', 'NA', '+264', '\u{1F1F3}\u{1F1E6}'),
  _Country('Nauru', 'NR', '+674', '\u{1F1F3}\u{1F1F7}'),
  _Country('Nepal', 'NP', '+977', '\u{1F1F3}\u{1F1F5}'),
  _Country('Netherlands', 'NL', '+31', '\u{1F1F3}\u{1F1F1}'),
  _Country('New Zealand', 'NZ', '+64', '\u{1F1F3}\u{1F1FF}'),
  _Country('Nicaragua', 'NI', '+505', '\u{1F1F3}\u{1F1EE}'),
  _Country('Niger', 'NE', '+227', '\u{1F1F3}\u{1F1EA}'),
  _Country('Nigeria', 'NG', '+234', '\u{1F1F3}\u{1F1EC}'),
  _Country('North Korea', 'KP', '+850', '\u{1F1F0}\u{1F1F5}'),
  _Country('North Macedonia', 'MK', '+389', '\u{1F1F2}\u{1F1F0}'),
  _Country('Norway', 'NO', '+47', '\u{1F1F3}\u{1F1F4}'),
  _Country('Oman', 'OM', '+968', '\u{1F1F4}\u{1F1F2}'),
  _Country('Pakistan', 'PK', '+92', '\u{1F1F5}\u{1F1F0}'),
  _Country('Palau', 'PW', '+680', '\u{1F1F5}\u{1F1FC}'),
  _Country('Palestine', 'PS', '+970', '\u{1F1F5}\u{1F1F8}'),
  _Country('Panama', 'PA', '+507', '\u{1F1F5}\u{1F1E6}'),
  _Country('Papua New Guinea', 'PG', '+675', '\u{1F1F5}\u{1F1EC}'),
  _Country('Paraguay', 'PY', '+595', '\u{1F1F5}\u{1F1FE}'),
  _Country('Peru', 'PE', '+51', '\u{1F1F5}\u{1F1EA}'),
  _Country('Philippines', 'PH', '+63', '\u{1F1F5}\u{1F1ED}'),
  _Country('Poland', 'PL', '+48', '\u{1F1F5}\u{1F1F1}'),
  _Country('Portugal', 'PT', '+351', '\u{1F1F5}\u{1F1F9}'),
  _Country('Qatar', 'QA', '+974', '\u{1F1F6}\u{1F1E6}'),
  _Country('Romania', 'RO', '+40', '\u{1F1F7}\u{1F1F4}'),
  _Country('Russia', 'RU', '+7', '\u{1F1F7}\u{1F1FA}'),
  _Country('Rwanda', 'RW', '+250', '\u{1F1F7}\u{1F1FC}'),
  _Country('Saint Kitts and Nevis', 'KN', '+1869', '\u{1F1F0}\u{1F1F3}'),
  _Country('Saint Lucia', 'LC', '+1758', '\u{1F1F1}\u{1F1E8}'),
  _Country('Saint Vincent', 'VC', '+1784', '\u{1F1FB}\u{1F1E8}'),
  _Country('Samoa', 'WS', '+685', '\u{1F1FC}\u{1F1F8}'),
  _Country('San Marino', 'SM', '+378', '\u{1F1F8}\u{1F1F2}'),
  _Country('S\u00e3o Tom\u00e9 and Pr\u00edncipe', 'ST', '+239', '\u{1F1F8}\u{1F1F9}'),
  _Country('Saudi Arabia', 'SA', '+966', '\u{1F1F8}\u{1F1E6}'),
  _Country('Senegal', 'SN', '+221', '\u{1F1F8}\u{1F1F3}'),
  _Country('Serbia', 'RS', '+381', '\u{1F1F7}\u{1F1F8}'),
  _Country('Seychelles', 'SC', '+248', '\u{1F1F8}\u{1F1E8}'),
  _Country('Sierra Leone', 'SL', '+232', '\u{1F1F8}\u{1F1F1}'),
  _Country('Singapore', 'SG', '+65', '\u{1F1F8}\u{1F1EC}'),
  _Country('Slovakia', 'SK', '+421', '\u{1F1F8}\u{1F1F0}'),
  _Country('Slovenia', 'SI', '+386', '\u{1F1F8}\u{1F1EE}'),
  _Country('Solomon Islands', 'SB', '+677', '\u{1F1F8}\u{1F1E7}'),
  _Country('Somalia', 'SO', '+252', '\u{1F1F8}\u{1F1F4}'),
  _Country('South Africa', 'ZA', '+27', '\u{1F1FF}\u{1F1E6}'),
  _Country('South Korea', 'KR', '+82', '\u{1F1F0}\u{1F1F7}'),
  _Country('South Sudan', 'SS', '+211', '\u{1F1F8}\u{1F1F8}'),
  _Country('Spain', 'ES', '+34', '\u{1F1EA}\u{1F1F8}'),
  _Country('Sri Lanka', 'LK', '+94', '\u{1F1F1}\u{1F1F0}'),
  _Country('Sudan', 'SD', '+249', '\u{1F1F8}\u{1F1E9}'),
  _Country('Suriname', 'SR', '+597', '\u{1F1F8}\u{1F1F7}'),
  _Country('Sweden', 'SE', '+46', '\u{1F1F8}\u{1F1EA}'),
  _Country('Switzerland', 'CH', '+41', '\u{1F1E8}\u{1F1ED}'),
  _Country('Syria', 'SY', '+963', '\u{1F1F8}\u{1F1FE}'),
  _Country('Taiwan', 'TW', '+886', '\u{1F1F9}\u{1F1FC}'),
  _Country('Tajikistan', 'TJ', '+992', '\u{1F1F9}\u{1F1EF}'),
  _Country('Tanzania', 'TZ', '+255', '\u{1F1F9}\u{1F1FF}'),
  _Country('Thailand', 'TH', '+66', '\u{1F1F9}\u{1F1ED}'),
  _Country('Timor-Leste', 'TL', '+670', '\u{1F1F9}\u{1F1F1}'),
  _Country('Togo', 'TG', '+228', '\u{1F1F9}\u{1F1EC}'),
  _Country('Tonga', 'TO', '+676', '\u{1F1F9}\u{1F1F4}'),
  _Country('Trinidad and Tobago', 'TT', '+1868', '\u{1F1F9}\u{1F1F9}'),
  _Country('Tunisia', 'TN', '+216', '\u{1F1F9}\u{1F1F3}'),
  _Country('Turkey', 'TR', '+90', '\u{1F1F9}\u{1F1F7}'),
  _Country('Turkmenistan', 'TM', '+993', '\u{1F1F9}\u{1F1F2}'),
  _Country('Tuvalu', 'TV', '+688', '\u{1F1F9}\u{1F1FB}'),
  _Country('Uganda', 'UG', '+256', '\u{1F1FA}\u{1F1EC}'),
  _Country('Ukraine', 'UA', '+380', '\u{1F1FA}\u{1F1E6}'),
  _Country('United Arab Emirates', 'AE', '+971', '\u{1F1E6}\u{1F1EA}'),
  _Country('United Kingdom', 'GB', '+44', '\u{1F1EC}\u{1F1E7}'),
  _Country('United States', 'US', '+1', '\u{1F1FA}\u{1F1F8}'),
  _Country('Uruguay', 'UY', '+598', '\u{1F1FA}\u{1F1FE}'),
  _Country('Uzbekistan', 'UZ', '+998', '\u{1F1FA}\u{1F1FF}'),
  _Country('Vanuatu', 'VU', '+678', '\u{1F1FB}\u{1F1FA}'),
  _Country('Vatican City', 'VA', '+379', '\u{1F1FB}\u{1F1E6}'),
  _Country('Venezuela', 'VE', '+58', '\u{1F1FB}\u{1F1EA}'),
  _Country('Vietnam', 'VN', '+84', '\u{1F1FB}\u{1F1F3}'),
  _Country('Yemen', 'YE', '+967', '\u{1F1FE}\u{1F1EA}'),
  _Country('Zambia', 'ZM', '+260', '\u{1F1FF}\u{1F1F2}'),
  _Country('Zimbabwe', 'ZW', '+263', '\u{1F1FF}\u{1F1FC}'),
];

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final _controller = TextEditingController();
  _Country _selectedCountry = _countries.firstWhere((c) => c.code == 'DE');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    if (_controller.text.length < 6) return;

    final fullNumber = '${_selectedCountry.dialCode}${_controller.text}';
    final authProvider = context.read<AuthProvider>();

    debugPrint('[PhoneScreen] Calling requestOtp for: $fullNumber');
    final success = await authProvider.requestOtp(fullNumber);
    debugPrint(
      '[PhoneScreen] requestOtp returned: $success, error: ${authProvider.error}',
    );

    if (mounted && success) {
      debugPrint('[PhoneScreen] Navigating to OTP screen');
      context.push(RouteConstants.otp, extra: fullNumber);
    } else if (mounted && authProvider.error != null) {
      debugPrint('[PhoneScreen] Showing error snackbar: ${authProvider.error}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.error!),
          backgroundColor: AppColors.error,
        ),
      );
      authProvider.clearError();
    } else {
      debugPrint('[PhoneScreen] No success and no error - unexpected state');
    }
  }

  void _showLanguagePicker() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final localeProvider = context.read<LocaleProvider>();
    final currentLocale = localeProvider.locale.languageCode;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.language,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Select Language',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
            ...LocaleProvider.supportedLocales.map((locale) {
              final isSelected = locale.languageCode == currentLocale;
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 4,
                ),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getLanguageFlag(locale.languageCode),
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                title: Text(
                  localeProvider.getLanguageName(locale.languageCode),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: textColor,
                  ),
                ),
                trailing: isSelected
                    ? Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        ),
                      )
                    : null,
                onTap: () {
                  localeProvider.setLocale(locale);
                  Navigator.pop(context);
                },
              );
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  String _getLanguageFlag(String code) {
    switch (code) {
      case 'en':
        return '🇬🇧';
      case 'de':
        return '🇩🇪';
      case 'fr':
        return '🇫🇷';
      case 'ar':
        return '🇸🇦';
      default:
        return '🌐';
    }
  }

  void _showCountryPicker() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final secondaryColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final surfaceColor = isDark
        ? AppColors.darkSurface
        : AppColors.lightSurface;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final searchController = TextEditingController();
        var filtered = List<_Country>.from(_countries);
        return StatefulBuilder(
          builder: (context, setModalState) => Container(
            height: MediaQuery.of(context).size.height * 0.85,
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.language,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        AppLocalizations.of(context)!.selectCountry,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: searchController,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.searchCountry,
                      hintStyle: TextStyle(
                        color: isDark
                            ? AppColors.darkTextHint
                            : AppColors.lightTextHint,
                      ),
                      prefixIcon: Icon(Icons.search, color: secondaryColor),
                      filled: true,
                      fillColor: surfaceColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onChanged: (query) {
                      setModalState(() {
                        final q = query.toLowerCase();
                        filtered = _countries
                            .where((c) =>
                                c.name.toLowerCase().contains(q) ||
                                c.dialCode.contains(q) ||
                                c.code.toLowerCase().contains(q))
                            .toList();
                      });
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final country = filtered[index];
                      final isSelected = country.code == _selectedCountry.code;
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 4,
                        ),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: surfaceColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            country.flag,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        title: Text(
                          country.name,
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              country.dialCode,
                              style: TextStyle(color: secondaryColor),
                            ),
                            if (isSelected) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                            ],
                          ],
                        ),
                        onTap: () {
                          setState(() => _selectedCountry = country);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Language picker button
              Align(
                alignment: Alignment.topRight,
                child: Consumer<LocaleProvider>(
                  builder: (context, localeProvider, _) {
                    return InkWell(
                      onTap: _showLanguagePicker,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _getLanguageFlag(localeProvider.locale.languageCode),
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              localeProvider.getLanguageName(localeProvider.locale.languageCode),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_drop_down,
                              color: secondaryColor,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const Spacer(),

              // Logo
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  'assets/icons/tybetogo.jpg',
                  width: 60,
                  height: 60,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.local_shipping,
                        color: AppColors.primary,
                        size: 32,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 32),

              // Title
              Text(
                l10n.enterPhoneNumber,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.info.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.verified_user,
                          size: 14,
                          color: AppColors.info,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          l10n.secure,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.info,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.wellSendVerificationCode,
                    style: TextStyle(fontSize: 14, color: secondaryColor),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Phone input with country code
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _controller.text.isNotEmpty
                        ? AppColors.primary
                        : borderColor,
                    width: _controller.text.isNotEmpty ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    // Country selector
                    GestureDetector(
                      onTap: _showCountryPicker,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkBg : AppColors.lightBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Text(
                              _selectedCountry.flag,
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _selectedCountry.dialCode,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: secondaryColor,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Phone number input
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        keyboardType: TextInputType.phone,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                        decoration: InputDecoration(
                          hintText: '123 456 7890',
                          hintStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: isDark
                                ? AppColors.darkTextHint
                                : AppColors.lightTextHint,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(15),
                        ],
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              // Continue button
              Consumer<AuthProvider>(
                builder: (context, authProvider, _) {
                  final isLoading = authProvider.isLoading;
                  return SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: _controller.text.length >= 6 && !isLoading
                          ? _continue
                          : null,
                      icon: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.arrow_forward, size: 20),
                      label: Text(
                        l10n.continueText,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: borderColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // New user link
              // Center(
              //   child: TextButton.icon(
              //     onPressed: () => context.push(RouteConstants.application),
              //     icon: const Icon(
              //       Icons.person_add_alt_1,
              //       size: 18,
              //       color: AppColors.primary,
              //     ),
              //     label: Text.rich(
              //       TextSpan(
              //         text: 'New driver? ',
              //         style: TextStyle(color: secondaryColor),
              //         children: const [
              //           TextSpan(
              //             text: 'Apply here',
              //             style: TextStyle(
              //               color: AppColors.primary,
              //               fontWeight: FontWeight.w600,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 8),

              // Terms
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      size: 14,
                      color: secondaryColor,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        l10n.byConsentTerms,
                        style: TextStyle(fontSize: 12, color: secondaryColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

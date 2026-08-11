import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';

class ChangelogScreen extends StatelessWidget {
  const ChangelogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final secondaryColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final surfaceColor = isDark
        ? AppColors.darkSurface
        : AppColors.lightSurface;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final l10n = AppLocalizations.of(context)!;
    final releases = _buildReleases(l10n);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        ),
        title: Text(l10n.changelog),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          children: [
            _buildHero(context, l10n),
            const SizedBox(height: 24),
            Row(
              children: [
                Icon(Icons.history_rounded, size: 20, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  l10n.changelogReleaseNotes,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...releases.map(
              (release) => _buildReleaseCard(
                context,
                release,
                l10n,
                textColor,
                secondaryColor,
                surfaceColor,
                borderColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context, AppLocalizations l10n) {
    final version = _buildReleases(l10n).first;

    return Container(
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF00A844)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -24,
            top: -28,
            child: Icon(
              Icons.auto_awesome,
              size: 150,
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                l10n.changelogTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.changelogSubtitle,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.88),
                  fontSize: 14,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildHeroMeta(Icons.verified_rounded, l10n.changelogCurrent),
                  _buildHeroMeta(
                    Icons.tag_rounded,
                    l10n.version(version.version),
                  ),
                  _buildHeroMeta(Icons.calendar_today_rounded, version.date),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroMeta(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReleaseCard(
    BuildContext context,
    _ChangelogRelease release,
    AppLocalizations l10n,
    Color textColor,
    Color secondaryColor,
    Color surfaceColor,
    Color borderColor,
  ) {
    final accentColor = release.isCurrent ? AppColors.primary : AppColors.info;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: release.isCurrent
              ? accentColor.withValues(alpha: 0.45)
              : borderColor,
          width: release.isCurrent ? 1.4 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark(context) ? 0.18 : 0.04,
            ),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: release.isCurrent,
          tilePadding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          leading: Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              '+${release.build}',
              style: TextStyle(
                color: accentColor,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  l10n.version(release.version),
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (release.isCurrent)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    l10n.changelogCurrent,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Wrap(
              spacing: 10,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 13,
                      color: secondaryColor,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${l10n.changelogReleased} ${release.date}',
                      style: TextStyle(fontSize: 12, color: secondaryColor),
                    ),
                  ],
                ),
                Text(
                  '${l10n.changelogBuild} ${release.build}',
                  style: TextStyle(fontSize: 12, color: secondaryColor),
                ),
              ],
            ),
          ),
          children: [
            Divider(height: 1, color: borderColor),
            const SizedBox(height: 16),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                l10n.changelogHighlights,
                style: TextStyle(
                  color: textColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 4),
            ...release.sections.map(
              (section) => _buildSection(
                section,
                textColor,
                secondaryColor,
                accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    _ChangelogSection section,
    Color textColor,
    Color secondaryColor,
    Color accentColor,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(section.icon, size: 16, color: accentColor),
              ),
              const SizedBox(width: 8),
              Text(
                section.title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...section.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 7),
                    child: Icon(Icons.circle, size: 5, color: accentColor),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  List<_ChangelogRelease> _buildReleases(AppLocalizations l10n) => [
    _ChangelogRelease(
      version: '1.0.13+15',
      build: '15',
      date: l10n.changelogDateAug11,
      isCurrent: true,
      sections: [
        _ChangelogSection(
          title: l10n.changelogImprovements,
          icon: Icons.location_on_outlined,
          items: [l10n.changelogVersion1013Address],
        ),
        _ChangelogSection(
          title: l10n.changelogStability,
          icon: Icons.verified_user_outlined,
          items: [l10n.changelogVersion1013Status],
        ),
        _ChangelogSection(
          title: l10n.changelogRelease,
          icon: Icons.rocket_launch_outlined,
          items: [l10n.changelogVersion1013Release],
        ),
      ],
    ),
    _ChangelogRelease(
      version: '1.0.12+14',
      build: '14',
      date: l10n.changelogDateAug9,
      sections: [
        _ChangelogSection(
          title: l10n.changelogFixes,
          icon: Icons.build_circle_outlined,
          items: [l10n.changelogCurrentTaxi],
        ),
        _ChangelogSection(
          title: l10n.changelogImprovements,
          icon: Icons.auto_awesome_outlined,
          items: [l10n.changelogCurrentChangelog],
        ),
        _ChangelogSection(
          title: l10n.changelogRelease,
          icon: Icons.rocket_launch_outlined,
          items: [l10n.changelogCurrentRelease],
        ),
      ],
    ),
    _ChangelogRelease(
      version: '1.0.11+13',
      build: '13',
      date: l10n.changelogDateMay31,
      sections: [
        _ChangelogSection(
          title: l10n.changelogFixes,
          icon: Icons.build_circle_outlined,
          items: [l10n.changelogVersion1113Upload],
        ),
        _ChangelogSection(
          title: l10n.changelogImprovements,
          icon: Icons.auto_awesome_outlined,
          items: [l10n.changelogVersion1113Version],
        ),
        _ChangelogSection(
          title: l10n.changelogRelease,
          icon: Icons.rocket_launch_outlined,
          items: [l10n.changelogVersion1113Release],
        ),
      ],
    ),
    _ChangelogRelease(
      version: '1.0.11+12',
      build: '12',
      date: l10n.changelogDateMay24,
      sections: [
        _ChangelogSection(
          title: l10n.changelogRelease,
          icon: Icons.rocket_launch_outlined,
          items: [l10n.changelogVersion1112Release],
        ),
      ],
    ),
    _ChangelogRelease(
      version: '1.0.10+11',
      build: '11',
      date: l10n.changelogDateMay13,
      sections: [
        _ChangelogSection(
          title: l10n.profile,
          icon: Icons.person_outline,
          items: [l10n.changelogVersion1011Documents],
        ),
        _ChangelogSection(
          title: l10n.changelogImprovements,
          icon: Icons.auto_awesome_outlined,
          items: [
            l10n.changelogVersion1011Uploads,
            l10n.changelogVersion1011Feedback,
          ],
        ),
        _ChangelogSection(
          title: l10n.changelogRelease,
          icon: Icons.rocket_launch_outlined,
          items: [l10n.changelogVersion1011Release],
        ),
      ],
    ),
    _ChangelogRelease(
      version: '1.0.9+10',
      build: '10',
      date: l10n.changelogDateMay11,
      sections: [
        _ChangelogSection(
          title: l10n.changelogStability,
          icon: Icons.shield_outlined,
          items: [l10n.changelogVersion0910Crashlytics],
        ),
        _ChangelogSection(
          title: l10n.notifications,
          icon: Icons.notifications_none_outlined,
          items: [l10n.changelogVersion0910Notifications],
        ),
        _ChangelogSection(
          title: l10n.changelogPlatform,
          icon: Icons.devices_other_outlined,
          items: [l10n.changelogVersion0910Platform],
        ),
        _ChangelogSection(
          title: l10n.changelogRelease,
          icon: Icons.rocket_launch_outlined,
          items: [l10n.changelogVersion0910Release],
        ),
      ],
    ),
  ];
}

class _ChangelogRelease {
  const _ChangelogRelease({
    required this.version,
    required this.build,
    required this.date,
    required this.sections,
    this.isCurrent = false,
  });

  final String version;
  final String build;
  final String date;
  final bool isCurrent;
  final List<_ChangelogSection> sections;
}

class _ChangelogSection {
  const _ChangelogSection({
    required this.title,
    required this.icon,
    required this.items,
  });

  final String title;
  final IconData icon;
  final List<String> items;
}

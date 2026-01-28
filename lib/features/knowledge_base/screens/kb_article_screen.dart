import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/kb_models.dart';
import '../services/kb_service.dart';

class KBArticleScreen extends StatefulWidget {
  final String categoryId;
  final String articleId;
  final KBArticle? article;

  const KBArticleScreen({
    super.key,
    required this.categoryId,
    required this.articleId,
    this.article,
  });

  @override
  State<KBArticleScreen> createState() => _KBArticleScreenState();
}

class _KBArticleScreenState extends State<KBArticleScreen> {
  final KBService _kbService = KBService();
  final ScrollController _scrollController = ScrollController();
  KBArticle? _article;
  KnowledgeBase? _knowledgeBase;
  bool _isLoading = true;
  bool _wasHelpful = false;
  bool _feedbackGiven = false;
  double _readingProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadArticle();
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (mounted) {
        setState(() {
          _readingProgress =
              maxScroll > 0 ? (currentScroll / maxScroll).clamp(0.0, 1.0) : 0.0;
        });
      }
    }
  }

  Future<void> _loadArticle() async {
    setState(() => _isLoading = true);

    if (widget.article != null) {
      setState(() {
        _article = widget.article;
        _isLoading = false;
      });
      _loadKnowledgeBase();
      return;
    }

    final locale = context.read<LocaleProvider>().locale.languageCode;
    final kb = await _kbService.loadKnowledgeBase(locale);

    if (mounted) {
      final article = kb.findArticle(widget.articleId);
      setState(() {
        _knowledgeBase = kb;
        _article = article;
        _isLoading = false;
      });
    }
  }

  Future<void> _loadKnowledgeBase() async {
    final locale = context.read<LocaleProvider>().locale.languageCode;
    final kb = await _kbService.loadKnowledgeBase(locale);

    if (mounted) {
      setState(() {
        _knowledgeBase = kb;
      });
    }
  }

  void _handleFeedback(bool helpful) {
    setState(() {
      _wasHelpful = helpful;
      _feedbackGiven = true;
    });

    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          helpful ? l10n.thankYouFeedback : l10n.willImproveArticle,
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  int _estimateReadTime() {
    if (_article == null) return 1;
    int wordCount = 0;
    for (final section in _article!.sections) {
      if (section.content != null) {
        wordCount += section.content!.split(' ').length;
      }
      if (section.items != null) {
        for (final item in section.items!) {
          wordCount += item.split(' ').length;
        }
      }
    }
    return (wordCount / 200).ceil().clamp(1, 30);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final secondaryColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final surfaceColor =
        isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.knowledgeBase),
        backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: LinearProgressIndicator(
            value: _readingProgress,
            backgroundColor: borderColor,
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 2,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _article == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline,
                          size: 64, color: secondaryColor),
                      const SizedBox(height: 16),
                      Text(
                        l10n.articleNotFound,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Article header ──
                      _buildArticleHeader(
                          textColor, secondaryColor, borderColor, l10n),

                      // ── Article sections ──
                      ..._article!.sections.asMap().entries.map((entry) {
                        final index = entry.key;
                        final section = entry.value;
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index < _article!.sections.length - 1
                                ? 24
                                : 0,
                          ),
                          child: _buildSection(
                            section,
                            textColor,
                            secondaryColor,
                            surfaceColor,
                            borderColor,
                            l10n,
                          ),
                        );
                      }),

                      const SizedBox(height: 32),

                      // ── Feedback section ──
                      _buildFeedbackSection(
                        textColor,
                        secondaryColor,
                        surfaceColor,
                        borderColor,
                        l10n,
                      ),

                      // ── Related articles ──
                      if (_article!.relatedIds.isNotEmpty &&
                          _knowledgeBase != null) ...[
                        const SizedBox(height: 32),
                        _buildRelatedArticles(
                          textColor,
                          secondaryColor,
                          surfaceColor,
                          borderColor,
                          l10n,
                        ),
                      ],

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
    );
  }

  // ── Article Header ──

  Widget _buildArticleHeader(
    Color textColor,
    Color secondaryColor,
    Color borderColor,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          _article!.title,
          style: AppTextStyles.h2.copyWith(color: textColor),
        ),
        const SizedBox(height: 12),
        // Meta badges
        Row(
          children: [
            _buildMetaBadge(
              Icons.menu_book_outlined,
              l10n.sectionsCount(_article!.sections.length),
              AppColors.primary,
            ),
            const SizedBox(width: 8),
            _buildMetaBadge(
              Icons.schedule,
              l10n.minRead(_estimateReadTime()),
              AppColors.info,
            ),
          ],
        ),
        if (_article!.description != null) ...[
          const SizedBox(height: 16),
          Text(
            _article!.description!,
            style: TextStyle(
              fontSize: 15,
              color: secondaryColor,
              height: 1.6,
            ),
          ),
        ],
        const SizedBox(height: 20),
        Divider(color: borderColor),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildMetaBadge(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ── Section Dispatcher ──

  Widget _buildSection(
    KBSection section,
    Color textColor,
    Color secondaryColor,
    Color surfaceColor,
    Color borderColor,
    AppLocalizations l10n,
  ) {
    switch (section.type) {
      case KBSectionType.text:
        return _buildTextSection(section, textColor);
      case KBSectionType.steps:
        return _buildStepsSection(
            section, textColor, secondaryColor, surfaceColor);
      case KBSectionType.tip:
        return _buildInfoBox(
          section,
          textColor,
          AppColors.success,
          Icons.lightbulb_outline,
          l10n.kbTip,
        );
      case KBSectionType.warning:
        return _buildInfoBox(
          section,
          textColor,
          AppColors.error,
          Icons.warning_amber_rounded,
          l10n.kbWarning,
        );
      case KBSectionType.screenshot:
        return _buildScreenshotSection(section, borderColor);
    }
  }

  // ── Text Section ──

  Widget _buildTextSection(KBSection section, Color textColor) {
    return Text(
      section.content ?? '',
      style: AppTextStyles.body.copyWith(color: textColor),
    );
  }

  // ── Steps Section (stepper with connecting line) ──

  Widget _buildStepsSection(
    KBSection section,
    Color textColor,
    Color secondaryColor,
    Color surfaceColor,
  ) {
    if (section.items == null || section.items!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: section.items!.asMap().entries.map((entry) {
          final index = entry.key;
          final step = entry.value;
          final isLast = index == section.items!.length - 1;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step indicator column with connecting line
              SizedBox(
                width: 32,
                child: Column(
                  children: [
                    // Number badge (rounded square)
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    // Connecting line
                    if (!isLast)
                      Container(
                        width: 2,
                        height: 24,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color:
                              AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Step text
              Expanded(
                child: Padding(
                  padding:
                      EdgeInsets.only(top: 6, bottom: isLast ? 0 : 12),
                  child: Text(
                    step,
                    style: TextStyle(
                      fontSize: 15,
                      color: textColor,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  // ── Tip / Warning Info Box (with left accent bar) ──

  Widget _buildInfoBox(
    KBSection section,
    Color textColor,
    Color accentColor,
    IconData icon,
    String label,
  ) {
    return IntrinsicHeight(
      child: Container(
        decoration: BoxDecoration(
          color: accentColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: accentColor.withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          children: [
            // Left accent bar
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                ),
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, color: accentColor, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: accentColor,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            section.content ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              color: textColor,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Screenshot Section ──

  Widget _buildScreenshotSection(KBSection section, Color borderColor) {
    if (section.imageUrl == null) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.asset(
          section.imageUrl!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              padding: const EdgeInsets.all(32),
              child: const Center(
                child: Icon(Icons.broken_image, size: 48),
              ),
            );
          },
        ),
      ),
    );
  }

  // ── Feedback Section ──

  Widget _buildFeedbackSection(
    Color textColor,
    Color secondaryColor,
    Color surfaceColor,
    Color borderColor,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.rate_review_outlined,
                color: AppColors.primary, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.wasArticleHelpful,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 16),
          if (_feedbackGiven) ...[
            Container(
              padding: const EdgeInsets.symmetric(
                  vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _wasHelpful
                        ? Icons.check_circle
                        : Icons.info_outline,
                    color: AppColors.success,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.thankYouFeedback,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _handleFeedback(false),
                    icon:
                        const Icon(Icons.thumb_down_outlined, size: 18),
                    label: Text(l10n.no),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: secondaryColor,
                      side: BorderSide(color: borderColor),
                      padding:
                          const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _handleFeedback(true),
                    icon:
                        const Icon(Icons.thumb_up_outlined, size: 18),
                    label: Text(l10n.yes),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding:
                          const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ── Related Articles ──

  Widget _buildRelatedArticles(
    Color textColor,
    Color secondaryColor,
    Color surfaceColor,
    Color borderColor,
    AppLocalizations l10n,
  ) {
    final relatedArticles = _article!.relatedIds
        .map((id) => _knowledgeBase!.findArticle(id))
        .where((article) => article != null)
        .cast<KBArticle>()
        .toList();

    if (relatedArticles.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            Icon(Icons.link, size: 16, color: secondaryColor),
            const SizedBox(width: 6),
            Text(
              l10n.relatedArticles,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: secondaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Grouped container
        Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: relatedArticles.asMap().entries.map((entry) {
              final isLast =
                  entry.key == relatedArticles.length - 1;
              final article = entry.value;

              // Find category for this article
              String categoryId = '';
              for (final category in _knowledgeBase!.categories) {
                if (category.articles
                    .any((a) => a.id == article.id)) {
                  categoryId = category.id;
                  break;
                }
              }

              return Column(
                children: [
                  ListTile(
                    onTap: () {
                      context.push(
                        RouteConstants.kbArticlePath(
                            categoryId, article.id),
                        extra: article,
                      );
                    },
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 4),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                          Icons.article_outlined,
                          size: 20,
                          color: AppColors.primary),
                    ),
                    title: Text(
                      article.title,
                      style: TextStyle(
                          fontSize: 15, color: textColor),
                    ),
                    trailing: Icon(Icons.chevron_right,
                        size: 20, color: secondaryColor),
                  ),
                  if (!isLast)
                    Divider(
                        height: 1,
                        indent: 56,
                        color: borderColor),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

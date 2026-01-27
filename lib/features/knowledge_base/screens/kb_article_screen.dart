import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/theme/app_colors.dart';
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
  KBArticle? _article;
  KnowledgeBase? _knowledgeBase;
  bool _isLoading = true;
  bool _wasHelpful = false;
  bool _feedbackGiven = false;

  @override
  void initState() {
    super.initState();
    _loadArticle();
  }

  Future<void> _loadArticle() async {
    setState(() => _isLoading = true);

    // Use article from constructor if provided
    if (widget.article != null) {
      setState(() {
        _article = widget.article;
        _isLoading = false;
      });
      // Still load KB for related articles
      _loadKnowledgeBase();
      return;
    }

    // Otherwise load from service
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

    // Show thank you message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          helpful
              ? 'Thank you for your feedback!'
              : 'We\'ll work on improving this article.',
        ),
        duration: const Duration(seconds: 2),
      ),
    );

    // TODO: Send feedback to analytics/backend
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final secondaryColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Scaffold(
      appBar: AppBar(
        title: Text(_article?.title ?? 'Article'),
        backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _article == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: secondaryColor),
                      const SizedBox(height: 16),
                      Text(
                        'Article not found',
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
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Article header
                      if (_article!.description != null) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: AppColors.primary,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _article!.description!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: textColor,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Article sections
                      ..._article!.sections.asMap().entries.map((entry) {
                        final index = entry.key;
                        final section = entry.value;
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index < _article!.sections.length - 1 ? 24 : 0,
                          ),
                          child: _buildSection(
                            section,
                            textColor,
                            secondaryColor,
                            surfaceColor,
                            borderColor,
                          ),
                        );
                      }),

                      const SizedBox(height: 32),

                      // Feedback section
                      _buildFeedbackSection(
                        textColor,
                        secondaryColor,
                        surfaceColor,
                        borderColor,
                      ),

                      // Related articles
                      if (_article!.relatedIds.isNotEmpty &&
                          _knowledgeBase != null) ...[
                        const SizedBox(height: 32),
                        _buildRelatedArticles(
                          textColor,
                          secondaryColor,
                          surfaceColor,
                          borderColor,
                        ),
                      ],
                    ],
                  ),
                ),
    );
  }

  Widget _buildSection(
    KBSection section,
    Color textColor,
    Color secondaryColor,
    Color surfaceColor,
    Color borderColor,
  ) {
    switch (section.type) {
      case KBSectionType.text:
        return _buildTextSection(section, textColor);
      case KBSectionType.steps:
        return _buildStepsSection(section, textColor, secondaryColor);
      case KBSectionType.tip:
        return _buildInfoBox(
          section,
          textColor,
          AppColors.success,
          Icons.lightbulb_outline,
          'Tip',
        );
      case KBSectionType.warning:
        return _buildInfoBox(
          section,
          textColor,
          AppColors.error,
          Icons.warning_amber_rounded,
          'Warning',
        );
      case KBSectionType.screenshot:
        return _buildScreenshotSection(section, borderColor);
    }
  }

  Widget _buildTextSection(KBSection section, Color textColor) {
    return Text(
      section.content ?? '',
      style: TextStyle(
        fontSize: 15,
        color: textColor,
        height: 1.6,
      ),
    );
  }

  Widget _buildStepsSection(
    KBSection section,
    Color textColor,
    Color secondaryColor,
  ) {
    if (section.items == null || section.items!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: section.items!.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        return Padding(
          padding: EdgeInsets.only(
            bottom: index < section.items!.length - 1 ? 16 : 0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
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
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInfoBox(
    KBSection section,
    Color textColor,
    Color accentColor,
    IconData icon,
    String label,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accentColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: accentColor,
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
    );
  }

  Widget _buildScreenshotSection(KBSection section, Color borderColor) {
    if (section.imageUrl == null) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
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

  Widget _buildFeedbackSection(
    Color textColor,
    Color secondaryColor,
    Color surfaceColor,
    Color borderColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Text(
            'Was this article helpful?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 16),
          if (_feedbackGiven) ...[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _wasHelpful ? Icons.check_circle : Icons.info_outline,
                    color: AppColors.success,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Thank you for your feedback!',
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
                    icon: const Icon(Icons.thumb_down_outlined, size: 18),
                    label: const Text('No'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: secondaryColor,
                      side: BorderSide(color: borderColor),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _handleFeedback(true),
                    icon: const Icon(Icons.thumb_up_outlined, size: 18),
                    label: const Text('Yes'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
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

  Widget _buildRelatedArticles(
    Color textColor,
    Color secondaryColor,
    Color surfaceColor,
    Color borderColor,
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
        Text(
          'Related Articles',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 16),
        ...relatedArticles.map((article) {
          // Find category for this article
          String categoryId = '';
          for (final category in _knowledgeBase!.categories) {
            if (category.articles.any((a) => a.id == article.id)) {
              categoryId = category.id;
              break;
            }
          }

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: InkWell(
              onTap: () {
                context.push(
                  RouteConstants.kbArticlePath(categoryId, article.id),
                  extra: article,
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            article.title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                          if (article.description != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              article.description!,
                              style: TextStyle(
                                fontSize: 13,
                                color: secondaryColor,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16, color: secondaryColor),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

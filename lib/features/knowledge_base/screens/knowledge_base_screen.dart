import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/providers/tour_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../models/kb_models.dart';
import '../services/kb_service.dart';

class KnowledgeBaseScreen extends StatefulWidget {
  const KnowledgeBaseScreen({super.key});

  @override
  State<KnowledgeBaseScreen> createState() => _KnowledgeBaseScreenState();
}

class _KnowledgeBaseScreenState extends State<KnowledgeBaseScreen> {
  final KBService _kbService = KBService();
  final TextEditingController _searchController = TextEditingController();
  KnowledgeBase? _knowledgeBase;
  List<KBArticle> _searchResults = [];
  bool _isLoading = true;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadKnowledgeBase();
  }

  Future<void> _loadKnowledgeBase() async {
    setState(() => _isLoading = true);

    final locale = context.read<LocaleProvider>().locale.languageCode;
    final kb = await _kbService.loadKnowledgeBase(locale);

    if (mounted) {
      setState(() {
        _knowledgeBase = kb;
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _searchResults = _knowledgeBase?.search(query) ?? [];
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
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
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: l10n.searchForHelp,
                      hintStyle: TextStyle(color: secondaryColor),
                      prefixIcon:
                          Icon(Icons.search, color: secondaryColor),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon:
                                  Icon(Icons.clear, color: secondaryColor),
                              onPressed: () {
                                _searchController.clear();
                                _onSearchChanged('');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: surfaceColor,
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
                        borderSide: const BorderSide(
                            color: AppColors.primary, width: 2),
                      ),
                    ),
                  ),
                ),

                // Content
                Expanded(
                  child: _isSearching
                      ? _buildSearchResults(
                          textColor, secondaryColor, surfaceColor,
                          borderColor, l10n)
                      : _buildMainContent(
                          textColor, secondaryColor, surfaceColor,
                          borderColor, l10n),
                ),
              ],
            ),
    );
  }

  // ── Main content: category grid + articles by category ──

  Widget _buildMainContent(
    Color textColor,
    Color secondaryColor,
    Color surfaceColor,
    Color borderColor,
    AppLocalizations l10n,
  ) {
    if (_knowledgeBase == null || _knowledgeBase!.categories.isEmpty) {
      return Center(
        child: Text(
          l10n.noCategoriesAvailable,
          style: TextStyle(color: secondaryColor),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        const SizedBox(height: 4),
        // Start Tour button (always visible)
        _buildStartTourCard(secondaryColor, surfaceColor, borderColor, l10n),
        const SizedBox(height: 16),
        // Category grid
        _buildCategoryGrid(
            textColor, secondaryColor, surfaceColor, borderColor, l10n),
        const SizedBox(height: 28),
        // Articles grouped by category
        _buildArticlesByCategory(
            textColor, secondaryColor, surfaceColor, borderColor, l10n),
        const SizedBox(height: 20),
      ],
    );
  }

  // ── Start Tour Card (always visible) ──

  Widget _buildStartTourCard(
    Color secondaryColor,
    Color surfaceColor,
    Color borderColor,
    AppLocalizations l10n,
  ) {
    final tourProvider = Provider.of<TourProvider>(context, listen: false);
    final textColor = Theme.of(context).brightness == Brightness.dark
        ? AppColors.darkText
        : AppColors.lightText;
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.tourWelcomeTitle,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.tourWelcomeDesc,
            style: TextStyle(fontSize: 12, color: secondaryColor),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: ElevatedButton(
              onPressed: () async {
                context.go(RouteConstants.home);
                await Future.delayed(const Duration(milliseconds: 350));
                await tourProvider.startTour();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.play_arrow, size: 18),
                  const SizedBox(width: 6),
                  Text(l10n.tourStartBtn),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Category Grid (2-column) ──

  Widget _buildCategoryGrid(
    Color textColor,
    Color secondaryColor,
    Color surfaceColor,
    Color borderColor,
    AppLocalizations l10n,
  ) {
    final categories = _knowledgeBase!.categories;

    // Build rows of 2 manually to avoid nested scrollable rendering issues
    final List<Widget> rows = [];
    for (int i = 0; i < categories.length; i += 2) {
      final first = categories[i];
      final second = i + 1 < categories.length ? categories[i + 1] : null;

      rows.add(
        Padding(
          padding: EdgeInsets.only(bottom: i + 2 < categories.length ? 12 : 0),
          child: Row(
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1.3,
                  child: _buildCategoryGridCard(
                      first, textColor, secondaryColor, surfaceColor, l10n),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: second != null
                    ? AspectRatio(
                        aspectRatio: 1.3,
                        child: _buildCategoryGridCard(
                            second, textColor, secondaryColor, surfaceColor, l10n),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      );
    }

    return Column(children: rows);
  }

  Widget _buildCategoryGridCard(
    KBCategory category,
    Color textColor,
    Color secondaryColor,
    Color surfaceColor,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: category.color.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: category.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getIconData(category.icon),
              color: category.color,
              size: 22,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            category.title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            l10n.articlesCount(category.articles.length),
            style: TextStyle(fontSize: 12, color: secondaryColor),
          ),
        ],
      ),
    );
  }

  // ── Articles grouped by category ──

  Widget _buildArticlesByCategory(
    Color textColor,
    Color secondaryColor,
    Color surfaceColor,
    Color borderColor,
    AppLocalizations l10n,
  ) {
    final categories = _knowledgeBase!.categories;

    return Column(
      children: categories.map((category) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Icon(
                    _getIconData(category.icon),
                    size: 16,
                    color: category.color,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    category.title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: secondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            // Grouped container
            Container(
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children:
                    category.articles.asMap().entries.map((entry) {
                  final isLast =
                      entry.key == category.articles.length - 1;
                  final article = entry.value;
                  return Column(
                    children: [
                      ListTile(
                        onTap: () => context.push(
                          RouteConstants.kbArticlePath(
                              category.id, article.id),
                          extra: article,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: category.color
                                .withValues(alpha: 0.1),
                            borderRadius:
                                BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.article_outlined,
                              size: 20, color: category.color),
                        ),
                        title: Text(
                          article.title,
                          style: TextStyle(
                              fontSize: 15, color: textColor),
                        ),
                        subtitle: article.description != null
                            ? Text(
                                article.description!,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: secondaryColor),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                            : null,
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
            const SizedBox(height: 24),
          ],
        );
      }).toList(),
    );
  }

  // ── Search Results ──

  Widget _buildSearchResults(
    Color textColor,
    Color secondaryColor,
    Color surfaceColor,
    Color borderColor,
    AppLocalizations l10n,
  ) {
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: secondaryColor),
            const SizedBox(height: 16),
            Text(
              l10n.noArticlesFound,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.tryDifferentSearch,
              style:
                  TextStyle(fontSize: 14, color: secondaryColor),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children:
                _searchResults.asMap().entries.map((entry) {
              final isLast =
                  entry.key == _searchResults.length - 1;
              final article = entry.value;

              // Find category for this article
              String categoryId = '';
              Color categoryColor = AppColors.primary;
              for (final category
                  in _knowledgeBase!.categories) {
                if (category.articles
                    .any((a) => a.id == article.id)) {
                  categoryId = category.id;
                  categoryColor = category.color;
                  break;
                }
              }

              return Column(
                children: [
                  ListTile(
                    onTap: () => context.push(
                      RouteConstants.kbArticlePath(
                          categoryId, article.id),
                      extra: article,
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: categoryColor
                            .withValues(alpha: 0.1),
                        borderRadius:
                            BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.article_outlined,
                          size: 20, color: categoryColor),
                    ),
                    title: Text(
                      article.title,
                      style: TextStyle(
                          fontSize: 15, color: textColor),
                    ),
                    subtitle: article.description != null
                        ? Text(
                            article.description!,
                            style: TextStyle(
                                fontSize: 12,
                                color: secondaryColor),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        : null,
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

  // ── Helpers ──

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'school':
        return Icons.school;
      case 'local_shipping':
        return Icons.local_shipping;
      case 'attach_money':
        return Icons.attach_money;
      case 'build':
        return Icons.build;
      case 'help_outline':
        return Icons.help_outline;
      default:
        return Icons.help_outline;
    }
  }
}

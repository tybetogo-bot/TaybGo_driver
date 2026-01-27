import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/providers/locale_provider.dart';
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
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Knowledge Base'),
        backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Search for help...',
                      hintStyle: TextStyle(color: secondaryColor),
                      prefixIcon: Icon(Icons.search, color: secondaryColor),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear, color: secondaryColor),
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
                        borderSide:
                            const BorderSide(color: AppColors.primary, width: 2),
                      ),
                    ),
                  ),
                ),

                // Content
                Expanded(
                  child: _isSearching
                      ? _buildSearchResults(textColor, secondaryColor, surfaceColor)
                      : _buildCategories(textColor, secondaryColor, surfaceColor),
                ),
              ],
            ),
    );
  }

  Widget _buildSearchResults(
      Color textColor, Color secondaryColor, Color surfaceColor) {
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: secondaryColor),
            const SizedBox(height: 16),
            Text(
              'No articles found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try a different search term',
              style: TextStyle(fontSize: 14, color: secondaryColor),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final article = _searchResults[index];
        // Find category for this article
        String categoryId = '';
        for (final category in _knowledgeBase!.categories) {
          if (category.articles.any((a) => a.id == article.id)) {
            categoryId = category.id;
            break;
          }
        }

        return _buildArticleCard(
          article,
          categoryId,
          textColor,
          secondaryColor,
          surfaceColor,
        );
      },
    );
  }

  Widget _buildCategories(
      Color textColor, Color secondaryColor, Color surfaceColor) {
    if (_knowledgeBase == null || _knowledgeBase!.categories.isEmpty) {
      return Center(
        child: Text(
          'No categories available',
          style: TextStyle(color: secondaryColor),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _knowledgeBase!.categories.length,
      itemBuilder: (context, index) {
        final category = _knowledgeBase!.categories[index];
        return _buildCategoryCard(category, textColor, secondaryColor, surfaceColor);
      },
    );
  }

  Widget _buildCategoryCard(
      KBCategory category, Color textColor, Color secondaryColor, Color surfaceColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: category.color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: category.color.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: category.color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _getIconData(category.icon),
                    color: category.color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      if (category.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          category.description,
                          style: TextStyle(fontSize: 12, color: secondaryColor),
                        ),
                      ],
                    ],
                  ),
                ),
                Text(
                  '${category.articles.length} articles',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: category.color,
                  ),
                ),
              ],
            ),
          ),

          // Articles list
          ...category.articles.map((article) => _buildArticleListItem(
                article,
                category.id,
                textColor,
                secondaryColor,
              )),
        ],
      ),
    );
  }

  Widget _buildArticleListItem(
      KBArticle article, String categoryId, Color textColor, Color secondaryColor) {
    return InkWell(
      onTap: () => context.push(
        RouteConstants.kbArticlePath(categoryId, article.id),
        extra: article,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: secondaryColor.withValues(alpha: 0.1),
            ),
          ),
        ),
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
            Icon(Icons.chevron_right, color: secondaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleCard(
    KBArticle article,
    String categoryId,
    Color textColor,
    Color secondaryColor,
    Color surfaceColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: secondaryColor.withValues(alpha: 0.2)),
      ),
      child: InkWell(
        onTap: () => context.push(
          RouteConstants.kbArticlePath(categoryId, article.id),
          extra: article,
        ),
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
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    if (article.description != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        article.description!,
                        style: TextStyle(fontSize: 13, color: secondaryColor),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: secondaryColor),
            ],
          ),
        ),
      ),
    );
  }

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

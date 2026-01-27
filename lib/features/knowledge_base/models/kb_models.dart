import 'package:flutter/material.dart';

/// Type of content section in a knowledge base article
enum KBSectionType {
  text,
  steps,
  tip,
  warning,
  screenshot,
}

/// A section within a knowledge base article
class KBSection {
  final KBSectionType type;
  final String? content;
  final List<String>? items;
  final String? imageUrl;

  KBSection({
    required this.type,
    this.content,
    this.items,
    this.imageUrl,
  });

  factory KBSection.fromJson(Map<String, dynamic> json) {
    return KBSection(
      type: KBSectionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => KBSectionType.text,
      ),
      content: json['content'] as String?,
      items: json['items'] != null
          ? List<String>.from(json['items'] as List)
          : null,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      if (content != null) 'content': content,
      if (items != null) 'items': items,
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }
}

/// A knowledge base article
class KBArticle {
  final String id;
  final String title;
  final String? description;
  final List<KBSection> sections;
  final List<String> relatedIds;
  final List<String> tags;

  KBArticle({
    required this.id,
    required this.title,
    this.description,
    required this.sections,
    this.relatedIds = const [],
    this.tags = const [],
  });

  factory KBArticle.fromJson(Map<String, dynamic> json) {
    return KBArticle(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      sections: (json['sections'] as List)
          .map((s) => KBSection.fromJson(s as Map<String, dynamic>))
          .toList(),
      relatedIds: json['relatedIds'] != null
          ? List<String>.from(json['relatedIds'] as List)
          : [],
      tags: json['tags'] != null ? List<String>.from(json['tags'] as List) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      if (description != null) 'description': description,
      'sections': sections.map((s) => s.toJson()).toList(),
      'relatedIds': relatedIds,
      'tags': tags,
    };
  }
}

/// A category containing multiple articles
class KBCategory {
  final String id;
  final String title;
  final String description;
  final String icon;
  final Color color;
  final List<KBArticle> articles;

  KBCategory({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.articles,
  });

  factory KBCategory.fromJson(Map<String, dynamic> json) {
    return KBCategory(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      icon: json['icon'] as String? ?? 'help_outline',
      color: _parseColor(json['color'] as String?),
      articles: (json['articles'] as List)
          .map((a) => KBArticle.fromJson(a as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'color': '#${color.toARGB32().toRadixString(16).padLeft(8, '0')}',
      'articles': articles.map((a) => a.toJson()).toList(),
    };
  }

  static Color _parseColor(String? colorString) {
    if (colorString == null) return Colors.blue;

    try {
      // Remove # if present
      final hex = colorString.replaceFirst('#', '');

      // Parse hex color
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      } else if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
    } catch (e) {
      // Return default color on parse error
    }

    return Colors.blue;
  }
}

/// Complete knowledge base data
class KnowledgeBase {
  final List<KBCategory> categories;

  KnowledgeBase({required this.categories});

  factory KnowledgeBase.fromJson(Map<String, dynamic> json) {
    return KnowledgeBase(
      categories: (json['categories'] as List)
          .map((c) => KBCategory.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categories': categories.map((c) => c.toJson()).toList(),
    };
  }

  /// Get all articles across all categories
  List<KBArticle> get allArticles {
    return categories.expand((c) => c.articles).toList();
  }

  /// Find article by ID
  KBArticle? findArticle(String id) {
    for (final category in categories) {
      final article = category.articles.firstWhere(
        (a) => a.id == id,
        orElse: () => KBArticle(id: '', title: '', sections: []),
      );
      if (article.id.isNotEmpty) return article;
    }
    return null;
  }

  /// Find category by ID
  KBCategory? findCategory(String id) {
    try {
      return categories.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Search articles by query
  List<KBArticle> search(String query) {
    if (query.isEmpty) return [];

    final lowerQuery = query.toLowerCase();
    final results = <KBArticle>[];

    for (final category in categories) {
      for (final article in category.articles) {
        // Search in title
        if (article.title.toLowerCase().contains(lowerQuery)) {
          results.add(article);
          continue;
        }

        // Search in description
        if (article.description != null &&
            article.description!.toLowerCase().contains(lowerQuery)) {
          results.add(article);
          continue;
        }

        // Search in tags
        if (article.tags.any((tag) => tag.toLowerCase().contains(lowerQuery))) {
          results.add(article);
          continue;
        }

        // Search in content
        for (final section in article.sections) {
          if (section.content != null &&
              section.content!.toLowerCase().contains(lowerQuery)) {
            results.add(article);
            break;
          }
        }
      }
    }

    return results;
  }
}

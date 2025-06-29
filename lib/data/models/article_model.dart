// lib/data/models/article_model.dart
// Import untuk jsonEncode/jsonDecode

class Article {
  final String? id;
  final String? title;
  final String? summary;
  final String? content;
  final String? featuredImageUrl;
  final String? publishedAt;
  final String? authorName;
  final String? authorAvatar;
  final String? authorBio;
  final String? category;
  final List<String>? tags;
  final int? viewCount;
  final bool isBookmarked; // Field untuk status bookmark
  final bool? isPublished; // <<< TAMBAHKAN INI

  Article({
    this.id,
    this.title,
    this.summary,
    this.content,
    this.featuredImageUrl,
    this.publishedAt,
    this.authorName,
    this.authorAvatar,
    this.authorBio,
    this.category,
    this.tags,
    this.viewCount,
    this.isBookmarked = false, // Defaultnya false
    this.isPublished, // <<< TAMBAHKAN INI
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] as String?,
      title: json['title'] as String?,
      summary: json['summary'] as String?,
      content: json['content'] as String?,
      featuredImageUrl: json['featured_image_url'] as String?,
      publishedAt: json['published_at'] as String?,
      authorName: json['author_name'] as String?,
      authorAvatar: json['author_avatar'] as String?,
      authorBio: json['author_bio'] as String?,
      category: json['category'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      viewCount: json['view_count'] as int?,
      isBookmarked:
          json['is_bookmarked'] as bool? ??
          false, // Baca dari JSON, default false
      isPublished: json['is_published'] as bool?, // <<< TAMBAHKAN INI
    );
  }

  // Method untuk mengonversi Article ke Map<String, dynamic> (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'summary': summary,
      'content': content,
      'featured_image_url': featuredImageUrl,
      'published_at': publishedAt,
      'author_name': authorName,
      'author_avatar': authorAvatar,
      'author_bio': authorBio,
      'category': category,
      'tags': tags,
      'view_count': viewCount,
      'is_bookmarked': isBookmarked,
      'is_published': isPublished, // <<< TAMBAHKAN INI
    };
  }

  // Method copyWith untuk memudahkan modifikasi
  Article copyWith({
    String? id,
    String? title,
    String? summary,
    String? content,
    String? featuredImageUrl,
    String? publishedAt,
    String? authorName,
    String? authorAvatar,
    String? authorBio,
    String? category,
    List<String>? tags,
    int? viewCount,
    bool? isBookmarked,
    bool? isPublished, // <<< TAMBAHKAN INI
  }) {
    return Article(
      id: id ?? this.id,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      content: content ?? this.content,
      featuredImageUrl: featuredImageUrl ?? this.featuredImageUrl,
      publishedAt: publishedAt ?? this.publishedAt,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      authorBio: authorBio ?? this.authorBio,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      viewCount: viewCount ?? this.viewCount,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isPublished: isPublished ?? this.isPublished, // <<< GUNAKAN INI
    );
  }
}

// lib/data/models/news_everything_model.dart
import 'package:my_news_app/data/models/article_model.dart';

class NewsEverythingModel {
  final String? status;
  final int? totalResults;
  final List<Article>? articles;

  NewsEverythingModel({this.status, this.totalResults, this.articles});

  factory NewsEverythingModel.fromJson(Map<String, dynamic> json) {
    return NewsEverythingModel(
      status: json['status'] as String?,
      totalResults: json['totalResults'] as int?,
      articles: (json['articles'] as List<dynamic>?)
          ?.map((e) => Article.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
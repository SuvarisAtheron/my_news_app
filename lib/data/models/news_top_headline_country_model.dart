import 'package:my_news_app/data/models/article_model.dart';

class NewsTopHeadlineCountryModel {
  final String? status;
  final int? totalResults;
  final List<Article>? articles;

  NewsTopHeadlineCountryModel({this.status, this.totalResults, this.articles});

  factory NewsTopHeadlineCountryModel.fromJson(Map<String, dynamic> json) {
    return NewsTopHeadlineCountryModel(
      status: json['status'] as String?,
      totalResults: json['totalResults'] as int?,
      articles: (json['articles'] as List<dynamic>?)
          ?.map((e) => Article.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
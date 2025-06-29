// lib/data/repositories/author_news_repository.dart
import 'package:http/http.dart' as http;
import 'package:my_news_app/core/constants/api_constant.dart';
import 'package:my_news_app/data/models/article_model.dart';
import 'dart:convert';

class AuthorNewsRepository {
  /// Mengambil daftar berita milik author yang sedang login.
  Future<List<Article>> getAuthorNews({
    int page = 1,
    int limit = 10,
  }) async {
    final Map<String, String> queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
    };

    final Uri uri = Uri(
      scheme: Uri.parse(ApiConstants.baseUrl).scheme,
      host: Uri.parse(ApiConstants.baseUrl).host,
      port: Uri.parse(ApiConstants.baseUrl).port,
      path: ApiConstants.endpointAuthorNews, // /api/author/news
      queryParameters: queryParams,
    );

    print('Calling AUTHOR NEWS API URL: $uri'); // Debugging

    final response = await http.get(
      uri,
      headers: ApiConstants.getAuthHeaders(), // Menggunakan token yang sudah disimpan
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData.containsKey('body') && responseData['body'] is Map) {
        final Map<String, dynamic> bodyData = responseData['body'] as Map<String, dynamic>;
        if (bodyData.containsKey('data') && bodyData['data'] is List) {
          final List<dynamic> jsonList = bodyData['data'] as List<dynamic>;
          return jsonList
              .map((json) => Article.fromJson(json as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception(
            'Data list not found in "body" key or is not a list. Response: ${response.body}',
          );
        }
      } else {
        throw Exception(
          'Missing "body" key in API response or "body" is not a map. Response: ${response.body}',
        );
      }
    } else {
      String errorMessage = 'Failed to load author news: ${response.statusCode}';
      try {
        final errorBody = json.decode(response.body);
        if (errorBody is Map &&
            errorBody.containsKey('body') &&
            errorBody['body'] is Map &&
            errorBody['body'].containsKey('message')) {
          errorMessage =
              'Failed to load author news: ${errorBody['body']['message']} (Status: ${response.statusCode})';
        } else if (errorBody is Map && errorBody.containsKey('message')) {
          errorMessage =
              'Failed to load author news: ${errorBody['message']} (Status: ${response.statusCode})';
        }
      } catch (e) {
        // Biarkan errorMessage default jika gagal parse body error
      }
      throw Exception(errorMessage);
    }
  }

  /// Membuat berita baru.
  Future<Article> createArticle({
    required String title,
    String? summary,
    required String content,
    String? featuredImageUrl,
    String? category,
    List<String>? tags,
    bool isPublished = true,
  }) async {
    final Uri uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.endpointAuthorNews}', // POST /api/author/news
    );

    final Map<String, dynamic> body = {
      'title': title,
      'summary': summary,
      'content': content,
      'featuredImageUrl': featuredImageUrl,
      'category': category,
      'tags': tags,
      'isPublished': isPublished,
    };

    print('Creating article with body: ${json.encode(body)}');

    final response = await http.post(
      uri,
      headers: ApiConstants.getAuthHeaders(),
      body: json.encode(body),
    );

    if (response.statusCode == 201 || response.statusCode == 200) { // Check for 201 Created or 200 OK
      final Map<String, dynamic> responseData = json.decode(response.body);
      // Asumsi respons untuk create juga memiliki struktur "body": { "data": {} }
      if (responseData.containsKey('body') && responseData['body'] is Map) {
        final Map<String, dynamic> bodyData = responseData['body'] as Map<String, dynamic>;
        if (bodyData.containsKey('data') && bodyData['data'] is Map) {
          return Article.fromJson(bodyData['data'] as Map<String, dynamic>);
        } else {
          throw Exception('Data not found in response body for create article: ${response.body}');
        }
      } else {
        throw Exception('Invalid response structure for create article: ${response.body}');
      }
    } else {
      String errorMessage = 'Failed to create article: ${response.statusCode}';
      try {
        final errorBody = json.decode(response.body);
        if (errorBody is Map && errorBody.containsKey('body') && errorBody['body'] is Map && errorBody['body'].containsKey('message')) {
          errorMessage = 'Failed to create article: ${errorBody['body']['message']} (Status: ${response.statusCode})';
        } else if (errorBody is Map && errorBody.containsKey('message')) {
          errorMessage = 'Failed to create article: ${errorBody['message']} (Status: ${response.statusCode})';
        }
      } catch (e) {
        // Biarkan errorMessage default
      }
      throw Exception(errorMessage);
    }
  }

  /// Memperbarui berita yang sudah ada.
  Future<Article> updateArticle(String id, {
    String? title,
    String? summary,
    String? content,
    String? featuredImageUrl,
    String? category,
    List<String>? tags,
    bool? isPublished,
  }) async {
    final Uri uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.endpointAuthorNewsById}/$id', // PUT /api/author/news/{id}
    );

    final Map<String, dynamic> body = {};
    if (title != null) body['title'] = title;
    if (summary != null) body['summary'] = summary;
    if (content != null) body['content'] = content;
    if (featuredImageUrl != null) body['featuredImageUrl'] = featuredImageUrl;
    if (category != null) body['category'] = category;
    if (tags != null) body['tags'] = tags;
    if (isPublished != null) body['isPublished'] = isPublished;

    print('Updating article ID: $id with body: ${json.encode(body)}');

    final response = await http.put(
      uri,
      headers: ApiConstants.getAuthHeaders(),
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      // Asumsi respons untuk update juga memiliki struktur "body": { "data": {} }
      if (responseData.containsKey('body') && responseData['body'] is Map) {
        final Map<String, dynamic> bodyData = responseData['body'] as Map<String, dynamic>;
        if (bodyData.containsKey('data') && bodyData['data'] is Map) {
          return Article.fromJson(bodyData['data'] as Map<String, dynamic>);
        } else {
          throw Exception('Data not found in response body for update article: ${response.body}');
        }
      } else {
        throw Exception('Invalid response structure for update article: ${response.body}');
      }
    } else {
      String errorMessage = 'Failed to update article: ${response.statusCode}';
      try {
        final errorBody = json.decode(response.body);
        if (errorBody is Map && errorBody.containsKey('body') && errorBody['body'] is Map && errorBody['body'].containsKey('message')) {
          errorMessage = 'Failed to update article: ${errorBody['body']['message']} (Status: ${response.statusCode})';
        } else if (errorBody is Map && errorBody.containsKey('message')) {
          errorMessage = 'Failed to update article: ${errorBody['message']} (Status: ${response.statusCode})';
        }
      } catch (e) {
        // Biarkan errorMessage default
      }
      throw Exception(errorMessage);
    }
  }

  /// Menghapus berita berdasarkan ID.
  Future<void> deleteArticle(String id) async {
    final Uri uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.endpointAuthorNewsById}/$id', // DELETE /api/author/news/{id}
    );

    print('Deleting article ID: $id');

    final response = await http.delete(
      uri,
      headers: ApiConstants.getAuthHeaders(),
    );

    if (response.statusCode == 200) {
      print('Article ID: $id deleted successfully.');
      // Tidak ada body yang diharapkan untuk respons delete 200 OK, cukup berhasil.
    } else {
      String errorMessage = 'Failed to delete article: ${response.statusCode}';
      try {
        final errorBody = json.decode(response.body);
        if (errorBody is Map && errorBody.containsKey('body') && errorBody['body'] is Map && errorBody['body'].containsKey('message')) {
          errorMessage = 'Failed to delete article: ${errorBody['body']['message']} (Status: ${response.statusCode})';
        } else if (errorBody is Map && errorBody.containsKey('message')) {
          errorMessage = 'Failed to delete article: ${errorBody['message']} (Status: ${response.statusCode})';
        }
      } catch (e) {
        // Biarkan errorMessage default
      }
      throw Exception(errorMessage);
    }
  }
}

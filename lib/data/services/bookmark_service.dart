// lib/data/services/bookmark_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_news_app/data/models/article_model.dart';

class BookmarkService {
  static const String _bookmarkKey = 'bookmarked_articles';

  Future<List<Article>> getBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? bookmarksJson = prefs.getString(_bookmarkKey);
    if (bookmarksJson == null || bookmarksJson.isEmpty) {
      return [];
    }
    final List<dynamic> decodedList = json.decode(bookmarksJson);
    return decodedList.map((json) => Article.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<void> saveBookmarks(List<Article> bookmarks) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedList = json.encode(bookmarks.map((e) => e.toJson()).toList());
    await prefs.setString(_bookmarkKey, encodedList);
  }

  // --- TAMBAHKAN METODE INI ---
  Future<void> clearAllBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_bookmarkKey); // Hapus key bookmark sepenuhnya
  }
  // ---------------------------
}
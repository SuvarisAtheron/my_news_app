// lib/controllers/bookmark_controller.dart
import 'package:flutter/material.dart';
import 'package:my_news_app/data/models/article_model.dart';
import 'package:my_news_app/data/services/bookmark_service.dart';

class BookmarkController extends ChangeNotifier {
  final BookmarkService _bookmarkService = BookmarkService();
  List<Article> _bookmarkedArticles = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Article> get bookmarkedArticles => _bookmarkedArticles;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  BookmarkController() {
    fetchBookmarks(); // Muat bookmark saat controller dibuat
  }

  // --- UBAH DARI _loadBookmarks MENJADI fetchBookmarks ---
  Future<void> fetchBookmarks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _bookmarkedArticles = await _bookmarkService.getBookmarks();
    } catch (e) {
      _errorMessage = 'Failed to load bookmarks: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  // -----------------------------------------------------

  bool isArticleBookmarked(String articleId) {
    return _bookmarkedArticles.any((article) => article.id == articleId);
  }

  Future<void> addBookmark(Article article) async {
    if (!isArticleBookmarked(article.id ?? '')) {
      _bookmarkedArticles.add(article);
      await _bookmarkService.saveBookmarks(_bookmarkedArticles);
      notifyListeners();
    }
  }

  Future<void> removeBookmark(String articleId) async {
    _bookmarkedArticles.removeWhere((article) => article.id == articleId);
    await _bookmarkService.saveBookmarks(_bookmarkedArticles);
    notifyListeners();
  }

  Future<void> clearAllBookmarks() async {
    _bookmarkedArticles.clear(); // Hapus dari memori
    await _bookmarkService.clearAllBookmarks(); // Hapus dari SharedPreferences
    notifyListeners();
  }
}

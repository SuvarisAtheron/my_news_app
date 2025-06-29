// lib/controllers/author_news_controller.dart
import 'package:flutter/material.dart';
import 'package:my_news_app/data/models/article_model.dart';
import 'package:my_news_app/data/repositories/author_news_repository.dart';

class AuthorNewsController extends ChangeNotifier {
  final AuthorNewsRepository _authorNewsRepository = AuthorNewsRepository();
  List<Article> _authorArticles = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Article> get authorArticles => _authorArticles;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Mengambil berita yang dibuat oleh author
  Future<void> fetchAuthorNews() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _authorArticles = await _authorNewsRepository.getAuthorNews();
      _errorMessage = null; // Hapus error sebelumnya
    } catch (e) {
      _errorMessage = 'Failed to load author news: ${e.toString()}';
      print('Error fetching author news: $_errorMessage'); // Debugging
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Menambahkan berita baru
  Future<void> createArticle({
    required String title,
    String? summary,
    required String content,
    String? featuredImageUrl,
    String? category,
    List<String>? tags,
    bool isPublished = true,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final newArticle = await _authorNewsRepository.createArticle(
        title: title,
        summary: summary,
        content: content,
        featuredImageUrl: featuredImageUrl,
        category: category,
        tags: tags,
        isPublished: isPublished,
      );
      // Tambahkan artikel baru ke daftar lokal dan perbarui UI
      _authorArticles.insert(0, newArticle); 
      _errorMessage = null;
      notifyListeners();
      // Panggil fetchAuthorNews lagi untuk memastikan daftar terbaru
      await fetchAuthorNews();
    } catch (e) {
      _errorMessage = 'Failed to create article: ${e.toString()}';
      print('Error creating article: $_errorMessage'); // Debugging
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Memperbarui berita yang sudah ada
  Future<void> updateArticle(
    String articleId, {
    String? title,
    String? summary,
    String? content,
    String? featuredImageUrl,
    String? category,
    List<String>? tags,
    bool? isPublished,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final updatedArticle = await _authorNewsRepository.updateArticle(
        articleId,
        title: title,
        summary: summary,
        content: content,
        featuredImageUrl: featuredImageUrl,
        category: category,
        tags: tags,
        isPublished: isPublished,
      );
      // Perbarui artikel di daftar lokal
      final index = _authorArticles.indexWhere((article) => article.id == articleId);
      if (index != -1) {
        _authorArticles[index] = updatedArticle;
      }
      _errorMessage = null;
      notifyListeners();
      // Panggil fetchAuthorNews lagi untuk memastikan daftar terbaru
      await fetchAuthorNews();
    } catch (e) {
      _errorMessage = 'Failed to update article: ${e.toString()}';
      print('Error updating article: $_errorMessage'); // Debugging
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Menghapus berita
  Future<void> deleteArticle(String articleId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _authorNewsRepository.deleteArticle(articleId);
      _authorArticles.removeWhere((article) => article.id == articleId);
      _errorMessage = null;
      notifyListeners();
      // Panggil fetchAuthorNews lagi untuk memastikan daftar terbaru
      await fetchAuthorNews();
    } catch (e) {
      _errorMessage = 'Failed to delete article: ${e.toString()}';
      print('Error deleting article: $_errorMessage'); // Debugging
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

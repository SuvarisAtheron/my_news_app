// lib/main.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:my_news_app/core/constants/api_constant.dart';
import 'package:my_news_app/data/services/auth_service.dart';
import 'package:my_news_app/data/models/article_model.dart';
import 'package:my_news_app/controllers/bookmark_controller.dart';
import 'package:my_news_app/controllers/profile_controller.dart';
import 'package:my_news_app/controllers/author_news_controller.dart';
import 'package:my_news_app/core/routes/app_route.dart';

// Ini tetap NewsController untuk berita umum
class NewsController extends ChangeNotifier {
  final _publicNewsRepository = _NewsRepository();
  List<Article> _articles = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Article> get articles => _articles;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchNews({int page = 1, int limit = 10}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final news = await _publicNewsRepository.getPublicNews(
        page: page,
        limit: limit,
      );
      _articles = news;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

// NewsRepository asli untuk getPublicNews
class _NewsRepository {
  Future<List<Article>> getPublicNews({
    int page = 1,
    int limit = 10,
    String? category,
    String? search,
    String? tags,
  }) async {
    final Map<String, String> queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
    };
    if (category != null && category.isNotEmpty) {
      queryParams['category'] = category;
    }
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }
    if (tags != null && tags.isNotEmpty) {
      queryParams['tags'] = tags;
    }

    final Uri uri = Uri(
      scheme: Uri.parse(ApiConstants.baseUrl).scheme,
      host: Uri.parse(ApiConstants.baseUrl).host,
      port: Uri.parse(ApiConstants.baseUrl).port,
      path: ApiConstants.endpointGetAllPublicNews,
      queryParameters: queryParams,
    );

    print('Calling PUBLIC API URL: $uri'); // Debugging

    final response = await http.get(
      uri,
      headers: ApiConstants.getAuthHeaders(),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData.containsKey('body') && responseData['body'] is Map) {
        final Map<String, dynamic> bodyData =
            responseData['body'] as Map<String, dynamic>;
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
      String errorMessage =
          'Failed to load public news: ${response.statusCode}';
      try {
        final errorBody = json.decode(response.body);
        if (errorBody is Map &&
            errorBody.containsKey('body') &&
            errorBody['body'] is Map &&
            errorBody['body'].containsKey('message')) {
          errorMessage =
              'Failed to load public news: ${errorBody['body']['message']} (Status: ${response.statusCode})';
        } else if (errorBody is Map && errorBody.containsKey('message')) {
          errorMessage =
              'Failed to load public news: ${errorBody['message']} (Status: ${response.statusCode})';
        }
      } catch (e) {
        // Biarkan errorMessage default jika gagal parse body error
      }
      throw Exception(errorMessage);
    }
  }
}

// Global variable initialRoute tidak lagi digunakan di sini, tetapi di AppRouter
// String initialRoute = '/login'; // Tidak lagi diperlukan di sini

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Pastikan token dimuat sebelum runApp untuk digunakan di SplashScreen
  final authService = AuthService();
  ApiConstants.authToken = await authService.getAuthToken();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NewsController()),
        ChangeNotifierProvider(create: (_) => BookmarkController()),
        ChangeNotifierProvider(create: (_) => ProfileController()),
        ChangeNotifierProvider(create: (_) => AuthorNewsController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'WhatsNews',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              centerTitle: true,
              elevation: 0,
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
            ),
            textTheme: const TextTheme(
              displayLarge: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              titleLarge: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              titleMedium: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
              bodyLarge: TextStyle(fontSize: 14.0, color: Colors.black),
              bodyMedium: TextStyle(fontSize: 14.0, color: Colors.black),
              bodySmall: TextStyle(fontSize: 12.0, color: Colors.grey),
            ),
          ),
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}

// lib/core/routes/app_route.dart
import 'package:go_router/go_router.dart';
import 'package:my_news_app/features/auth/presentation/screens/login_register_screen.dart';
import 'package:my_news_app/features/home/presentation/screens/home_screen.dart';
import 'package:my_news_app/features/detail/presentation/screens/detail_screen.dart';
import 'package:my_news_app/features/bookmark/presentation/screens/bookmark_screen.dart';
import 'package:my_news_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:my_news_app/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:my_news_app/features/intro/presentation/screens/introduction_screen.dart' as app_intro;
import 'package:my_news_app/features/author/presentation/screens/manage_news_screen.dart';
import 'package:my_news_app/features/author/presentation/screens/article_form_screen.dart';
import 'package:my_news_app/features/splash/presentation/screens/splash_screen.dart'; // IMPORT INI

// Import initialRoute dari main.dart
// IMPORT INI

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash', // <<< UBAH INITIAL LOCATION KE SPLASH SCREEN
    routes: [
      GoRoute(
        path: '/splash', // <<< RUTE BARU UNTUK SPLASH SCREEN
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/intro',
        builder: (context, state) => const app_intro.IntroductionScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginRegisterScreen(),
      ),
      GoRoute(
        path: '/auth/login',
        builder: (context, state) => const LoginRegisterScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/detail',
        builder: (context, state) {
          final article = state.extra;
          if (article != null) {
            return DetailScreen(article: article as dynamic);
          }
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: '/bookmark',
        builder: (context, state) => const BookmarkScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/edit-profile',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/manage-news',
        builder: (context, state) => const ManageNewsScreen(),
        routes: [
          GoRoute(
            path: 'form',
            builder: (context, state) {
              final article = state.extra;
              return ArticleFormScreen(article: article as dynamic);
            },
          ),
        ],
      ),
    ],
  );
}

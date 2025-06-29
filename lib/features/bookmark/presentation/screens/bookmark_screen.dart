// lib/features/bookmark/presentation/screens/bookmark_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:my_news_app/controllers/bookmark_controller.dart';
import 'package:my_news_app/shared/styles/app_styles.dart';
import 'package:my_news_app/features/home/presentation/screens/home_screen.dart'; // Untuk NewsCard

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  @override
  void initState() {
    super.initState();
    // Memuat bookmark saat screen ini dibuka
    Future.microtask(
      () => Provider.of<BookmarkController>(
        context,
        listen: false,
      ).fetchBookmarks(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bookmark Saya",
          style: kTitleTextStyle.copyWith(color: kWhiteColor),
        ),
        backgroundColor: kPrimaryColor,
      ),
      body: Consumer<BookmarkController>(
        builder: (context, bookmarkController, child) {
          if (bookmarkController.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: kPrimaryColor),
            );
          } else if (bookmarkController.errorMessage != null) {
            return Center(
              child: Text(
                'Error: ${bookmarkController.errorMessage}',
                style: kBodyTextStyle.copyWith(color: kRedColor),
              ),
            );
          } else if (bookmarkController.bookmarkedArticles.isEmpty) {
            return Center(
              child: Text(
                'Belum ada berita yang di-bookmark.',
                style: kBodyTextStyle,
              ),
            );
          } else {
            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
              itemCount: bookmarkController.bookmarkedArticles.length,
              itemBuilder: (context, index) {
                final article = bookmarkController.bookmarkedArticles[index];
                return NewsCard(
                  article: article,
                ); // Menggunakan NewsCard yang sudah ada
              },
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Bookmark',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: 1, // Pastikan ini sesuai dengan tab Bookmark
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: kGreyColor,
        onTap: (index) {
          if (index == 0) {
            context.go('/home');
          } else if (index == 1) {
            // Sudah di Bookmark
          } else if (index == 2) {
            context.go('/profile');
          }
        },
      ),
    );
  }
}

// lib/features/home/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_news_app/data/models/article_model.dart';
import 'package:my_news_app/shared/styles/app_styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:my_news_app/main.dart'; // Pastikan ini diimpor jika NewsController ada di main.dart

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Memanggil fetchNews setelah widget diinisialisasi
    Future.microtask(() => Provider.of<NewsController>(context, listen: false).fetchNews(page: 1, limit: 10));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Berita Terkini", style: kTitleTextStyle.copyWith(color: kWhiteColor)),
        backgroundColor: kPrimaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: kWhiteColor),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search functionality coming soon!')),
              );
            },
          ),
        ],
      ),
      body: Consumer<NewsController>(
        builder: (context, newsController, child) {
          if (newsController.isLoading) {
            return Center(child: CircularProgressIndicator(color: kPrimaryColor));
          } else if (newsController.errorMessage != null) {
            return Center(child: Text('Error: ${newsController.errorMessage}', style: kBodyTextStyle.copyWith(color: kRedColor)));
          } else if (newsController.articles.isEmpty) {
            return Center(child: Text('No news found.', style: kBodyTextStyle));
          } else {
            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
              itemCount: newsController.articles.length,
              itemBuilder: (context, index) {
                final article = newsController.articles[index];
                return NewsCard(article: article);
              },
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Bookmark',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: 0, // Pastikan ini sesuai dengan tab Home
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: kGreyColor,
        onTap: (index) {
          // Gunakan context.go untuk navigasi antar tab utama
          if (index == 0) {
            // Sudah di Home
          } else if (index == 1) {
            context.go('/bookmark');
          } else if (index == 2) {
            context.go('/profile');
          }
        },
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  final Article article;
  const NewsCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    // Pastikan publishedAt tidak null sebelum diformat
    String formattedDate = article.publishedAt != null
        ? DateFormat('dd MMM yyyy HH:mm').format(DateTime.parse(article.publishedAt!))
        : 'Unknown Date';

    return Card(
      margin: EdgeInsets.symmetric(horizontal: kDefaultMargin, vertical: kDefaultPadding / 2),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kDefaultBorderRadius),
      ),
      child: InkWell(
        onTap: () {
          // --- PERUBAHAN UTAMA: Gunakan context.push() ---
          // Ini akan menambahkan DetailScreen ke stack navigasi, memungkinkan pop()
          context.push('/detail', extra: article);
        },
        child: Padding(
          padding: EdgeInsets.all(kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar Berita
              if (article.featuredImageUrl != null && article.featuredImageUrl!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(kDefaultBorderRadius / 2),
                  child: CachedNetworkImage(
                    imageUrl: article.featuredImageUrl!,
                    fit: BoxFit.cover,
                    height: 150,
                    width: double.infinity,
                    placeholder: (context, url) => Container(
                      height: 150,
                      width: double.infinity,
                      color: kLightGrey,
                      child: const Center(child: CircularProgressIndicator(color: kPrimaryColor)),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 150,
                      width: double.infinity,
                      color: kLightGrey,
                      child: Center(child: Text('Image not available', style: kSmallBodyTextStyle.copyWith(color: kDarkGrey))),
                    ),
                  ),
                )
              else
                Container(
                  height: 150,
                  width: double.infinity,
                  color: kLightGrey,
                  child: Center(child: Text('No Image', style: kSmallBodyTextStyle.copyWith(color: kDarkGrey))),
                ),
              SizedBox(height: kDefaultPadding),

              // Judul Berita
              Text(
                article.title ?? 'No Title',
                style: kTitleTextStyle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: kDefaultPadding / 4),

              // Ringkasan Berita
              Text(
                article.summary ?? 'No description available.',
                style: kBodyTextStyle.copyWith(color: kDarkGrey),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: kDefaultPadding / 2),

              // Nama Penulis dan Tanggal
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  '${article.authorName ?? "Unknown Author"} - $formattedDate',
                  style: kSmallBodyTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// lib/features/detail/presentation/screens/detail_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_news_app/data/models/article_model.dart';
import 'package:my_news_app/shared/styles/app_styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; // Diperlukan untuk mengakses BookmarkController
import 'package:my_news_app/controllers/bookmark_controller.dart'; // Diperlukan untuk BookmarkController

class DetailScreen extends StatefulWidget {
  // <<< UBAH KE STATEFULWIDGET
  final Article article;
  const DetailScreen({super.key, required this.article});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late bool _isBookmarked; // Untuk menyimpan status bookmark artikel ini

  @override
  void initState() {
    super.initState();
    // Menginisialisasi status bookmark dari controller saat widget dibuat
    // Gunakan Future.microtask untuk menunda panggilan hingga setelah build
    Future.microtask(() {
      _isBookmarked = Provider.of<BookmarkController>(
        context,
        listen: false,
      ).isArticleBookmarked(widget.article.id ?? '');
      setState(() {}); // Perbarui UI setelah status diinisialisasi
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = widget.article.publishedAt != null
        ? DateFormat(
            'dd MMMM HH:mm',
          ).format(DateTime.parse(widget.article.publishedAt!))
        : 'Unknown Date';

    // Menggunakan Consumer untuk mendengarkan perubahan pada BookmarkController
    return Consumer<BookmarkController>(
      builder: (context, bookmarkController, child) {
        // Perbarui status _isBookmarked setiap kali BookmarkController berubah
        _isBookmarked = bookmarkController.isArticleBookmarked(
          widget.article.id ?? '',
        );

        return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.article.title ?? 'Detail Berita',
              style: kTitleTextStyle.copyWith(color: kWhiteColor),
            ),
            backgroundColor: kPrimaryColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: kWhiteColor),
              onPressed: () {
                context.pop();
              },
            ),
            actions: [
              // --- TOMBOL BOOKMARK BARU ---
              IconButton(
                icon: Icon(
                  _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: kWhiteColor,
                ),
                onPressed: () {
                  if (_isBookmarked) {
                    // Jika sudah di-bookmark, hapus dari bookmark
                    bookmarkController.removeBookmark(widget.article.id ?? '');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Berita dihapus dari bookmark'),
                      ),
                    );
                  } else {
                    // Jika belum di-bookmark, tambahkan ke bookmark
                    bookmarkController.addBookmark(widget.article);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Berita ditambahkan ke bookmark'),
                      ),
                    );
                  }
                },
              ),
              // --------------------------
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(kDefaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gambar Utama
                if (widget.article.featuredImageUrl != null &&
                    widget.article.featuredImageUrl!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                    child: CachedNetworkImage(
                      imageUrl: widget.article.featuredImageUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                      placeholder: (context, url) => Container(
                        height: 200,
                        width: double.infinity,
                        color: kLightGrey,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 200,
                        width: double.infinity,
                        color: kLightGrey,
                        child: Center(
                          child: Text(
                            'Image not available',
                            style: kSmallBodyTextStyle.copyWith(
                              color: kDarkGrey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  Container(
                    height: 200,
                    width: double.infinity,
                    color: kLightGrey,
                    child: Center(
                      child: Text(
                        'No Image',
                        style: kSmallBodyTextStyle.copyWith(color: kDarkGrey),
                      ),
                    ),
                  ),
                SizedBox(height: kDefaultPadding),

                // Judul Berita
                Text(
                  widget.article.title ?? 'No Title',
                  style: kHeadlineTextStyle,
                ),
                SizedBox(height: kDefaultPadding / 2),

                // Nama Penulis dan Tanggal
                Text(
                  '${widget.article.authorName ?? "Unknown Author"} - $formattedDate',
                  style: kSmallBodyTextStyle.copyWith(color: kDarkGrey),
                ),
                SizedBox(height: kDefaultPadding),

                // Konten Berita
                Text(
                  widget.article.content ?? 'No content available.',
                  style: kBodyTextStyle,
                ),
                SizedBox(height: kDefaultPadding),

                // Kategori dan Tags (jika ada)
                if (widget.article.category != null &&
                    widget.article.category!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      'Category: ${widget.article.category}',
                      style: kSmallBodyTextStyle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (widget.article.tags != null &&
                    widget.article.tags!.isNotEmpty)
                  Wrap(
                    spacing: 8.0,
                    children: widget.article.tags!
                        .map((tag) => Chip(label: Text(tag)))
                        .toList(),
                  ),
                if (widget.article.viewCount != null)
                  Text(
                    'Views: ${widget.article.viewCount}',
                    style: kSmallBodyTextStyle,
                  ),

                // Author Bio dan Avatar (jika ada)
                if (widget.article.authorBio != null &&
                    widget.article.authorBio!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: kDefaultPadding),
                    child: Text(
                      'Author Bio: ${widget.article.authorBio}',
                      style: kBodyTextStyle,
                    ),
                  ),
                if (widget.article.authorAvatar != null &&
                    widget.article.authorAvatar!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: kDefaultPadding / 2),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: widget.article.authorAvatar!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(color: kPrimaryColor),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.person, size: 60, color: kDarkGrey),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

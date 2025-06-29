// lib/features/author/presentation/screens/manage_news_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:my_news_app/controllers/author_news_controller.dart';
import 'package:my_news_app/shared/styles/app_styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ManageNewsScreen extends StatefulWidget {
  const ManageNewsScreen({super.key});

  @override
  State<ManageNewsScreen> createState() => _ManageNewsScreenState();
}

class _ManageNewsScreenState extends State<ManageNewsScreen> {
  @override
  void initState() {
    super.initState();
    // Memuat berita author saat screen dibuka
    Future.microtask(
      () => Provider.of<AuthorNewsController>(
        context,
        listen: false,
      ).fetchAuthorNews(),
    );
  }

  // Fungsi untuk menampilkan dialog konfirmasi hapus
  Future<void> _confirmDelete(String articleId) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text('Apakah Anda yakin ingin menghapus berita ini?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text('Hapus', style: TextStyle(color: kRedColor)),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      final authorNewsController = Provider.of<AuthorNewsController>(context, listen: false);
      try {
        await authorNewsController.deleteArticle(articleId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Berita berhasil dihapus!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus berita: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Kelola Berita Saya",
          style: kTitleTextStyle.copyWith(color: kWhiteColor),
        ),
        backgroundColor: kPrimaryColor,
      ),
      body: Consumer<AuthorNewsController>(
        builder: (context, authorNewsController, child) {
          if (authorNewsController.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: kPrimaryColor),
            );
          } else if (authorNewsController.errorMessage != null) {
            return Center(
              child: Text(
                'Error: ${authorNewsController.errorMessage}',
                style: kBodyTextStyle.copyWith(color: kRedColor),
              ),
            );
          } else if (authorNewsController.authorArticles.isEmpty) {
            return Center(
              child: Text(
                'Anda belum memiliki berita. Tekan tombol + untuk membuat berita baru.',
                style: kBodyTextStyle,
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
              itemCount: authorNewsController.authorArticles.length,
              itemBuilder: (context, index) {
                final article = authorNewsController.authorArticles[index];
                String formattedDate = article.publishedAt != null
                    ? DateFormat('dd MMMM HH:mm').format(DateTime.parse(article.publishedAt!))
                    : 'Unknown Date';

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: kDefaultMargin.w, vertical: kDefaultPadding.h / 2),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kDefaultBorderRadius.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(kDefaultPadding.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Gambar Berita
                        if (article.featuredImageUrl != null && article.featuredImageUrl!.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(kDefaultBorderRadius.r / 2),
                            child: CachedNetworkImage(
                              imageUrl: article.featuredImageUrl!,
                              fit: BoxFit.cover,
                              height: 120.h,
                              width: double.infinity,
                              placeholder: (context, url) => Container(
                                height: 120.h,
                                width: double.infinity,
                                color: kLightGrey,
                                child: Center(child: CircularProgressIndicator(color: kPrimaryColor)),
                              ),
                              errorWidget: (context, url, error) => Container(
                                height: 120.h,
                                width: double.infinity,
                                color: kLightGrey,
                                child: Center(child: Text('Image not available', style: kSmallBodyTextStyle.copyWith(color: kDarkGrey))),
                              ),
                            ),
                          )
                        else
                          Container(
                            height: 120.h,
                            width: double.infinity,
                            color: kLightGrey,
                            child: Center(child: Text('No Image', style: kSmallBodyTextStyle.copyWith(color: kDarkGrey))),
                          ),
                        SizedBox(height: kDefaultPadding.h),
                        // Judul Berita
                        Text(
                          article.title ?? 'No Title',
                          style: kTitleTextStyle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: kDefaultPadding.h / 4),
                        // Ringkasan Berita
                        Text(
                          article.summary ?? 'No description available.',
                          style: kBodyTextStyle.copyWith(color: kDarkGrey),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: kDefaultPadding.h / 2),
                        // Nama Penulis dan Tanggal
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            '${article.authorName ?? "Unknown Author"} - $formattedDate',
                            style: kSmallBodyTextStyle,
                          ),
                        ),
                        SizedBox(height: kDefaultPadding.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                // Navigasi ke ArticleFormScreen untuk edit
                                context.push('/manage-news/form', extra: article);
                              },
                              icon: Icon(Icons.edit, size: 18.r),
                              label: Text('Edit', style: kSmallBodyTextStyle.copyWith(color: kWhiteColor)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryColor,
                                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kDefaultBorderRadius.r)),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            ElevatedButton.icon(
                              onPressed: () {
                                // Panggil fungsi konfirmasi hapus
                                _confirmDelete(article.id!);
                              },
                              icon: Icon(Icons.delete, size: 18.r),
                              label: Text('Hapus', style: kSmallBodyTextStyle.copyWith(color: kWhiteColor)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kRedColor,
                                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kDefaultBorderRadius.r)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke ArticleFormScreen untuk membuat berita baru
          context.push('/manage-news/form');
        },
        backgroundColor: kPrimaryColor,
        child: Icon(Icons.add, color: kWhiteColor),
      ),
    );
  }
}

// lib/features/author/presentation/screens/article_form_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_news_app/shared/styles/app_styles.dart';
import 'package:my_news_app/shared/widgets/custom_form_field.dart'; // Pastikan CustomFormField punya labelText
import 'package:my_news_app/shared/utils/form_validator.dart';
import 'package:my_news_app/data/models/article_model.dart';
import 'package:my_news_app/controllers/author_news_controller.dart';

class ArticleFormScreen extends StatefulWidget {
  final Article? article; // Opsional: jika ada, ini untuk mode edit

  const ArticleFormScreen({super.key, this.article});

  @override
  State<ArticleFormScreen> createState() => _ArticleFormScreenState();
}

class _ArticleFormScreenState extends State<ArticleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _summaryController;
  late TextEditingController _contentController;
  late TextEditingController _imageUrlController;
  late TextEditingController _categoryController;
  late TextEditingController _tagsController; // Untuk input tags sebagai string dipisahkan koma
  late bool _isPublished;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan data artikel jika dalam mode edit
    _titleController = TextEditingController(text: widget.article?.title);
    _summaryController = TextEditingController(text: widget.article?.summary);
    _contentController = TextEditingController(text: widget.article?.content);
    _imageUrlController = TextEditingController(text: widget.article?.featuredImageUrl);
    _categoryController = TextEditingController(text: widget.article?.category);
    _tagsController = TextEditingController(text: widget.article?.tags?.join(', '));
    _isPublished = widget.article?.isPublished ?? true; // Default true untuk artikel baru
  }

  @override
  void dispose() {
    _titleController.dispose();
    _summaryController.dispose();
    _contentController.dispose();
    _imageUrlController.dispose();
    _categoryController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  // Fungsi untuk submit form (Create atau Update)
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final authorNewsController = Provider.of<AuthorNewsController>(context, listen: false);

      // Pisahkan string tags menjadi List<String>
      final List<String> tagsList = _tagsController.text
          .split(',')
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty)
          .toList();

      try {
        if (widget.article == null) {
          // Mode Create
          await authorNewsController.createArticle(
            title: _titleController.text,
            summary: _summaryController.text.isNotEmpty ? _summaryController.text : null,
            content: _contentController.text,
            featuredImageUrl: _imageUrlController.text.isNotEmpty ? _imageUrlController.text : null,
            category: _categoryController.text.isNotEmpty ? _categoryController.text : null,
            tags: tagsList.isNotEmpty ? tagsList : null,
            isPublished: _isPublished,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Berita berhasil dibuat!')),
          );
        } else {
          // Mode Update
          await authorNewsController.updateArticle(
            widget.article!.id!,
            title: _titleController.text,
            summary: _summaryController.text.isNotEmpty ? _summaryController.text : null,
            content: _contentController.text,
            featuredImageUrl: _imageUrlController.text.isNotEmpty ? _imageUrlController.text : null,
            category: _categoryController.text.isNotEmpty ? _categoryController.text : null,
            tags: tagsList.isNotEmpty ? tagsList : null,
            isPublished: _isPublished,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Berita berhasil diperbarui!')),
          );
        }
        context.pop(); // Kembali ke ManageNewsScreen setelah sukses
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditMode = widget.article != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditMode ? "Edit Berita" : "Buat Berita Baru",
          style: kTitleTextStyle.copyWith(color: kWhiteColor),
        ),
        backgroundColor: kPrimaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kWhiteColor),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(kDefaultPadding.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomFormField(
                controller: _titleController,
                hintText: 'Judul Berita',
                labelText: 'Judul', // Tambahkan labelText
                validator: (value) => FormValidator.validateNonEmpty(value, 'Judul'),
              ),
              SizedBox(height: kDefaultPadding.h),
              CustomFormField(
                controller: _summaryController,
                hintText: 'Ringkasan Berita (Opsional)',
                labelText: 'Ringkasan', // Tambahkan labelText
                maxLines: 3,
              ),
              SizedBox(height: kDefaultPadding.h),
              CustomFormField(
                controller: _contentController,
                hintText: 'Isi Berita',
                labelText: 'Konten', // Tambahkan labelText
                maxLines: 10,
                validator: (value) => FormValidator.validateNonEmpty(value, 'Konten'),
              ),
              SizedBox(height: kDefaultPadding.h),
              CustomFormField(
                controller: _imageUrlController,
                hintText: 'URL Gambar Unggulan (Opsional)',
                labelText: 'URL Gambar', // Tambahkan labelText
                keyboardType: TextInputType.url,
              ),
              SizedBox(height: kDefaultPadding.h),
              CustomFormField(
                controller: _categoryController,
                hintText: 'Kategori (Opsional, ex: Teknologi, Olahraga)',
                labelText: 'Kategori', // Tambahkan labelText
              ),
              SizedBox(height: kDefaultPadding.h),
              CustomFormField(
                controller: _tagsController,
                hintText: 'Tags (Opsional, pisahkan dengan koma, ex: flutter, dart)',
                labelText: 'Tags', // Tambahkan labelText
              ),
              SizedBox(height: kDefaultPadding.h),
              Row(
                children: [
                  Text('Publikasikan:', style: kBodyTextStyle),
                  SizedBox(width: 8.w),
                  Switch(
                    value: _isPublished,
                    onChanged: (value) {
                      setState(() {
                        _isPublished = value;
                      });
                    },
                    activeColor: kPrimaryColor,
                  ),
                ],
              ),
              SizedBox(height: kDefaultPadding.h * 2),
              Center(
                child: Consumer<AuthorNewsController>(
                  builder: (context, authorNewsController, child) {
                    if (authorNewsController.isLoading) {
                      return CircularProgressIndicator(color: kPrimaryColor);
                    }
                    return ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        padding: EdgeInsets.symmetric(horizontal: kDefaultPadding.w * 2, vertical: kDefaultPadding.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(kDefaultBorderRadius.r),
                        ),
                      ),
                      child: Text(
                        isEditMode ? 'Simpan Perubahan' : 'Buat Berita',
                        style: kTitleTextStyle.copyWith(color: kWhiteColor),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

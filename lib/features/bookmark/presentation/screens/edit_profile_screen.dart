// lib/features/profile/presentation/screens/edit_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_news_app/shared/styles/app_styles.dart';
import 'package:my_news_app/controllers/profile_controller.dart'; // Import ProfileController

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>(); // Kunci untuk validasi form
  late TextEditingController _usernameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    final profileController = Provider.of<ProfileController>(context, listen: false);
    _usernameController = TextEditingController(text: profileController.userProfile?.username);
    _emailController = TextEditingController(text: profileController.userProfile?.email);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final profileController = Provider.of<ProfileController>(context, listen: false);
      try {
        await profileController.updateProfile(
          username: _usernameController.text,
          email: _emailController.text,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil berhasil diperbarui!')),
        );
        context.pop(); // Kembali ke ProfileScreen setelah sukses
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui profil: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profil", style: kTitleTextStyle.copyWith(color: kWhiteColor)),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(kDefaultPadding.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  hintText: 'Masukkan username baru',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(kDefaultBorderRadius.r),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: kDefaultPadding.h),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Masukkan email baru',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(kDefaultBorderRadius.r),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Masukkan alamat email yang valid';
                  }
                  return null;
                },
              ),
              SizedBox(height: kDefaultPadding.h * 2),
              Center(
                child: Consumer<ProfileController>(
                  builder: (context, profileController, child) {
                    if (profileController.isLoading) {
                      return CircularProgressIndicator(color: Theme.of(context).primaryColor);
                    }
                    return ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: EdgeInsets.symmetric(horizontal: kDefaultPadding.w * 2, vertical: kDefaultPadding.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(kDefaultBorderRadius.r),
                        ),
                      ),
                      child: Text(
                        'Simpan Perubahan',
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(color: kWhiteColor),
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
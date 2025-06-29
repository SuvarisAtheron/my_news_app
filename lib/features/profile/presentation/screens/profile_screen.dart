// lib/features/profile/presentation/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_news_app/shared/styles/app_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:my_news_app/controllers/profile_controller.dart';
import 'package:my_news_app/controllers/bookmark_controller.dart';
// IMPORT INI
import 'package:my_news_app/data/services/auth_service.dart'; // IMPORT INI untuk logout token

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ProfileController>(context, listen: false).fetchUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileController>(
      builder: (context, profileController, child) {
        final user = profileController.userProfile;
        final username = user?.username ?? "John Doe";
        final email = user?.email ?? "john.doe@example.com";

        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Profil",
              style: kTitleTextStyle.copyWith(color: kWhiteColor),
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(kDefaultPadding.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50.r,
                        backgroundColor: kLightGrey,
                        child: Icon(
                          Icons.person,
                          size: 60.r,
                          color: kGreyColor,
                        ),
                      ),
                      SizedBox(height: kDefaultPadding.h),
                      Text(
                        username,
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      Text(
                        email,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: kDefaultPadding.h * 2),
                    ],
                  ),
                ),

                // Edit Profil
                ListTile(
                  leading: Icon(
                    Icons.edit,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(
                    "Edit Profil",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    context.push('/edit-profile');
                  },
                ),
                Divider(color: kLightGrey),

                // --- OPSI BARU: Kelola Berita Saya ---
                ListTile(
                  leading: Icon(
                    Icons.article, // Icon artikel
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(
                    "Kelola Berita Saya",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    context.push('/manage-news'); // Navigasi ke ManageNewsScreen
                  },
                ),
                Divider(color: kLightGrey),
                // -------------------------------------

                // Logout
                ListTile(
                  leading: Icon(Icons.logout, color: kRedColor),
                  title: Text(
                    "Logout",
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium!.copyWith(color: kRedColor),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () async {
                    final bool confirmLogout =
                        await showDialog(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              title: const Text('Konfirmasi Logout'),
                              content: const Text(
                                'Apakah Anda yakin ingin logout?',
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(dialogContext).pop(false),
                                  child: Text(
                                    'Batal',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(dialogContext).pop(true),
                                  child: Text(
                                    'Logout',
                                    style: TextStyle(color: kRedColor),
                                  ),
                                ),
                              ],
                            );
                          },
                        ) ??
                        false;

                    if (confirmLogout) {
                      await profileController.resetProfile();
                      await Provider.of<BookmarkController>(
                        context,
                        listen: false,
                      ).clearAllBookmarks();
                      // Tambahkan clear token saat logout
                      final authService = AuthService();
                      await authService.clearAuthToken();

                      context.go('/login');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Anda telah berhasil logout.'),
                        ),
                      );
                    }
                  },
                ),
                Divider(color: kLightGrey),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.bookmark),
                label: 'Bookmark',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            currentIndex: 2,
            selectedItemColor: Theme.of(
              context,
            ).bottomNavigationBarTheme.selectedItemColor,
            unselectedItemColor: Theme.of(
              context,
            ).bottomNavigationBarTheme.unselectedItemColor,
            onTap: (index) {
              if (index == 0) {
                context.go('/home');
              } else if (index == 1) {
                context.go('/bookmark');
              }
              // Jika index 2 (Profile), tetap di halaman ini, tidak perlu navigasi ulang
            },
          ),
        );
      },
    );
  }
}

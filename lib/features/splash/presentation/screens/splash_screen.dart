// lib/features/splash/presentation/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_news_app/core/constants/api_constant.dart'; // Untuk cek token
import 'package:my_news_app/shared/styles/app_styles.dart'; // Untuk warna background

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    // Tunggu selama 3-5 detik (misal 3 detik)
    await Future.delayed(const Duration(seconds: 3));

    // Periksa apakah intro sudah dilihat
    final prefs = await SharedPreferences.getInstance();
    final hasSeenIntro = prefs.getBool('hasSeenIntro') ?? false;

    // Periksa apakah token autentikasi ada
    // Asumsi ApiConstants.authToken sudah diinisialisasi di main.dart saat app startup
    final bool isLoggedIn = ApiConstants.authToken != null && ApiConstants.authToken!.isNotEmpty;

    if (!mounted) return; // Pastikan widget masih ada di tree

    if (!hasSeenIntro) {
      context.go('/intro'); // Jika belum lihat intro, arahkan ke intro screen
    } else {
      // Jika sudah lihat intro, cek status login
      if (isLoggedIn) {
        context.go('/home'); // Jika sudah login, langsung ke home
      } else {
        context.go('/login'); // Jika belum login, arahkan ke login
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 11, 87, 13), // Warna latar belakang splash screen
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icon/icon.png', // Pastikan jalur gambar ini benar
              width: 150, // Sesuaikan ukuran logo
              height: 150, // Sesuaikan ukuran logo
            ),
            const SizedBox(height: 24),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(kWhiteColor), // Warna loading indicator
            ),
            const SizedBox(height: 16),
            Text(
              'Loading WhatsNews...',
              style: kTitleTextStyle.copyWith(color: kWhiteColor),
            ),
          ],
        ),
      ),
    );
  }
}

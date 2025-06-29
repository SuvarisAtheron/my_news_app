// lib/features/intro/presentation/screens/introduction_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_news_app/shared/styles/app_styles.dart'; // Import style kita
import 'package:flutter_screenutil/flutter_screenutil.dart'; // <<< IMPORT INI
import 'package:shared_preferences/shared_preferences.dart'; // <<< IMPORT INI UNTUK MENYIMPAN HAS SEEN INTRO

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Fungsi untuk menandai bahwa intro sudah dilihat dan navigasi ke login
  void _onIntroEnd(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenIntro', true); // Set flag
    context.go('/login'); // Navigasi ke halaman login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: [
              IntroductionSlide(
                imagePath: 'assets/images/img_intro_1.png',
                title: 'Welcome to WhatsNews',
                description:
                    'Get the latest news from around the world, tailored for you.',
              ),
              IntroductionSlide(
                imagePath: 'assets/images/img_intro_2.png',
                title: 'Stay Informed, Anytime, Anywhere',
                description:
                    'Breaking news, in-depth analysis, and top stories at your fingertips.',
              ),
              IntroductionSlide(
                imagePath: 'assets/images/img_intro_3.png',
                title: 'Personalized News Feed',
                description:
                    'Follow topics you care about and get news that matters to you.',
              ),
            ],
          ),
          Positioned(
            bottom: kDefaultPadding.h * 4, // Gunakan .h
            left: kDefaultPadding.w, // Gunakan .w
            right: kDefaultPadding.w, // Gunakan .w
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 8.h, // Gunakan .h
                      width: _currentPage == index ? 24.w : 8.w, // Gunakan .w
                      margin: EdgeInsets.symmetric(
                        horizontal: 4.w,
                      ), // Gunakan .w
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? kPrimaryColor
                            : kGreyColor,
                        borderRadius: BorderRadius.circular(4.r), // Gunakan .r
                      ),
                    ),
                  ),
                ),
                SizedBox(height: kDefaultPadding.h * 2), // Gunakan .h
                _currentPage == 2
                    ? SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _onIntroEnd(
                            context,
                          ), // Panggil fungsi _onIntroEnd
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            padding: EdgeInsets.symmetric(
                              vertical: kDefaultPadding.h,
                            ), // Gunakan .h
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                kDefaultBorderRadius.r,
                              ), // Gunakan .r
                            ),
                          ),
                          child: Text(
                            'Get Started',
                            style: kTitleTextStyle.copyWith(color: kWhiteColor),
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () => _onIntroEnd(
                              context,
                            ), // Panggil fungsi _onIntroEnd
                            child: Text(
                              'Skip',
                              style: kBodyTextStyle.copyWith(color: kGreyColor),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              padding: EdgeInsets.symmetric(
                                horizontal: kDefaultPadding.w * 2,
                                vertical: kDefaultPadding.h / 2,
                              ), // Gunakan .w dan .h
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  kDefaultBorderRadius.r,
                                ), // Gunakan .r
                              ),
                            ),
                            child: Text(
                              'Next',
                              style: kBodyTextStyle.copyWith(
                                color: kWhiteColor,
                              ),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class IntroductionSlide extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const IntroductionSlide({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(kDefaultPadding.w), // Gunakan .w
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, height: 250.h), // <<< AKTIFKAN INI, gunakan .h
          SizedBox(height: kDefaultPadding.h * 2), // Gunakan .h
          Text(title, style: kHeadlineTextStyle, textAlign: TextAlign.center),
          SizedBox(height: kDefaultPadding.h), // Gunakan .h
          Text(
            description,
            style: kBodyTextStyle.copyWith(color: kDarkGrey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

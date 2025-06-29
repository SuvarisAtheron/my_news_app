// lib/features/auth/presentation/screens/login_register_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_news_app/shared/styles/app_styles.dart';
import 'package:my_news_app/shared/widgets/custom_form_field.dart';
import 'package:my_news_app/shared/utils/form_validator.dart';

class LoginRegisterScreen extends StatefulWidget {
  const LoginRegisterScreen({super.key});

  @override
  State<LoginRegisterScreen> createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLogin = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Kredensial yang diizinkan
  static const String _allowedEmail = "news@itg.ac.id";
  static const String _allowedPassword = "ITG#news";

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (isLogin) {
        // Logika untuk mode Login
        final String enteredEmail = _emailController.text;
        final String enteredPassword = _passwordController.text;

        if (enteredEmail == _allowedEmail &&
            enteredPassword == _allowedPassword) {
          // Login berhasil
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Login Berhasil!')));
          // Navigasi ke halaman home setelah login berhasil
          Future.delayed(const Duration(seconds: 1), () {
            context.go('/home'); // Navigasi ke halaman home
          });
        } else {
          // Login gagal
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email atau Password salah!')),
          );
        }
      } else {
        // Logika untuk mode Register (tetap seperti sebelumnya atau sesuaikan)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Registering... (Fitur ini belum diimplementasi penuh)',
            ),
          ),
        );
        // Untuk demo, tetap navigasi setelah register
        Future.delayed(const Duration(seconds: 2), () {
          context.go('/home'); // Navigasi ke halaman home
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Menggunakan kTitleTextStyle dari app_styles.dart
        title: Text(
          isLogin ? 'Login' : 'Register',
          style: kTitleTextStyle.copyWith(color: kWhiteColor),
        ),
        backgroundColor: kPrimaryColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(kDefaultPadding * 2),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isLogin ? 'Welcome Back!' : 'Create New Account',
                  style: kHeadlineTextStyle,
                ),
                SizedBox(height: kDefaultPadding * 2),
                CustomFormField(
                  controller: _emailController,
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: FormValidator.validateEmail,
                ),
                SizedBox(height: kDefaultPadding),
                CustomFormField(
                  controller: _passwordController,
                  hintText: 'Password',
                  obscureText: true,
                  validator: FormValidator.validatePassword,
                ),
                if (!isLogin) ...[
                  SizedBox(height: kDefaultPadding),
                  CustomFormField(
                    controller: _confirmPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                ],
                SizedBox(height: kDefaultPadding * 2),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      padding: EdgeInsets.symmetric(vertical: kDefaultPadding),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          kDefaultBorderRadius,
                        ),
                      ),
                    ),
                    // Menggunakan kTitleTextStyle dari app_styles.dart
                    child: Text(
                      isLogin ? 'Login' : 'Register',
                      style: kTitleTextStyle.copyWith(color: kWhiteColor),
                    ),
                  ),
                ),
                SizedBox(height: kDefaultPadding),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isLogin = !isLogin;
                    });
                  },
                  // Menggunakan kBodyTextStyle dari app_styles.dart
                  child: Text(
                    isLogin
                        ? 'Don\'t have an account? Register'
                        : 'Already have an account? Login',
                    style: kBodyTextStyle.copyWith(color: kPrimaryColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

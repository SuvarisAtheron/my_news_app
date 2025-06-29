// lib/data/services/profile_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_news_app/data/models/user_model.dart';

class ProfileService {
  static const String _userProfileKey = 'user_profile';

  // Mendapatkan profil pengguna dari SharedPreferences
  Future<User> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userJson = prefs.getString(_userProfileKey);

    if (userJson == null || userJson.isEmpty) {
      // Jika belum ada profil, kembalikan profil default dengan nama dan email yang baru
      return User(username: 'NewsITG', email: 'news@itg.ac.id');
    }

    try {
      final Map<String, dynamic> decodedJson = json.decode(userJson);
      return User.fromJson(decodedJson);
    } catch (e) {
      print('Error decoding user profile: $e');
      // Jika gagal decode, kembalikan profil default dengan nama dan email yang baru
      return User(username: 'NewsITG', email: 'news@itg.ac.id');
    }
  }

  // Menyimpan profil pengguna ke SharedPreferences
  Future<void> saveUserProfile(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userProfileKey, json.encode(user.toJson()));
  }
}

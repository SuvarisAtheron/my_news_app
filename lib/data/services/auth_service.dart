// lib/data/services/auth_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _authTokenKey = 'auth_token';

  /// Menyimpan token autentikasi ke SharedPreferences.
  Future<void> saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authTokenKey, token);
  }

  /// Mengambil token autentikasi dari SharedPreferences.
  /// Mengembalikan null jika token tidak ditemukan.
  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_authTokenKey);
  }

  /// Menghapus token autentikasi dari SharedPreferences.
  Future<void> clearAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authTokenKey);
  }
}

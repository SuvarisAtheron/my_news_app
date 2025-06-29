// lib/data/repositories/auth_repository.dart
import 'package:http/http.dart' as http;
import 'package:my_news_app/core/constants/api_constant.dart';
import 'package:my_news_app/data/services/auth_service.dart'; // Import AuthService
import 'dart:convert';

class AuthRepository { // Mengganti nama kelas dari NewsRepository menjadi AuthRepository
  final AuthService _authService = AuthService(); // Instance AuthService

  /// Melakukan proses login pengguna.
  /// Setelah berhasil login, token akan disimpan ke SharedPreferences
  /// dan juga diatur ke ApiConstants.authToken.
  Future<String> loginUser(String email, String password) async {
    final Uri uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.endpointLogin}',
    );
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    final String body = json.encode({'email': email, 'password': password});

    print('Attempting login to URL: $uri with body: $body');

    final response = await http.post(uri, headers: headers, body: body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      // Pastikan struktur respons sesuai dengan yang Anda berikan
      // { "status": 200, "body": { "success": true, "data": { "token": "..." } } }
      if (responseData.containsKey('body') && responseData['body'] is Map) {
        final Map<String, dynamic> bodyData = responseData['body'] as Map<String, dynamic>;
        if (bodyData.containsKey('data') && bodyData['data'] is Map) {
          final Map<String, dynamic> dataContent = bodyData['data'] as Map<String, dynamic>;
          final String? token = dataContent['token'] as String?;

          if (token != null && token.isNotEmpty) {
            // Simpan token menggunakan AuthService
            await _authService.saveAuthToken(token);
            // Juga set token ke variabel global di ApiConstants
            ApiConstants.authToken = token;

            print('Login successful! Token: $token');
            return 'Login Success';
          } else {
            throw Exception(
              'Login successful, but no token received. Response: ${response.body}',
            );
          }
        } else {
          throw Exception(
            'Missing "data" key in API response body or "data" is not a map. Response: ${response.body}',
          );
        }
      } else {
        throw Exception(
          'Missing "body" key in API response or "body" is not a map. Response: ${response.body}',
        );
      }
    } else {
      String errorMessage = 'Login failed: ${response.statusCode}';
      try {
        final errorBody = json.decode(response.body);
        if (errorBody is Map &&
            errorBody.containsKey('body') &&
            errorBody['body'] is Map &&
            errorBody['body'].containsKey('message')) {
          errorMessage =
              'Login failed: ${errorBody['body']['message']} (Status: ${response.statusCode})';
        } else if (errorBody is Map && errorBody.containsKey('message')) {
          errorMessage =
              'Login failed: ${errorBody['message']} (Status: ${response.statusCode})';
        }
      } catch (e) {
        // Biarkan errorMessage default jika gagal parse body error
      }
      throw Exception(errorMessage);
    }
  }

  // Metode untuk GET ALL PUBLIC NEWS tetap di NewsRepository, bukan AuthRepository
  // Jadi saya akan membuat NewsRepository yang terpisah atau mengembalikan nama NewsRepository asli.
  // Untuk saat ini, saya akan biarkan ini di AuthRepository sementara,
  // tapi idealnya getPublicNews() ada di NewsRepository terpisah.
  // Akan lebih baik membuat NewsRepository terpisah untuk public news dan AuthorNewsRepository untuk author news.
  // Namun, karena Anda sudah punya NewsRepository dengan getPublicNews, saya akan membuat AuthorNewsRepository.

  // --- Perhatian: Metode getPublicNews ini akan saya pindahkan ke NewsRepository baru/yang sudah ada
  //                  jika kita memisahkan NewsRepository dan AuthorNewsRepository.
  //                  Untuk sementara, ini akan tetap di sini atau kita bisa mengabaikannya
  //                  jika NewsRepository yang Anda berikan sebelumnya sudah punya.
  //                  Saya asumsikan Anda ingin memisahkan repositori untuk Author News.
}

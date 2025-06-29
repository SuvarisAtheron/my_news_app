// lib/core/constants/api_constant.dart

class ApiConstants {
  static const String baseUrl = "http://45.149.187.204:3000";

  // --- TAMBAHKAN INI UNTUK MENYIMPAN AUTH TOKEN SECARA GLOBAL ---
  static String? authToken;
  // ---------------------------------------------------------------

  // --- Endpoint-endpoint dari API Anda ---
  static const String endpointLogin = "/api/auth/login"; // Ini tetap ada untuk login author
  static const String endpointGetAllPublicNews = "/api/news"; // Endpoint publik untuk semua berita
  static const String endpointGetAuthorProfile = "/api/auth/me"; // Ini butuh auth
  static const String endpointAuthorNews = "/api/author/news"; // Endpoint untuk CRUD berita author
  static const String endpointAuthorNewsById = "/api/author/news"; // Digunakan dengan ID untuk PUT/DELETE

  // Header autentikasi: Sekarang akan menyertakan Authorization Bearer Token jika tersedia.
  static Map<String, String> getAuthHeaders({String? token}) {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    // Menggunakan token yang diberikan, jika ada, atau authToken global
    final String? currentToken = token ?? authToken;
    if (currentToken != null && currentToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $currentToken';
    }
    return headers;
  }
}

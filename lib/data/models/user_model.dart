// lib/data/models/user_model.dart

class User {
  final String username;
  final String email;

  User({required this.username, required this.email});

  // Factory constructor untuk membuat instance User dari Map (JSON)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] as String,
      email: json['email'] as String,
    );
  }

  // Method untuk mengonversi instance User ke Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
    };
  }

  // Method copyWith untuk memudahkan perubahan sebagian data User
  User copyWith({
    String? username,
    String? email,
  }) {
    return User(
      username: username ?? this.username,
      email: email ?? this.email,
    );
  }
}
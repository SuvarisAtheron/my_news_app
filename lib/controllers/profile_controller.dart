// lib/controllers/profile_controller.dart
import 'package:flutter/material.dart';
import 'package:my_news_app/data/models/user_model.dart';
import 'package:my_news_app/data/services/profile_service.dart';

class ProfileController extends ChangeNotifier {
  final ProfileService _profileService = ProfileService();
  User? _userProfile;
  bool _isLoading = false;
  String? _errorMessage;

  User? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  ProfileController() {
    fetchUserProfile(); // Muat profil saat controller dibuat
  }

  Future<void> fetchUserProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _userProfile = await _profileService.getUserProfile();
    } catch (e) {
      _errorMessage = 'Failed to load profile: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile({String? username, String? email}) async {
    if (_userProfile == null) {
      // Jika profil belum dimuat, coba muat dulu atau set error
      _errorMessage = 'Profile not loaded yet. Please try again.';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedUser = _userProfile!.copyWith(
        username: username,
        email: email,
      );
      await _profileService.saveUserProfile(updatedUser);
      _userProfile = updatedUser; // Perbarui state lokal
    } catch (e) {
      _errorMessage = 'Failed to update profile: $e';
      rethrow; // Lemparkan error agar ditangkap di UI
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resetProfile() async {
    // Mengatur ulang profil ke nilai default 'NewsITG' dan 'news@itg.ac.id'
    _userProfile = User(username: 'NewsITG', email: 'news@itg.ac.id');
    await _profileService.saveUserProfile(_userProfile!);
    notifyListeners();
  }
}

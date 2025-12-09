import 'dart:io';
import 'package:kinolive_mobile/domain/entities/auth/user_profile.dart';
import 'package:kinolive_mobile/domain/entities/auth_session.dart';

abstract class AuthRepository {
  Future<AuthSession> login({
    required String email,
    required String password,
  });
  Future<AuthSession> register({
    required String email,
    required String password,
  });
  Future<void> logout();
  Future<AuthSession?> getSavedSession();
  Future<bool> isLoggedIn();
  Future<UserProfile> getProfile();
  Future<UserProfile> updateProfile({
    String? firstName,
    String? lastName,
    String? username,
    String? phoneNumber,
    DateTime? dateOfBirth,
  });
  Future<String> uploadProfilePhoto(File photoFile);
  Future<void> deleteProfilePhoto();
}
import 'dart:io';
import 'package:kinolive_mobile/data/models/auth/profile_dto.dart';
import 'package:kinolive_mobile/data/sources/local/auth_token_storage.dart';
import 'package:kinolive_mobile/data/sources/remote/auth_api_service.dart';
import 'package:kinolive_mobile/domain/entities/auth/user_profile.dart';
import 'package:kinolive_mobile/domain/entities/auth_session.dart';
import 'package:kinolive_mobile/domain/repositories/auth_repository.dart';
import 'package:kinolive_mobile/shared/errors/app_exception.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService apiService;
  final AccessTokenStorage tokenStorage;

  AuthRepositoryImpl(this.apiService, this.tokenStorage);

  @override
  Future<bool> isLoggedIn() async {
    final storedToken = await tokenStorage.read();
    return storedToken?.isNotEmpty == true;
  }

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
  }) {
    return _handleAuthRequest(
      request: () => apiService.login(email, password),
    );
  }

  @override
  Future<AuthSession> register({
    required String email,
    required String password,
  }) {
    return _handleAuthRequest(
      request: () => apiService.register(email, password),
    );
  }

  Future<AuthSession> _handleAuthRequest({
    required Future<String> Function() request,
  }) async {
    final accessToken = await request();
    await tokenStorage.save(accessToken);
    return AuthSession(accessToken: accessToken);
  }

  @override
  Future<void> logout() async {
    await tokenStorage.clear();
  }

  @override
  Future<AuthSession?> getSavedSession() async {
    final storedToken = await tokenStorage.read();
    if (storedToken == null || storedToken.isEmpty) return null;
    return AuthSession(accessToken: storedToken);
  }

  @override
  Future<UserProfile> getProfile() async {
    final ProfileDto dto = await apiService.getProfile();

    return UserProfile(
      email: dto.email,
      firstName: dto.firstName,
      lastName: dto.lastName,
      username: dto.username,
      phoneNumber: dto.phoneNumber,
      userRole: dto.userRole,
      profilePhotoUrl: dto.profilePhotoUrl,
      dateOfBirth: dto.dateOfBirth != null && dto.dateOfBirth!.isNotEmpty
          ? DateTime.parse(dto.dateOfBirth!)
          : null,
      createdAt: dto.createdAt != null && dto.createdAt!.isNotEmpty
          ? DateTime.parse(dto.createdAt!)
          : null,
    );
  }

  @override
  Future<UserProfile> updateProfile({
    String? firstName,
    String? lastName,
    String? username,
    String? phoneNumber,
    DateTime? dateOfBirth,
  }) async {
    final ProfileDto dto = await apiService.updateProfile(
      firstName: firstName,
      lastName: lastName,
      username: username,
      phoneNumber: phoneNumber,
      dateOfBirth: dateOfBirth != null 
          ? '${dateOfBirth.year}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}'
          : null,
    );

    return UserProfile(
      email: dto.email,
      firstName: dto.firstName,
      lastName: dto.lastName,
      username: dto.username,
      phoneNumber: dto.phoneNumber,
      userRole: dto.userRole,
      profilePhotoUrl: dto.profilePhotoUrl,
      dateOfBirth: dto.dateOfBirth != null && dto.dateOfBirth!.isNotEmpty
          ? DateTime.parse(dto.dateOfBirth!)
          : null,
      createdAt: dto.createdAt != null && dto.createdAt!.isNotEmpty
          ? DateTime.parse(dto.createdAt!)
          : null,
    );
  }

  @override
  Future<String> uploadProfilePhoto(File photoFile) async {
    return await apiService.uploadProfilePhoto(photoFile);
  }

  @override
  Future<void> deleteProfilePhoto() async {
    await apiService.deleteProfilePhoto();
  }
}

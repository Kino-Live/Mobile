import 'dart:io';
import 'package:dio/dio.dart';
import 'package:kinolive_mobile/data/mappers/network_error_mapper.dart';
import 'package:kinolive_mobile/data/models/auth/profile_dto.dart';
import 'package:kinolive_mobile/shared/errors/app_exception.dart';

class AuthApiService {
  final Dio _dio;
  AuthApiService(this._dio);

  Future<String> login(String email, String password) {
    return _tryPostAndExtractToken('/login', {
      'email': email,
      'password': password,
    });
  }

  Future<String> register(String email, String password) {
    return _tryPostAndExtractToken('/register', {
      'email': email,
      'password': password,
    });
  }

  Future<String> _tryPostAndExtractToken(String endpoint, Map<String, dynamic> body) async {
    try {
      return await _postAndExtractToken(endpoint, body);
    } on DioException catch (e) {
      throw NetworkErrorMapper.map(e);
    } on AppException {
      rethrow;
    } catch (_) {
      throw const SomethingGetWrong();
    }
  }

  Future<String> _postAndExtractToken(String endpoint, Map<String, dynamic> body) async {
    final Response<dynamic> response = await _dio.post(endpoint, data: body);

    final responseData = response.data;
    if (responseData is! Map<String, dynamic>) {
      throw const InvalidResponseException('Empty response from server');
    }

    final token = responseData['token'];
    if (token is! String || token.isEmpty) {
      throw const InvalidResponseException('Token missing in response');
    }

    return token;
  }

  Future<ProfileDto> getProfile() async {
    try {
      final res = await _dio.get('/profile');

      final data = res.data;

      if (data is! Map<String, dynamic>) {
        throw const InvalidResponseException("Invalid profile response");
      }

      final profileJson = data['profile'];
      if (profileJson is! Map<String, dynamic>) {
        throw const InvalidResponseException("Profile missing in response");
      }

      return ProfileDto.fromJson(profileJson);
    } on DioException catch (e) {
      throw NetworkErrorMapper.map(e);
    } catch (_) {
      throw const SomethingGetWrong();
    }
  }

  Future<ProfileDto> updateProfile({
    String? firstName,
    String? lastName,
    String? username,
    String? phoneNumber,
    String? dateOfBirth,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (firstName != null) body['first_name'] = firstName;
      if (lastName != null) body['last_name'] = lastName;
      if (username != null) body['username'] = username;
      if (phoneNumber != null) body['phone_number'] = phoneNumber;
      if (dateOfBirth != null) body['date_of_birth'] = dateOfBirth;

      final res = await _dio.put('/profile', data: body);

      final data = res.data;

      if (data is! Map<String, dynamic>) {
        throw const InvalidResponseException("Invalid profile response");
      }

      final profileJson = data['profile'];
      if (profileJson is! Map<String, dynamic>) {
        throw const InvalidResponseException("Profile missing in response");
      }

      return ProfileDto.fromJson(profileJson);
    } on DioException catch (e) {
      throw NetworkErrorMapper.map(e);
    } catch (_) {
      throw const SomethingGetWrong();
    }
  }

  Future<String> uploadProfilePhoto(File photoFile) async {
    try {
      final filename = photoFile.path.split(RegExp(r'[/\\]')).last;
      
      final formData = FormData.fromMap({
        'photo': await MultipartFile.fromFile(
          photoFile.path,
          filename: filename,
        ),
      });

      final res = await _dio.post(
        '/profile/photo',
        data: formData,
      );

      final data = res.data;

      if (data is! Map<String, dynamic>) {
        throw const InvalidResponseException("Invalid response");
      }

      final photoUrl = data['profile_photo_url'];
      if (photoUrl is! String || photoUrl.isEmpty) {
        throw const InvalidResponseException("Photo URL missing in response");
      }

      return photoUrl;
    } on DioException catch (e) {
      throw NetworkErrorMapper.map(e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw SomethingGetWrong('Upload failed: ${e.toString()}');
    }
  }

  Future<void> deleteProfilePhoto() async {
    try {
      await _dio.delete('/profile/photo');
    } on DioException catch (e) {
      throw NetworkErrorMapper.map(e);
    } catch (_) {
      throw const SomethingGetWrong();
    }
  }
}

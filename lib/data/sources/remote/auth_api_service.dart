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
}

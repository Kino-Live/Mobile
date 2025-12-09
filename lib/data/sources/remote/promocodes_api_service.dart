import 'package:dio/dio.dart';
import 'package:kinolive_mobile/data/mappers/network_error_mapper.dart';
import 'package:kinolive_mobile/data/models/promocodes/promocode_dto.dart';
import 'package:kinolive_mobile/shared/errors/app_exception.dart';

class PromocodesApiService {
  final Dio _dio;
  PromocodesApiService(this._dio);

  Future<List<PromocodeDto>> getMyPromocodes() async {
    try {
      final Response<Map<String, dynamic>> resp = await _dio.get('/my-promocodes');

      final json = resp.data;
      if (json == null) {
        throw const InvalidResponseException('Empty response from server');
      }

      final promocodes = json['promocodes'];
      if (promocodes is! List) {
        return [];
      }

      return promocodes
          .map((item) => PromocodeDto.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw NetworkErrorMapper.map(e);
    } catch (_) {
      throw const SomethingGetWrong();
    }
  }
}


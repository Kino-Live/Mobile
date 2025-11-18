import 'package:dio/dio.dart';
import 'package:kinolive_mobile/data/mappers/network_error_mapper.dart';
import 'package:kinolive_mobile/data/models/payments/liqpay_init_payment_dto.dart';
import 'package:kinolive_mobile/shared/errors/app_exception.dart';

class LiqpayApiService {
  final Dio _dio;
  LiqpayApiService(this._dio);

  Future<LiqpayInitPaymentDto> createPayment({
    required double amount,
    required String currency,
    required String orderId,
    required String description,
    String? email,
  }) async {
    try {
      final Response<Map<String, dynamic>> resp = await _dio.post(
        '/liqpay/create-payment',
        data: {
          'amount': amount,
          'currency': currency,
          'order_id': orderId,
          'description': description,
          if (email != null) 'email': email,
        },
      );

      final json = resp.data;
      if (json == null) {
        throw const InvalidResponseException('Empty response from server');
      }

      final success = json['success'];
      if (success != true) {
        final error = json['error']?.toString() ?? 'LiqPay init failed';
        throw InvalidResponseException(error);
      }

      final data = json['data'];
      final signature = json['signature'];

      if (data is! String || signature is! String) {
        throw const InvalidResponseException('Malformed LiqPay init payload');
      }

      final params = json['params'];
      return LiqpayInitPaymentDto(
        data: data,
        signature: signature,
        params: params is Map<String, dynamic> ? params : null,
      );
    } on DioException catch (e) {
      throw NetworkErrorMapper.map(e);
    } on AppException {
      rethrow;
    } catch (_) {
      throw const SomethingGetWrong();
    }
  }
}

import 'package:dio/dio.dart';
import 'package:kinolive_mobile/data/mappers/network_error_mapper.dart';
import 'package:kinolive_mobile/data/models/orders/order_details_dto.dart';
import 'package:kinolive_mobile/data/models/orders/order_dto.dart';
import 'package:kinolive_mobile/shared/errors/app_exception.dart';

class OrdersApiService {
  final Dio _dio;
  OrdersApiService(this._dio);

  Future<OrderDto> createOrder({
    required String showtimeId,
    required int movieId,
    required int hallId,
    required List<String> seats,
    required double totalAmount,
    required String currency,
  }) async {
    try {
      final Response<Map<String, dynamic>> resp = await _dio.post(
        '/orders',
        data: {
          'showtime_id': showtimeId,
          'movie_id': movieId,
          'hall_id': hallId,
          'seats': seats,
          'total_amount': totalAmount,
          'currency': currency,
        },
      );

      final json = resp.data;
      if (json == null) {
        throw const InvalidResponseException('Empty response from server');
      }

      final order = json['order'];
      if (order is! Map<String, dynamic>) {
        throw const InvalidResponseException('Malformed order payload');
      }

      return OrderDto.fromJson(order);
    } on DioException catch (e) {
      throw NetworkErrorMapper.map(e);
    } on AppException {
      rethrow;
    } catch (_) {
      throw const SomethingGetWrong();
    }
  }

  Future<List<OrderDto>> getMyOrders() async {
    try {
      final Response<Map<String, dynamic>> resp = await _dio.get('/my-orders');

      final json = resp.data;
      if (json == null) {
        throw const InvalidResponseException('Empty response from server');
      }

      final orders = json['orders'];
      if (orders is! List) {
        return [];
      }

      return orders
          .whereType<Map<String, dynamic>>()
          .map(OrderDto.fromJson)
          .toList();
    } on DioException catch (e) {
      throw NetworkErrorMapper.map(e);
    } on AppException {
      rethrow;
    } catch (_) {
      throw const SomethingGetWrong();
    }
  }

  Future<OrderDetailsDto> getOrderDetails(String orderId) async {
    try {
      final Response<Map<String, dynamic>> resp =
      await _dio.get('/my-orders/$orderId');

      final json = resp.data;
      if (json == null) {
        throw const InvalidResponseException('Empty response from server');
      }

      return OrderDetailsDto.fromJson(json);
    } on DioException catch (e) {
      throw NetworkErrorMapper.map(e);
    } on AppException {
      rethrow;
    } catch (_) {
      throw const SomethingGetWrong();
    }
  }

  Future<OrderDto> refundOrder(String orderId) async {
    try {
      final Response<Map<String, dynamic>> resp =
      await _dio.post('/orders/$orderId/refund');

      final json = resp.data;
      if (json == null) {
        throw const InvalidResponseException('Empty response from server');
      }

      final order = json['order'];
      if (order is! Map<String, dynamic>) {
        throw const InvalidResponseException('Malformed order payload');
      }

      return OrderDto.fromJson(order);
    } on DioException catch (e) {
      throw NetworkErrorMapper.map(e);
    } on AppException {
      rethrow;
    } catch (_) {
      throw const SomethingGetWrong();
    }
  }
}

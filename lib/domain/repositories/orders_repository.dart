import 'package:kinolive_mobile/domain/entities/orders/order.dart';

abstract class OrdersRepository {
  Future<Order> createOrder({
    required String showtimeId,
    required int movieId,
    required int hallId,
    required List<String> seats,
    required double totalAmount,
    required String currency,
  });

  Future<List<Order>> getMyOrders();
}

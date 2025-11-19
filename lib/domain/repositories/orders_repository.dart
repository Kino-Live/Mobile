import 'package:kinolive_mobile/domain/entities/orders/order.dart';
import 'package:kinolive_mobile/domain/entities/orders/order_details.dart';

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

  Future<OrderDetails> getOrderDetails(String orderId);
}

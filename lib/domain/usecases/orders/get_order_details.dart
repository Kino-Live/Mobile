import 'package:kinolive_mobile/domain/entities/orders/order_details.dart';
import 'package:kinolive_mobile/domain/repositories/orders_repository.dart';

class GetOrderDetails {
  final OrdersRepository _repo;

  GetOrderDetails(this._repo);

  Future<OrderDetails> call(String orderId) {
    return _repo.getOrderDetails(orderId);
  }
}

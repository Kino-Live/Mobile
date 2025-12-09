import 'package:kinolive_mobile/domain/repositories/orders_repository.dart';

class RefundOrder {
  final OrdersRepository _repo;

  RefundOrder(this._repo);

  Future<Map<String, dynamic>> call(String orderId) {
    return _repo.refundOrder(orderId);
  }
}
import 'package:kinolive_mobile/domain/entities/orders/order.dart';
import 'package:kinolive_mobile/domain/repositories/orders_repository.dart';

class GetMyOrders {
  final OrdersRepository _repo;

  GetMyOrders(this._repo);

  Future<List<Order>> call() {
    return _repo.getMyOrders();
  }
}

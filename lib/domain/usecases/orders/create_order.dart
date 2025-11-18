import 'package:kinolive_mobile/domain/entities/orders/order.dart';
import 'package:kinolive_mobile/domain/repositories/orders_repository.dart';

class CreateOrder {
  final OrdersRepository _repo;

  CreateOrder(this._repo);

  Future<Order> call({
    required String showtimeId,
    required int movieId,
    required int hallId,
    required List<String> seats,
    required double totalAmount,
    required String currency,
  }) {
    return _repo.createOrder(
      showtimeId: showtimeId,
      movieId: movieId,
      hallId: hallId,
      seats: seats,
      totalAmount: totalAmount,
      currency: currency,
    );
  }
}

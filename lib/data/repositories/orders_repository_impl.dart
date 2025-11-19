import 'package:kinolive_mobile/data/models/orders/order_dto.dart';
import 'package:kinolive_mobile/data/models/orders/order_details_dto.dart';
import 'package:kinolive_mobile/data/sources/remote/orders_api_service.dart';
import 'package:kinolive_mobile/domain/entities/orders/order.dart';
import 'package:kinolive_mobile/domain/entities/orders/order_details.dart';
import 'package:kinolive_mobile/domain/repositories/orders_repository.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersApiService _api;

  OrdersRepositoryImpl(this._api);

  @override
  Future<Order> createOrder({
    required String showtimeId,
    required int movieId,
    required int hallId,
    required List<String> seats,
    required double totalAmount,
    required String currency,
  }) async {
    final dto = await _api.createOrder(
      showtimeId: showtimeId,
      movieId: movieId,
      hallId: hallId,
      seats: seats,
      totalAmount: totalAmount,
      currency: currency,
    );

    return orderFromDto(dto);
  }

  @override
  Future<List<Order>> getMyOrders() async {
    final dtoList = await _api.getMyOrders();
    return dtoList.map(orderFromDto).toList();
  }

  @override
  Future<OrderDetails> getOrderDetails(String orderId) async {
    final dto = await _api.getOrderDetails(orderId);
    return orderDetailsFromDto(dto);
  }
}

OrderStatus _mapStatus(String raw) {
  switch (raw) {
    case 'paid':
      return OrderStatus.paid;
    case 'cancelled':
      return OrderStatus.cancelled;
    case 'refunded':
      return OrderStatus.refunded;
    default:
      return OrderStatus.unknown;
  }
}

DateTime? _parseDateTimeOrNull(String? value) {
  if (value == null || value.isEmpty) return null;
  return DateTime.tryParse(value);
}

Order orderFromDto(OrderDto dto) {
  return Order(
    id: dto.orderId,
    userId: dto.userId,
    email: dto.email,
    showtimeId: dto.showtimeId,
    movieId: dto.movieId,
    hallId: dto.hallId,
    seats: List<String>.from(dto.seats),
    totalAmount: dto.totalAmount,
    currency: dto.currency,
    status: _mapStatus(dto.status),
    createdAt: DateTime.parse(dto.createdAt),
    paidAt: _parseDateTimeOrNull(dto.paidAt),
    cancelledAt: _parseDateTimeOrNull(dto.cancelledAt),
    refundedAt: _parseDateTimeOrNull(dto.refundedAt),
    payment: dto.payment,
  );
}

OrderDetails orderDetailsFromDto(OrderDetailsDto dto) {
  return OrderDetails(
    id: dto.orderId,
    movieId: dto.movieId,
    hallId: dto.hallId,
    showtimeId: dto.showtimeId,
    seats: List<String>.from(dto.seats),
    totalAmount: dto.totalAmount,
    currency: dto.currency,
    status: _mapStatus(dto.status),
    createdAt: DateTime.parse(dto.createdAt),
    paidAt: _parseDateTimeOrNull(dto.paidAt),
  );
}

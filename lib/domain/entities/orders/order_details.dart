import 'package:kinolive_mobile/domain/entities/orders/order.dart';

class OrderDetails {
  final String id;
  final int movieId;
  final int hallId;
  final String showtimeId;
  final List<String> seats;

  final double totalAmount;
  final String currency;

  final OrderStatus status;

  final DateTime createdAt;
  final DateTime? paidAt;

  const OrderDetails({
    required this.id,
    required this.movieId,
    required this.hallId,
    required this.showtimeId,
    required this.seats,
    required this.totalAmount,
    required this.currency,
    required this.status,
    required this.createdAt,
    this.paidAt,
  });

  bool get isPaid => status == OrderStatus.paid;
}

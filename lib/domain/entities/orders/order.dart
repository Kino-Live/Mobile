enum OrderStatus {
  paid,
  cancelled,
  refunded,
  unknown,
}

class Order {
  final String id;
  final String userId;
  final String email;

  final String showtimeId;
  final int movieId;
  final int hallId;
  final List<String> seats;

  final double totalAmount;
  final String currency;

  final OrderStatus status;

  final DateTime createdAt;
  final DateTime? paidAt;
  final DateTime? cancelledAt;
  final DateTime? refundedAt;

  final Map<String, dynamic>? payment;

  final String? movieTitle;
  final String? posterUrl;

  const Order({
    required this.id,
    required this.userId,
    required this.email,
    required this.showtimeId,
    required this.movieId,
    required this.hallId,
    required this.seats,
    required this.totalAmount,
    required this.currency,
    required this.status,
    required this.createdAt,
    this.paidAt,
    this.cancelledAt,
    this.refundedAt,
    this.payment,
    this.movieTitle,
    this.posterUrl,
  });

  bool get isPaid => status == OrderStatus.paid;
  bool get isCancelled => status == OrderStatus.cancelled;
  bool get isRefunded => status == OrderStatus.refunded;
}
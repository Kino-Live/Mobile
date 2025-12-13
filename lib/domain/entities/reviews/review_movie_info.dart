import 'package:kinolive_mobile/domain/entities/orders/order.dart';
import 'package:kinolive_mobile/domain/entities/online_movies/online_movie.dart';

class ReviewMovieInfo {
  final int movieId;
  final String movieTitle;
  final String posterUrl;
  final String statusLabel;
  final int statusColorValue;

  const ReviewMovieInfo({
    required this.movieId,
    required this.movieTitle,
    required this.posterUrl,
    required this.statusLabel,
    required this.statusColorValue,
  });

  factory ReviewMovieInfo.fromOrder(Order order) {
    return ReviewMovieInfo(
      movieId: order.movieId,
      movieTitle: order.movieTitle ?? 'Movie #${order.movieId}',
      posterUrl: order.posterUrl ?? '',
      statusLabel: _orderStatusLabel(order.status),
      statusColorValue: _orderStatusColor(order.status),
    );
  }

  factory ReviewMovieInfo.fromOnlineMovie(MyOnlineMovie movie) {
    return ReviewMovieInfo(
      movieId: movie.movieId,
      movieTitle: movie.title,
      posterUrl: movie.posterUrl,
      statusLabel: 'Online',
      statusColorValue: 0xFF2196F3, // Colors.blue
    );
  }

  static String _orderStatusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.paid:
        return 'Paid';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.refunded:
        return 'Refunded';
      default:
        return 'Unknown';
    }
  }

  static int _orderStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.paid:
        return 0xFF4CAF50; // Colors.green
      case OrderStatus.cancelled:
        return 0xFFF44336; // Colors.red
      case OrderStatus.refunded:
        return 0xFFFF9800; // Colors.orange
      default:
        return 0xFF2196F3; // Colors.blue
    }
  }
}

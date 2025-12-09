import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kinolive_mobile/domain/entities/orders/order.dart';

String formatDateTime(DateTime dt) {
  final d = dt.day.toString().padLeft(2, '0');
  final m = dt.month.toString().padLeft(2, '0');
  final y = dt.year.toString();
  final hh = dt.hour.toString().padLeft(2, '0');
  final mm = dt.minute.toString().padLeft(2, '0');
  return '$d.$m.$y $hh:$mm';
}

String formatReviewDateTime(DateTime dt, String localeString) {
  try {
    final dateFormat = DateFormat('d MMM yyyy, HH:mm', localeString);
    final formatted = dateFormat.format(dt.toLocal());
    return formatted.split(' ').map((word) {
      if (word.length > 0 && word.contains(RegExp(r'[a-zA-Z]'))) {
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      }
      return word;
    }).join(' ');
  } catch (e) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final localDt = dt.toLocal();
    final hh = localDt.hour.toString().padLeft(2, '0');
    final mm = localDt.minute.toString().padLeft(2, '0');
    return '${localDt.day} ${months[localDt.month - 1]} ${localDt.year}, $hh:$mm';
  }
}

String shortenSeats(List<String> seats, {int max = 5}) {
  if (seats.isEmpty) return '-';
  if (seats.length <= max) {
    return seats.join(', ');
  }
  final visible = seats.take(max).join(', ');
  return '$visible...';
}

String statusLabel(OrderStatus status) {
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

Color statusColor(OrderStatus status, BuildContext context) {
  switch (status) {
    case OrderStatus.paid:
      return Colors.green;
    case OrderStatus.cancelled:
      return Colors.red;
    case OrderStatus.refunded:
      return Colors.orange;
    default:
      return Theme.of(context).colorScheme.primary;
  }
}

DateTime historySortKey(Order o) {
  if (o.refundedAt != null) return o.refundedAt!;
  if (o.cancelledAt != null) return o.cancelledAt!;

  final now = DateTime.now();
  final show = o.showStart;
  if (show != null && show.isBefore(now)) {
    return show;
  }

  return o.createdAt;
}

bool isHistoryOrder(Order o) {
  if (o.status != OrderStatus.paid) {
    return true;
  }
  final DateTime showStart = o.showStart ?? o.createdAt;
  return showStart.isBefore(DateTime.now());
}


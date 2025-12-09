enum PromocodeStatus { active, used, expired }

class Promocode {
  final String id;
  final String code;
  final String userEmail;
  final double amount;
  final String currency;
  final DateTime createdAt;
  final DateTime expiresAt;
  final DateTime? usedAt;
  final String orderId;
  final String? usedInOrderId;
  final PromocodeStatus status;
  final bool isActive;

  const Promocode({
    required this.id,
    required this.code,
    required this.userEmail,
    required this.amount,
    required this.currency,
    required this.createdAt,
    required this.expiresAt,
    this.usedAt,
    required this.orderId,
    this.usedInOrderId,
    required this.status,
    required this.isActive,
  });
}


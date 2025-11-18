class LiqpayInitPayment {
  final String data;

  final String signature;

  final Map<String, dynamic>? rawParams;

  const LiqpayInitPayment({
    required this.data,
    required this.signature,
    this.rawParams,
  });
}

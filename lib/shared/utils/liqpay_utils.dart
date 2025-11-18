import 'dart:convert';
import 'package:crypto/crypto.dart';

const String liqpayPublicKey  = 'sandbox_i75693473668';
const String liqpayPrivateKey = 'sandbox_B1zUK1V3g9LmOfpWppduuq7hrDxrXm0Epw6F6Ojd';

Map<String, dynamic> buildLiqpayParams({
  required double amount,
  required String currency,
  required String orderId,
  required String description,
}) {
  return {
    'public_key': liqpayPublicKey,
    'version': 3,
    'action': 'pay',
    'amount': amount.toStringAsFixed(2),
    'currency': currency,
    'description': description,
    'order_id': orderId,

    'result_url': 'https://test.kinolive/payment_success',
    'server_url': 'https://test.kinolive/payment_callback',

    'sandbox': 1,
  };
}

String buildLiqpayData(Map<String, dynamic> params) {
  final json = jsonEncode(params);
  final bytes = utf8.encode(json);
  return base64Encode(bytes);
}

String buildLiqpaySignature(String data) {
  final bytes = utf8.encode(liqpayPrivateKey + data + liqpayPrivateKey);
  final hash = sha1.convert(bytes).bytes;
  return base64Encode(hash);
}

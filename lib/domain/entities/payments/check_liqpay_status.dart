import 'package:kinolive_mobile/domain/repositories/liqpay_repository.dart';

class CheckLiqPayStatus {
  final LiqPayRepository _repo;

  CheckLiqPayStatus(this._repo);

  Future<String> call({required String orderId}) {
    return _repo.checkPaymentStatus(orderId: orderId);
  }
}

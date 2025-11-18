import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinolive_mobile/data/repositories/liqpay_repository_impl.dart';
import 'package:kinolive_mobile/data/sources/remote/liqpay_api_service.dart';
import 'package:kinolive_mobile/domain/repositories/liqpay_repository.dart';
import 'package:kinolive_mobile/domain/usecases/payments/init_liqpay_payment.dart';
import 'package:kinolive_mobile/shared/providers/network/dio_provider.dart';

final liqPayApiServiceProvider = Provider<LiqPayApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return LiqPayApiService(dio);
});

final liqPayRepositoryProvider = Provider<LiqPayRepository>((ref) {
  final api = ref.watch(liqPayApiServiceProvider);
  return LiqPayRepositoryImpl(api);
});

final initLiqPayPaymentProvider = Provider<InitLiqPayPayment>((ref) {
  final repo = ref.watch(liqPayRepositoryProvider);
  return InitLiqPayPayment(repo);
});

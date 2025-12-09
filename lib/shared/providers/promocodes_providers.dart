import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinolive_mobile/data/repositories/promocodes_repository_impl.dart';
import 'package:kinolive_mobile/data/sources/remote/promocodes_api_service.dart';
import 'package:kinolive_mobile/domain/repositories/promocodes_repository.dart';
import 'package:kinolive_mobile/domain/usecases/promocodes/get_my_promocodes.dart';
import 'package:kinolive_mobile/shared/providers/network/dio_provider.dart';

final promocodesApiServiceProvider = Provider<PromocodesApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return PromocodesApiService(dio);
});

final promocodesRepositoryProvider = Provider<PromocodesRepository>((ref) {
  final api = ref.watch(promocodesApiServiceProvider);
  return PromocodesRepositoryImpl(api);
});

final getMyPromocodesProvider = Provider<GetMyPromocodes>((ref) {
  final repo = ref.watch(promocodesRepositoryProvider);
  return GetMyPromocodes(repo);
});


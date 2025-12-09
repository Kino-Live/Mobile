import 'package:kinolive_mobile/data/models/promocodes/promocode_dto.dart';
import 'package:kinolive_mobile/data/sources/remote/promocodes_api_service.dart';
import 'package:kinolive_mobile/domain/entities/promocodes/promocode.dart';
import 'package:kinolive_mobile/domain/repositories/promocodes_repository.dart';

class PromocodesRepositoryImpl implements PromocodesRepository {
  final PromocodesApiService _api;

  PromocodesRepositoryImpl(this._api);

  @override
  Future<List<Promocode>> getMyPromocodes() async {
    final dtoList = await _api.getMyPromocodes();
    final promocodes = dtoList.map(promocodeFromDto).toList();
    promocodes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return promocodes;
  }
}

Promocode promocodeFromDto(PromocodeDto dto) {
  PromocodeStatus status;
  switch (dto.status) {
    case 'active':
      status = PromocodeStatus.active;
      break;
    case 'used':
      status = PromocodeStatus.used;
      break;
    case 'expired':
      status = PromocodeStatus.expired;
      break;
    default:
      status = PromocodeStatus.expired;
  }

  return Promocode(
    id: dto.id,
    code: dto.code,
    userEmail: dto.userEmail,
    amount: dto.amount,
    currency: dto.currency,
    createdAt: DateTime.parse(dto.createdAt),
    expiresAt: DateTime.parse(dto.expiresAt),
    usedAt: dto.usedAt != null ? DateTime.parse(dto.usedAt!) : null,
    orderId: dto.orderId,
    usedInOrderId: dto.usedInOrderId,
    status: status,
    isActive: dto.isActive,
  );
}


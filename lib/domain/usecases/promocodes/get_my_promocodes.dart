import 'package:kinolive_mobile/domain/entities/promocodes/promocode.dart';
import 'package:kinolive_mobile/domain/repositories/promocodes_repository.dart';

class GetMyPromocodes {
  final PromocodesRepository _repository;

  GetMyPromocodes(this._repository);

  Future<List<Promocode>> call() {
    return _repository.getMyPromocodes();
  }
}


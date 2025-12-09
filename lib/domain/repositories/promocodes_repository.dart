import 'package:kinolive_mobile/domain/entities/promocodes/promocode.dart';

abstract class PromocodesRepository {
  Future<List<Promocode>> getMyPromocodes();
}


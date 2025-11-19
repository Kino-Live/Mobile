import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinolive_mobile/data/repositories/orders_repository_impl.dart';
import 'package:kinolive_mobile/data/sources/remote/orders_api_service.dart';
import 'package:kinolive_mobile/domain/repositories/orders_repository.dart';
import 'package:kinolive_mobile/domain/usecases/orders/create_order.dart';
import 'package:kinolive_mobile/domain/usecases/orders/get_my_orders.dart';
import 'package:kinolive_mobile/domain/usecases/orders/get_order_details.dart';
import 'package:kinolive_mobile/shared/providers/network/dio_provider.dart';

final ordersApiServiceProvider = Provider<OrdersApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return OrdersApiService(dio);
});

final ordersRepositoryProvider = Provider<OrdersRepository>((ref) {
  final api = ref.watch(ordersApiServiceProvider);
  return OrdersRepositoryImpl(api);
});

final createOrderProvider = Provider<CreateOrder>((ref) {
  final repo = ref.watch(ordersRepositoryProvider);
  return CreateOrder(repo);
});

final getMyOrdersProvider = Provider<GetMyOrders>((ref) {
  final repo = ref.watch(ordersRepositoryProvider);
  return GetMyOrders(repo);
});

final getOrderDetailsProvider = Provider<GetOrderDetails>((ref) {
  final repo = ref.watch(ordersRepositoryProvider);
  return GetOrderDetails(repo);
});
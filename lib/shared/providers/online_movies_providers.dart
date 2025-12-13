import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinolive_mobile/data/repositories/online_movies_repository_impl.dart';
import 'package:kinolive_mobile/data/sources/remote/online_movies_api_service.dart';
import 'package:kinolive_mobile/domain/repositories/online_movies_repository.dart';
import 'package:kinolive_mobile/shared/providers/network/dio_provider.dart';

final onlineMoviesApiServiceProvider = Provider<OnlineMoviesApiService>((ref) {
  return OnlineMoviesApiService(ref.read(dioProvider));
});

final onlineMoviesRepositoryProvider = Provider<OnlineMoviesRepository>((ref) {
  return OnlineMoviesRepositoryImpl(ref.read(onlineMoviesApiServiceProvider));
});


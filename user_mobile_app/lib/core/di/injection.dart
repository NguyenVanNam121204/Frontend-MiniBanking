import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../network/dio_client.dart';
import '../../services/storage_service.dart';
import '../../services/auth/auth_service.dart';
import '../../repositories/auth/auth_repository.dart';

final getIt = GetIt.instance;

Future<void> setupInjection() async {
  // Services
  getIt.registerLazySingleton<FlutterSecureStorage>(() => const FlutterSecureStorage());
  getIt.registerLazySingleton<StorageService>(() => StorageService(getIt()));
  
  // Network
  getIt.registerLazySingleton<Dio>(() => createDio(getIt<StorageService>()));

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository(getIt<Dio>()));

  // Services (Logic)
  getIt.registerLazySingleton<AuthService>(() => AuthService(getIt<AuthRepository>(), getIt<StorageService>()));
}

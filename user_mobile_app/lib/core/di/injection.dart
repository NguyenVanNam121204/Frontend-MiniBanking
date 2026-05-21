import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../network/dio_client.dart';
import '../../services/storage_service.dart';
import '../../services/realtime_event_service.dart';
import '../../services/auth/auth_service.dart';
import '../../repositories/auth/auth_repository.dart';
import '../../repositories/auth/auth_repository_impl.dart';
import '../../repositories/account/account_repository.dart';
import '../../repositories/account/account_repository_impl.dart';
import '../../services/account/account_service.dart';

final getIt = GetIt.instance;

Future<void> setupInjection() async {
  // Services
  getIt.registerLazySingleton<FlutterSecureStorage>(() => const FlutterSecureStorage());
  getIt.registerLazySingleton<StorageService>(() => StorageService(getIt()));
  getIt.registerLazySingleton<RealtimeEventService>(() => RealtimeEventService(getIt<StorageService>()));
  
  // Network
  getIt.registerLazySingleton<Dio>(() => createDio(getIt<StorageService>()));

  // Repositories
  getIt.registerLazySingleton<IAuthRepository>(() => AuthRepositoryImpl(getIt<Dio>()));
  getIt.registerLazySingleton<IAccountRepository>(() => AccountRepositoryImpl(getIt<Dio>()));
  // Services (Logic)
  getIt.registerLazySingleton<AuthService>(() => AuthService(getIt<IAuthRepository>(), getIt<StorageService>()));
  getIt.registerLazySingleton<AccountService>(() => AccountService(getIt<IAccountRepository>()));
}

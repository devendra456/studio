import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studio/application/auth/auth_service.dart';
import 'package:studio/application/download/download_service.dart';
import 'package:studio/application/favorites/favorites_service.dart';
import 'package:studio/application/network/network_info.dart';
import 'package:studio/application/preferences/app_preferences_impl.dart';
import 'package:studio/data/data_source/on_boarding_local_data_source.dart';
import 'package:studio/data/data_source/on_boarding_remote_data_source.dart';
import 'package:studio/data/repos/on_boarding_repos_impl.dart';

import '../../domain/repos/on_boarding_repos.dart';
import '../../domain/use_cases/load_images_use_case.dart';
import '../preferences/app_preferences.dart';

final GetIt getIt = GetIt.instance;

Future<void> setUpDi() async {
  final NetworkInfo networkInfo = NetworkInfoImpl(Connectivity());
  getIt.registerFactory<NetworkInfo>(() => networkInfo);
  final OnBoardingRepos onBoardingRepos = OnBoardingReposImpl(
    networkInfo: networkInfo,
    onBoardingRemoteDataSource: OnBoardingRemoteDataSourceImpl(),
    onBoardingLocalDataSource: OnBoardingLocalDataSourceImpl(),
  );
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  final AppPreferences appPreferences = AppPreferencesIMPL(sharedPreferences);
  getIt.registerFactory<OnBoardingRepos>(() => onBoardingRepos);
  getIt.registerFactory<AppPreferences>(() => appPreferences);
  getIt.registerFactory<Dio>(() => Dio());
  getIt.registerFactory<DefaultCacheManager>(() => DefaultCacheManager());
  getIt.registerFactory<LoadImagesUseCase>(
      () => LoadImagesUseCase(onBoardingRepos));
  
  // Register AuthService as a singleton
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  
  // Register FavoritesService as a singleton
  getIt.registerLazySingleton<FavoritesService>(() => FavoritesService());
  
  // Register DownloadService as a singleton
  getIt.registerLazySingleton<DownloadService>(() => DownloadService(
    cacheManager: getIt.get<DefaultCacheManager>(),
    dio: getIt.get<Dio>(),
  ));
}

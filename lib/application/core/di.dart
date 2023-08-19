import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studio/application/preferences/app_preferences_impl.dart';
import 'package:studio/data/repos/on_boarding_repos_impl.dart';

import '../../domain/repos/on_boarding_repos.dart';
import '../../domain/use_cases/load_images_use_case.dart';
import '../preferences/app_preferences.dart';

final GetIt getIt = GetIt.instance;

Future<void> setUpDi() async {
  final OnBoardingRepos onBoardingRepos = OnBoardingReposImpl();
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  final AppPreferences appPreferences = AppPreferencesIMPL(sharedPreferences);
  getIt.registerFactory<OnBoardingRepos>(() => onBoardingRepos);
  getIt.registerFactory<AppPreferences>(() => appPreferences);
  getIt.registerFactory<LoadImagesUseCase>(
      () => LoadImagesUseCase(onBoardingRepos));
}

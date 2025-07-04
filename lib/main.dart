import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:studio/application/preferences/app_preferences.dart';
import 'package:studio/domain/entities/image_entity.dart';
import 'package:studio/domain/use_cases/load_images_use_case.dart';
import 'package:studio/firebase_options.dart';
import 'package:studio/presentation/auth/auth_wrapper.dart';
import 'package:studio/presentation/auth/login_screen.dart';
import 'package:studio/presentation/on_boarding/bloc/on_boarding_bloc.dart';
import 'package:studio/presentation/on_boarding/views/on_boarding_screen.dart';

import 'application/core/di.dart';
import 'application/routes/route_names.dart';
import 'presentation/favorites/favorites_screen.dart';
import 'presentation/image_viewer/image_viewer_screen.dart';
import 'presentation/settings/setting_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    case TargetPlatform.fuchsia:
    case TargetPlatform.iOS:
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    case TargetPlatform.linux:
    case TargetPlatform.macOS:
    case TargetPlatform.windows:
  }
  await setUpDi();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final bloc = OnBoardingBloc(getIt.get<LoadImagesUseCase>(),
                getIt.get<AppPreferences>(), getIt());
            return bloc;
          },
        )
      ],
      child: DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
          return MaterialApp(
            title: 'Studio',
            themeMode: ThemeMode.system,
            darkTheme: ThemeData(
              colorScheme: lightDynamic,
              useMaterial3: true,
              scaffoldBackgroundColor: Colors.black,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              popupMenuTheme: const PopupMenuThemeData(
                color: Colors.black,
                shadowColor: Colors.grey,
              ),
              textTheme: const TextTheme(
                bodyMedium: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
            theme: ThemeData(
              colorScheme: darkDynamic,
              useMaterial3: true,
              textTheme: TextTheme(
                bodyMedium: TextStyle(
                  color: darkDynamic == null ? Colors.black : Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
            routes: {
              Navigator.defaultRouteName: (context) => const AuthWrapper(),
              RouteName.home: (context) => const OnBoardingScreen(),
              RouteName.login: (context) => const LoginScreen(),
              RouteName.imageViewer: (context) {
                final PageImageData url =
                    ModalRoute.of(context)?.settings.arguments as PageImageData;
                return ImageViewerScreen(
                  imageEntity: url,
                  defaultCacheManager: getIt.get<DefaultCacheManager>(),
                );
              },
              RouteName.setting: (context) => const SettingScreen(),
              RouteName.favorites: (context) => const FavoritesScreen(),
            },
            initialRoute: Navigator.defaultRouteName,
          );
        },
      ),
    );
  }
}

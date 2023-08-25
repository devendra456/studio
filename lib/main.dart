import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studio/application/preferences/app_preferences.dart';
import 'package:studio/domain/use_cases/load_images_use_case.dart';
import 'package:studio/presentation/on_boarding/bloc/on_boarding_bloc.dart';

import 'application/core/di.dart';
import 'application/routes/route_setting.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
            final bloc = OnBoardingBloc(
                getIt.get<LoadImagesUseCase>(), getIt.get<AppPreferences>());
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
                shadowColor: Colors.white24,
              ),
              textTheme: const TextTheme(
                  bodyMedium: TextStyle(color: Colors.white60, fontSize: 16)),
            ),
            theme: ThemeData(
              colorScheme: darkDynamic,
              useMaterial3: true,
              textTheme: const TextTheme(
                  bodyMedium: TextStyle(color: Colors.black87, fontSize: 16)),
            ),
            initialRoute: Navigator.defaultRouteName,
            onGenerateRoute: onGenerateRoute,
          );
        },
      ),
    );
  }
}

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
            final bloc = OnBoardingBloc(getIt.get<LoadImagesUseCase>(),getIt.get<AppPreferences>());
            return bloc;
          },
        )
      ],
      child: MaterialApp(
        title: 'Studio',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: Navigator.defaultRouteName,
        onGenerateRoute: onGenerateRoute,
      ),
    );
  }

}

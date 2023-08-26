import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:studio/application/core/di.dart';
import 'package:studio/application/routes/route_names.dart';
import 'package:studio/presentation/image_viewer/image_viewer_screen.dart';
import 'package:studio/presentation/settings/setting_screen.dart';

import '../../presentation/on_boarding/views/on_boarding_screen.dart';

Route? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Navigator.defaultRouteName:
      return MaterialPageRoute(
        builder: (context) {
          return const OnBoardingScreen();
        },
      );
    case RouteName.imageViewer:
      return MaterialPageRoute(
        builder: (context) {
          final String url = settings.arguments as String;
          return ImageViewerScreen(
            url: url,
            defaultCacheManager: getIt.get<DefaultCacheManager>(),
          );
        },
      );
    case RouteName.setting:
      return MaterialPageRoute(
        builder: (context) {
          return const SettingScreen();
        },
      );
  }
  return null;
}

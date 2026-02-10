import 'package:auto_route/auto_route.dart';
import '../features/hydration/pages/home_page.dart';
import '../features/settings/pages/settings_page.dart';

part 'app_router.gr.dart';

/// Auto Route configuration for app navigation
@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    // Home route - initial route
    AutoRoute(page: HomeRoute.page, initial: true, path: '/'),

    // Settings route
    AutoRoute(page: SettingsRoute.page, path: '/settings'),
  ];
}

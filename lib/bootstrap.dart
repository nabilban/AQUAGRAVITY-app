import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app/providers/injection.dart';
import 'app/router/app_router.dart';
import 'app/ui/theme/app_theme.dart';
import 'app/features/hydration/cubit/hydration_cubit.dart';
import 'app/features/settings/cubit/theme_cubit.dart';
import 'app/features/settings/cubit/theme_state.dart';

/// Bootstrap the application
Future<void> bootstrap({required String environment}) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await configureDependencies();

  runApp(AquaGravityApp(environment: environment));
}

/// Main application widget
class AquaGravityApp extends StatefulWidget {
  final String environment;

  const AquaGravityApp({super.key, required this.environment});

  @override
  State<AquaGravityApp> createState() => _AquaGravityAppState();
}

class _AquaGravityAppState extends State<AquaGravityApp> {
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<HydrationCubit>()),
        BlocProvider(create: (_) => getIt<ThemeCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: 'AQUAGRAVITY',
            theme: AppTheme.lightTheme(),
            darkTheme: AppTheme.darkTheme(),
            themeMode: state.themeMode,
            routerConfig: _appRouter.config(),
            debugShowCheckedModeBanner: widget.environment != 'production',
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _appRouter.dispose();
    super.dispose();
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../ui/constants/app_dimens.dart';
import '../cubit/theme_cubit.dart';

/// Settings page for user preferences
@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'User Preferences',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Gap(AppDimens.x4),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimens.x4),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.water_drop),
                        title: const Text('Daily Goal'),
                        subtitle: const Text('2000 ml'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // TODO: Implement daily goal settings
                        },
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.brightness_medium),
                        title: const Text('Theme'),
                        subtitle: Text(
                          _getThemeText(
                            context.watch<ThemeCubit>().state.themeMode,
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _showThemeDialog(context),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.notifications),
                        title: const Text('Reminders'),
                        subtitle: const Text('Every 60 minutes'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // TODO: Implement reminder settings
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(AppDimens.x6),
              Text('About', style: Theme.of(context).textTheme.titleLarge),
              const Gap(AppDimens.x4),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimens.x4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AQUAGRAVITY',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Gap(AppDimens.x2),
                      Text(
                        'Stay Hydrated. Stay Grounded.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const Gap(AppDimens.x3),
                      Text(
                        'Version 1.0.0',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getThemeText(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'System Default';
      case ThemeMode.light:
        return 'Light Mode';
      case ThemeMode.dark:
        return 'Dark Mode';
    }
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Select Theme'),
          children: [
            _buildThemeOption(context, ThemeMode.system, 'System Default'),
            _buildThemeOption(context, ThemeMode.light, 'Light Mode'),
            _buildThemeOption(context, ThemeMode.dark, 'Dark Mode'),
          ],
        );
      },
    );
  }

  Widget _buildThemeOption(BuildContext context, ThemeMode mode, String label) {
    return SimpleDialogOption(
      onPressed: () {
        context.read<ThemeCubit>().updateTheme(mode);
        Navigator.pop(context);
      },
      child: Text(label),
    );
  }
}

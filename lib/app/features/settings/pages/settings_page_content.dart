import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../ui/constants/app_dimens.dart';
import '../../hydration/cubit/hydration_cubit.dart';
import '../../hydration/cubit/hydration_state.dart';

/// Settings page for configuring daily goals, reminders, and app preferences
class SettingsPageContent extends StatefulWidget {
  const SettingsPageContent({super.key});

  @override
  State<SettingsPageContent> createState() => _SettingsPageContentState();
}

class _SettingsPageContentState extends State<SettingsPageContent> {
  final TextEditingController _dailyGoalController = TextEditingController();
  final TextEditingController _intervalController = TextEditingController();
  late final ValueNotifier<bool> _remindersEnabledNotifier = ValueNotifier(
    false,
  );

  // Track original values to detect changes
  double? _originalDailyGoal;
  bool _originalRemindersEnabled = false;
  int _originalInterval = 60;

  bool _isInitialized = false;

  @override
  void dispose() {
    _dailyGoalController.dispose();
    _intervalController.dispose();
    _remindersEnabledNotifier.dispose();
    super.dispose();
  }

  void _initializeFromState(
    double dailyGoal,
    bool reminderEnabled,
    int reminderInterval,
  ) {
    if (!_isInitialized) {
      _originalDailyGoal = dailyGoal;
      _dailyGoalController.text = dailyGoal.toInt().toString();
      _originalRemindersEnabled = reminderEnabled;
      _originalInterval = reminderInterval;
      _remindersEnabledNotifier.value = reminderEnabled;
      _intervalController.text = reminderInterval.toString();
      _isInitialized = true;
    }
  }

  bool _hasChanges() {
    if (_originalDailyGoal == null) return false;

    final currentGoal = double.tryParse(_dailyGoalController.text);
    if (currentGoal == null) return false;

    final currentInterval =
        int.tryParse(_intervalController.text) ?? _originalInterval;

    return currentGoal != _originalDailyGoal ||
        _remindersEnabledNotifier.value != _originalRemindersEnabled ||
        currentInterval != _originalInterval;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HydrationCubit, HydrationState>(
      builder: (context, state) {
        return state.when(
          initial: () => const Center(child: CircularProgressIndicator()),
          loading: () => const Center(child: CircularProgressIndicator()),
          loaded:
              (
                logs,
                _,
                todayTotal,
                dailyGoal,
                reminderEnabled,
                reminderInterval,
              ) {
                _initializeFromState(
                  dailyGoal,
                  reminderEnabled,
                  reminderInterval,
                );
                return _buildContent(context, dailyGoal);
              },
          error: (message) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error,
                  size: 64,
                  color: Theme.of(context).colorScheme.error,
                ),
                const Gap(AppDimens.x4),
                Text(
                  'Error: $message',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                const Gap(AppDimens.x4),
                ElevatedButton(
                  onPressed: () {
                    context.read<HydrationCubit>().refresh();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, double currentDailyGoal) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.x4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Gap(AppDimens.x4),

            // Daily Goal Card
            _buildDailyGoalCard(context),
            const Gap(AppDimens.x4),

            // Reminders Card
            _buildRemindersCard(context),
            const Gap(AppDimens.x6),

            // Save Settings Button
            _buildSaveButton(context),
            const Gap(AppDimens.x6),

            // Danger Zone
            _buildDangerZone(context),
            const Gap(AppDimens.x8),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyGoalCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.x5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.outlineVariant.withValues(alpha: 0.05),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimens.x3),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.secondary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.track_changes,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 24,
                ),
              ),
              const Gap(AppDimens.x3),
              Text(
                'Daily Goal',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const Gap(AppDimens.x5),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Target (ml)',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              SizedBox(
                width: 120,
                child: TextField(
                  controller: _dailyGoalController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  onChanged: (_) {}, // Let ListenableBuilder update save button
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        width: 2,
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.x4,
                      vertical: AppDimens.x3,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Gap(AppDimens.x4),
          Container(
            padding: const EdgeInsets.all(AppDimens.x3),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.amber.withValues(alpha: 0.1)
                  : Colors.amber.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.amber.withValues(alpha: 0.3)
                    : Colors.amber.shade200,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  size: 16,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.amber.shade400
                      : Colors.amber.shade700,
                ),
                const Gap(AppDimens.x2),
                Expanded(
                  child: Text(
                    'Recommended: 2000-3000 ml per day for adults',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.amber.shade100
                          : Colors.amber.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemindersCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.x5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.outlineVariant.withValues(alpha: 0.05),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimens.x3),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_outlined,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
              ),
              const Gap(AppDimens.x3),
              Text(
                'Reminders',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const Gap(AppDimens.x5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Enable reminders',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              ValueListenableBuilder<bool>(
                valueListenable: _remindersEnabledNotifier,
                builder: (context, remindersEnabled, _) {
                  return Switch(
                    value: remindersEnabled,
                    onChanged: (value) {
                      _remindersEnabledNotifier.value = value;
                    },
                    activeTrackColor: Theme.of(
                      context,
                    ).colorScheme.secondary.withValues(alpha: 0.5),
                    activeThumbColor: Theme.of(context).colorScheme.secondary,
                  );
                },
              ),
            ],
          ),
          const Gap(AppDimens.x2),
          ValueListenableBuilder<bool>(
            valueListenable: _remindersEnabledNotifier,
            builder: (context, remindersEnabled, _) {
              return Row(
                children: [
                  Expanded(
                    child: Text(
                      'Interval (minutes)',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    child: TextField(
                      controller: _intervalController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      enabled: remindersEnabled,
                      onChanged:
                          (_) {}, // Let ListenableBuilder update save button
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: remindersEnabled
                            ? Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest
                            : Theme.of(
                                context,
                              ).disabledColor.withValues(alpha: 0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            width: 2,
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            width: 2,
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            width: 2,
                            color: Theme.of(
                              context,
                            ).colorScheme.outlineVariant.withValues(alpha: 0.2),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppDimens.x4,
                          vertical: AppDimens.x3,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          // Dev Only
          // const Gap(AppDimens.x4),
          // SizedBox(
          //   width: double.infinity,
          //   child: OutlinedButton.icon(
          //     onPressed: () {
          //       context.read<HydrationCubit>().testNotification();
          //     },
          //     icon: const Icon(Icons.notifications_active_outlined),
          //     label: const Text('Test Immediate Notification'),
          //     style: OutlinedButton.styleFrom(
          //       padding: const EdgeInsets.symmetric(vertical: 12),
          //       side: BorderSide(color: Theme.of(context).colorScheme.primary),
          //       foregroundColor: Theme.of(context).colorScheme.primary,
          //     ),
          //   ),
          // ),
          const Gap(AppDimens.x4),
          Container(
            padding: const EdgeInsets.all(AppDimens.x3),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.orange.withValues(alpha: 0.1)
                  : Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.orange.withValues(alpha: 0.3)
                    : Colors.orange.shade200,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber,
                  size: 16,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.orange.shade400
                      : Colors.orange.shade700,
                ),
                const Gap(AppDimens.x2),
                Expanded(
                  child: Text(
                    'Browser notifications require permission and may not work on all devices',
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.orange.shade100
                          : Colors.orange.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        _dailyGoalController,
        _remindersEnabledNotifier,
        _intervalController,
      ]),
      builder: (context, _) {
        final hasChanges = _hasChanges();

        return AnimatedOpacity(
          opacity: hasChanges ? 1.0 : 0.5,
          duration: const Duration(milliseconds: 300),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: hasChanges
                    ? [
                        Theme.of(context).colorScheme.secondary,
                        Theme.of(context).colorScheme.primary,
                      ]
                    : [
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                        Theme.of(context).colorScheme.outline,
                      ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: hasChanges
                  ? [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).colorScheme.secondary.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: ElevatedButton(
              onPressed: hasChanges ? () => _saveSettings(context) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                disabledBackgroundColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: AppDimens.x4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: hasChanges
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline,
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.save,
                    color: hasChanges ? Colors.white : Colors.white70,
                  ),
                  const Gap(AppDimens.x2),
                  Text(
                    'Save Settings',
                    style: TextStyle(
                      color: hasChanges ? Colors.white : Colors.white70,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDangerZone(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.x5),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.errorContainer.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          width: 2,
          color: Theme.of(context).colorScheme.error.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Danger Zone !',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          const Gap(AppDimens.x4),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _showClearDataDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.errorContainer,
                padding: const EdgeInsets.symmetric(vertical: AppDimens.x4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.delete_forever,
                    color: Theme.of(context).colorScheme.onError,
                  ),
                  Gap(AppDimens.x2),
                  Text(
                    'Clear All Data',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onError,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveSettings(BuildContext context) {
    final dailyGoal = double.tryParse(_dailyGoalController.text);

    if (dailyGoal != null && dailyGoal > 0) {
      final cubit = context.read<HydrationCubit>();

      if (dailyGoal != _originalDailyGoal) {
        cubit.updateDailyGoal(dailyGoal);
      }

      if (_remindersEnabledNotifier.value != _originalRemindersEnabled) {
        cubit.toggleReminders(_remindersEnabledNotifier.value);
      }

      final interval = int.tryParse(_intervalController.text);
      if (interval != null && interval != _originalInterval) {
        cubit.updateReminderInterval(interval);
      }

      // Update original values after successful save
      setState(() {
        _originalDailyGoal = dailyGoal;
        _originalRemindersEnabled = _remindersEnabledNotifier.value;
        _originalInterval = int.tryParse(_intervalController.text) ?? 60;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              Gap(AppDimens.x2),
              Text('Settings saved successfully!'),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              Gap(AppDimens.x2),
              Text('Please enter a valid daily goal'),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            Gap(AppDimens.x2),
            Text('Clear All Data?'),
          ],
        ),
        content: const Text(
          'This will permanently delete all your hydration logs. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<HydrationCubit>().clearAllLogs();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.delete, color: Colors.white),
                      Gap(AppDimens.x2),
                      Text('All data cleared'),
                    ],
                  ),
                  backgroundColor: Theme.of(context).colorScheme.error,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text(
              'Clear Data',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

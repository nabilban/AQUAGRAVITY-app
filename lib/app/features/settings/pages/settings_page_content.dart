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
  bool _remindersEnabled = false;

  // Track original values to detect changes
  double? _originalDailyGoal;
  bool _originalRemindersEnabled = false;
  int _originalInterval = 60;

  bool _isInitialized = false;

  @override
  void dispose() {
    _dailyGoalController.dispose();
    _intervalController.dispose();
    super.dispose();
  }

  void _initializeFromState(double dailyGoal) {
    if (!_isInitialized) {
      _originalDailyGoal = dailyGoal;
      _dailyGoalController.text = dailyGoal.toInt().toString();
      _intervalController.text = _originalInterval.toString();
      _remindersEnabled = _originalRemindersEnabled;
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
        _remindersEnabled != _originalRemindersEnabled ||
        currentInterval != _originalInterval;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HydrationCubit, HydrationState>(
      builder: (context, state) {
        return state.when(
          initial: () => const Center(child: CircularProgressIndicator()),
          loading: () => const Center(child: CircularProgressIndicator()),
          loaded: (logs, todayTotal, dailyGoal) {
            _initializeFromState(dailyGoal);
            return _buildContent(context, dailyGoal);
          },
          error: (message) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const Gap(AppDimens.x4),
                Text(
                  'Error: $message',
                  style: const TextStyle(color: Colors.red),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
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
                  color: const Color(0xFF00BCD4).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.track_changes,
                  color: Color(0xFF00BCD4),
                  size: 24,
                ),
              ),
              const Gap(AppDimens.x3),
              const Text(
                'Daily Goal',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Gap(AppDimens.x5),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Target (ml)',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                ),
              ),
              SizedBox(
                width: 120,
                child: TextField(
                  controller: _dailyGoalController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  onChanged: (_) =>
                      setState(() {}), // Trigger rebuild to update button state
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF00BCD4),
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
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.shade200),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  size: 16,
                  color: Colors.amber.shade700,
                ),
                const Gap(AppDimens.x2),
                Expanded(
                  child: Text(
                    'Recommended: 2000-3000 ml per day for adults',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.amber.shade900,
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
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
                  color: const Color(0xFF2196F3).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: Color(0xFF2196F3),
                  size: 24,
                ),
              ),
              const Gap(AppDimens.x3),
              const Text(
                'Reminders',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Gap(AppDimens.x5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Enable reminders',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
              ),
              Switch(
                value: _remindersEnabled,
                onChanged: (value) {
                  setState(() {
                    _remindersEnabled = value;
                  });
                },
                activeTrackColor: const Color(0xFF00BCD4).withOpacity(0.5),
                activeColor: const Color(0xFF00BCD4),
              ),
            ],
          ),
          const Gap(AppDimens.x4),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Interval (minutes)',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                ),
              ),
              SizedBox(
                width: 120,
                child: TextField(
                  controller: _intervalController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  enabled: _remindersEnabled,
                  onChanged: (_) =>
                      setState(() {}), // Trigger rebuild to update button state
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: _remindersEnabled
                        ? Colors.grey.shade50
                        : Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF00BCD4),
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
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber,
                  size: 16,
                  color: Colors.orange.shade700,
                ),
                const Gap(AppDimens.x2),
                Expanded(
                  child: Text(
                    'Browser notifications require permission and may not work on all devices',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.orange.shade900,
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
    final hasChanges = _hasChanges();

    return Opacity(
      opacity: hasChanges ? 1.0 : 0.5,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: hasChanges
                ? [const Color(0xFF00BCD4), const Color(0xFF2196F3)]
                : [Colors.grey.shade400, Colors.grey.shade500],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: hasChanges
              ? [
                  BoxShadow(
                    color: const Color(0xFF00BCD4).withOpacity(0.3),
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
  }

  Widget _buildDangerZone(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.x5),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Danger Zone',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red.shade900,
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
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: AppDimens.x4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.delete_forever, color: Colors.white),
                  Gap(AppDimens.x2),
                  Text(
                    'Clear All Data',
                    style: TextStyle(
                      color: Colors.white,
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
      context.read<HydrationCubit>().updateDailyGoal(dailyGoal);

      // Update original values after successful save
      setState(() {
        _originalDailyGoal = dailyGoal;
        _originalRemindersEnabled = _remindersEnabled;
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
          backgroundColor: const Color(0xFF1976D2),
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
          backgroundColor: Colors.red,
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
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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

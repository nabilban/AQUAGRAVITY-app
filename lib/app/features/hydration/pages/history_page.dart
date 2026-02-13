import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../ui/constants/app_dimens.dart';
import '../cubit/hydration_cubit.dart';
import '../cubit/hydration_state.dart';
import '../../../../core/domain/models/hydration_log.dart';

/// History page displaying weekly stats and daily hydration history
class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final theme = Theme.of(context);
    return BlocBuilder<HydrationCubit, HydrationState>(
      builder: (context, state) {
        return state.when(
          initial: () => const Center(child: Text('Initializing...')),
          loading: () => const Center(child: CircularProgressIndicator()),
          loaded:
              (
                logs,
                allLogs,
                todayTotal,
                dailyGoal,
                p4,
                p5,
                bedTimeHour,
                wakeUpHour,
              ) => _buildLoadedView(
                context,
                logs,
                allLogs,
                todayTotal,
                dailyGoal,
                theme,
                width,
                height,
              ),
          error: (message) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: theme.colorScheme.error,
                ),
                const Gap(AppDimens.x4),
                Text('Error: $message'),
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

  Widget _buildLoadedView(
    BuildContext context,
    List<HydrationLog> logs,
    List<HydrationLog> allLogs,
    double todayTotal,
    double dailyGoal,
    ThemeData theme,
    double width,
    double height,
  ) {
    // Group logs by date
    final Map<int, List<HydrationLog>> groupedLogs = {};
    for (final log in allLogs) {
      final date = DateTime(
        log.timestamp.year,
        log.timestamp.month,
        log.timestamp.day,
      );
      final key = date.millisecondsSinceEpoch;
      if (!groupedLogs.containsKey(key)) {
        groupedLogs[key] = [];
      }
      groupedLogs[key]!.add(log);
    }

    // Sort keys descending (newest first)
    final sortedKeys = groupedLogs.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    // Calculate stats
    final daysTracked = sortedKeys.length;
    // Calculate daily average - avoid division by zero
    final totalVolume = allLogs.fold(0.0, (sum, log) => sum + log.amount);
    final dailyAverage = daysTracked > 0 ? totalVolume / daysTracked : 0.0;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Weekly Stats Card
            _buildWeeklyStatsCard(
              context,
              dailyAverage: dailyAverage,
              daysTracked: daysTracked,
              theme,
            ),
            Gap(height * 0.03),

            // History Section Header
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: theme.colorScheme.onSurface,
                ),
                const Gap(AppDimens.x2),
                Text(
                  'History',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            // History List
            if (sortedKeys.isNotEmpty)
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sortedKeys.length,
                separatorBuilder: (context, index) => const Gap(AppDimens.x2),
                itemBuilder: (context, index) {
                  final dateMillis = sortedKeys[index];
                  final date = DateTime.fromMillisecondsSinceEpoch(dateMillis);
                  final dayLogs = groupedLogs[dateMillis]!;

                  final dayTotal = dayLogs.fold(
                    0.0,
                    (sum, log) => sum + log.amount,
                  );
                  final dayProgress = (dayTotal / dailyGoal).clamp(0.0, 1.0);
                  final isGoalMet = dayProgress >= 1.0;

                  final isToday =
                      DateTime.now().year == date.year &&
                      DateTime.now().month == date.month &&
                      DateTime.now().day == date.day;

                  final dateString = isToday
                      ? 'Today'
                      : '${_getMonth(date.month)} ${date.day}, ${date.year}';

                  return _buildHistoryCard(
                    context,
                    date: dateString,
                    amount: dayTotal,
                    goal:
                        dailyGoal, // Using current goal for history as simplification
                    progress: dayProgress,
                    isGoalMet: isGoalMet,
                    theme,
                  );
                },
              )
            else
              _buildEmptyState(context, theme),
          ],
        ),
      ),
    );
  }

  String _getMonth(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  Widget _buildWeeklyStatsCard(
    BuildContext context,
    ThemeData theme, {
    required double dailyAverage,
    required int daysTracked,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.x6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.secondary, theme.colorScheme.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.secondary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.trending_up,
                color: theme.colorScheme.onPrimary,
                size: 24,
              ),
              const Gap(AppDimens.x2),
              Text(
                'Weekly Stats',
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Gap(AppDimens.x6),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${dailyAverage.toInt()} ml',
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(AppDimens.x1),
                    Text(
                      'Daily Average',
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary.withValues(
                          alpha: 0.7,
                        ),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(AppDimens.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$daysTracked',
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(AppDimens.x1),
                    Text(
                      'Days Tracked',
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary.withValues(
                          alpha: 0.7,
                        ),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(
    BuildContext context,
    ThemeData theme, {
    required String date,
    required double amount,
    required double goal,
    required double progress,
    required bool isGoalMet,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.x4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isGoalMet
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceContainerHighest,
          width: isGoalMet ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Row(
                children: [
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isGoalMet
                          ? theme.colorScheme.primary
                          : theme.colorScheme.secondary,
                    ),
                  ),
                  if (isGoalMet) ...[
                    const Gap(AppDimens.x2),
                    Icon(
                      Icons.check_circle,
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                  ],
                ],
              ),
            ],
          ),
          const Gap(AppDimens.x2),
          Text(
            '${amount.toInt()} ml / ${goal.toInt()} ml',
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
          if (isGoalMet)
            Padding(
              padding: const EdgeInsets.only(top: AppDimens.x1),
              child: Row(
                children: [
                  Icon(
                    Icons.celebration,
                    size: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const Gap(AppDimens.x1),
                  Text(
                    'Goal met',
                    style: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          const Gap(AppDimens.x3),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(
                isGoalMet
                    ? theme.colorScheme.primary
                    : theme.colorScheme.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.x8),
        child: Column(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 80,
              color: theme.colorScheme.outlineVariant,
            ),
            const Gap(AppDimens.x4),
            Text(
              'No history yet',
              style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Gap(AppDimens.x2),
            Text(
              'Start tracking your water intake to see your history',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

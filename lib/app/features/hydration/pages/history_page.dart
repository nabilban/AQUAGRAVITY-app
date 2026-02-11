import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../ui/constants/app_dimens.dart';
import '../cubit/hydration_cubit.dart';
import '../cubit/hydration_state.dart';

/// History page displaying weekly stats and daily hydration history
class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HydrationCubit, HydrationState>(
      builder: (context, state) {
        return state.when(
          initial: () => const Center(child: Text('Initializing...')),
          loading: () => const Center(child: CircularProgressIndicator()),
          loaded: (logs, todayTotal, dailyGoal) =>
              _buildLoadedView(context, logs, todayTotal, dailyGoal),
          error: (message) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
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
    List logs,
    double todayTotal,
    double dailyGoal,
  ) {
    // Calculate weekly stats
    final daysTracked = logs.isNotEmpty ? 1 : 0; // Simplified for now
    final dailyAverage = daysTracked > 0 ? todayTotal : 0.0;
    final todayProgress = (todayTotal / dailyGoal).clamp(0.0, 1.0);
    final isGoalMet = todayProgress >= 1.0;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.x4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Weekly Stats Card
            _buildWeeklyStatsCard(
              context,
              dailyAverage: dailyAverage,
              daysTracked: daysTracked,
            ),
            const Gap(AppDimens.x6),

            // History Section Header
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 20),
                const Gap(AppDimens.x2),
                Text(
                  'History',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Gap(AppDimens.x4),

            // Today's Entry
            if (logs.isNotEmpty)
              _buildHistoryCard(
                context,
                date: 'Today',
                amount: todayTotal,
                goal: dailyGoal,
                progress: todayProgress,
                isGoalMet: isGoalMet,
              )
            else
              _buildEmptyState(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyStatsCard(
    BuildContext context, {
    required double dailyAverage,
    required int daysTracked,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.x6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00BCD4), Color(0xFF2196F3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00BCD4).withOpacity(0.3),
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
              const Icon(Icons.trending_up, color: Colors.white, size: 24),
              const Gap(AppDimens.x2),
              const Text(
                'Weekly Stats',
                style: TextStyle(
                  color: Colors.white,
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
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(AppDimens.x1),
                    const Text(
                      'Daily Average',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
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
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(AppDimens.x1),
                    const Text(
                      'Days Tracked',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
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
    BuildContext context, {
    required String date,
    required double amount,
    required double goal,
    required double progress,
    required bool isGoalMet,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.x4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isGoalMet ? const Color(0xFF1976D2) : Colors.grey.shade200,
          width: isGoalMet ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
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
                          ? const Color(0xFF1976D2)
                          : const Color(0xFF00BCD4),
                    ),
                  ),
                  if (isGoalMet) ...[
                    const Gap(AppDimens.x2),
                    const Icon(
                      Icons.check_circle,
                      color: Color(0xFF1976D2),
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
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          if (isGoalMet)
            Padding(
              padding: const EdgeInsets.only(top: AppDimens.x1),
              child: Row(
                children: [
                  Icon(
                    Icons.celebration,
                    size: 14,
                    color: Colors.grey.shade600,
                  ),
                  const Gap(AppDimens.x1),
                  Text(
                    'Goal met',
                    style: TextStyle(
                      color: Colors.grey.shade600,
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
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(
                isGoalMet ? const Color(0xFF1976D2) : const Color(0xFF00BCD4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.x8),
        child: Column(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 80,
              color: Colors.grey.shade300,
            ),
            const Gap(AppDimens.x4),
            Text(
              'No history yet',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Gap(AppDimens.x2),
            Text(
              'Start tracking your water intake to see your history',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

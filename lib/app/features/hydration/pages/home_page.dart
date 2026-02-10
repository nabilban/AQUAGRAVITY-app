import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../ui/constants/app_dimens.dart';
import '../cubit/hydration_cubit.dart';
import '../cubit/hydration_state.dart';
import '../../settings/pages/settings_page.dart';
import '../widgets/water_bubble_widget.dart';

/// Home page displaying hydration tracking
@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AQUAGRAVITY'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const SettingsPage()));
            },
          ),
        ],
      ),
      body: BlocBuilder<HydrationCubit, HydrationState>(
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddWaterDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildLoadedView(
    BuildContext context,
    List logs,
    double todayTotal,
    double dailyGoal,
  ) {
    final progress = (todayTotal / dailyGoal).clamp(0.0, 1.0);
    final isDehydrated = progress < 0.5;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.x4),
        child: Column(
          children: [
            // Progress indicator
            _buildProgressCard(context, todayTotal, dailyGoal, progress),
            const Gap(AppDimens.x6),

            // Water bubble widget with gravity effect
            WaterBubbleWidget(
              isDehydrated: isDehydrated,
              progress: progress,
              onTap: () => _showAddWaterDialog(context),
            ),
            const Gap(AppDimens.x6),

            // Today's logs
            Expanded(child: _buildLogsList(context, logs)),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(
    BuildContext context,
    double todayTotal,
    double dailyGoal,
    double progress,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.x4),
        child: Column(
          children: [
            Text(
              'Today\'s Hydration',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Gap(AppDimens.x2),
            Text(
              '${todayTotal.toInt()} / ${dailyGoal.toInt()} ml',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(AppDimens.x3),
            LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const Gap(AppDimens.x2),
            Text(
              '${(progress * 100).toInt()}% complete',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogsList(BuildContext context, List logs) {
    if (logs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.water_drop_outlined,
              size: 64,
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.3),
            ),
            const Gap(AppDimens.x4),
            Text(
              'No water logged today',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const Gap(AppDimens.x2),
            Text(
              'Tap the + button to start tracking',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];
        return Dismissible(
          key: Key(log.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: AppDimens.x4),
            color: Colors.red,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) {
            context.read<HydrationCubit>().deleteLog(log.id);
          },
          child: Card(
            child: ListTile(
              leading: const Icon(Icons.water_drop),
              title: Text('${log.amount.toInt()} ml'),
              subtitle: Text(
                '${log.timestamp.hour}:${log.timestamp.minute.toString().padLeft(2, '0')}',
              ),
              trailing: log.note != null && log.note!.isNotEmpty
                  ? const Icon(Icons.note, size: 16)
                  : null,
            ),
          ),
        );
      },
    );
  }

  void _showAddWaterDialog(BuildContext context) {
    final amounts = [250, 500, 750, 1000];

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add Water'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...amounts.map(
              (amount) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<HydrationCubit>().addLog(
                        amount: amount.toDouble(),
                      );
                      Navigator.of(dialogContext).pop();
                    },
                    child: Text('$amount ml'),
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

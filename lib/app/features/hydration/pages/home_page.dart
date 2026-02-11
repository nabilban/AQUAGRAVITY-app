import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../ui/constants/app_dimens.dart';
import '../cubit/hydration_cubit.dart';
import '../cubit/hydration_state.dart';
import 'history_page.dart';
import '../../settings/pages/settings_page_content.dart';
import '../../settings/cubit/theme_cubit.dart';
import '../../settings/cubit/theme_state.dart';

/// Home page displaying hydration tracking with AQUAGRAVITY design
@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final TextEditingController _customAmountController = TextEditingController();
  int _selectedTab = 0;
  late AnimationController _progressAnimationController;
  late Animation<double> _progressAnimation;
  double _currentProgress = 0.0;
  late AnimationController _floatingAnimationController;
  late Animation<double> _floatingAnimation;
  late AnimationController _celebrationAnimationController;
  late Animation<double> _celebrationAnimation;
  bool _hasReached100 = false;
  late AnimationController _fadeAnimationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Progress animation controller
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _progressAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    // Floating animation controller (continuous)
    _floatingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _floatingAnimation = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(
        parent: _floatingAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Celebration animation controller (for 100% completion)
    _celebrationAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _celebrationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _celebrationAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Fade animation controller (for tab transitions)
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Start with fade in
    _fadeAnimationController.forward();
  }

  @override
  void dispose() {
    _progressAnimationController.dispose();
    _floatingAnimationController.dispose();
    _celebrationAnimationController.dispose();
    _fadeAnimationController.dispose();
    _customAmountController.dispose();
    super.dispose();
  }

  void _updateProgress(double newProgress) {
    setState(() {
      _progressAnimation =
          Tween<double>(begin: _currentProgress, end: newProgress).animate(
            CurvedAnimation(
              parent: _progressAnimationController,
              curve: Curves.easeOutCubic,
            ),
          );
      _currentProgress = newProgress;
    });
    _progressAnimationController.forward(from: 0.0);

    // Trigger celebration animation when reaching 100%
    if (newProgress >= 1.0 && !_hasReached100) {
      _hasReached100 = true;
      _celebrationAnimationController.repeat(reverse: true);
    } else if (newProgress < 1.0 && _hasReached100) {
      _hasReached100 = false;
      _celebrationAnimationController.stop();
      _celebrationAnimationController.reset();
    }
  }

  void _switchTab(int newTab) {
    if (_selectedTab != newTab) {
      // Fade out
      _fadeAnimationController.reverse().then((_) {
        // Change tab
        setState(() {
          _selectedTab = newTab;
        });
        // Fade in
        _fadeAnimationController.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }

  Widget _buildLoadedView(
    BuildContext context,
    List logs,
    double todayTotal,
    double dailyGoal,
  ) {
    final progress = (todayTotal / dailyGoal).clamp(0.0, 1.0);

    // Update animation when progress changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (progress != _currentProgress) {
        _updateProgress(progress);
      }
    });

    return Column(
      children: [
        // Gradient Header with Navigation
        _buildHeader(context),

        // Content based on selected tab with fade animation
        Expanded(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: _selectedTab == 0
                ? _buildTrackerContent(
                    context,
                    logs,
                    todayTotal,
                    dailyGoal,
                    progress,
                  )
                : _selectedTab == 1
                ? _buildHistoryContent(context, logs, todayTotal, dailyGoal)
                : _buildSettingsContent(context),
          ),
        ),
      ],
    );
  }

  Widget _buildTrackerContent(
    BuildContext context,
    List logs,
    double todayTotal,
    double dailyGoal,
    double progress,
  ) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.x4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(AppDimens.x6),

            // Circular Progress Indicator
            _buildCircularProgress(context, todayTotal, dailyGoal, progress),
            const Gap(AppDimens.x8),

            // Quick Add Section
            _buildQuickAddSection(context),
            const Gap(AppDimens.x6),

            // Custom Amount Section
            _buildCustomAmountSection(context),
            const Gap(AppDimens.x8),

            // Today's Log Section
            _buildTodaysLogSection(context, logs),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryContent(
    BuildContext context,
    List logs,
    double todayTotal,
    double dailyGoal,
  ) {
    return HistoryPage();
  }

  Widget _buildSettingsContent(BuildContext context) {
    return const SettingsPageContent();
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF00BCD4), // Cyan
            Color(0xFF2196F3), // Blue
            // Color(0xFF1976D2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        // No borderRadius - straight edge at the bottom
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: AppDimens.x4,
            right: AppDimens.x4,
            top: AppDimens.x4,
            bottom: 0,
          ),
          child: Column(
            children: [
              // Logo and Title
              Row(
                children: [
                  const Icon(Icons.water_drop, color: Colors.white, size: 32),
                  const Gap(AppDimens.x2),
                  Text(
                    'AQUAGRAVITY',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const Spacer(),
                  BlocBuilder<ThemeCubit, ThemeState>(
                    builder: (context, state) {
                      final isDark = state.themeMode == ThemeMode.dark;
                      return IconButton(
                        icon: Icon(
                          isDark ? Icons.light_mode : Icons.dark_mode,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          context.read<ThemeCubit>().updateTheme(
                            isDark ? ThemeMode.light : ThemeMode.dark,
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              const Gap(AppDimens.x4),

              // Navigation Tabs with Sliding Indicator
              SizedBox(
                height: 70,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final tabWidth =
                        (constraints.maxWidth - (AppDimens.x2 * 2)) / 3;

                    return Stack(
                      children: [
                        // Animated sliding white background
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          left: _selectedTab * (tabWidth + AppDimens.x2),
                          top: 0,
                          bottom: 0,
                          width: tabWidth,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Tab buttons
                        Row(
                          children: [
                            Expanded(
                              child: _buildNavTab(
                                context,
                                icon: Icons.water_drop,
                                label: 'Tracker',
                                isSelected: _selectedTab == 0,
                                onTap: () => _switchTab(0),
                              ),
                            ),
                            const Gap(AppDimens.x2),
                            Expanded(
                              child: _buildNavTab(
                                context,
                                icon: Icons.history,
                                label: 'History',
                                isSelected: _selectedTab == 1,
                                onTap: () => _switchTab(1),
                              ),
                            ),
                            const Gap(AppDimens.x2),
                            Expanded(
                              child: _buildNavTab(
                                context,
                                icon: Icons.settings,
                                label: 'Settings',
                                isSelected: _selectedTab == 2,
                                onTap: () => _switchTab(2),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavTab(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppDimens.x3,
          horizontal: AppDimens.x2,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(
            alpha: 0.25,
          ), // Transparent to show sliding indicator
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF00BCD4) : Colors.white,
              size: 24,
            ),
            const Gap(4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF00BCD4) : Colors.white,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularProgress(
    BuildContext context,
    double todayTotal,
    double dailyGoal,
    double progress,
  ) {
    final isComplete = progress >= 1.0;

    return Center(
      child: Column(
        children: [
          SizedBox(
            width: 200,
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Celebration glow effect at 100%
                if (isComplete)
                  AnimatedBuilder(
                    animation: _celebrationAnimation,
                    builder: (context, child) {
                      final glowOpacity =
                          0.3 + (_celebrationAnimation.value * 0.3);
                      return Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF00BCD4,
                              ).withOpacity(glowOpacity),
                              blurRadius: 30,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                // Animated Circular Progress Indicator
                AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return SizedBox(
                      width: 200,
                      height: 200,
                      child: CircularProgressIndicator(
                        value: _progressAnimation.value,
                        strokeWidth: 18,
                        backgroundColor: Colors.blue.shade50,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isComplete
                              ? const Color(0xFF2196F3)
                              : const Color(0xFF00BCD4),
                        ),
                      ),
                    );
                  },
                ),

                // Water Droplet Icon with floating and scale animation
                AnimatedBuilder(
                  animation: Listenable.merge([
                    _floatingAnimationController,
                    _progressAnimationController,
                    if (isComplete) _celebrationAnimationController,
                  ]),
                  builder: (context, child) {
                    final scale =
                        1.0 + (_progressAnimationController.value * 0.2);
                    final floatingOffset = _floatingAnimation.value;
                    final celebrationScale = isComplete
                        ? 1.0 + (_celebrationAnimation.value * 0.15)
                        : 1.0;

                    return Transform.translate(
                      offset: Offset(0, floatingOffset),
                      child: Transform.scale(
                        scale:
                            (scale > 1.1 ? 2.2 - scale : scale) *
                            celebrationScale,
                        child: Icon(
                          Icons.water_drop,
                          size: 64,
                          color: isComplete
                              ? const Color(
                                  0xFF1976D2,
                                ) // Deep blue when complete
                              : const Color(0xFF2196F3),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const Gap(AppDimens.x4),

          // Animated text with celebration colors
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
              color: isComplete
                  ? const Color(0xFF1976D2)
                  : const Color(0xFF00BCD4),
              fontWeight: FontWeight.bold,
            ),
            child: Text(
              '${todayTotal.toInt()} ml',
              style: TextStyle(fontSize: 35),
            ),
          ),

          const Gap(AppDimens.x1),
          Text(
            'of ${dailyGoal.toInt()} ml daily goal',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
          ),
          const Gap(AppDimens.x2),

          // Celebration message or progress indicator
          if (isComplete)
            AnimatedBuilder(
              animation: _celebrationAnimation,
              builder: (context, child) {
                final opacity = 0.7 + (_celebrationAnimation.value * 0.3);
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.x6,
                    vertical: AppDimens.x3,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF1976D2).withOpacity(opacity),
                        Color(0xFF2196F3).withOpacity(opacity),
                        Color(0xFF00BCD4).withOpacity(opacity),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1976D2).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.celebration,
                        color: Colors.white,
                        size: 20,
                      ),
                      const Gap(AppDimens.x2),
                      const Text(
                        'Goal Achieved! 🎉',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.x4,
                vertical: AppDimens.x2,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF00BCD4).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${(progress * 100).toInt()}% complete',
                style: const TextStyle(
                  color: Color(0xFF00BCD4),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuickAddSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Add',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: Colors.grey.shade800,
          ),
        ),
        const Gap(AppDimens.x3),
        Row(
          children: [
            Expanded(
              child: _buildQuickAddButton(
                context,
                icon: Icons.local_bar,
                label: 'Glass',
                amount: '250ml',
                color: const Color(0xFF00BCD4),
                onTap: () => _addWater(250),
              ),
            ),
            const Gap(AppDimens.x3),
            Expanded(
              child: _buildQuickAddButton(
                context,
                icon: Icons.water_drop,
                label: 'Bottle',
                amount: '500ml',
                color: const Color(0xFF2196F3),
                onTap: () => _addWater(500),
              ),
            ),
            const Gap(AppDimens.x3),
            Expanded(
              child: _buildQuickAddButton(
                context,
                icon: Icons.coffee,
                label: 'Large',
                amount: '750ml',
                color: const Color(0xFF7C4DFF),
                onTap: () => _addWater(750),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickAddButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String amount,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimens.x4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const Gap(AppDimens.x2),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const Gap(4),
            Text(
              amount,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomAmountSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Custom Amount',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: Colors.grey.shade800,
          ),
        ),
        const Gap(AppDimens.x3),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _customAmountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter ml',
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.x4,
                    vertical: AppDimens.x3,
                  ),
                ),
              ),
            ),
            const Gap(AppDimens.x3),
            ElevatedButton(
              onPressed: _addCustomAmount,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00BCD4),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.x6,
                  vertical: AppDimens.x4,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                children: [Icon(Icons.add, size: 20), Gap(4), Text('Add')],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTodaysLogSection(BuildContext context, List logs) {
    // Limit to 5 most recent logs
    final displayLogs = logs.take(5).toList();
    final hasMore = logs.length > 5;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Today\'s Log',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
                color: Colors.grey.shade800,
              ),
            ),
            if (logs.isNotEmpty)
              Text(
                '${logs.length} ${logs.length == 1 ? 'entry' : 'entries'}',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
          ],
        ),
        const Gap(AppDimens.x3),
        if (logs.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.x8),
              child: Column(
                children: [
                  Icon(
                    Icons.water_drop_outlined,
                    size: 64,
                    color: Colors.grey.shade300,
                  ),
                  const Gap(AppDimens.x3),
                  Text(
                    'No water logged yet today',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                  ),
                ],
              ),
            ),
          )
        else
          ...displayLogs.map(
            (log) => Padding(
              padding: const EdgeInsets.only(bottom: AppDimens.x2),
              child: Dismissible(
                key: Key(log.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: AppDimens.x4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  context.read<HydrationCubit>().deleteLog(log.id);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.x4,
                    vertical: AppDimens.x3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.water_drop,
                        color: const Color(0xFF00BCD4),
                        size: 20,
                      ),
                      const Gap(AppDimens.x3),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${log.amount.toInt()} ml',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              '${log.timestamp.hour}:${log.timestamp.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (log.note != null && log.note!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: AppDimens.x2),
                          child: Icon(
                            Icons.note,
                            size: 14,
                            color: Colors.grey.shade400,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        if (hasMore)
          Padding(
            padding: const EdgeInsets.only(top: AppDimens.x2),
            child: Center(
              child: Text(
                '+ ${logs.length - 5} more entries',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        // Add bottom padding to ensure content doesn't get cut off
        const Gap(AppDimens.x8),
      ],
    );
  }

  void _addWater(int amount) {
    context.read<HydrationCubit>().addLog(amount: amount.toDouble());
  }

  void _addCustomAmount() {
    final amount = double.tryParse(_customAmountController.text);
    if (amount != null && amount > 0) {
      context.read<HydrationCubit>().addLog(amount: amount);
      _customAmountController.clear();
    }
  }
}

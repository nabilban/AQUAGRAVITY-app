import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/domain/models/hydration_log.dart';
import '../../../../core/domain/models/user_settings.dart';
import '../../../../core/domain/repositories/hydration_repository.dart';
import '../../../../core/domain/repositories/settings_repository.dart';
import '../../../../core/services/notification_service.dart';
import 'hydration_state.dart';

/// Cubit for hydration tracking feature
class HydrationCubit extends Cubit<HydrationState> with WidgetsBindingObserver {
  final HydrationRepository _hydrationRepository;
  final SettingsRepository _settingsRepository;
  final NotificationService _notificationService = NotificationService();

  StreamSubscription? _subscription;

  // Track last state to avoid rescheduling notifications unnecessarily
  List<HydrationLog>? _lastLogs;
  UserSettings? _lastSettings;
  bool? _lastGoalReached;

  HydrationCubit({
    required HydrationRepository hydrationRepository,
    required SettingsRepository settingsRepository,
  }) : _hydrationRepository = hydrationRepository,
       _settingsRepository = settingsRepository,
       super(const HydrationState.initial()) {
    WidgetsBinding.instance.addObserver(this);
    _init();
  }

  @override
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(this);
    _subscription?.cancel();
    return super.close();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _init(showLoading: false);
    }
  }

  /// Initialize by watching logs and settings
  void _init({bool showLoading = true}) {
    _subscription?.cancel();
    if (showLoading) emit(const HydrationState.loading());

    // Ticker that emits every minute to handle midnight rollover
    final ticker = Stream.periodic(
      const Duration(minutes: 1),
      (i) => i,
    ).startWith(0);

    // Combine streams of logs and settings
    _subscription =
        Rx.combineLatest3(
          _hydrationRepository.watchLogs(),
          _settingsRepository.watchSettings(),
          ticker,
          (List<HydrationLog> logs, UserSettings settings, dynamic _) =>
              (logs: logs, settings: settings),
        ).listen(
          (data) {
            final now = DateTime.now();
            final startOfDay = DateTime(now.year, now.month, now.day);
            final endOfDay = startOfDay.add(const Duration(days: 1));

            final todayLogs = data.logs
                .where(
                  (log) =>
                      (log.timestamp.isAfter(startOfDay) &&
                          log.timestamp.isBefore(endOfDay)) ||
                      log.timestamp.isAtSameMomentAs(startOfDay),
                )
                .toList();

            final total = todayLogs.fold(0.0, (sum, log) => sum + log.amount);
            final goalReached = total >= data.settings.dailyGoal;

            // Smart Notification Handling:
            // Only reschedule if logs changed, settings changed, or goal status changed (e.g. rollover reset)
            final bool shouldReschedule =
                !identical(data.logs, _lastLogs) ||
                !identical(data.settings, _lastSettings) ||
                (_lastGoalReached != null && _lastGoalReached! && !goalReached);

            if (shouldReschedule) {
              _manageNotifications(todayLogs, data.settings, total);
            }

            _lastLogs = data.logs;
            _lastSettings = data.settings;
            _lastGoalReached = goalReached;

            emit(
              HydrationState.loaded(
                logs: todayLogs,
                allLogs: data.logs,
                todayTotal: total,
                dailyGoal: data.settings.dailyGoal,
                reminderEnabled: data.settings.reminderEnabled,
                reminderInterval: data.settings.reminderInterval,
                bedTimeHour: data.settings.bedTimeHour,
                wakeUpHour: data.settings.wakeUpHour,
              ),
            );
          },
          onError: (error) {
            emit(HydrationState.error(message: error.toString()));
          },
        );
  }

  void _manageNotifications(
    List<HydrationLog> logs,
    UserSettings settings,
    double total,
  ) {
    if (!settings.reminderEnabled) {
      _notificationService.cancelAllNotifications();
      return;
    }

    if (total >= settings.dailyGoal) {
      _notificationService.cancelAllNotifications();
      return;
    }

    // Schedule notification based on last log or now
    // If we just logged water, logs.first (or last depending on sort) is recent.
    // Assuming logs are sorted (usually desc or asc).
    // Drift usually returns chronological unless specified.
    // Let's assume we want to schedule 'interval' minutes from NOW
    // because any update to logs or settings implies user interaction.
    _notificationService.scheduleReminder(
      settings.reminderInterval,
      settings.bedTimeHour,
      settings.wakeUpHour,
    );
  }

  /// Add a new hydration log
  Future<void> addLog({required double amount, String? note}) async {
    final log = HydrationLog(
      id: const Uuid().v4(),
      amount: amount,
      timestamp: DateTime.now(),
      note: note,
    );

    final result = await _hydrationRepository.addLog(log);
    result.fold(
      (failure) => emit(HydrationState.error(message: failure.message)),
      (_) {}, // Success - stream will update automatically
    );
  }

  /// Delete a hydration log
  Future<void> deleteLog(String id) async {
    final result = await _hydrationRepository.deleteLog(id);
    result.fold(
      (failure) => emit(HydrationState.error(message: failure.message)),
      (_) {}, // Success - stream will update automatically
    );
  }

  /// Update daily goal
  Future<void> updateDailyGoal(double newGoal) async {
    final result = await _settingsRepository.updateDailyGoal(newGoal);
    result.fold(
      (failure) => emit(HydrationState.error(message: failure.message)),
      (_) {}, // Success - stream will update automatically
    );
  }

  /// Toggle reminders
  Future<void> toggleReminders(bool enabled) async {
    final currentState = state;
    final loadedState = currentState.mapOrNull(loaded: (s) => s);
    if (loadedState == null) return;

    // We need the current settings to update purely one field,
    // but repository updateSettings requires full object.
    // We can reconstruct it from state or fetch it.
    // Since we maintain state consistent with repo via stream, using state is fine.

    // However, clean approach: fetch current, modify, save.
    // Or simpler: use what we have in state.

    // Let's use getSettings to be safe/atomic
    final currentSettingsResult = await _settingsRepository.getSettings();

    currentSettingsResult.fold(
      (failure) => emit(HydrationState.error(message: failure.message)),
      (settings) async {
        final updated = settings.copyWith(reminderEnabled: enabled);
        final result = await _settingsRepository.updateSettings(updated);
        result.fold(
          (failure) => emit(HydrationState.error(message: failure.message)),
          (_) {
            if (enabled) {
              _notificationService.requestPermissions();
              _notificationService.requestExactAlarmPermissions();
            }
          },
        );
      },
    );
  }

  /// Update reminder interval
  Future<void> updateReminderInterval(int minutes) async {
    final currentSettingsResult = await _settingsRepository.getSettings();

    currentSettingsResult.fold(
      (failure) => emit(HydrationState.error(message: failure.message)),
      (settings) async {
        final updated = settings.copyWith(reminderInterval: minutes);
        final result = await _settingsRepository.updateSettings(updated);
        result.fold(
          (failure) => emit(HydrationState.error(message: failure.message)),
          (_) {},
        );
      },
    );
  }

  /// Update bed time hour
  Future<void> updateBedTime(int hour) async {
    final currentSettingsResult = await _settingsRepository.getSettings();

    currentSettingsResult.fold(
      (failure) => emit(HydrationState.error(message: failure.message)),
      (settings) async {
        final updated = settings.copyWith(bedTimeHour: hour);
        final result = await _settingsRepository.updateSettings(updated);
        result.fold(
          (failure) => emit(HydrationState.error(message: failure.message)),
          (_) {},
        );
      },
    );
  }

  /// Update wake up hour
  Future<void> updateWakeUpTime(int hour) async {
    final currentSettingsResult = await _settingsRepository.getSettings();

    currentSettingsResult.fold(
      (failure) => emit(HydrationState.error(message: failure.message)),
      (settings) async {
        final updated = settings.copyWith(wakeUpHour: hour);
        final result = await _settingsRepository.updateSettings(updated);
        result.fold(
          (failure) => emit(HydrationState.error(message: failure.message)),
          (_) {},
        );
      },
    );
  }

  /// Trigger a test notification
  Future<void> testNotification() async {
    await _notificationService.requestPermissions();
    await _notificationService.requestExactAlarmPermissions();
    await _notificationService.showInstantNotification();
  }

  /// Clear all hydration logs
  Future<void> clearAllLogs() async {
    final result = await _hydrationRepository.clearAllLogs();
    result.fold(
      (failure) => emit(HydrationState.error(message: failure.message)),
      (_) {}, // Success - stream will update automatically
    );
  }

  /// Refresh data
  void refresh() {
    _init(showLoading: true);
  }
}

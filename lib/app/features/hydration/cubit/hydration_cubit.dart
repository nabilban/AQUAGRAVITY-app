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
class HydrationCubit extends Cubit<HydrationState> {
  final HydrationRepository _hydrationRepository;
  final SettingsRepository _settingsRepository;
  final NotificationService _notificationService = NotificationService();

  HydrationCubit({
    required HydrationRepository hydrationRepository,
    required SettingsRepository settingsRepository,
  }) : _hydrationRepository = hydrationRepository,
       _settingsRepository = settingsRepository,
       super(const HydrationState.initial()) {
    _init();
  }

  /// Initialize by watching logs and settings
  void _init() {
    emit(const HydrationState.loading());

    // Combine streams of logs and settings
    Rx.combineLatest2(
      _hydrationRepository.watchTodayLogs(),
      _settingsRepository.watchSettings(),
      (logs, settings) => (logs: logs, settings: settings),
    ).listen(
      (data) {
        final total = data.logs.fold(0.0, (sum, log) => sum + log.amount);

        // Handle notifications
        _manageNotifications(data.logs, data.settings, total);

        emit(
          HydrationState.loaded(
            logs: data.logs,
            todayTotal: total,
            dailyGoal: data.settings.dailyGoal,
            reminderEnabled: data.settings.reminderEnabled,
            reminderInterval: data.settings.reminderInterval,
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
    _notificationService.scheduleReminder(settings.reminderInterval);
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

  /// Trigger a test notification
  Future<void> testNotification() async {
    await _notificationService.requestPermissions();
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
    _init();
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/domain/models/hydration_log.dart';
import '../../../../core/domain/repositories/hydration_repository.dart';
import '../../../../core/domain/repositories/settings_repository.dart';
import 'hydration_state.dart';

/// Cubit for hydration tracking feature
class HydrationCubit extends Cubit<HydrationState> {
  final HydrationRepository _hydrationRepository;
  final SettingsRepository _settingsRepository;

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
        emit(
          HydrationState.loaded(
            logs: data.logs,
            todayTotal: total,
            dailyGoal: data.settings.dailyGoal,
          ),
        );
      },
      onError: (error) {
        emit(HydrationState.error(message: error.toString()));
      },
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

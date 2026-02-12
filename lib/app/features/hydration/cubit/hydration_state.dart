import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/domain/models/hydration_log.dart';

part 'hydration_state.freezed.dart';

/// State for hydration tracking feature
@freezed
sealed class HydrationState with _$HydrationState {
  const factory HydrationState.initial() = _Initial;

  const factory HydrationState.loading() = _Loading;

  const factory HydrationState.loaded({
    required List<HydrationLog> logs,
    required List<HydrationLog> allLogs,
    required double todayTotal,
    required double dailyGoal,
    required bool reminderEnabled,
    required int reminderInterval,
  }) = _Loaded;

  const factory HydrationState.error({required String message}) = _Error;
}

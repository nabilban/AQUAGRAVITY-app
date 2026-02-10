import 'package:freezed_annotation/freezed_annotation.dart';

part 'hydration_log.freezed.dart';
part 'hydration_log.g.dart';

/// Domain model for hydration log entries
@freezed
sealed class HydrationLog with _$HydrationLog {
  const factory HydrationLog({
    required String id,
    required double amount,
    required DateTime timestamp,
    String? note,
  }) = _HydrationLog;

  factory HydrationLog.fromJson(Map<String, dynamic> json) =>
      _$HydrationLogFromJson(json);
}

/// Extension for domain model utilities
extension HydrationLogX on HydrationLog {
  /// Check if this log was created today
  bool get isToday {
    final now = DateTime.now();
    return timestamp.year == now.year &&
        timestamp.month == now.month &&
        timestamp.day == now.day;
  }
}

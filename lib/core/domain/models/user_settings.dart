import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_settings.freezed.dart';
part 'user_settings.g.dart';

/// Domain model for user settings
@freezed
sealed class UserSettings with _$UserSettings {
  const factory UserSettings({
    required String id,
    @Default(2000.0) double dailyGoal,
    @Default(true) bool reminderEnabled,
    @Default(60) int reminderInterval,
  }) = _UserSettings;

  factory UserSettings.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFromJson(json);
}

/// Extension for domain model utilities
extension UserSettingsX on UserSettings {
  /// Check if daily goal is valid (between 500ml and 5000ml)
  bool get isValidDailyGoal => dailyGoal >= 500 && dailyGoal <= 5000;

  /// Check if reminder interval is valid (between 15 and 240 minutes)
  bool get isValidReminderInterval =>
      reminderInterval >= 15 && reminderInterval <= 240;
}

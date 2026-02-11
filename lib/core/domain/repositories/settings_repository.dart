import 'package:dartz/dartz.dart';
import '../models/failure.dart';
import '../models/user_settings.dart';

/// Repository interface for user settings operations
abstract class SettingsRepository {
  /// Watch user settings as a stream
  Stream<UserSettings> watchSettings();

  /// Get current user settings
  Future<Either<Failure, UserSettings>> getSettings();

  /// Update user settings
  Future<Either<Failure, bool>> updateSettings(UserSettings settings);

  /// Update daily goal
  Future<Either<Failure, bool>> updateDailyGoal(double newGoal);

  /// Reset settings to default values
  Future<Either<Failure, bool>> resetSettings();
}

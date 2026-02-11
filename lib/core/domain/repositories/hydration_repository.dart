import 'package:dartz/dartz.dart';
import '../models/failure.dart';
import '../models/hydration_log.dart';

/// Repository interface for hydration tracking operations
abstract class HydrationRepository {
  /// Watch all hydration logs as a stream
  Stream<List<HydrationLog>> watchLogs();

  /// Watch today's hydration logs as a stream
  Stream<List<HydrationLog>> watchTodayLogs();

  /// Add a new hydration log
  Future<Either<Failure, bool>> addLog(HydrationLog log);

  /// Delete a hydration log by ID
  Future<Either<Failure, bool>> deleteLog(String id);

  /// Clear all hydration logs
  Future<Either<Failure, bool>> clearAllLogs();

  /// Get today's total hydration amount
  Future<Either<Failure, double>> getTodayTotal();

  /// Get hydration logs for a specific date
  Future<Either<Failure, List<HydrationLog>>> getLogsByDate(DateTime date);
}

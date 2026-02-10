import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:aquagravity/core/domain/models/failure.dart';
import 'package:aquagravity/core/domain/models/hydration_log.dart';
import 'package:aquagravity/core/domain/repositories/hydration_repository.dart';
import 'package:aquagravity/core/data/database/daos/hydration_dao.dart';
import 'package:aquagravity/core/data/database/app_database.dart';

/// Implementation of HydrationRepository using Drift
class HydrationRepositoryImpl implements HydrationRepository {
  final HydrationDao _hydrationDao;

  HydrationRepositoryImpl({required HydrationDao hydrationDao})
    : _hydrationDao = hydrationDao;

  @override
  Stream<List<HydrationLog>> watchLogs() {
    return _hydrationDao.watchAll().map(
      (entities) => entities.map((e) => e.toDomain()).toList(),
    );
  }

  @override
  Stream<List<HydrationLog>> watchTodayLogs() {
    return _hydrationDao.watchTodayLogs().map(
      (entities) => entities.map((e) => e.toDomain()).toList(),
    );
  }

  @override
  Future<Either<Failure, bool>> addLog(HydrationLog log) async {
    try {
      await _hydrationDao.insertLog(log.toCompanion());
      return const Right(true);
    } catch (e) {
      return Left(Failure.database(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteLog(String id) async {
    try {
      final result = await _hydrationDao.deleteLog(id);
      return Right(result > 0);
    } catch (e) {
      return Left(Failure.database(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> getTodayTotal() async {
    try {
      final total = await _hydrationDao.getTodayTotal();
      return Right(total);
    } catch (e) {
      return Left(Failure.database(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<HydrationLog>>> getLogsByDate(
    DateTime date,
  ) async {
    try {
      final entities = await _hydrationDao.getLogsByDate(date);
      return Right(entities.map((e) => e.toDomain()).toList());
    } catch (e) {
      return Left(Failure.database(message: e.toString()));
    }
  }
}

/// Extension to convert HydrationLogEntity to domain model
extension HydrationLogEntityX on HydrationLogEntity {
  HydrationLog toDomain() {
    return HydrationLog(
      id: uuid,
      amount: amount,
      timestamp: timestamp,
      note: note,
    );
  }
}

/// Extension to convert domain model to Drift companion
extension HydrationLogCompanionX on HydrationLog {
  HydrationLogsCompanion toCompanion() {
    return HydrationLogsCompanion.insert(
      uuid: this.id,
      amount: this.amount,
      timestamp: this.timestamp,
      note: Value(this.note),
    );
  }
}

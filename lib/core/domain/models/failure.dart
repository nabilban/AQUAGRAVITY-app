import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

/// Base failure class for error handling using Freezed
@freezed
sealed class Failure with _$Failure {
  const factory Failure.database({required String message}) = DatabaseFailure;
  const factory Failure.notFound({required String message}) = NotFoundFailure;
  const factory Failure.unknown({required String message}) = UnknownFailure;
}

/// Extension to get message from any Failure
extension FailureX on Failure {
  /// Get the error message regardless of the failure type
  String get message => switch (this) {
    DatabaseFailure(:final message) => message,
    NotFoundFailure(:final message) => message,
    UnknownFailure(:final message) => message,
  };
}

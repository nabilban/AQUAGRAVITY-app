// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hydration_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HydrationLog _$HydrationLogFromJson(Map<String, dynamic> json) =>
    _HydrationLog(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$HydrationLogToJson(_HydrationLog instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'timestamp': instance.timestamp.toIso8601String(),
      'note': instance.note,
    };

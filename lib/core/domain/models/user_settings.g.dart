// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserSettings _$UserSettingsFromJson(Map<String, dynamic> json) =>
    _UserSettings(
      id: json['id'] as String,
      dailyGoal: (json['dailyGoal'] as num?)?.toDouble() ?? 2000.0,
      reminderEnabled: json['reminderEnabled'] as bool? ?? true,
      reminderInterval: (json['reminderInterval'] as num?)?.toInt() ?? 60,
    );

Map<String, dynamic> _$UserSettingsToJson(_UserSettings instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dailyGoal': instance.dailyGoal,
      'reminderEnabled': instance.reminderEnabled,
      'reminderInterval': instance.reminderInterval,
    };

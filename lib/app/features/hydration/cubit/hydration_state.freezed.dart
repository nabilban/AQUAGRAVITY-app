// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hydration_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HydrationState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HydrationState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HydrationState()';
}


}

/// @nodoc
class $HydrationStateCopyWith<$Res>  {
$HydrationStateCopyWith(HydrationState _, $Res Function(HydrationState) __);
}


/// Adds pattern-matching-related methods to [HydrationState].
extension HydrationStatePatterns on HydrationState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Loaded value)?  loaded,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Error() when error != null:
return error(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Loaded value)  loaded,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Loaded():
return loaded(_that);case _Error():
return error(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Loaded value)?  loaded,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Error() when error != null:
return error(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<HydrationLog> logs,  List<HydrationLog> allLogs,  double todayTotal,  double dailyGoal,  bool reminderEnabled,  int reminderInterval)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.logs,_that.allLogs,_that.todayTotal,_that.dailyGoal,_that.reminderEnabled,_that.reminderInterval);case _Error() when error != null:
return error(_that.message);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<HydrationLog> logs,  List<HydrationLog> allLogs,  double todayTotal,  double dailyGoal,  bool reminderEnabled,  int reminderInterval)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Loaded():
return loaded(_that.logs,_that.allLogs,_that.todayTotal,_that.dailyGoal,_that.reminderEnabled,_that.reminderInterval);case _Error():
return error(_that.message);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<HydrationLog> logs,  List<HydrationLog> allLogs,  double todayTotal,  double dailyGoal,  bool reminderEnabled,  int reminderInterval)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.logs,_that.allLogs,_that.todayTotal,_that.dailyGoal,_that.reminderEnabled,_that.reminderInterval);case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements HydrationState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HydrationState.initial()';
}


}




/// @nodoc


class _Loading implements HydrationState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HydrationState.loading()';
}


}




/// @nodoc


class _Loaded implements HydrationState {
  const _Loaded({required final  List<HydrationLog> logs, required final  List<HydrationLog> allLogs, required this.todayTotal, required this.dailyGoal, required this.reminderEnabled, required this.reminderInterval}): _logs = logs,_allLogs = allLogs;
  

 final  List<HydrationLog> _logs;
 List<HydrationLog> get logs {
  if (_logs is EqualUnmodifiableListView) return _logs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_logs);
}

 final  List<HydrationLog> _allLogs;
 List<HydrationLog> get allLogs {
  if (_allLogs is EqualUnmodifiableListView) return _allLogs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allLogs);
}

 final  double todayTotal;
 final  double dailyGoal;
 final  bool reminderEnabled;
 final  int reminderInterval;

/// Create a copy of HydrationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&const DeepCollectionEquality().equals(other._logs, _logs)&&const DeepCollectionEquality().equals(other._allLogs, _allLogs)&&(identical(other.todayTotal, todayTotal) || other.todayTotal == todayTotal)&&(identical(other.dailyGoal, dailyGoal) || other.dailyGoal == dailyGoal)&&(identical(other.reminderEnabled, reminderEnabled) || other.reminderEnabled == reminderEnabled)&&(identical(other.reminderInterval, reminderInterval) || other.reminderInterval == reminderInterval));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_logs),const DeepCollectionEquality().hash(_allLogs),todayTotal,dailyGoal,reminderEnabled,reminderInterval);

@override
String toString() {
  return 'HydrationState.loaded(logs: $logs, allLogs: $allLogs, todayTotal: $todayTotal, dailyGoal: $dailyGoal, reminderEnabled: $reminderEnabled, reminderInterval: $reminderInterval)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $HydrationStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 List<HydrationLog> logs, List<HydrationLog> allLogs, double todayTotal, double dailyGoal, bool reminderEnabled, int reminderInterval
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of HydrationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? logs = null,Object? allLogs = null,Object? todayTotal = null,Object? dailyGoal = null,Object? reminderEnabled = null,Object? reminderInterval = null,}) {
  return _then(_Loaded(
logs: null == logs ? _self._logs : logs // ignore: cast_nullable_to_non_nullable
as List<HydrationLog>,allLogs: null == allLogs ? _self._allLogs : allLogs // ignore: cast_nullable_to_non_nullable
as List<HydrationLog>,todayTotal: null == todayTotal ? _self.todayTotal : todayTotal // ignore: cast_nullable_to_non_nullable
as double,dailyGoal: null == dailyGoal ? _self.dailyGoal : dailyGoal // ignore: cast_nullable_to_non_nullable
as double,reminderEnabled: null == reminderEnabled ? _self.reminderEnabled : reminderEnabled // ignore: cast_nullable_to_non_nullable
as bool,reminderInterval: null == reminderInterval ? _self.reminderInterval : reminderInterval // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _Error implements HydrationState {
  const _Error({required this.message});
  

 final  String message;

/// Create a copy of HydrationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'HydrationState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $HydrationStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of HydrationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

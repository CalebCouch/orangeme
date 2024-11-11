// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pub_structs.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TestEnum {
  int? get field0 => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int? field0) value,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int? field0)? value,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int? field0)? value,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TestEnum_Value value) value,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TestEnum_Value value)? value,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TestEnum_Value value)? value,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of TestEnum
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TestEnumCopyWith<TestEnum> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TestEnumCopyWith<$Res> {
  factory $TestEnumCopyWith(TestEnum value, $Res Function(TestEnum) then) =
      _$TestEnumCopyWithImpl<$Res, TestEnum>;
  @useResult
  $Res call({int? field0});
}

/// @nodoc
class _$TestEnumCopyWithImpl<$Res, $Val extends TestEnum>
    implements $TestEnumCopyWith<$Res> {
  _$TestEnumCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TestEnum
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = freezed,
  }) {
    return _then(_value.copyWith(
      field0: freezed == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TestEnum_ValueImplCopyWith<$Res>
    implements $TestEnumCopyWith<$Res> {
  factory _$$TestEnum_ValueImplCopyWith(_$TestEnum_ValueImpl value,
          $Res Function(_$TestEnum_ValueImpl) then) =
      __$$TestEnum_ValueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? field0});
}

/// @nodoc
class __$$TestEnum_ValueImplCopyWithImpl<$Res>
    extends _$TestEnumCopyWithImpl<$Res, _$TestEnum_ValueImpl>
    implements _$$TestEnum_ValueImplCopyWith<$Res> {
  __$$TestEnum_ValueImplCopyWithImpl(
      _$TestEnum_ValueImpl _value, $Res Function(_$TestEnum_ValueImpl) _then)
      : super(_value, _then);

  /// Create a copy of TestEnum
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = freezed,
  }) {
    return _then(_$TestEnum_ValueImpl(
      freezed == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$TestEnum_ValueImpl extends TestEnum_Value {
  const _$TestEnum_ValueImpl([this.field0]) : super._();

  @override
  final int? field0;

  @override
  String toString() {
    return 'TestEnum.value(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TestEnum_ValueImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of TestEnum
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TestEnum_ValueImplCopyWith<_$TestEnum_ValueImpl> get copyWith =>
      __$$TestEnum_ValueImplCopyWithImpl<_$TestEnum_ValueImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int? field0) value,
  }) {
    return value(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int? field0)? value,
  }) {
    return value?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int? field0)? value,
    required TResult orElse(),
  }) {
    if (value != null) {
      return value(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TestEnum_Value value) value,
  }) {
    return value(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TestEnum_Value value)? value,
  }) {
    return value?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TestEnum_Value value)? value,
    required TResult orElse(),
  }) {
    if (value != null) {
      return value(this);
    }
    return orElse();
  }
}

abstract class TestEnum_Value extends TestEnum {
  const factory TestEnum_Value([final int? field0]) = _$TestEnum_ValueImpl;
  const TestEnum_Value._() : super._();

  @override
  int? get field0;

  /// Create a copy of TestEnum
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TestEnum_ValueImplCopyWith<_$TestEnum_ValueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

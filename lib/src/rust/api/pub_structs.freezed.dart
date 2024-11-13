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
mixin _$Thread {
  WalletMethod get field0 => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(WalletMethod field0) wallet,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(WalletMethod field0)? wallet,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(WalletMethod field0)? wallet,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Thread_Wallet value) wallet,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Thread_Wallet value)? wallet,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Thread_Wallet value)? wallet,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of Thread
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ThreadCopyWith<Thread> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ThreadCopyWith<$Res> {
  factory $ThreadCopyWith(Thread value, $Res Function(Thread) then) =
      _$ThreadCopyWithImpl<$Res, Thread>;
  @useResult
  $Res call({WalletMethod field0});
}

/// @nodoc
class _$ThreadCopyWithImpl<$Res, $Val extends Thread>
    implements $ThreadCopyWith<$Res> {
  _$ThreadCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Thread
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_value.copyWith(
      field0: null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as WalletMethod,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$Thread_WalletImplCopyWith<$Res>
    implements $ThreadCopyWith<$Res> {
  factory _$$Thread_WalletImplCopyWith(
          _$Thread_WalletImpl value, $Res Function(_$Thread_WalletImpl) then) =
      __$$Thread_WalletImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({WalletMethod field0});
}

/// @nodoc
class __$$Thread_WalletImplCopyWithImpl<$Res>
    extends _$ThreadCopyWithImpl<$Res, _$Thread_WalletImpl>
    implements _$$Thread_WalletImplCopyWith<$Res> {
  __$$Thread_WalletImplCopyWithImpl(
      _$Thread_WalletImpl _value, $Res Function(_$Thread_WalletImpl) _then)
      : super(_value, _then);

  /// Create a copy of Thread
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$Thread_WalletImpl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as WalletMethod,
    ));
  }
}

/// @nodoc

class _$Thread_WalletImpl extends Thread_Wallet {
  const _$Thread_WalletImpl(this.field0) : super._();

  @override
  final WalletMethod field0;

  @override
  String toString() {
    return 'Thread.wallet(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Thread_WalletImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of Thread
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$Thread_WalletImplCopyWith<_$Thread_WalletImpl> get copyWith =>
      __$$Thread_WalletImplCopyWithImpl<_$Thread_WalletImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(WalletMethod field0) wallet,
  }) {
    return wallet(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(WalletMethod field0)? wallet,
  }) {
    return wallet?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(WalletMethod field0)? wallet,
    required TResult orElse(),
  }) {
    if (wallet != null) {
      return wallet(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Thread_Wallet value) wallet,
  }) {
    return wallet(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Thread_Wallet value)? wallet,
  }) {
    return wallet?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Thread_Wallet value)? wallet,
    required TResult orElse(),
  }) {
    if (wallet != null) {
      return wallet(this);
    }
    return orElse();
  }
}

abstract class Thread_Wallet extends Thread {
  const factory Thread_Wallet(final WalletMethod field0) = _$Thread_WalletImpl;
  const Thread_Wallet._() : super._();

  @override
  WalletMethod get field0;

  /// Create a copy of Thread
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$Thread_WalletImplCopyWith<_$Thread_WalletImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

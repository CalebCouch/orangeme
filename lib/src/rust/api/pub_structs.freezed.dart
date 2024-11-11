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
mixin _$Field {
  Object? get field0 => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? field0) path,
    required TResult Function(double? field0) price,
    required TResult Function(bool? field0) internet,
    required TResult Function(Platform? field0) platform,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? field0)? path,
    TResult? Function(double? field0)? price,
    TResult? Function(bool? field0)? internet,
    TResult? Function(Platform? field0)? platform,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? field0)? path,
    TResult Function(double? field0)? price,
    TResult Function(bool? field0)? internet,
    TResult Function(Platform? field0)? platform,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Field_Path value) path,
    required TResult Function(Field_Price value) price,
    required TResult Function(Field_Internet value) internet,
    required TResult Function(Field_Platform value) platform,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Field_Path value)? path,
    TResult? Function(Field_Price value)? price,
    TResult? Function(Field_Internet value)? internet,
    TResult? Function(Field_Platform value)? platform,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Field_Path value)? path,
    TResult Function(Field_Price value)? price,
    TResult Function(Field_Internet value)? internet,
    TResult Function(Field_Platform value)? platform,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FieldCopyWith<$Res> {
  factory $FieldCopyWith(Field value, $Res Function(Field) then) =
      _$FieldCopyWithImpl<$Res, Field>;
}

/// @nodoc
class _$FieldCopyWithImpl<$Res, $Val extends Field>
    implements $FieldCopyWith<$Res> {
  _$FieldCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Field
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$Field_PathImplCopyWith<$Res> {
  factory _$$Field_PathImplCopyWith(
          _$Field_PathImpl value, $Res Function(_$Field_PathImpl) then) =
      __$$Field_PathImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String? field0});
}

/// @nodoc
class __$$Field_PathImplCopyWithImpl<$Res>
    extends _$FieldCopyWithImpl<$Res, _$Field_PathImpl>
    implements _$$Field_PathImplCopyWith<$Res> {
  __$$Field_PathImplCopyWithImpl(
      _$Field_PathImpl _value, $Res Function(_$Field_PathImpl) _then)
      : super(_value, _then);

  /// Create a copy of Field
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = freezed,
  }) {
    return _then(_$Field_PathImpl(
      freezed == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$Field_PathImpl extends Field_Path {
  const _$Field_PathImpl([this.field0]) : super._();

  @override
  final String? field0;

  @override
  String toString() {
    return 'Field.path(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Field_PathImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of Field
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$Field_PathImplCopyWith<_$Field_PathImpl> get copyWith =>
      __$$Field_PathImplCopyWithImpl<_$Field_PathImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? field0) path,
    required TResult Function(double? field0) price,
    required TResult Function(bool? field0) internet,
    required TResult Function(Platform? field0) platform,
  }) {
    return path(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? field0)? path,
    TResult? Function(double? field0)? price,
    TResult? Function(bool? field0)? internet,
    TResult? Function(Platform? field0)? platform,
  }) {
    return path?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? field0)? path,
    TResult Function(double? field0)? price,
    TResult Function(bool? field0)? internet,
    TResult Function(Platform? field0)? platform,
    required TResult orElse(),
  }) {
    if (path != null) {
      return path(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Field_Path value) path,
    required TResult Function(Field_Price value) price,
    required TResult Function(Field_Internet value) internet,
    required TResult Function(Field_Platform value) platform,
  }) {
    return path(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Field_Path value)? path,
    TResult? Function(Field_Price value)? price,
    TResult? Function(Field_Internet value)? internet,
    TResult? Function(Field_Platform value)? platform,
  }) {
    return path?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Field_Path value)? path,
    TResult Function(Field_Price value)? price,
    TResult Function(Field_Internet value)? internet,
    TResult Function(Field_Platform value)? platform,
    required TResult orElse(),
  }) {
    if (path != null) {
      return path(this);
    }
    return orElse();
  }
}

abstract class Field_Path extends Field {
  const factory Field_Path([final String? field0]) = _$Field_PathImpl;
  const Field_Path._() : super._();

  @override
  String? get field0;

  /// Create a copy of Field
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$Field_PathImplCopyWith<_$Field_PathImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$Field_PriceImplCopyWith<$Res> {
  factory _$$Field_PriceImplCopyWith(
          _$Field_PriceImpl value, $Res Function(_$Field_PriceImpl) then) =
      __$$Field_PriceImplCopyWithImpl<$Res>;
  @useResult
  $Res call({double? field0});
}

/// @nodoc
class __$$Field_PriceImplCopyWithImpl<$Res>
    extends _$FieldCopyWithImpl<$Res, _$Field_PriceImpl>
    implements _$$Field_PriceImplCopyWith<$Res> {
  __$$Field_PriceImplCopyWithImpl(
      _$Field_PriceImpl _value, $Res Function(_$Field_PriceImpl) _then)
      : super(_value, _then);

  /// Create a copy of Field
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = freezed,
  }) {
    return _then(_$Field_PriceImpl(
      freezed == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc

class _$Field_PriceImpl extends Field_Price {
  const _$Field_PriceImpl([this.field0]) : super._();

  @override
  final double? field0;

  @override
  String toString() {
    return 'Field.price(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Field_PriceImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of Field
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$Field_PriceImplCopyWith<_$Field_PriceImpl> get copyWith =>
      __$$Field_PriceImplCopyWithImpl<_$Field_PriceImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? field0) path,
    required TResult Function(double? field0) price,
    required TResult Function(bool? field0) internet,
    required TResult Function(Platform? field0) platform,
  }) {
    return price(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? field0)? path,
    TResult? Function(double? field0)? price,
    TResult? Function(bool? field0)? internet,
    TResult? Function(Platform? field0)? platform,
  }) {
    return price?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? field0)? path,
    TResult Function(double? field0)? price,
    TResult Function(bool? field0)? internet,
    TResult Function(Platform? field0)? platform,
    required TResult orElse(),
  }) {
    if (price != null) {
      return price(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Field_Path value) path,
    required TResult Function(Field_Price value) price,
    required TResult Function(Field_Internet value) internet,
    required TResult Function(Field_Platform value) platform,
  }) {
    return price(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Field_Path value)? path,
    TResult? Function(Field_Price value)? price,
    TResult? Function(Field_Internet value)? internet,
    TResult? Function(Field_Platform value)? platform,
  }) {
    return price?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Field_Path value)? path,
    TResult Function(Field_Price value)? price,
    TResult Function(Field_Internet value)? internet,
    TResult Function(Field_Platform value)? platform,
    required TResult orElse(),
  }) {
    if (price != null) {
      return price(this);
    }
    return orElse();
  }
}

abstract class Field_Price extends Field {
  const factory Field_Price([final double? field0]) = _$Field_PriceImpl;
  const Field_Price._() : super._();

  @override
  double? get field0;

  /// Create a copy of Field
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$Field_PriceImplCopyWith<_$Field_PriceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$Field_InternetImplCopyWith<$Res> {
  factory _$$Field_InternetImplCopyWith(_$Field_InternetImpl value,
          $Res Function(_$Field_InternetImpl) then) =
      __$$Field_InternetImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool? field0});
}

/// @nodoc
class __$$Field_InternetImplCopyWithImpl<$Res>
    extends _$FieldCopyWithImpl<$Res, _$Field_InternetImpl>
    implements _$$Field_InternetImplCopyWith<$Res> {
  __$$Field_InternetImplCopyWithImpl(
      _$Field_InternetImpl _value, $Res Function(_$Field_InternetImpl) _then)
      : super(_value, _then);

  /// Create a copy of Field
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = freezed,
  }) {
    return _then(_$Field_InternetImpl(
      freezed == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc

class _$Field_InternetImpl extends Field_Internet {
  const _$Field_InternetImpl([this.field0]) : super._();

  @override
  final bool? field0;

  @override
  String toString() {
    return 'Field.internet(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Field_InternetImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of Field
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$Field_InternetImplCopyWith<_$Field_InternetImpl> get copyWith =>
      __$$Field_InternetImplCopyWithImpl<_$Field_InternetImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? field0) path,
    required TResult Function(double? field0) price,
    required TResult Function(bool? field0) internet,
    required TResult Function(Platform? field0) platform,
  }) {
    return internet(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? field0)? path,
    TResult? Function(double? field0)? price,
    TResult? Function(bool? field0)? internet,
    TResult? Function(Platform? field0)? platform,
  }) {
    return internet?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? field0)? path,
    TResult Function(double? field0)? price,
    TResult Function(bool? field0)? internet,
    TResult Function(Platform? field0)? platform,
    required TResult orElse(),
  }) {
    if (internet != null) {
      return internet(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Field_Path value) path,
    required TResult Function(Field_Price value) price,
    required TResult Function(Field_Internet value) internet,
    required TResult Function(Field_Platform value) platform,
  }) {
    return internet(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Field_Path value)? path,
    TResult? Function(Field_Price value)? price,
    TResult? Function(Field_Internet value)? internet,
    TResult? Function(Field_Platform value)? platform,
  }) {
    return internet?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Field_Path value)? path,
    TResult Function(Field_Price value)? price,
    TResult Function(Field_Internet value)? internet,
    TResult Function(Field_Platform value)? platform,
    required TResult orElse(),
  }) {
    if (internet != null) {
      return internet(this);
    }
    return orElse();
  }
}

abstract class Field_Internet extends Field {
  const factory Field_Internet([final bool? field0]) = _$Field_InternetImpl;
  const Field_Internet._() : super._();

  @override
  bool? get field0;

  /// Create a copy of Field
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$Field_InternetImplCopyWith<_$Field_InternetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$Field_PlatformImplCopyWith<$Res> {
  factory _$$Field_PlatformImplCopyWith(_$Field_PlatformImpl value,
          $Res Function(_$Field_PlatformImpl) then) =
      __$$Field_PlatformImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Platform? field0});
}

/// @nodoc
class __$$Field_PlatformImplCopyWithImpl<$Res>
    extends _$FieldCopyWithImpl<$Res, _$Field_PlatformImpl>
    implements _$$Field_PlatformImplCopyWith<$Res> {
  __$$Field_PlatformImplCopyWithImpl(
      _$Field_PlatformImpl _value, $Res Function(_$Field_PlatformImpl) _then)
      : super(_value, _then);

  /// Create a copy of Field
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = freezed,
  }) {
    return _then(_$Field_PlatformImpl(
      freezed == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as Platform?,
    ));
  }
}

/// @nodoc

class _$Field_PlatformImpl extends Field_Platform {
  const _$Field_PlatformImpl([this.field0]) : super._();

  @override
  final Platform? field0;

  @override
  String toString() {
    return 'Field.platform(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Field_PlatformImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of Field
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$Field_PlatformImplCopyWith<_$Field_PlatformImpl> get copyWith =>
      __$$Field_PlatformImplCopyWithImpl<_$Field_PlatformImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? field0) path,
    required TResult Function(double? field0) price,
    required TResult Function(bool? field0) internet,
    required TResult Function(Platform? field0) platform,
  }) {
    return platform(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? field0)? path,
    TResult? Function(double? field0)? price,
    TResult? Function(bool? field0)? internet,
    TResult? Function(Platform? field0)? platform,
  }) {
    return platform?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? field0)? path,
    TResult Function(double? field0)? price,
    TResult Function(bool? field0)? internet,
    TResult Function(Platform? field0)? platform,
    required TResult orElse(),
  }) {
    if (platform != null) {
      return platform(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Field_Path value) path,
    required TResult Function(Field_Price value) price,
    required TResult Function(Field_Internet value) internet,
    required TResult Function(Field_Platform value) platform,
  }) {
    return platform(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Field_Path value)? path,
    TResult? Function(Field_Price value)? price,
    TResult? Function(Field_Internet value)? internet,
    TResult? Function(Field_Platform value)? platform,
  }) {
    return platform?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Field_Path value)? path,
    TResult Function(Field_Price value)? price,
    TResult Function(Field_Internet value)? internet,
    TResult Function(Field_Platform value)? platform,
    required TResult orElse(),
  }) {
    if (platform != null) {
      return platform(this);
    }
    return orElse();
  }
}

abstract class Field_Platform extends Field {
  const factory Field_Platform([final Platform? field0]) = _$Field_PlatformImpl;
  const Field_Platform._() : super._();

  @override
  Platform? get field0;

  /// Create a copy of Field
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$Field_PlatformImplCopyWith<_$Field_PlatformImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

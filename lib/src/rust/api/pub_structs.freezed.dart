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
mixin _$DartMethod {
  String get field0 => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0, String field1) storageSet,
    required TResult Function(String field0) storageGet,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String field0, String field1)? storageSet,
    TResult? Function(String field0)? storageGet,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String field0, String field1)? storageSet,
    TResult Function(String field0)? storageGet,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DartMethod_StorageSet value) storageSet,
    required TResult Function(DartMethod_StorageGet value) storageGet,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DartMethod_StorageSet value)? storageSet,
    TResult? Function(DartMethod_StorageGet value)? storageGet,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DartMethod_StorageSet value)? storageSet,
    TResult Function(DartMethod_StorageGet value)? storageGet,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of DartMethod
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DartMethodCopyWith<DartMethod> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DartMethodCopyWith<$Res> {
  factory $DartMethodCopyWith(
          DartMethod value, $Res Function(DartMethod) then) =
      _$DartMethodCopyWithImpl<$Res, DartMethod>;
  @useResult
  $Res call({String field0});
}

/// @nodoc
class _$DartMethodCopyWithImpl<$Res, $Val extends DartMethod>
    implements $DartMethodCopyWith<$Res> {
  _$DartMethodCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DartMethod
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
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DartMethod_StorageSetImplCopyWith<$Res>
    implements $DartMethodCopyWith<$Res> {
  factory _$$DartMethod_StorageSetImplCopyWith(
          _$DartMethod_StorageSetImpl value,
          $Res Function(_$DartMethod_StorageSetImpl) then) =
      __$$DartMethod_StorageSetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String field0, String field1});
}

/// @nodoc
class __$$DartMethod_StorageSetImplCopyWithImpl<$Res>
    extends _$DartMethodCopyWithImpl<$Res, _$DartMethod_StorageSetImpl>
    implements _$$DartMethod_StorageSetImplCopyWith<$Res> {
  __$$DartMethod_StorageSetImplCopyWithImpl(_$DartMethod_StorageSetImpl _value,
      $Res Function(_$DartMethod_StorageSetImpl) _then)
      : super(_value, _then);

  /// Create a copy of DartMethod
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
    Object? field1 = null,
  }) {
    return _then(_$DartMethod_StorageSetImpl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as String,
      null == field1
          ? _value.field1
          : field1 // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$DartMethod_StorageSetImpl extends DartMethod_StorageSet {
  const _$DartMethod_StorageSetImpl(this.field0, this.field1) : super._();

  @override
  final String field0;
  @override
  final String field1;

  @override
  String toString() {
    return 'DartMethod.storageSet(field0: $field0, field1: $field1)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DartMethod_StorageSetImpl &&
            (identical(other.field0, field0) || other.field0 == field0) &&
            (identical(other.field1, field1) || other.field1 == field1));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0, field1);

  /// Create a copy of DartMethod
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DartMethod_StorageSetImplCopyWith<_$DartMethod_StorageSetImpl>
      get copyWith => __$$DartMethod_StorageSetImplCopyWithImpl<
          _$DartMethod_StorageSetImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0, String field1) storageSet,
    required TResult Function(String field0) storageGet,
  }) {
    return storageSet(field0, field1);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String field0, String field1)? storageSet,
    TResult? Function(String field0)? storageGet,
  }) {
    return storageSet?.call(field0, field1);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String field0, String field1)? storageSet,
    TResult Function(String field0)? storageGet,
    required TResult orElse(),
  }) {
    if (storageSet != null) {
      return storageSet(field0, field1);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DartMethod_StorageSet value) storageSet,
    required TResult Function(DartMethod_StorageGet value) storageGet,
  }) {
    return storageSet(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DartMethod_StorageSet value)? storageSet,
    TResult? Function(DartMethod_StorageGet value)? storageGet,
  }) {
    return storageSet?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DartMethod_StorageSet value)? storageSet,
    TResult Function(DartMethod_StorageGet value)? storageGet,
    required TResult orElse(),
  }) {
    if (storageSet != null) {
      return storageSet(this);
    }
    return orElse();
  }
}

abstract class DartMethod_StorageSet extends DartMethod {
  const factory DartMethod_StorageSet(
      final String field0, final String field1) = _$DartMethod_StorageSetImpl;
  const DartMethod_StorageSet._() : super._();

  @override
  String get field0;
  String get field1;

  /// Create a copy of DartMethod
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DartMethod_StorageSetImplCopyWith<_$DartMethod_StorageSetImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DartMethod_StorageGetImplCopyWith<$Res>
    implements $DartMethodCopyWith<$Res> {
  factory _$$DartMethod_StorageGetImplCopyWith(
          _$DartMethod_StorageGetImpl value,
          $Res Function(_$DartMethod_StorageGetImpl) then) =
      __$$DartMethod_StorageGetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String field0});
}

/// @nodoc
class __$$DartMethod_StorageGetImplCopyWithImpl<$Res>
    extends _$DartMethodCopyWithImpl<$Res, _$DartMethod_StorageGetImpl>
    implements _$$DartMethod_StorageGetImplCopyWith<$Res> {
  __$$DartMethod_StorageGetImplCopyWithImpl(_$DartMethod_StorageGetImpl _value,
      $Res Function(_$DartMethod_StorageGetImpl) _then)
      : super(_value, _then);

  /// Create a copy of DartMethod
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$DartMethod_StorageGetImpl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$DartMethod_StorageGetImpl extends DartMethod_StorageGet {
  const _$DartMethod_StorageGetImpl(this.field0) : super._();

  @override
  final String field0;

  @override
  String toString() {
    return 'DartMethod.storageGet(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DartMethod_StorageGetImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of DartMethod
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DartMethod_StorageGetImplCopyWith<_$DartMethod_StorageGetImpl>
      get copyWith => __$$DartMethod_StorageGetImplCopyWithImpl<
          _$DartMethod_StorageGetImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0, String field1) storageSet,
    required TResult Function(String field0) storageGet,
  }) {
    return storageGet(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String field0, String field1)? storageSet,
    TResult? Function(String field0)? storageGet,
  }) {
    return storageGet?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String field0, String field1)? storageSet,
    TResult Function(String field0)? storageGet,
    required TResult orElse(),
  }) {
    if (storageGet != null) {
      return storageGet(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DartMethod_StorageSet value) storageSet,
    required TResult Function(DartMethod_StorageGet value) storageGet,
  }) {
    return storageGet(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DartMethod_StorageSet value)? storageSet,
    TResult? Function(DartMethod_StorageGet value)? storageGet,
  }) {
    return storageGet?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DartMethod_StorageSet value)? storageSet,
    TResult Function(DartMethod_StorageGet value)? storageGet,
    required TResult orElse(),
  }) {
    if (storageGet != null) {
      return storageGet(this);
    }
    return orElse();
  }
}

abstract class DartMethod_StorageGet extends DartMethod {
  const factory DartMethod_StorageGet(final String field0) =
      _$DartMethod_StorageGetImpl;
  const DartMethod_StorageGet._() : super._();

  @override
  String get field0;

  /// Create a copy of DartMethod
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DartMethod_StorageGetImplCopyWith<_$DartMethod_StorageGetImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PageName {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() bitcoinHome,
    required TResult Function(String field0) viewTransaction,
    required TResult Function() receive,
    required TResult Function(String field0) send,
    required TResult Function(String field0) amount,
    required TResult Function(BigInt field0) speed,
    required TResult Function(String field0, BigInt field1, BigInt field2)
        confirm,
    required TResult Function(String field0) success,
    required TResult Function(bool field0) myProfile,
    required TResult Function(bool field0) userProfile,
    required TResult Function() messagesHome,
    required TResult Function() chooseRecipient,
    required TResult Function() currentConversation,
    required TResult Function() conversationInfo,
    required TResult Function(String field0) test,
    required TResult Function() scan,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? bitcoinHome,
    TResult? Function(String field0)? viewTransaction,
    TResult? Function()? receive,
    TResult? Function(String field0)? send,
    TResult? Function(String field0)? amount,
    TResult? Function(BigInt field0)? speed,
    TResult? Function(String field0, BigInt field1, BigInt field2)? confirm,
    TResult? Function(String field0)? success,
    TResult? Function(bool field0)? myProfile,
    TResult? Function(bool field0)? userProfile,
    TResult? Function()? messagesHome,
    TResult? Function()? chooseRecipient,
    TResult? Function()? currentConversation,
    TResult? Function()? conversationInfo,
    TResult? Function(String field0)? test,
    TResult? Function()? scan,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? bitcoinHome,
    TResult Function(String field0)? viewTransaction,
    TResult Function()? receive,
    TResult Function(String field0)? send,
    TResult Function(String field0)? amount,
    TResult Function(BigInt field0)? speed,
    TResult Function(String field0, BigInt field1, BigInt field2)? confirm,
    TResult Function(String field0)? success,
    TResult Function(bool field0)? myProfile,
    TResult Function(bool field0)? userProfile,
    TResult Function()? messagesHome,
    TResult Function()? chooseRecipient,
    TResult Function()? currentConversation,
    TResult Function()? conversationInfo,
    TResult Function(String field0)? test,
    TResult Function()? scan,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PageName_BitcoinHome value) bitcoinHome,
    required TResult Function(PageName_ViewTransaction value) viewTransaction,
    required TResult Function(PageName_Receive value) receive,
    required TResult Function(PageName_Send value) send,
    required TResult Function(PageName_Amount value) amount,
    required TResult Function(PageName_Speed value) speed,
    required TResult Function(PageName_Confirm value) confirm,
    required TResult Function(PageName_Success value) success,
    required TResult Function(PageName_MyProfile value) myProfile,
    required TResult Function(PageName_UserProfile value) userProfile,
    required TResult Function(PageName_MessagesHome value) messagesHome,
    required TResult Function(PageName_ChooseRecipient value) chooseRecipient,
    required TResult Function(PageName_CurrentConversation value)
        currentConversation,
    required TResult Function(PageName_ConversationInfo value) conversationInfo,
    required TResult Function(PageName_Test value) test,
    required TResult Function(PageName_Scan value) scan,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PageName_BitcoinHome value)? bitcoinHome,
    TResult? Function(PageName_ViewTransaction value)? viewTransaction,
    TResult? Function(PageName_Receive value)? receive,
    TResult? Function(PageName_Send value)? send,
    TResult? Function(PageName_Amount value)? amount,
    TResult? Function(PageName_Speed value)? speed,
    TResult? Function(PageName_Confirm value)? confirm,
    TResult? Function(PageName_Success value)? success,
    TResult? Function(PageName_MyProfile value)? myProfile,
    TResult? Function(PageName_UserProfile value)? userProfile,
    TResult? Function(PageName_MessagesHome value)? messagesHome,
    TResult? Function(PageName_ChooseRecipient value)? chooseRecipient,
    TResult? Function(PageName_CurrentConversation value)? currentConversation,
    TResult? Function(PageName_ConversationInfo value)? conversationInfo,
    TResult? Function(PageName_Test value)? test,
    TResult? Function(PageName_Scan value)? scan,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PageName_BitcoinHome value)? bitcoinHome,
    TResult Function(PageName_ViewTransaction value)? viewTransaction,
    TResult Function(PageName_Receive value)? receive,
    TResult Function(PageName_Send value)? send,
    TResult Function(PageName_Amount value)? amount,
    TResult Function(PageName_Speed value)? speed,
    TResult Function(PageName_Confirm value)? confirm,
    TResult Function(PageName_Success value)? success,
    TResult Function(PageName_MyProfile value)? myProfile,
    TResult Function(PageName_UserProfile value)? userProfile,
    TResult Function(PageName_MessagesHome value)? messagesHome,
    TResult Function(PageName_ChooseRecipient value)? chooseRecipient,
    TResult Function(PageName_CurrentConversation value)? currentConversation,
    TResult Function(PageName_ConversationInfo value)? conversationInfo,
    TResult Function(PageName_Test value)? test,
    TResult Function(PageName_Scan value)? scan,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PageNameCopyWith<$Res> {
  factory $PageNameCopyWith(PageName value, $Res Function(PageName) then) =
      _$PageNameCopyWithImpl<$Res, PageName>;
}

/// @nodoc
class _$PageNameCopyWithImpl<$Res, $Val extends PageName>
    implements $PageNameCopyWith<$Res> {
  _$PageNameCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PageName
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$PageName_BitcoinHomeImplCopyWith<$Res> {
  factory _$$PageName_BitcoinHomeImplCopyWith(_$PageName_BitcoinHomeImpl value,
          $Res Function(_$PageName_BitcoinHomeImpl) then) =
      __$$PageName_BitcoinHomeImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PageName_BitcoinHomeImplCopyWithImpl<$Res>
    extends _$PageNameCopyWithImpl<$Res, _$PageName_BitcoinHomeImpl>
    implements _$$PageName_BitcoinHomeImplCopyWith<$Res> {
  __$$PageName_BitcoinHomeImplCopyWithImpl(_$PageName_BitcoinHomeImpl _value,
      $Res Function(_$PageName_BitcoinHomeImpl) _then)
      : super(_value, _then);

  /// Create a copy of PageName
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PageName_BitcoinHomeImpl extends PageName_BitcoinHome {
  const _$PageName_BitcoinHomeImpl() : super._();

  @override
  String toString() {
    return 'PageName.bitcoinHome()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PageName_BitcoinHomeImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() bitcoinHome,
    required TResult Function(String field0) viewTransaction,
    required TResult Function() receive,
    required TResult Function(String field0) send,
    required TResult Function(String field0) amount,
    required TResult Function(BigInt field0) speed,
    required TResult Function(String field0, BigInt field1, BigInt field2)
        confirm,
    required TResult Function(String field0) success,
    required TResult Function(bool field0) myProfile,
    required TResult Function(bool field0) userProfile,
    required TResult Function() messagesHome,
    required TResult Function() chooseRecipient,
    required TResult Function() currentConversation,
    required TResult Function() conversationInfo,
    required TResult Function(String field0) test,
    required TResult Function() scan,
  }) {
    return bitcoinHome();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? bitcoinHome,
    TResult? Function(String field0)? viewTransaction,
    TResult? Function()? receive,
    TResult? Function(String field0)? send,
    TResult? Function(String field0)? amount,
    TResult? Function(BigInt field0)? speed,
    TResult? Function(String field0, BigInt field1, BigInt field2)? confirm,
    TResult? Function(String field0)? success,
    TResult? Function(bool field0)? myProfile,
    TResult? Function(bool field0)? userProfile,
    TResult? Function()? messagesHome,
    TResult? Function()? chooseRecipient,
    TResult? Function()? currentConversation,
    TResult? Function()? conversationInfo,
    TResult? Function(String field0)? test,
    TResult? Function()? scan,
  }) {
    return bitcoinHome?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? bitcoinHome,
    TResult Function(String field0)? viewTransaction,
    TResult Function()? receive,
    TResult Function(String field0)? send,
    TResult Function(String field0)? amount,
    TResult Function(BigInt field0)? speed,
    TResult Function(String field0, BigInt field1, BigInt field2)? confirm,
    TResult Function(String field0)? success,
    TResult Function(bool field0)? myProfile,
    TResult Function(bool field0)? userProfile,
    TResult Function()? messagesHome,
    TResult Function()? chooseRecipient,
    TResult Function()? currentConversation,
    TResult Function()? conversationInfo,
    TResult Function(String field0)? test,
    TResult Function()? scan,
    required TResult orElse(),
  }) {
    if (bitcoinHome != null) {
      return bitcoinHome();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PageName_BitcoinHome value) bitcoinHome,
    required TResult Function(PageName_ViewTransaction value) viewTransaction,
    required TResult Function(PageName_Receive value) receive,
    required TResult Function(PageName_Send value) send,
    required TResult Function(PageName_Amount value) amount,
    required TResult Function(PageName_Speed value) speed,
    required TResult Function(PageName_Confirm value) confirm,
    required TResult Function(PageName_Success value) success,
    required TResult Function(PageName_MyProfile value) myProfile,
    required TResult Function(PageName_UserProfile value) userProfile,
    required TResult Function(PageName_MessagesHome value) messagesHome,
    required TResult Function(PageName_ChooseRecipient value) chooseRecipient,
    required TResult Function(PageName_CurrentConversation value)
        currentConversation,
    required TResult Function(PageName_ConversationInfo value) conversationInfo,
    required TResult Function(PageName_Test value) test,
    required TResult Function(PageName_Scan value) scan,
  }) {
    return bitcoinHome(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PageName_BitcoinHome value)? bitcoinHome,
    TResult? Function(PageName_ViewTransaction value)? viewTransaction,
    TResult? Function(PageName_Receive value)? receive,
    TResult? Function(PageName_Send value)? send,
    TResult? Function(PageName_Amount value)? amount,
    TResult? Function(PageName_Speed value)? speed,
    TResult? Function(PageName_Confirm value)? confirm,
    TResult? Function(PageName_Success value)? success,
    TResult? Function(PageName_MyProfile value)? myProfile,
    TResult? Function(PageName_UserProfile value)? userProfile,
    TResult? Function(PageName_MessagesHome value)? messagesHome,
    TResult? Function(PageName_ChooseRecipient value)? chooseRecipient,
    TResult? Function(PageName_CurrentConversation value)? currentConversation,
    TResult? Function(PageName_ConversationInfo value)? conversationInfo,
    TResult? Function(PageName_Test value)? test,
    TResult? Function(PageName_Scan value)? scan,
  }) {
    return bitcoinHome?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PageName_BitcoinHome value)? bitcoinHome,
    TResult Function(PageName_ViewTransaction value)? viewTransaction,
    TResult Function(PageName_Receive value)? receive,
    TResult Function(PageName_Send value)? send,
    TResult Function(PageName_Amount value)? amount,
    TResult Function(PageName_Speed value)? speed,
    TResult Function(PageName_Confirm value)? confirm,
    TResult Function(PageName_Success value)? success,
    TResult Function(PageName_MyProfile value)? myProfile,
    TResult Function(PageName_UserProfile value)? userProfile,
    TResult Function(PageName_MessagesHome value)? messagesHome,
    TResult Function(PageName_ChooseRecipient value)? chooseRecipient,
    TResult Function(PageName_CurrentConversation value)? currentConversation,
    TResult Function(PageName_ConversationInfo value)? conversationInfo,
    TResult Function(PageName_Test value)? test,
    TResult Function(PageName_Scan value)? scan,
    required TResult orElse(),
  }) {
    if (bitcoinHome != null) {
      return bitcoinHome(this);
    }
    return orElse();
  }
}

abstract class PageName_BitcoinHome extends PageName {
  const factory PageName_BitcoinHome() = _$PageName_BitcoinHomeImpl;
  const PageName_BitcoinHome._() : super._();
}

/// @nodoc
abstract class _$$PageName_ViewTransactionImplCopyWith<$Res> {
  factory _$$PageName_ViewTransactionImplCopyWith(
          _$PageName_ViewTransactionImpl value,
          $Res Function(_$PageName_ViewTransactionImpl) then) =
      __$$PageName_ViewTransactionImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String field0});
}

/// @nodoc
class __$$PageName_ViewTransactionImplCopyWithImpl<$Res>
    extends _$PageNameCopyWithImpl<$Res, _$PageName_ViewTransactionImpl>
    implements _$$PageName_ViewTransactionImplCopyWith<$Res> {
  __$$PageName_ViewTransactionImplCopyWithImpl(
      _$PageName_ViewTransactionImpl _value,
      $Res Function(_$PageName_ViewTransactionImpl) _then)
      : super(_value, _then);

  /// Create a copy of PageName
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$PageName_ViewTransactionImpl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$PageName_ViewTransactionImpl extends PageName_ViewTransaction {
  const _$PageName_ViewTransactionImpl(this.field0) : super._();

  @override
  final String field0;

  @override
  String toString() {
    return 'PageName.viewTransaction(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PageName_ViewTransactionImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of PageName
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PageName_ViewTransactionImplCopyWith<_$PageName_ViewTransactionImpl>
      get copyWith => __$$PageName_ViewTransactionImplCopyWithImpl<
          _$PageName_ViewTransactionImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() bitcoinHome,
    required TResult Function(String field0) viewTransaction,
    required TResult Function() receive,
    required TResult Function(String field0) send,
    required TResult Function(String field0) amount,
    required TResult Function(BigInt field0) speed,
    required TResult Function(String field0, BigInt field1, BigInt field2)
        confirm,
    required TResult Function(String field0) success,
    required TResult Function(bool field0) myProfile,
    required TResult Function(bool field0) userProfile,
    required TResult Function() messagesHome,
    required TResult Function() chooseRecipient,
    required TResult Function() currentConversation,
    required TResult Function() conversationInfo,
    required TResult Function(String field0) test,
    required TResult Function() scan,
  }) {
    return viewTransaction(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? bitcoinHome,
    TResult? Function(String field0)? viewTransaction,
    TResult? Function()? receive,
    TResult? Function(String field0)? send,
    TResult? Function(String field0)? amount,
    TResult? Function(BigInt field0)? speed,
    TResult? Function(String field0, BigInt field1, BigInt field2)? confirm,
    TResult? Function(String field0)? success,
    TResult? Function(bool field0)? myProfile,
    TResult? Function(bool field0)? userProfile,
    TResult? Function()? messagesHome,
    TResult? Function()? chooseRecipient,
    TResult? Function()? currentConversation,
    TResult? Function()? conversationInfo,
    TResult? Function(String field0)? test,
    TResult? Function()? scan,
  }) {
    return viewTransaction?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? bitcoinHome,
    TResult Function(String field0)? viewTransaction,
    TResult Function()? receive,
    TResult Function(String field0)? send,
    TResult Function(String field0)? amount,
    TResult Function(BigInt field0)? speed,
    TResult Function(String field0, BigInt field1, BigInt field2)? confirm,
    TResult Function(String field0)? success,
    TResult Function(bool field0)? myProfile,
    TResult Function(bool field0)? userProfile,
    TResult Function()? messagesHome,
    TResult Function()? chooseRecipient,
    TResult Function()? currentConversation,
    TResult Function()? conversationInfo,
    TResult Function(String field0)? test,
    TResult Function()? scan,
    required TResult orElse(),
  }) {
    if (viewTransaction != null) {
      return viewTransaction(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PageName_BitcoinHome value) bitcoinHome,
    required TResult Function(PageName_ViewTransaction value) viewTransaction,
    required TResult Function(PageName_Receive value) receive,
    required TResult Function(PageName_Send value) send,
    required TResult Function(PageName_Amount value) amount,
    required TResult Function(PageName_Speed value) speed,
    required TResult Function(PageName_Confirm value) confirm,
    required TResult Function(PageName_Success value) success,
    required TResult Function(PageName_MyProfile value) myProfile,
    required TResult Function(PageName_UserProfile value) userProfile,
    required TResult Function(PageName_MessagesHome value) messagesHome,
    required TResult Function(PageName_ChooseRecipient value) chooseRecipient,
    required TResult Function(PageName_CurrentConversation value)
        currentConversation,
    required TResult Function(PageName_ConversationInfo value) conversationInfo,
    required TResult Function(PageName_Test value) test,
    required TResult Function(PageName_Scan value) scan,
  }) {
    return viewTransaction(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PageName_BitcoinHome value)? bitcoinHome,
    TResult? Function(PageName_ViewTransaction value)? viewTransaction,
    TResult? Function(PageName_Receive value)? receive,
    TResult? Function(PageName_Send value)? send,
    TResult? Function(PageName_Amount value)? amount,
    TResult? Function(PageName_Speed value)? speed,
    TResult? Function(PageName_Confirm value)? confirm,
    TResult? Function(PageName_Success value)? success,
    TResult? Function(PageName_MyProfile value)? myProfile,
    TResult? Function(PageName_UserProfile value)? userProfile,
    TResult? Function(PageName_MessagesHome value)? messagesHome,
    TResult? Function(PageName_ChooseRecipient value)? chooseRecipient,
    TResult? Function(PageName_CurrentConversation value)? currentConversation,
    TResult? Function(PageName_ConversationInfo value)? conversationInfo,
    TResult? Function(PageName_Test value)? test,
    TResult? Function(PageName_Scan value)? scan,
  }) {
    return viewTransaction?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PageName_BitcoinHome value)? bitcoinHome,
    TResult Function(PageName_ViewTransaction value)? viewTransaction,
    TResult Function(PageName_Receive value)? receive,
    TResult Function(PageName_Send value)? send,
    TResult Function(PageName_Amount value)? amount,
    TResult Function(PageName_Speed value)? speed,
    TResult Function(PageName_Confirm value)? confirm,
    TResult Function(PageName_Success value)? success,
    TResult Function(PageName_MyProfile value)? myProfile,
    TResult Function(PageName_UserProfile value)? userProfile,
    TResult Function(PageName_MessagesHome value)? messagesHome,
    TResult Function(PageName_ChooseRecipient value)? chooseRecipient,
    TResult Function(PageName_CurrentConversation value)? currentConversation,
    TResult Function(PageName_ConversationInfo value)? conversationInfo,
    TResult Function(PageName_Test value)? test,
    TResult Function(PageName_Scan value)? scan,
    required TResult orElse(),
  }) {
    if (viewTransaction != null) {
      return viewTransaction(this);
    }
    return orElse();
  }
}

abstract class PageName_ViewTransaction extends PageName {
  const factory PageName_ViewTransaction(final String field0) =
      _$PageName_ViewTransactionImpl;
  const PageName_ViewTransaction._() : super._();

  String get field0;

  /// Create a copy of PageName
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PageName_ViewTransactionImplCopyWith<_$PageName_ViewTransactionImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PageName_ReceiveImplCopyWith<$Res> {
  factory _$$PageName_ReceiveImplCopyWith(_$PageName_ReceiveImpl value,
          $Res Function(_$PageName_ReceiveImpl) then) =
      __$$PageName_ReceiveImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PageName_ReceiveImplCopyWithImpl<$Res>
    extends _$PageNameCopyWithImpl<$Res, _$PageName_ReceiveImpl>
    implements _$$PageName_ReceiveImplCopyWith<$Res> {
  __$$PageName_ReceiveImplCopyWithImpl(_$PageName_ReceiveImpl _value,
      $Res Function(_$PageName_ReceiveImpl) _then)
      : super(_value, _then);

  /// Create a copy of PageName
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PageName_ReceiveImpl extends PageName_Receive {
  const _$PageName_ReceiveImpl() : super._();

  @override
  String toString() {
    return 'PageName.receive()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$PageName_ReceiveImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() bitcoinHome,
    required TResult Function(String field0) viewTransaction,
    required TResult Function() receive,
    required TResult Function(String field0) send,
    required TResult Function(String field0) amount,
    required TResult Function(BigInt field0) speed,
    required TResult Function(String field0, BigInt field1, BigInt field2)
        confirm,
    required TResult Function(String field0) success,
    required TResult Function(bool field0) myProfile,
    required TResult Function(bool field0) userProfile,
    required TResult Function() messagesHome,
    required TResult Function() chooseRecipient,
    required TResult Function() currentConversation,
    required TResult Function() conversationInfo,
    required TResult Function(String field0) test,
    required TResult Function() scan,
  }) {
    return receive();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? bitcoinHome,
    TResult? Function(String field0)? viewTransaction,
    TResult? Function()? receive,
    TResult? Function(String field0)? send,
    TResult? Function(String field0)? amount,
    TResult? Function(BigInt field0)? speed,
    TResult? Function(String field0, BigInt field1, BigInt field2)? confirm,
    TResult? Function(String field0)? success,
    TResult? Function(bool field0)? myProfile,
    TResult? Function(bool field0)? userProfile,
    TResult? Function()? messagesHome,
    TResult? Function()? chooseRecipient,
    TResult? Function()? currentConversation,
    TResult? Function()? conversationInfo,
    TResult? Function(String field0)? test,
    TResult? Function()? scan,
  }) {
    return receive?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? bitcoinHome,
    TResult Function(String field0)? viewTransaction,
    TResult Function()? receive,
    TResult Function(String field0)? send,
    TResult Function(String field0)? amount,
    TResult Function(BigInt field0)? speed,
    TResult Function(String field0, BigInt field1, BigInt field2)? confirm,
    TResult Function(String field0)? success,
    TResult Function(bool field0)? myProfile,
    TResult Function(bool field0)? userProfile,
    TResult Function()? messagesHome,
    TResult Function()? chooseRecipient,
    TResult Function()? currentConversation,
    TResult Function()? conversationInfo,
    TResult Function(String field0)? test,
    TResult Function()? scan,
    required TResult orElse(),
  }) {
    if (receive != null) {
      return receive();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PageName_BitcoinHome value) bitcoinHome,
    required TResult Function(PageName_ViewTransaction value) viewTransaction,
    required TResult Function(PageName_Receive value) receive,
    required TResult Function(PageName_Send value) send,
    required TResult Function(PageName_Amount value) amount,
    required TResult Function(PageName_Speed value) speed,
    required TResult Function(PageName_Confirm value) confirm,
    required TResult Function(PageName_Success value) success,
    required TResult Function(PageName_MyProfile value) myProfile,
    required TResult Function(PageName_UserProfile value) userProfile,
    required TResult Function(PageName_MessagesHome value) messagesHome,
    required TResult Function(PageName_ChooseRecipient value) chooseRecipient,
    required TResult Function(PageName_CurrentConversation value)
        currentConversation,
    required TResult Function(PageName_ConversationInfo value) conversationInfo,
    required TResult Function(PageName_Test value) test,
    required TResult Function(PageName_Scan value) scan,
  }) {
    return receive(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PageName_BitcoinHome value)? bitcoinHome,
    TResult? Function(PageName_ViewTransaction value)? viewTransaction,
    TResult? Function(PageName_Receive value)? receive,
    TResult? Function(PageName_Send value)? send,
    TResult? Function(PageName_Amount value)? amount,
    TResult? Function(PageName_Speed value)? speed,
    TResult? Function(PageName_Confirm value)? confirm,
    TResult? Function(PageName_Success value)? success,
    TResult? Function(PageName_MyProfile value)? myProfile,
    TResult? Function(PageName_UserProfile value)? userProfile,
    TResult? Function(PageName_MessagesHome value)? messagesHome,
    TResult? Function(PageName_ChooseRecipient value)? chooseRecipient,
    TResult? Function(PageName_CurrentConversation value)? currentConversation,
    TResult? Function(PageName_ConversationInfo value)? conversationInfo,
    TResult? Function(PageName_Test value)? test,
    TResult? Function(PageName_Scan value)? scan,
  }) {
    return receive?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PageName_BitcoinHome value)? bitcoinHome,
    TResult Function(PageName_ViewTransaction value)? viewTransaction,
    TResult Function(PageName_Receive value)? receive,
    TResult Function(PageName_Send value)? send,
    TResult Function(PageName_Amount value)? amount,
    TResult Function(PageName_Speed value)? speed,
    TResult Function(PageName_Confirm value)? confirm,
    TResult Function(PageName_Success value)? success,
    TResult Function(PageName_MyProfile value)? myProfile,
    TResult Function(PageName_UserProfile value)? userProfile,
    TResult Function(PageName_MessagesHome value)? messagesHome,
    TResult Function(PageName_ChooseRecipient value)? chooseRecipient,
    TResult Function(PageName_CurrentConversation value)? currentConversation,
    TResult Function(PageName_ConversationInfo value)? conversationInfo,
    TResult Function(PageName_Test value)? test,
    TResult Function(PageName_Scan value)? scan,
    required TResult orElse(),
  }) {
    if (receive != null) {
      return receive(this);
    }
    return orElse();
  }
}

abstract class PageName_Receive extends PageName {
  const factory PageName_Receive() = _$PageName_ReceiveImpl;
  const PageName_Receive._() : super._();
}

/// @nodoc
abstract class _$$PageName_SendImplCopyWith<$Res> {
  factory _$$PageName_SendImplCopyWith(
          _$PageName_SendImpl value, $Res Function(_$PageName_SendImpl) then) =
      __$$PageName_SendImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String field0});
}

/// @nodoc
class __$$PageName_SendImplCopyWithImpl<$Res>
    extends _$PageNameCopyWithImpl<$Res, _$PageName_SendImpl>
    implements _$$PageName_SendImplCopyWith<$Res> {
  __$$PageName_SendImplCopyWithImpl(
      _$PageName_SendImpl _value, $Res Function(_$PageName_SendImpl) _then)
      : super(_value, _then);

  /// Create a copy of PageName
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$PageName_SendImpl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$PageName_SendImpl extends PageName_Send {
  const _$PageName_SendImpl(this.field0) : super._();

  @override
  final String field0;

  @override
  String toString() {
    return 'PageName.send(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PageName_SendImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of PageName
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PageName_SendImplCopyWith<_$PageName_SendImpl> get copyWith =>
      __$$PageName_SendImplCopyWithImpl<_$PageName_SendImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() bitcoinHome,
    required TResult Function(String field0) viewTransaction,
    required TResult Function() receive,
    required TResult Function(String field0) send,
    required TResult Function(String field0) amount,
    required TResult Function(BigInt field0) speed,
    required TResult Function(String field0, BigInt field1, BigInt field2)
        confirm,
    required TResult Function(String field0) success,
    required TResult Function(bool field0) myProfile,
    required TResult Function(bool field0) userProfile,
    required TResult Function() messagesHome,
    required TResult Function() chooseRecipient,
    required TResult Function() currentConversation,
    required TResult Function() conversationInfo,
    required TResult Function(String field0) test,
    required TResult Function() scan,
  }) {
    return send(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? bitcoinHome,
    TResult? Function(String field0)? viewTransaction,
    TResult? Function()? receive,
    TResult? Function(String field0)? send,
    TResult? Function(String field0)? amount,
    TResult? Function(BigInt field0)? speed,
    TResult? Function(String field0, BigInt field1, BigInt field2)? confirm,
    TResult? Function(String field0)? success,
    TResult? Function(bool field0)? myProfile,
    TResult? Function(bool field0)? userProfile,
    TResult? Function()? messagesHome,
    TResult? Function()? chooseRecipient,
    TResult? Function()? currentConversation,
    TResult? Function()? conversationInfo,
    TResult? Function(String field0)? test,
    TResult? Function()? scan,
  }) {
    return send?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? bitcoinHome,
    TResult Function(String field0)? viewTransaction,
    TResult Function()? receive,
    TResult Function(String field0)? send,
    TResult Function(String field0)? amount,
    TResult Function(BigInt field0)? speed,
    TResult Function(String field0, BigInt field1, BigInt field2)? confirm,
    TResult Function(String field0)? success,
    TResult Function(bool field0)? myProfile,
    TResult Function(bool field0)? userProfile,
    TResult Function()? messagesHome,
    TResult Function()? chooseRecipient,
    TResult Function()? currentConversation,
    TResult Function()? conversationInfo,
    TResult Function(String field0)? test,
    TResult Function()? scan,
    required TResult orElse(),
  }) {
    if (send != null) {
      return send(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PageName_BitcoinHome value) bitcoinHome,
    required TResult Function(PageName_ViewTransaction value) viewTransaction,
    required TResult Function(PageName_Receive value) receive,
    required TResult Function(PageName_Send value) send,
    required TResult Function(PageName_Amount value) amount,
    required TResult Function(PageName_Speed value) speed,
    required TResult Function(PageName_Confirm value) confirm,
    required TResult Function(PageName_Success value) success,
    required TResult Function(PageName_MyProfile value) myProfile,
    required TResult Function(PageName_UserProfile value) userProfile,
    required TResult Function(PageName_MessagesHome value) messagesHome,
    required TResult Function(PageName_ChooseRecipient value) chooseRecipient,
    required TResult Function(PageName_CurrentConversation value)
        currentConversation,
    required TResult Function(PageName_ConversationInfo value) conversationInfo,
    required TResult Function(PageName_Test value) test,
    required TResult Function(PageName_Scan value) scan,
  }) {
    return send(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PageName_BitcoinHome value)? bitcoinHome,
    TResult? Function(PageName_ViewTransaction value)? viewTransaction,
    TResult? Function(PageName_Receive value)? receive,
    TResult? Function(PageName_Send value)? send,
    TResult? Function(PageName_Amount value)? amount,
    TResult? Function(PageName_Speed value)? speed,
    TResult? Function(PageName_Confirm value)? confirm,
    TResult? Function(PageName_Success value)? success,
    TResult? Function(PageName_MyProfile value)? myProfile,
    TResult? Function(PageName_UserProfile value)? userProfile,
    TResult? Function(PageName_MessagesHome value)? messagesHome,
    TResult? Function(PageName_ChooseRecipient value)? chooseRecipient,
    TResult? Function(PageName_CurrentConversation value)? currentConversation,
    TResult? Function(PageName_ConversationInfo value)? conversationInfo,
    TResult? Function(PageName_Test value)? test,
    TResult? Function(PageName_Scan value)? scan,
  }) {
    return send?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PageName_BitcoinHome value)? bitcoinHome,
    TResult Function(PageName_ViewTransaction value)? viewTransaction,
    TResult Function(PageName_Receive value)? receive,
    TResult Function(PageName_Send value)? send,
    TResult Function(PageName_Amount value)? amount,
    TResult Function(PageName_Speed value)? speed,
    TResult Function(PageName_Confirm value)? confirm,
    TResult Function(PageName_Success value)? success,
    TResult Function(PageName_MyProfile value)? myProfile,
    TResult Function(PageName_UserProfile value)? userProfile,
    TResult Function(PageName_MessagesHome value)? messagesHome,
    TResult Function(PageName_ChooseRecipient value)? chooseRecipient,
    TResult Function(PageName_CurrentConversation value)? currentConversation,
    TResult Function(PageName_ConversationInfo value)? conversationInfo,
    TResult Function(PageName_Test value)? test,
    TResult Function(PageName_Scan value)? scan,
    required TResult orElse(),
  }) {
    if (send != null) {
      return send(this);
    }
    return orElse();
  }
}

abstract class PageName_Send extends PageName {
  const factory PageName_Send(final String field0) = _$PageName_SendImpl;
  const PageName_Send._() : super._();

  String get field0;

  /// Create a copy of PageName
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PageName_SendImplCopyWith<_$PageName_SendImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PageName_AmountImplCopyWith<$Res> {
  factory _$$PageName_AmountImplCopyWith(_$PageName_AmountImpl value,
          $Res Function(_$PageName_AmountImpl) then) =
      __$$PageName_AmountImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String field0});
}

/// @nodoc
class __$$PageName_AmountImplCopyWithImpl<$Res>
    extends _$PageNameCopyWithImpl<$Res, _$PageName_AmountImpl>
    implements _$$PageName_AmountImplCopyWith<$Res> {
  __$$PageName_AmountImplCopyWithImpl(
      _$PageName_AmountImpl _value, $Res Function(_$PageName_AmountImpl) _then)
      : super(_value, _then);

  /// Create a copy of PageName
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$PageName_AmountImpl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$PageName_AmountImpl extends PageName_Amount {
  const _$PageName_AmountImpl(this.field0) : super._();

  @override
  final String field0;

  @override
  String toString() {
    return 'PageName.amount(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PageName_AmountImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of PageName
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PageName_AmountImplCopyWith<_$PageName_AmountImpl> get copyWith =>
      __$$PageName_AmountImplCopyWithImpl<_$PageName_AmountImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() bitcoinHome,
    required TResult Function(String field0) viewTransaction,
    required TResult Function() receive,
    required TResult Function(String field0) send,
    required TResult Function(String field0) amount,
    required TResult Function(BigInt field0) speed,
    required TResult Function(String field0, BigInt field1, BigInt field2)
        confirm,
    required TResult Function(String field0) success,
    required TResult Function(bool field0) myProfile,
    required TResult Function(bool field0) userProfile,
    required TResult Function() messagesHome,
    required TResult Function() chooseRecipient,
    required TResult Function() currentConversation,
    required TResult Function() conversationInfo,
    required TResult Function(String field0) test,
    required TResult Function() scan,
  }) {
    return amount(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? bitcoinHome,
    TResult? Function(String field0)? viewTransaction,
    TResult? Function()? receive,
    TResult? Function(String field0)? send,
    TResult? Function(String field0)? amount,
    TResult? Function(BigInt field0)? speed,
    TResult? Function(String field0, BigInt field1, BigInt field2)? confirm,
    TResult? Function(String field0)? success,
    TResult? Function(bool field0)? myProfile,
    TResult? Function(bool field0)? userProfile,
    TResult? Function()? messagesHome,
    TResult? Function()? chooseRecipient,
    TResult? Function()? currentConversation,
    TResult? Function()? conversationInfo,
    TResult? Function(String field0)? test,
    TResult? Function()? scan,
  }) {
    return amount?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? bitcoinHome,
    TResult Function(String field0)? viewTransaction,
    TResult Function()? receive,
    TResult Function(String field0)? send,
    TResult Function(String field0)? amount,
    TResult Function(BigInt field0)? speed,
    TResult Function(String field0, BigInt field1, BigInt field2)? confirm,
    TResult Function(String field0)? success,
    TResult Function(bool field0)? myProfile,
    TResult Function(bool field0)? userProfile,
    TResult Function()? messagesHome,
    TResult Function()? chooseRecipient,
    TResult Function()? currentConversation,
    TResult Function()? conversationInfo,
    TResult Function(String field0)? test,
    TResult Function()? scan,
    required TResult orElse(),
  }) {
    if (amount != null) {
      return amount(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PageName_BitcoinHome value) bitcoinHome,
    required TResult Function(PageName_ViewTransaction value) viewTransaction,
    required TResult Function(PageName_Receive value) receive,
    required TResult Function(PageName_Send value) send,
    required TResult Function(PageName_Amount value) amount,
    required TResult Function(PageName_Speed value) speed,
    required TResult Function(PageName_Confirm value) confirm,
    required TResult Function(PageName_Success value) success,
    required TResult Function(PageName_MyProfile value) myProfile,
    required TResult Function(PageName_UserProfile value) userProfile,
    required TResult Function(PageName_MessagesHome value) messagesHome,
    required TResult Function(PageName_ChooseRecipient value) chooseRecipient,
    required TResult Function(PageName_CurrentConversation value)
        currentConversation,
    required TResult Function(PageName_ConversationInfo value) conversationInfo,
    required TResult Function(PageName_Test value) test,
    required TResult Function(PageName_Scan value) scan,
  }) {
    return amount(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PageName_BitcoinHome value)? bitcoinHome,
    TResult? Function(PageName_ViewTransaction value)? viewTransaction,
    TResult? Function(PageName_Receive value)? receive,
    TResult? Function(PageName_Send value)? send,
    TResult? Function(PageName_Amount value)? amount,
    TResult? Function(PageName_Speed value)? speed,
    TResult? Function(PageName_Confirm value)? confirm,
    TResult? Function(PageName_Success value)? success,
    TResult? Function(PageName_MyProfile value)? myProfile,
    TResult? Function(PageName_UserProfile value)? userProfile,
    TResult? Function(PageName_MessagesHome value)? messagesHome,
    TResult? Function(PageName_ChooseRecipient value)? chooseRecipient,
    TResult? Function(PageName_CurrentConversation value)? currentConversation,
    TResult? Function(PageName_ConversationInfo value)? conversationInfo,
    TResult? Function(PageName_Test value)? test,
    TResult? Function(PageName_Scan value)? scan,
  }) {
    return amount?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PageName_BitcoinHome value)? bitcoinHome,
    TResult Function(PageName_ViewTransaction value)? viewTransaction,
    TResult Function(PageName_Receive value)? receive,
    TResult Function(PageName_Send value)? send,
    TResult Function(PageName_Amount value)? amount,
    TResult Function(PageName_Speed value)? speed,
    TResult Function(PageName_Confirm value)? confirm,
    TResult Function(PageName_Success value)? success,
    TResult Function(PageName_MyProfile value)? myProfile,
    TResult Function(PageName_UserProfile value)? userProfile,
    TResult Function(PageName_MessagesHome value)? messagesHome,
    TResult Function(PageName_ChooseRecipient value)? chooseRecipient,
    TResult Function(PageName_CurrentConversation value)? currentConversation,
    TResult Function(PageName_ConversationInfo value)? conversationInfo,
    TResult Function(PageName_Test value)? test,
    TResult Function(PageName_Scan value)? scan,
    required TResult orElse(),
  }) {
    if (amount != null) {
      return amount(this);
    }
    return orElse();
  }
}

abstract class PageName_Amount extends PageName {
  const factory PageName_Amount(final String field0) = _$PageName_AmountImpl;
  const PageName_Amount._() : super._();

  String get field0;

  /// Create a copy of PageName
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PageName_AmountImplCopyWith<_$PageName_AmountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PageName_SpeedImplCopyWith<$Res> {
  factory _$$PageName_SpeedImplCopyWith(_$PageName_SpeedImpl value,
          $Res Function(_$PageName_SpeedImpl) then) =
      __$$PageName_SpeedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({BigInt field0});
}

/// @nodoc
class __$$PageName_SpeedImplCopyWithImpl<$Res>
    extends _$PageNameCopyWithImpl<$Res, _$PageName_SpeedImpl>
    implements _$$PageName_SpeedImplCopyWith<$Res> {
  __$$PageName_SpeedImplCopyWithImpl(
      _$PageName_SpeedImpl _value, $Res Function(_$PageName_SpeedImpl) _then)
      : super(_value, _then);

  /// Create a copy of PageName
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$PageName_SpeedImpl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as BigInt,
    ));
  }
}

/// @nodoc

class _$PageName_SpeedImpl extends PageName_Speed {
  const _$PageName_SpeedImpl(this.field0) : super._();

  @override
  final BigInt field0;

  @override
  String toString() {
    return 'PageName.speed(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PageName_SpeedImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of PageName
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PageName_SpeedImplCopyWith<_$PageName_SpeedImpl> get copyWith =>
      __$$PageName_SpeedImplCopyWithImpl<_$PageName_SpeedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() bitcoinHome,
    required TResult Function(String field0) viewTransaction,
    required TResult Function() receive,
    required TResult Function(String field0) send,
    required TResult Function(String field0) amount,
    required TResult Function(BigInt field0) speed,
    required TResult Function(String field0, BigInt field1, BigInt field2)
        confirm,
    required TResult Function(String field0) success,
    required TResult Function(bool field0) myProfile,
    required TResult Function(bool field0) userProfile,
    required TResult Function() messagesHome,
    required TResult Function() chooseRecipient,
    required TResult Function() currentConversation,
    required TResult Function() conversationInfo,
    required TResult Function(String field0) test,
    required TResult Function() scan,
  }) {
    return speed(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? bitcoinHome,
    TResult? Function(String field0)? viewTransaction,
    TResult? Function()? receive,
    TResult? Function(String field0)? send,
    TResult? Function(String field0)? amount,
    TResult? Function(BigInt field0)? speed,
    TResult? Function(String field0, BigInt field1, BigInt field2)? confirm,
    TResult? Function(String field0)? success,
    TResult? Function(bool field0)? myProfile,
    TResult? Function(bool field0)? userProfile,
    TResult? Function()? messagesHome,
    TResult? Function()? chooseRecipient,
    TResult? Function()? currentConversation,
    TResult? Function()? conversationInfo,
    TResult? Function(String field0)? test,
    TResult? Function()? scan,
  }) {
    return speed?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? bitcoinHome,
    TResult Function(String field0)? viewTransaction,
    TResult Function()? receive,
    TResult Function(String field0)? send,
    TResult Function(String field0)? amount,
    TResult Function(BigInt field0)? speed,
    TResult Function(String field0, BigInt field1, BigInt field2)? confirm,
    TResult Function(String field0)? success,
    TResult Function(bool field0)? myProfile,
    TResult Function(bool field0)? userProfile,
    TResult Function()? messagesHome,
    TResult Function()? chooseRecipient,
    TResult Function()? currentConversation,
    TResult Function()? conversationInfo,
    TResult Function(String field0)? test,
    TResult Function()? scan,
    required TResult orElse(),
  }) {
    if (speed != null) {
      return speed(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PageName_BitcoinHome value) bitcoinHome,
    required TResult Function(PageName_ViewTransaction value) viewTransaction,
    required TResult Function(PageName_Receive value) receive,
    required TResult Function(PageName_Send value) send,
    required TResult Function(PageName_Amount value) amount,
    required TResult Function(PageName_Speed value) speed,
    required TResult Function(PageName_Confirm value) confirm,
    required TResult Function(PageName_Success value) success,
    required TResult Function(PageName_MyProfile value) myProfile,
    required TResult Function(PageName_UserProfile value) userProfile,
    required TResult Function(PageName_MessagesHome value) messagesHome,
    required TResult Function(PageName_ChooseRecipient value) chooseRecipient,
    required TResult Function(PageName_CurrentConversation value)
        currentConversation,
    required TResult Function(PageName_ConversationInfo value) conversationInfo,
    required TResult Function(PageName_Test value) test,
    required TResult Function(PageName_Scan value) scan,
  }) {
    return speed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PageName_BitcoinHome value)? bitcoinHome,
    TResult? Function(PageName_ViewTransaction value)? viewTransaction,
    TResult? Function(PageName_Receive value)? receive,
    TResult? Function(PageName_Send value)? send,
    TResult? Function(PageName_Amount value)? amount,
    TResult? Function(PageName_Speed value)? speed,
    TResult? Function(PageName_Confirm value)? confirm,
    TResult? Function(PageName_Success value)? success,
    TResult? Function(PageName_MyProfile value)? myProfile,
    TResult? Function(PageName_UserProfile value)? userProfile,
    TResult? Function(PageName_MessagesHome value)? messagesHome,
    TResult? Function(PageName_ChooseRecipient value)? chooseRecipient,
    TResult? Function(PageName_CurrentConversation value)? currentConversation,
    TResult? Function(PageName_ConversationInfo value)? conversationInfo,
    TResult? Function(PageName_Test value)? test,
    TResult? Function(PageName_Scan value)? scan,
  }) {
    return speed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PageName_BitcoinHome value)? bitcoinHome,
    TResult Function(PageName_ViewTransaction value)? viewTransaction,
    TResult Function(PageName_Receive value)? receive,
    TResult Function(PageName_Send value)? send,
    TResult Function(PageName_Amount value)? amount,
    TResult Function(PageName_Speed value)? speed,
    TResult Function(PageName_Confirm value)? confirm,
    TResult Function(PageName_Success value)? success,
    TResult Function(PageName_MyProfile value)? myProfile,
    TResult Function(PageName_UserProfile value)? userProfile,
    TResult Function(PageName_MessagesHome value)? messagesHome,
    TResult Function(PageName_ChooseRecipient value)? chooseRecipient,
    TResult Function(PageName_CurrentConversation value)? currentConversation,
    TResult Function(PageName_ConversationInfo value)? conversationInfo,
    TResult Function(PageName_Test value)? test,
    TResult Function(PageName_Scan value)? scan,
    required TResult orElse(),
  }) {
    if (speed != null) {
      return speed(this);
    }
    return orElse();
  }
}

abstract class PageName_Speed extends PageName {
  const factory PageName_Speed(final BigInt field0) = _$PageName_SpeedImpl;
  const PageName_Speed._() : super._();

  BigInt get field0;

  /// Create a copy of PageName
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PageName_SpeedImplCopyWith<_$PageName_SpeedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PageName_ConfirmImplCopyWith<$Res> {
  factory _$$PageName_ConfirmImplCopyWith(_$PageName_ConfirmImpl value,
          $Res Function(_$PageName_ConfirmImpl) then) =
      __$$PageName_ConfirmImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String field0, BigInt field1, BigInt field2});
}

/// @nodoc
class __$$PageName_ConfirmImplCopyWithImpl<$Res>
    extends _$PageNameCopyWithImpl<$Res, _$PageName_ConfirmImpl>
    implements _$$PageName_ConfirmImplCopyWith<$Res> {
  __$$PageName_ConfirmImplCopyWithImpl(_$PageName_ConfirmImpl _value,
      $Res Function(_$PageName_ConfirmImpl) _then)
      : super(_value, _then);

  /// Create a copy of PageName
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
    Object? field1 = null,
    Object? field2 = null,
  }) {
    return _then(_$PageName_ConfirmImpl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as String,
      null == field1
          ? _value.field1
          : field1 // ignore: cast_nullable_to_non_nullable
              as BigInt,
      null == field2
          ? _value.field2
          : field2 // ignore: cast_nullable_to_non_nullable
              as BigInt,
    ));
  }
}

/// @nodoc

class _$PageName_ConfirmImpl extends PageName_Confirm {
  const _$PageName_ConfirmImpl(this.field0, this.field1, this.field2)
      : super._();

  @override
  final String field0;
  @override
  final BigInt field1;
  @override
  final BigInt field2;

  @override
  String toString() {
    return 'PageName.confirm(field0: $field0, field1: $field1, field2: $field2)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PageName_ConfirmImpl &&
            (identical(other.field0, field0) || other.field0 == field0) &&
            (identical(other.field1, field1) || other.field1 == field1) &&
            (identical(other.field2, field2) || other.field2 == field2));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0, field1, field2);

  /// Create a copy of PageName
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PageName_ConfirmImplCopyWith<_$PageName_ConfirmImpl> get copyWith =>
      __$$PageName_ConfirmImplCopyWithImpl<_$PageName_ConfirmImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() bitcoinHome,
    required TResult Function(String field0) viewTransaction,
    required TResult Function() receive,
    required TResult Function(String field0) send,
    required TResult Function(String field0) amount,
    required TResult Function(BigInt field0) speed,
    required TResult Function(String field0, BigInt field1, BigInt field2)
        confirm,
    required TResult Function(String field0) success,
    required TResult Function(bool field0) myProfile,
    required TResult Function(bool field0) userProfile,
    required TResult Function() messagesHome,
    required TResult Function() chooseRecipient,
    required TResult Function() currentConversation,
    required TResult Function() conversationInfo,
    required TResult Function(String field0) test,
    required TResult Function() scan,
  }) {
    return confirm(field0, field1, field2);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? bitcoinHome,
    TResult? Function(String field0)? viewTransaction,
    TResult? Function()? receive,
    TResult? Function(String field0)? send,
    TResult? Function(String field0)? amount,
    TResult? Function(BigInt field0)? speed,
    TResult? Function(String field0, BigInt field1, BigInt field2)? confirm,
    TResult? Function(String field0)? success,
    TResult? Function(bool field0)? myProfile,
    TResult? Function(bool field0)? userProfile,
    TResult? Function()? messagesHome,
    TResult? Function()? chooseRecipient,
    TResult? Function()? currentConversation,
    TResult? Function()? conversationInfo,
    TResult? Function(String field0)? test,
    TResult? Function()? scan,
  }) {
    return confirm?.call(field0, field1, field2);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? bitcoinHome,
    TResult Function(String field0)? viewTransaction,
    TResult Function()? receive,
    TResult Function(String field0)? send,
    TResult Function(String field0)? amount,
    TResult Function(BigInt field0)? speed,
    TResult Function(String field0, BigInt field1, BigInt field2)? confirm,
    TResult Function(String field0)? success,
    TResult Function(bool field0)? myProfile,
    TResult Function(bool field0)? userProfile,
    TResult Function()? messagesHome,
    TResult Function()? chooseRecipient,
    TResult Function()? currentConversation,
    TResult Function()? conversationInfo,
    TResult Function(String field0)? test,
    TResult Function()? scan,
    required TResult orElse(),
  }) {
    if (confirm != null) {
      return confirm(field0, field1, field2);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PageName_BitcoinHome value) bitcoinHome,
    required TResult Function(PageName_ViewTransaction value) viewTransaction,
    required TResult Function(PageName_Receive value) receive,
    required TResult Function(PageName_Send value) send,
    required TResult Function(PageName_Amount value) amount,
    required TResult Function(PageName_Speed value) speed,
    required TResult Function(PageName_Confirm value) confirm,
    required TResult Function(PageName_Success value) success,
    required TResult Function(PageName_MyProfile value) myProfile,
    required TResult Function(PageName_UserProfile value) userProfile,
    required TResult Function(PageName_MessagesHome value) messagesHome,
    required TResult Function(PageName_ChooseRecipient value) chooseRecipient,
    required TResult Function(PageName_CurrentConversation value)
        currentConversation,
    required TResult Function(PageName_ConversationInfo value) conversationInfo,
    required TResult Function(PageName_Test value) test,
    required TResult Function(PageName_Scan value) scan,
  }) {
    return confirm(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PageName_BitcoinHome value)? bitcoinHome,
    TResult? Function(PageName_ViewTransaction value)? viewTransaction,
    TResult? Function(PageName_Receive value)? receive,
    TResult? Function(PageName_Send value)? send,
    TResult? Function(PageName_Amount value)? amount,
    TResult? Function(PageName_Speed value)? speed,
    TResult? Function(PageName_Confirm value)? confirm,
    TResult? Function(PageName_Success value)? success,
    TResult? Function(PageName_MyProfile value)? myProfile,
    TResult? Function(PageName_UserProfile value)? userProfile,
    TResult? Function(PageName_MessagesHome value)? messagesHome,
    TResult? Function(PageName_ChooseRecipient value)? chooseRecipient,
    TResult? Function(PageName_CurrentConversation value)? currentConversation,
    TResult? Function(PageName_ConversationInfo value)? conversationInfo,
    TResult? Function(PageName_Test value)? test,
    TResult? Function(PageName_Scan value)? scan,
  }) {
    return confirm?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PageName_BitcoinHome value)? bitcoinHome,
    TResult Function(PageName_ViewTransaction value)? viewTransaction,
    TResult Function(PageName_Receive value)? receive,
    TResult Function(PageName_Send value)? send,
    TResult Function(PageName_Amount value)? amount,
    TResult Function(PageName_Speed value)? speed,
    TResult Function(PageName_Confirm value)? confirm,
    TResult Function(PageName_Success value)? success,
    TResult Function(PageName_MyProfile value)? myProfile,
    TResult Function(PageName_UserProfile value)? userProfile,
    TResult Function(PageName_MessagesHome value)? messagesHome,
    TResult Function(PageName_ChooseRecipient value)? chooseRecipient,
    TResult Function(PageName_CurrentConversation value)? currentConversation,
    TResult Function(PageName_ConversationInfo value)? conversationInfo,
    TResult Function(PageName_Test value)? test,
    TResult Function(PageName_Scan value)? scan,
    required TResult orElse(),
  }) {
    if (confirm != null) {
      return confirm(this);
    }
    return orElse();
  }
}

abstract class PageName_Confirm extends PageName {
  const factory PageName_Confirm(
          final String field0, final BigInt field1, final BigInt field2) =
      _$PageName_ConfirmImpl;
  const PageName_Confirm._() : super._();

  String get field0;
  BigInt get field1;
  BigInt get field2;

  /// Create a copy of PageName
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PageName_ConfirmImplCopyWith<_$PageName_ConfirmImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PageName_SuccessImplCopyWith<$Res> {
  factory _$$PageName_SuccessImplCopyWith(_$PageName_SuccessImpl value,
          $Res Function(_$PageName_SuccessImpl) then) =
      __$$PageName_SuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String field0});
}

/// @nodoc
class __$$PageName_SuccessImplCopyWithImpl<$Res>
    extends _$PageNameCopyWithImpl<$Res, _$PageName_SuccessImpl>
    implements _$$PageName_SuccessImplCopyWith<$Res> {
  __$$PageName_SuccessImplCopyWithImpl(_$PageName_SuccessImpl _value,
      $Res Function(_$PageName_SuccessImpl) _then)
      : super(_value, _then);

  /// Create a copy of PageName
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$PageName_SuccessImpl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$PageName_SuccessImpl extends PageName_Success {
  const _$PageName_SuccessImpl(this.field0) : super._();

  @override
  final String field0;

  @override
  String toString() {
    return 'PageName.success(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PageName_SuccessImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of PageName
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PageName_SuccessImplCopyWith<_$PageName_SuccessImpl> get copyWith =>
      __$$PageName_SuccessImplCopyWithImpl<_$PageName_SuccessImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() bitcoinHome,
    required TResult Function(String field0) viewTransaction,
    required TResult Function() receive,
    required TResult Function(String field0) send,
    required TResult Function(String field0) amount,
    required TResult Function(BigInt field0) speed,
    required TResult Function(String field0, BigInt field1, BigInt field2)
        confirm,
    required TResult Function(String field0) success,
    required TResult Function(bool field0) myProfile,
    required TResult Function(bool field0) userProfile,
    required TResult Function() messagesHome,
    required TResult Function() chooseRecipient,
    required TResult Function() currentConversation,
    required TResult Function() conversationInfo,
    required TResult Function(String field0) test,
    required TResult Function() scan,
  }) {
    return success(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? bitcoinHome,
    TResult? Function(String field0)? viewTransaction,
    TResult? Function()? receive,
    TResult? Function(String field0)? send,
    TResult? Function(String field0)? amount,
    TResult? Function(BigInt field0)? speed,
    TResult? Function(String field0, BigInt field1, BigInt field2)? confirm,
    TResult? Function(String field0)? success,
    TResult? Function(bool field0)? myProfile,
    TResult? Function(bool field0)? userProfile,
    TResult? Function()? messagesHome,
    TResult? Function()? chooseRecipient,
    TResult? Function()? currentConversation,
    TResult? Function()? conversationInfo,
    TResult? Function(String field0)? test,
    TResult? Function()? scan,
  }) {
    return success?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? bitcoinHome,
    TResult Function(String field0)? viewTransaction,
    TResult Function()? receive,
    TResult Function(String field0)? send,
    TResult Function(String field0)? amount,
    TResult Function(BigInt field0)? speed,
    TResult Function(String field0, BigInt field1, BigInt field2)? confirm,
    TResult Function(String field0)? success,
    TResult Function(bool field0)? myProfile,
    TResult Function(bool field0)? userProfile,
    TResult Function()? messagesHome,
    TResult Function()? chooseRecipient,
    TResult Function()? currentConversation,
    TResult Function()? conversationInfo,
    TResult Function(String field0)? test,
    TResult Function()? scan,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PageName_BitcoinHome value) bitcoinHome,
    required TResult Function(PageName_ViewTransaction value) viewTransaction,
    required TResult Function(PageName_Receive value) receive,
    required TResult Function(PageName_Send value) send,
    required TResult Function(PageName_Amount value) amount,
    required TResult Function(PageName_Speed value) speed,
    required TResult Function(PageName_Confirm value) confirm,
    required TResult Function(PageName_Success value) success,
    required TResult Function(PageName_MyProfile value) myProfile,
    required TResult Function(PageName_UserProfile value) userProfile,
    required TResult Function(PageName_MessagesHome value) messagesHome,
    required TResult Function(PageName_ChooseRecipient value) chooseRecipient,
    required TResult Function(PageName_CurrentConversation value)
        currentConversation,
    required TResult Function(PageName_ConversationInfo value) conversationInfo,
    required TResult Function(PageName_Test value) test,
    required TResult Function(PageName_Scan value) scan,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PageName_BitcoinHome value)? bitcoinHome,
    TResult? Function(PageName_ViewTransaction value)? viewTransaction,
    TResult? Function(PageName_Receive value)? receive,
    TResult? Function(PageName_Send value)? send,
    TResult? Function(PageName_Amount value)? amount,
    TResult? Function(PageName_Speed value)? speed,
    TResult? Function(PageName_Confirm value)? confirm,
    TResult? Function(PageName_Success value)? success,
    TResult? Function(PageName_MyProfile value)? myProfile,
    TResult? Function(PageName_UserProfile value)? userProfile,
    TResult? Function(PageName_MessagesHome value)? messagesHome,
    TResult? Function(PageName_ChooseRecipient value)? chooseRecipient,
    TResult? Function(PageName_CurrentConversation value)? currentConversation,
    TResult? Function(PageName_ConversationInfo value)? conversationInfo,
    TResult? Function(PageName_Test value)? test,
    TResult? Function(PageName_Scan value)? scan,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PageName_BitcoinHome value)? bitcoinHome,
    TResult Function(PageName_ViewTransaction value)? viewTransaction,
    TResult Function(PageName_Receive value)? receive,
    TResult Function(PageName_Send value)? send,
    TResult Function(PageName_Amount value)? amount,
    TResult Function(PageName_Speed value)? speed,
    TResult Function(PageName_Confirm value)? confirm,
    TResult Function(PageName_Success value)? success,
    TResult Function(PageName_MyProfile value)? myProfile,
    TResult Function(PageName_UserProfile value)? userProfile,
    TResult Function(PageName_MessagesHome value)? messagesHome,
    TResult Function(PageName_ChooseRecipient value)? chooseRecipient,
    TResult Function(PageName_CurrentConversation value)? currentConversation,
    TResult Function(PageName_ConversationInfo value)? conversationInfo,
    TResult Function(PageName_Test value)? test,
    TResult Function(PageName_Scan value)? scan,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class PageName_Success extends PageName {
  const factory PageName_Success(final String field0) = _$PageName_SuccessImpl;
  const PageName_Success._() : super._();

  String get field0;

  /// Create a copy of PageName
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PageName_SuccessImplCopyWith<_$PageName_SuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PageName_MyProfileImplCopyWith<$Res> {
  factory _$$PageName_MyProfileImplCopyWith(_$PageName_MyProfileImpl value,
          $Res Function(_$PageName_MyProfileImpl) then) =
      __$$PageName_MyProfileImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool field0});
}

/// @nodoc
class __$$PageName_MyProfileImplCopyWithImpl<$Res>
    extends _$PageNameCopyWithImpl<$Res, _$PageName_MyProfileImpl>
    implements _$$PageName_MyProfileImplCopyWith<$Res> {
  __$$PageName_MyProfileImplCopyWithImpl(_$PageName_MyProfileImpl _value,
      $Res Function(_$PageName_MyProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of PageName
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$PageName_MyProfileImpl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$PageName_MyProfileImpl extends PageName_MyProfile {
  const _$PageName_MyProfileImpl(this.field0) : super._();

  @override
  final bool field0;

  @override
  String toString() {
    return 'PageName.myProfile(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PageName_MyProfileImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of PageName
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PageName_MyProfileImplCopyWith<_$PageName_MyProfileImpl> get copyWith =>
      __$$PageName_MyProfileImplCopyWithImpl<_$PageName_MyProfileImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() bitcoinHome,
    required TResult Function(String field0) viewTransaction,
    required TResult Function() receive,
    required TResult Function(String field0) send,
    required TResult Function(String field0) amount,
    required TResult Function(BigInt field0) speed,
    required TResult Function(String field0, BigInt field1, BigInt field2)
        confirm,
    required TResult Function(String field0) success,
    required TResult Function(bool field0) myProfile,
    required TResult Function(bool field0) userProfile,
    required TResult Function() messagesHome,
    required TResult Function() chooseRecipient,
    required TResult Function() currentConversation,
    required TResult Function() conversationInfo,
    required TResult Function(String field0) test,
    required TResult Function() scan,
  }) {
    return myProfile(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? bitcoinHome,
    TResult? Function(String field0)? viewTransaction,
    TResult? Function()? receive,
    TResult? Function(String field0)? send,
    TResult? Function(String field0)? amount,
    TResult? Function(BigInt field0)? speed,
    TResult? Function(String field0, BigInt field1, BigInt field2)? confirm,
    TResult? Function(String field0)? success,
    TResult? Function(bool field0)? myProfile,
    TResult? Function(bool field0)? userProfile,
    TResult? Function()? messagesHome,
    TResult? Function()? chooseRecipient,
    TResult? Function()? currentConversation,
    TResult? Function()? conversationInfo,
    TResult? Function(String field0)? test,
    TResult? Function()? scan,
  }) {
    return myProfile?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? bitcoinHome,
    TResult Function(String field0)? viewTransaction,
    TResult Function()? receive,
    TResult Function(String field0)? send,
    TResult Function(String field0)? amount,
    TResult Function(BigInt field0)? speed,
    TResult Function(String field0, BigInt field1, BigInt field2)? confirm,
    TResult Function(String field0)? success,
    TResult Function(bool field0)? myProfile,
    TResult Function(bool field0)? userProfile,
    TResult Function()? messagesHome,
    TResult Function()? chooseRecipient,
    TResult Function()? currentConversation,
    TResult Function()? conversationInfo,
    TResult Function(String field0)? test,
    TResult Function()? scan,
    required TResult orElse(),
  }) {
    if (myProfile != null) {
      return myProfile(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PageName_BitcoinHome value) bitcoinHome,
    required TResult Function(PageName_ViewTransaction value) viewTransaction,
    required TResult Function(PageName_Receive value) receive,
    required TResult Function(PageName_Send value) send,
    required TResult Function(PageName_Amount value) amount,
    required TResult Function(PageName_Speed value) speed,
    required TResult Function(PageName_Confirm value) confirm,
    required TResult Function(PageName_Success value) success,
    required TResult Function(PageName_MyProfile value) myProfile,
    required TResult Function(PageName_UserProfile value) userProfile,
    required TResult Function(PageName_MessagesHome value) messagesHome,
    required TResult Function(PageName_ChooseRecipient value) chooseRecipient,
    required TResult Function(PageName_CurrentConversation value)
        currentConversation,
    required TResult Function(PageName_ConversationInfo value) conversationInfo,
    required TResult Function(PageName_Test value) test,
    required TResult Function(PageName_Scan value) scan,
  }) {
    return myProfile(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PageName_BitcoinHome value)? bitcoinHome,
    TResult? Function(PageName_ViewTransaction value)? viewTransaction,
    TResult? Function(PageName_Receive value)? receive,
    TResult? Function(PageName_Send value)? send,
    TResult? Function(PageName_Amount value)? amount,
    TResult? Function(PageName_Speed value)? speed,
    TResult? Function(PageName_Confirm value)? confirm,
    TResult? Function(PageName_Success value)? success,
    TResult? Function(PageName_MyProfile value)? myProfile,
    TResult? Function(PageName_UserProfile value)? userProfile,
    TResult? Function(PageName_MessagesHome value)? messagesHome,
    TResult? Function(PageName_ChooseRecipient value)? chooseRecipient,
    TResult? Function(PageName_CurrentConversation value)? currentConversation,
    TResult? Function(PageName_ConversationInfo value)? conversationInfo,
    TResult? Function(PageName_Test value)? test,
    TResult? Function(PageName_Scan value)? scan,
  }) {
    return myProfile?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PageName_BitcoinHome value)? bitcoinHome,
    TResult Function(PageName_ViewTransaction value)? viewTransaction,
    TResult Function(PageName_Receive value)? receive,
    TResult Function(PageName_Send value)? send,
    TResult Function(PageName_Amount value)? amount,
    TResult Function(PageName_Speed value)? speed,
    TResult Function(PageName_Confirm value)? confirm,
    TResult Function(PageName_Success value)? success,
    TResult Function(PageName_MyProfile value)? myProfile,
    TResult Function(PageName_UserProfile value)? userProfile,
    TResult Function(PageName_MessagesHome value)? messagesHome,
    TResult Function(PageName_ChooseRecipient value)? chooseRecipient,
    TResult Function(PageName_CurrentConversation value)? currentConversation,
    TResult Function(PageName_ConversationInfo value)? conversationInfo,
    TResult Function(PageName_Test value)? test,
    TResult Function(PageName_Scan value)? scan,
    required TResult orElse(),
  }) {
    if (myProfile != null) {
      return myProfile(this);
    }
    return orElse();
  }
}

abstract class PageName_MyProfile extends PageName {
  const factory PageName_MyProfile(final bool field0) =
      _$PageName_MyProfileImpl;
  const PageName_MyProfile._() : super._();

  bool get field0;

  /// Create a copy of PageName
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PageName_MyProfileImplCopyWith<_$PageName_MyProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PageName_UserProfileImplCopyWith<$Res> {
  factory _$$PageName_UserProfileImplCopyWith(_$PageName_UserProfileImpl value,
          $Res Function(_$PageName_UserProfileImpl) then) =
      __$$PageName_UserProfileImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool field0});
}

/// @nodoc
class __$$PageName_UserProfileImplCopyWithImpl<$Res>
    extends _$PageNameCopyWithImpl<$Res, _$PageName_UserProfileImpl>
    implements _$$PageName_UserProfileImplCopyWith<$Res> {
  __$$PageName_UserProfileImplCopyWithImpl(_$PageName_UserProfileImpl _value,
      $Res Function(_$PageName_UserProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of PageName
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$PageName_UserProfileImpl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$PageName_UserProfileImpl extends PageName_UserProfile {
  const _$PageName_UserProfileImpl(this.field0) : super._();

  @override
  final bool field0;

  @override
  String toString() {
    return 'PageName.userProfile(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PageName_UserProfileImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of PageName
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PageName_UserProfileImplCopyWith<_$PageName_UserProfileImpl>
      get copyWith =>
          __$$PageName_UserProfileImplCopyWithImpl<_$PageName_UserProfileImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() bitcoinHome,
    required TResult Function(String field0) viewTransaction,
    required TResult Function() receive,
    required TResult Function(String field0) send,
    required TResult Function(String field0) amount,
    required TResult Function(BigInt field0) speed,
    required TResult Function(String field0, BigInt field1, BigInt field2)
        confirm,
    required TResult Function(String field0) success,
    required TResult Function(bool field0) myProfile,
    required TResult Function(bool field0) userProfile,
    required TResult Function() messagesHome,
    required TResult Function() chooseRecipient,
    required TResult Function() currentConversation,
    required TResult Function() conversationInfo,
    required TResult Function(String field0) test,
    required TResult Function() scan,
  }) {
    return userProfile(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? bitcoinHome,
    TResult? Function(String field0)? viewTransaction,
    TResult? Function()? receive,
    TResult? Function(String field0)? send,
    TResult? Function(String field0)? amount,
    TResult? Function(BigInt field0)? speed,
    TResult? Function(String field0, BigInt field1, BigInt field2)? confirm,
    TResult? Function(String field0)? success,
    TResult? Function(bool field0)? myProfile,
    TResult? Function(bool field0)? userProfile,
    TResult? Function()? messagesHome,
    TResult? Function()? chooseRecipient,
    TResult? Function()? currentConversation,
    TResult? Function()? conversationInfo,
    TResult? Function(String field0)? test,
    TResult? Function()? scan,
  }) {
    return userProfile?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? bitcoinHome,
    TResult Function(String field0)? viewTransaction,
    TResult Function()? receive,
    TResult Function(String field0)? send,
    TResult Function(String field0)? amount,
    TResult Function(BigInt field0)? speed,
    TResult Function(String field0, BigInt field1, BigInt field2)? confirm,
    TResult Function(String field0)? success,
    TResult Function(bool field0)? myProfile,
    TResult Function(bool field0)? userProfile,
    TResult Function()? messagesHome,
    TResult Function()? chooseRecipient,
    TResult Function()? currentConversation,
    TResult Function()? conversationInfo,
    TResult Function(String field0)? test,
    TResult Function()? scan,
    required TResult orElse(),
  }) {
    if (userProfile != null) {
      return userProfile(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PageName_BitcoinHome value) bitcoinHome,
    required TResult Function(PageName_ViewTransaction value) viewTransaction,
    required TResult Function(PageName_Receive value) receive,
    required TResult Function(PageName_Send value) send,
    required TResult Function(PageName_Amount value) amount,
    required TResult Function(PageName_Speed value) speed,
    required TResult Function(PageName_Confirm value) confirm,
    required TResult Function(PageName_Success value) success,
    required TResult Function(PageName_MyProfile value) myProfile,
    required TResult Function(PageName_UserProfile value) userProfile,
    required TResult Function(PageName_MessagesHome value) messagesHome,
    required TResult Function(PageName_ChooseRecipient value) chooseRecipient,
    required TResult Function(PageName_CurrentConversation value)
        currentConversation,
    required TResult Function(PageName_ConversationInfo value) conversationInfo,
    required TResult Function(PageName_Test value) test,
    required TResult Function(PageName_Scan value) scan,
  }) {
    return userProfile(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PageName_BitcoinHome value)? bitcoinHome,
    TResult? Function(PageName_ViewTransaction value)? viewTransaction,
    TResult? Function(PageName_Receive value)? receive,
    TResult? Function(PageName_Send value)? send,
    TResult? Function(PageName_Amount value)? amount,
    TResult? Function(PageName_Speed value)? speed,
    TResult? Function(PageName_Confirm value)? confirm,
    TResult? Function(PageName_Success value)? success,
    TResult? Function(PageName_MyProfile value)? myProfile,
    TResult? Function(PageName_UserProfile value)? userProfile,
    TResult? Function(PageName_MessagesHome value)? messagesHome,
    TResult? Function(PageName_ChooseRecipient value)? chooseRecipient,
    TResult? Function(PageName_CurrentConversation value)? currentConversation,
    TResult? Function(PageName_ConversationInfo value)? conversationInfo,
    TResult? Function(PageName_Test value)? test,
    TResult? Function(PageName_Scan value)? scan,
  }) {
    return userProfile?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PageName_BitcoinHome value)? bitcoinHome,
    TResult Function(PageName_ViewTransaction value)? viewTransaction,
    TResult Function(PageName_Receive value)? receive,
    TResult Function(PageName_Send value)? send,
    TResult Function(PageName_Amount value)? amount,
    TResult Function(PageName_Speed value)? speed,
    TResult Function(PageName_Confirm value)? confirm,
    TResult Function(PageName_Success value)? success,
    TResult Function(PageName_MyProfile value)? myProfile,
    TResult Function(PageName_UserProfile value)? userProfile,
    TResult Function(PageName_MessagesHome value)? messagesHome,
    TResult Function(PageName_ChooseRecipient value)? chooseRecipient,
    TResult Function(PageName_CurrentConversation value)? currentConversation,
    TResult Function(PageName_ConversationInfo value)? conversationInfo,
    TResult Function(PageName_Test value)? test,
    TResult Function(PageName_Scan value)? scan,
    required TResult orElse(),
  }) {
    if (userProfile != null) {
      return userProfile(this);
    }
    return orElse();
  }
}

abstract class PageName_UserProfile extends PageName {
  const factory PageName_UserProfile(final bool field0) =
      _$PageName_UserProfileImpl;
  const PageName_UserProfile._() : super._();

  bool get field0;

  /// Create a copy of PageName
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PageName_UserProfileImplCopyWith<_$PageName_UserProfileImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PageName_MessagesHomeImplCopyWith<$Res> {
  factory _$$PageName_MessagesHomeImplCopyWith(
          _$PageName_MessagesHomeImpl value,
          $Res Function(_$PageName_MessagesHomeImpl) then) =
      __$$PageName_MessagesHomeImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PageName_MessagesHomeImplCopyWithImpl<$Res>
    extends _$PageNameCopyWithImpl<$Res, _$PageName_MessagesHomeImpl>
    implements _$$PageName_MessagesHomeImplCopyWith<$Res> {
  __$$PageName_MessagesHomeImplCopyWithImpl(_$PageName_MessagesHomeImpl _value,
      $Res Function(_$PageName_MessagesHomeImpl) _then)
      : super(_value, _then);

  /// Create a copy of PageName
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PageName_MessagesHomeImpl extends PageName_MessagesHome {
  const _$PageName_MessagesHomeImpl() : super._();

  @override
  String toString() {
    return 'PageName.messagesHome()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PageName_MessagesHomeImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() bitcoinHome,
    required TResult Function(String field0) viewTransaction,
    required TResult Function() receive,
    required TResult Function(String field0) send,
    required TResult Function(String field0) amount,
    required TResult Function(BigInt field0) speed,
    required TResult Function(String field0, BigInt field1, BigInt field2)
        confirm,
    required TResult Function(String field0) success,
    required TResult Function(bool field0) myProfile,
    required TResult Function(bool field0) userProfile,
    required TResult Function() messagesHome,
    required TResult Function() chooseRecipient,
    required TResult Function() currentConversation,
    required TResult Function() conversationInfo,
    required TResult Function(String field0) test,
    required TResult Function() scan,
  }) {
    return messagesHome();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? bitcoinHome,
    TResult? Function(String field0)? viewTransaction,
    TResult? Function()? receive,
    TResult? Function(String field0)? send,
    TResult? Function(String field0)? amount,
    TResult? Function(BigInt field0)? speed,
    TResult? Function(String field0, BigInt field1, BigInt field2)? confirm,
    TResult? Function(String field0)? success,
    TResult? Function(bool field0)? myProfile,
    TResult? Function(bool field0)? userProfile,
    TResult? Function()? messagesHome,
    TResult? Function()? chooseRecipient,
    TResult? Function()? currentConversation,
    TResult? Function()? conversationInfo,
    TResult? Function(String field0)? test,
    TResult? Function()? scan,
  }) {
    return messagesHome?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? bitcoinHome,
    TResult Function(String field0)? viewTransaction,
    TResult Function()? receive,
    TResult Function(String field0)? send,
    TResult Function(String field0)? amount,
    TResult Function(BigInt field0)? speed,
    TResult Function(String field0, BigInt field1, BigInt field2)? confirm,
    TResult Function(String field0)? success,
    TResult Function(bool field0)? myProfile,
    TResult Function(bool field0)? userProfile,
    TResult Function()? messagesHome,
    TResult Function()? chooseRecipient,
    TResult Function()? currentConversation,
    TResult Function()? conversationInfo,
    TResult Function(String field0)? test,
    TResult Function()? scan,
    required TResult orElse(),
  }) {
    if (messagesHome != null) {
      return messagesHome();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PageName_BitcoinHome value) bitcoinHome,
    required TResult Function(PageName_ViewTransaction value) viewTransaction,
    required TResult Function(PageName_Receive value) receive,
    required TResult Function(PageName_Send value) send,
    required TResult Function(PageName_Amount value) amount,
    required TResult Function(PageName_Speed value) speed,
    required TResult Function(PageName_Confirm value) confirm,
    required TResult Function(PageName_Success value) success,
    required TResult Function(PageName_MyProfile value) myProfile,
    required TResult Function(PageName_UserProfile value) userProfile,
    required TResult Function(PageName_MessagesHome value) messagesHome,
    required TResult Function(PageName_ChooseRecipient value) chooseRecipient,
    required TResult Function(PageName_CurrentConversation value)
        currentConversation,
    required TResult Function(PageName_ConversationInfo value) conversationInfo,
    required TResult Function(PageName_Test value) test,
    required TResult Function(PageName_Scan value) scan,
  }) {
    return messagesHome(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PageName_BitcoinHome value)? bitcoinHome,
    TResult? Function(PageName_ViewTransaction value)? viewTransaction,
    TResult? Function(PageName_Receive value)? receive,
    TResult? Function(PageName_Send value)? send,
    TResult? Function(PageName_Amount value)? amount,
    TResult? Function(PageName_Speed value)? speed,
    TResult? Function(PageName_Confirm value)? confirm,
    TResult? Function(PageName_Success value)? success,
    TResult? Function(PageName_MyProfile value)? myProfile,
    TResult? Function(PageName_UserProfile value)? userProfile,
    TResult? Function(PageName_MessagesHome value)? messagesHome,
    TResult? Function(PageName_ChooseRecipient value)? chooseRecipient,
    TResult? Function(PageName_CurrentConversation value)? currentConversation,
    TResult? Function(PageName_ConversationInfo value)? conversationInfo,
    TResult? Function(PageName_Test value)? test,
    TResult? Function(PageName_Scan value)? scan,
  }) {
    return messagesHome?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PageName_BitcoinHome value)? bitcoinHome,
    TResult Function(PageName_ViewTransaction value)? viewTransaction,
    TResult Function(PageName_Receive value)? receive,
    TResult Function(PageName_Send value)? send,
    TResult Function(PageName_Amount value)? amount,
    TResult Function(PageName_Speed value)? speed,
    TResult Function(PageName_Confirm value)? confirm,
    TResult Function(PageName_Success value)? success,
    TResult Function(PageName_MyProfile value)? myProfile,
    TResult Function(PageName_UserProfile value)? userProfile,
    TResult Function(PageName_MessagesHome value)? messagesHome,
    TResult Function(PageName_ChooseRecipient value)? chooseRecipient,
    TResult Function(PageName_CurrentConversation value)? currentConversation,
    TResult Function(PageName_ConversationInfo value)? conversationInfo,
    TResult Function(PageName_Test value)? test,
    TResult Function(PageName_Scan value)? scan,
    required TResult orElse(),
  }) {
    if (messagesHome != null) {
      return messagesHome(this);
    }
    return orElse();
  }
}

abstract class PageName_MessagesHome extends PageName {
  const factory PageName_MessagesHome() = _$PageName_MessagesHomeImpl;
  const PageName_MessagesHome._() : super._();
}

/// @nodoc
abstract class _$$PageName_ChooseRecipientImplCopyWith<$Res> {
  factory _$$PageName_ChooseRecipientImplCopyWith(
          _$PageName_ChooseRecipientImpl value,
          $Res Function(_$PageName_ChooseRecipientImpl) then) =
      __$$PageName_ChooseRecipientImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PageName_ChooseRecipientImplCopyWithImpl<$Res>
    extends _$PageNameCopyWithImpl<$Res, _$PageName_ChooseRecipientImpl>
    implements _$$PageName_ChooseRecipientImplCopyWith<$Res> {
  __$$PageName_ChooseRecipientImplCopyWithImpl(
      _$PageName_ChooseRecipientImpl _value,
      $Res Function(_$PageName_ChooseRecipientImpl) _then)
      : super(_value, _then);

  /// Create a copy of PageName
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PageName_ChooseRecipientImpl extends PageName_ChooseRecipient {
  const _$PageName_ChooseRecipientImpl() : super._();

  @override
  String toString() {
    return 'PageName.chooseRecipient()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PageName_ChooseRecipientImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() bitcoinHome,
    required TResult Function(String field0) viewTransaction,
    required TResult Function() receive,
    required TResult Function(String field0) send,
    required TResult Function(String field0) amount,
    required TResult Function(BigInt field0) speed,
    required TResult Function(String field0, BigInt field1, BigInt field2)
        confirm,
    required TResult Function(String field0) success,
    required TResult Function(bool field0) myProfile,
    required TResult Function(bool field0) userProfile,
    required TResult Function() messagesHome,
    required TResult Function() chooseRecipient,
    required TResult Function() currentConversation,
    required TResult Function() conversationInfo,
    required TResult Function(String field0) test,
    required TResult Function() scan,
  }) {
    return chooseRecipient();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? bitcoinHome,
    TResult? Function(String field0)? viewTransaction,
    TResult? Function()? receive,
    TResult? Function(String field0)? send,
    TResult? Function(String field0)? amount,
    TResult? Function(BigInt field0)? speed,
    TResult? Function(String field0, BigInt field1, BigInt field2)? confirm,
    TResult? Function(String field0)? success,
    TResult? Function(bool field0)? myProfile,
    TResult? Function(bool field0)? userProfile,
    TResult? Function()? messagesHome,
    TResult? Function()? chooseRecipient,
    TResult? Function()? currentConversation,
    TResult? Function()? conversationInfo,
    TResult? Function(String field0)? test,
    TResult? Function()? scan,
  }) {
    return chooseRecipient?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? bitcoinHome,
    TResult Function(String field0)? viewTransaction,
    TResult Function()? receive,
    TResult Function(String field0)? send,
    TResult Function(String field0)? amount,
    TResult Function(BigInt field0)? speed,
    TResult Function(String field0, BigInt field1, BigInt field2)? confirm,
    TResult Function(String field0)? success,
    TResult Function(bool field0)? myProfile,
    TResult Function(bool field0)? userProfile,
    TResult Function()? messagesHome,
    TResult Function()? chooseRecipient,
    TResult Function()? currentConversation,
    TResult Function()? conversationInfo,
    TResult Function(String field0)? test,
    TResult Function()? scan,
    required TResult orElse(),
  }) {
    if (chooseRecipient != null) {
      return chooseRecipient();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PageName_BitcoinHome value) bitcoinHome,
    required TResult Function(PageName_ViewTransaction value) viewTransaction,
    required TResult Function(PageName_Receive value) receive,
    required TResult Function(PageName_Send value) send,
    required TResult Function(PageName_Amount value) amount,
    required TResult Function(PageName_Speed value) speed,
    required TResult Function(PageName_Confirm value) confirm,
    required TResult Function(PageName_Success value) success,
    required TResult Function(PageName_MyProfile value) myProfile,
    required TResult Function(PageName_UserProfile value) userProfile,
    required TResult Function(PageName_MessagesHome value) messagesHome,
    required TResult Function(PageName_ChooseRecipient value) chooseRecipient,
    required TResult Function(PageName_CurrentConversation value)
        currentConversation,
    required TResult Function(PageName_ConversationInfo value) conversationInfo,
    required TResult Function(PageName_Test value) test,
    required TResult Function(PageName_Scan value) scan,
  }) {
    return chooseRecipient(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PageName_BitcoinHome value)? bitcoinHome,
    TResult? Function(PageName_ViewTransaction value)? viewTransaction,
    TResult? Function(PageName_Receive value)? receive,
    TResult? Function(PageName_Send value)? send,
    TResult? Function(PageName_Amount value)? amount,
    TResult? Function(PageName_Speed value)? speed,
    TResult? Function(PageName_Confirm value)? confirm,
    TResult? Function(PageName_Success value)? success,
    TResult? Function(PageName_MyProfile value)? myProfile,
    TResult? Function(PageName_UserProfile value)? userProfile,
    TResult? Function(PageName_MessagesHome value)? messagesHome,
    TResult? Function(PageName_ChooseRecipient value)? chooseRecipient,
    TResult? Function(PageName_CurrentConversation value)? currentConversation,
    TResult? Function(PageName_ConversationInfo value)? conversationInfo,
    TResult? Function(PageName_Test value)? test,
    TResult? Function(PageName_Scan value)? scan,
  }) {
    return chooseRecipient?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PageName_BitcoinHome value)? bitcoinHome,
    TResult Function(PageName_ViewTransaction value)? viewTransaction,
    TResult Function(PageName_Receive value)? receive,
    TResult Function(PageName_Send value)? send,
    TResult Function(PageName_Amount value)? amount,
    TResult Function(PageName_Speed value)? speed,
    TResult Function(PageName_Confirm value)? confirm,
    TResult Function(PageName_Success value)? success,
    TResult Function(PageName_MyProfile value)? myProfile,
    TResult Function(PageName_UserProfile value)? userProfile,
    TResult Function(PageName_MessagesHome value)? messagesHome,
    TResult Function(PageName_ChooseRecipient value)? chooseRecipient,
    TResult Function(PageName_CurrentConversation value)? currentConversation,
    TResult Function(PageName_ConversationInfo value)? conversationInfo,
    TResult Function(PageName_Test value)? test,
    TResult Function(PageName_Scan value)? scan,
    required TResult orElse(),
  }) {
    if (chooseRecipient != null) {
      return chooseRecipient(this);
    }
    return orElse();
  }
}

abstract class PageName_ChooseRecipient extends PageName {
  const factory PageName_ChooseRecipient() = _$PageName_ChooseRecipientImpl;
  const PageName_ChooseRecipient._() : super._();
}

/// @nodoc
abstract class _$$PageName_CurrentConversationImplCopyWith<$Res> {
  factory _$$PageName_CurrentConversationImplCopyWith(
          _$PageName_CurrentConversationImpl value,
          $Res Function(_$PageName_CurrentConversationImpl) then) =
      __$$PageName_CurrentConversationImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PageName_CurrentConversationImplCopyWithImpl<$Res>
    extends _$PageNameCopyWithImpl<$Res, _$PageName_CurrentConversationImpl>
    implements _$$PageName_CurrentConversationImplCopyWith<$Res> {
  __$$PageName_CurrentConversationImplCopyWithImpl(
      _$PageName_CurrentConversationImpl _value,
      $Res Function(_$PageName_CurrentConversationImpl) _then)
      : super(_value, _then);

  /// Create a copy of PageName
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PageName_CurrentConversationImpl extends PageName_CurrentConversation {
  const _$PageName_CurrentConversationImpl() : super._();

  @override
  String toString() {
    return 'PageName.currentConversation()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PageName_CurrentConversationImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() bitcoinHome,
    required TResult Function(String field0) viewTransaction,
    required TResult Function() receive,
    required TResult Function(String field0) send,
    required TResult Function(String field0) amount,
    required TResult Function(BigInt field0) speed,
    required TResult Function(String field0, BigInt field1, BigInt field2)
        confirm,
    required TResult Function(String field0) success,
    required TResult Function(bool field0) myProfile,
    required TResult Function(bool field0) userProfile,
    required TResult Function() messagesHome,
    required TResult Function() chooseRecipient,
    required TResult Function() currentConversation,
    required TResult Function() conversationInfo,
    required TResult Function(String field0) test,
    required TResult Function() scan,
  }) {
    return currentConversation();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? bitcoinHome,
    TResult? Function(String field0)? viewTransaction,
    TResult? Function()? receive,
    TResult? Function(String field0)? send,
    TResult? Function(String field0)? amount,
    TResult? Function(BigInt field0)? speed,
    TResult? Function(String field0, BigInt field1, BigInt field2)? confirm,
    TResult? Function(String field0)? success,
    TResult? Function(bool field0)? myProfile,
    TResult? Function(bool field0)? userProfile,
    TResult? Function()? messagesHome,
    TResult? Function()? chooseRecipient,
    TResult? Function()? currentConversation,
    TResult? Function()? conversationInfo,
    TResult? Function(String field0)? test,
    TResult? Function()? scan,
  }) {
    return currentConversation?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? bitcoinHome,
    TResult Function(String field0)? viewTransaction,
    TResult Function()? receive,
    TResult Function(String field0)? send,
    TResult Function(String field0)? amount,
    TResult Function(BigInt field0)? speed,
    TResult Function(String field0, BigInt field1, BigInt field2)? confirm,
    TResult Function(String field0)? success,
    TResult Function(bool field0)? myProfile,
    TResult Function(bool field0)? userProfile,
    TResult Function()? messagesHome,
    TResult Function()? chooseRecipient,
    TResult Function()? currentConversation,
    TResult Function()? conversationInfo,
    TResult Function(String field0)? test,
    TResult Function()? scan,
    required TResult orElse(),
  }) {
    if (currentConversation != null) {
      return currentConversation();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PageName_BitcoinHome value) bitcoinHome,
    required TResult Function(PageName_ViewTransaction value) viewTransaction,
    required TResult Function(PageName_Receive value) receive,
    required TResult Function(PageName_Send value) send,
    required TResult Function(PageName_Amount value) amount,
    required TResult Function(PageName_Speed value) speed,
    required TResult Function(PageName_Confirm value) confirm,
    required TResult Function(PageName_Success value) success,
    required TResult Function(PageName_MyProfile value) myProfile,
    required TResult Function(PageName_UserProfile value) userProfile,
    required TResult Function(PageName_MessagesHome value) messagesHome,
    required TResult Function(PageName_ChooseRecipient value) chooseRecipient,
    required TResult Function(PageName_CurrentConversation value)
        currentConversation,
    required TResult Function(PageName_ConversationInfo value) conversationInfo,
    required TResult Function(PageName_Test value) test,
    required TResult Function(PageName_Scan value) scan,
  }) {
    return currentConversation(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PageName_BitcoinHome value)? bitcoinHome,
    TResult? Function(PageName_ViewTransaction value)? viewTransaction,
    TResult? Function(PageName_Receive value)? receive,
    TResult? Function(PageName_Send value)? send,
    TResult? Function(PageName_Amount value)? amount,
    TResult? Function(PageName_Speed value)? speed,
    TResult? Function(PageName_Confirm value)? confirm,
    TResult? Function(PageName_Success value)? success,
    TResult? Function(PageName_MyProfile value)? myProfile,
    TResult? Function(PageName_UserProfile value)? userProfile,
    TResult? Function(PageName_MessagesHome value)? messagesHome,
    TResult? Function(PageName_ChooseRecipient value)? chooseRecipient,
    TResult? Function(PageName_CurrentConversation value)? currentConversation,
    TResult? Function(PageName_ConversationInfo value)? conversationInfo,
    TResult? Function(PageName_Test value)? test,
    TResult? Function(PageName_Scan value)? scan,
  }) {
    return currentConversation?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PageName_BitcoinHome value)? bitcoinHome,
    TResult Function(PageName_ViewTransaction value)? viewTransaction,
    TResult Function(PageName_Receive value)? receive,
    TResult Function(PageName_Send value)? send,
    TResult Function(PageName_Amount value)? amount,
    TResult Function(PageName_Speed value)? speed,
    TResult Function(PageName_Confirm value)? confirm,
    TResult Function(PageName_Success value)? success,
    TResult Function(PageName_MyProfile value)? myProfile,
    TResult Function(PageName_UserProfile value)? userProfile,
    TResult Function(PageName_MessagesHome value)? messagesHome,
    TResult Function(PageName_ChooseRecipient value)? chooseRecipient,
    TResult Function(PageName_CurrentConversation value)? currentConversation,
    TResult Function(PageName_ConversationInfo value)? conversationInfo,
    TResult Function(PageName_Test value)? test,
    TResult Function(PageName_Scan value)? scan,
    required TResult orElse(),
  }) {
    if (currentConversation != null) {
      return currentConversation(this);
    }
    return orElse();
  }
}

abstract class PageName_CurrentConversation extends PageName {
  const factory PageName_CurrentConversation() =
      _$PageName_CurrentConversationImpl;
  const PageName_CurrentConversation._() : super._();
}

/// @nodoc
abstract class _$$PageName_ConversationInfoImplCopyWith<$Res> {
  factory _$$PageName_ConversationInfoImplCopyWith(
          _$PageName_ConversationInfoImpl value,
          $Res Function(_$PageName_ConversationInfoImpl) then) =
      __$$PageName_ConversationInfoImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PageName_ConversationInfoImplCopyWithImpl<$Res>
    extends _$PageNameCopyWithImpl<$Res, _$PageName_ConversationInfoImpl>
    implements _$$PageName_ConversationInfoImplCopyWith<$Res> {
  __$$PageName_ConversationInfoImplCopyWithImpl(
      _$PageName_ConversationInfoImpl _value,
      $Res Function(_$PageName_ConversationInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of PageName
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PageName_ConversationInfoImpl extends PageName_ConversationInfo {
  const _$PageName_ConversationInfoImpl() : super._();

  @override
  String toString() {
    return 'PageName.conversationInfo()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PageName_ConversationInfoImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() bitcoinHome,
    required TResult Function(String field0) viewTransaction,
    required TResult Function() receive,
    required TResult Function(String field0) send,
    required TResult Function(String field0) amount,
    required TResult Function(BigInt field0) speed,
    required TResult Function(String field0, BigInt field1, BigInt field2)
        confirm,
    required TResult Function(String field0) success,
    required TResult Function(bool field0) myProfile,
    required TResult Function(bool field0) userProfile,
    required TResult Function() messagesHome,
    required TResult Function() chooseRecipient,
    required TResult Function() currentConversation,
    required TResult Function() conversationInfo,
    required TResult Function(String field0) test,
    required TResult Function() scan,
  }) {
    return conversationInfo();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? bitcoinHome,
    TResult? Function(String field0)? viewTransaction,
    TResult? Function()? receive,
    TResult? Function(String field0)? send,
    TResult? Function(String field0)? amount,
    TResult? Function(BigInt field0)? speed,
    TResult? Function(String field0, BigInt field1, BigInt field2)? confirm,
    TResult? Function(String field0)? success,
    TResult? Function(bool field0)? myProfile,
    TResult? Function(bool field0)? userProfile,
    TResult? Function()? messagesHome,
    TResult? Function()? chooseRecipient,
    TResult? Function()? currentConversation,
    TResult? Function()? conversationInfo,
    TResult? Function(String field0)? test,
    TResult? Function()? scan,
  }) {
    return conversationInfo?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? bitcoinHome,
    TResult Function(String field0)? viewTransaction,
    TResult Function()? receive,
    TResult Function(String field0)? send,
    TResult Function(String field0)? amount,
    TResult Function(BigInt field0)? speed,
    TResult Function(String field0, BigInt field1, BigInt field2)? confirm,
    TResult Function(String field0)? success,
    TResult Function(bool field0)? myProfile,
    TResult Function(bool field0)? userProfile,
    TResult Function()? messagesHome,
    TResult Function()? chooseRecipient,
    TResult Function()? currentConversation,
    TResult Function()? conversationInfo,
    TResult Function(String field0)? test,
    TResult Function()? scan,
    required TResult orElse(),
  }) {
    if (conversationInfo != null) {
      return conversationInfo();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PageName_BitcoinHome value) bitcoinHome,
    required TResult Function(PageName_ViewTransaction value) viewTransaction,
    required TResult Function(PageName_Receive value) receive,
    required TResult Function(PageName_Send value) send,
    required TResult Function(PageName_Amount value) amount,
    required TResult Function(PageName_Speed value) speed,
    required TResult Function(PageName_Confirm value) confirm,
    required TResult Function(PageName_Success value) success,
    required TResult Function(PageName_MyProfile value) myProfile,
    required TResult Function(PageName_UserProfile value) userProfile,
    required TResult Function(PageName_MessagesHome value) messagesHome,
    required TResult Function(PageName_ChooseRecipient value) chooseRecipient,
    required TResult Function(PageName_CurrentConversation value)
        currentConversation,
    required TResult Function(PageName_ConversationInfo value) conversationInfo,
    required TResult Function(PageName_Test value) test,
    required TResult Function(PageName_Scan value) scan,
  }) {
    return conversationInfo(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PageName_BitcoinHome value)? bitcoinHome,
    TResult? Function(PageName_ViewTransaction value)? viewTransaction,
    TResult? Function(PageName_Receive value)? receive,
    TResult? Function(PageName_Send value)? send,
    TResult? Function(PageName_Amount value)? amount,
    TResult? Function(PageName_Speed value)? speed,
    TResult? Function(PageName_Confirm value)? confirm,
    TResult? Function(PageName_Success value)? success,
    TResult? Function(PageName_MyProfile value)? myProfile,
    TResult? Function(PageName_UserProfile value)? userProfile,
    TResult? Function(PageName_MessagesHome value)? messagesHome,
    TResult? Function(PageName_ChooseRecipient value)? chooseRecipient,
    TResult? Function(PageName_CurrentConversation value)? currentConversation,
    TResult? Function(PageName_ConversationInfo value)? conversationInfo,
    TResult? Function(PageName_Test value)? test,
    TResult? Function(PageName_Scan value)? scan,
  }) {
    return conversationInfo?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PageName_BitcoinHome value)? bitcoinHome,
    TResult Function(PageName_ViewTransaction value)? viewTransaction,
    TResult Function(PageName_Receive value)? receive,
    TResult Function(PageName_Send value)? send,
    TResult Function(PageName_Amount value)? amount,
    TResult Function(PageName_Speed value)? speed,
    TResult Function(PageName_Confirm value)? confirm,
    TResult Function(PageName_Success value)? success,
    TResult Function(PageName_MyProfile value)? myProfile,
    TResult Function(PageName_UserProfile value)? userProfile,
    TResult Function(PageName_MessagesHome value)? messagesHome,
    TResult Function(PageName_ChooseRecipient value)? chooseRecipient,
    TResult Function(PageName_CurrentConversation value)? currentConversation,
    TResult Function(PageName_ConversationInfo value)? conversationInfo,
    TResult Function(PageName_Test value)? test,
    TResult Function(PageName_Scan value)? scan,
    required TResult orElse(),
  }) {
    if (conversationInfo != null) {
      return conversationInfo(this);
    }
    return orElse();
  }
}

abstract class PageName_ConversationInfo extends PageName {
  const factory PageName_ConversationInfo() = _$PageName_ConversationInfoImpl;
  const PageName_ConversationInfo._() : super._();
}

/// @nodoc
abstract class _$$PageName_TestImplCopyWith<$Res> {
  factory _$$PageName_TestImplCopyWith(
          _$PageName_TestImpl value, $Res Function(_$PageName_TestImpl) then) =
      __$$PageName_TestImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String field0});
}

/// @nodoc
class __$$PageName_TestImplCopyWithImpl<$Res>
    extends _$PageNameCopyWithImpl<$Res, _$PageName_TestImpl>
    implements _$$PageName_TestImplCopyWith<$Res> {
  __$$PageName_TestImplCopyWithImpl(
      _$PageName_TestImpl _value, $Res Function(_$PageName_TestImpl) _then)
      : super(_value, _then);

  /// Create a copy of PageName
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$PageName_TestImpl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$PageName_TestImpl extends PageName_Test {
  const _$PageName_TestImpl(this.field0) : super._();

  @override
  final String field0;

  @override
  String toString() {
    return 'PageName.test(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PageName_TestImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of PageName
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PageName_TestImplCopyWith<_$PageName_TestImpl> get copyWith =>
      __$$PageName_TestImplCopyWithImpl<_$PageName_TestImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() bitcoinHome,
    required TResult Function(String field0) viewTransaction,
    required TResult Function() receive,
    required TResult Function(String field0) send,
    required TResult Function(String field0) amount,
    required TResult Function(BigInt field0) speed,
    required TResult Function(String field0, BigInt field1, BigInt field2)
        confirm,
    required TResult Function(String field0) success,
    required TResult Function(bool field0) myProfile,
    required TResult Function(bool field0) userProfile,
    required TResult Function() messagesHome,
    required TResult Function() chooseRecipient,
    required TResult Function() currentConversation,
    required TResult Function() conversationInfo,
    required TResult Function(String field0) test,
    required TResult Function() scan,
  }) {
    return test(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? bitcoinHome,
    TResult? Function(String field0)? viewTransaction,
    TResult? Function()? receive,
    TResult? Function(String field0)? send,
    TResult? Function(String field0)? amount,
    TResult? Function(BigInt field0)? speed,
    TResult? Function(String field0, BigInt field1, BigInt field2)? confirm,
    TResult? Function(String field0)? success,
    TResult? Function(bool field0)? myProfile,
    TResult? Function(bool field0)? userProfile,
    TResult? Function()? messagesHome,
    TResult? Function()? chooseRecipient,
    TResult? Function()? currentConversation,
    TResult? Function()? conversationInfo,
    TResult? Function(String field0)? test,
    TResult? Function()? scan,
  }) {
    return test?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? bitcoinHome,
    TResult Function(String field0)? viewTransaction,
    TResult Function()? receive,
    TResult Function(String field0)? send,
    TResult Function(String field0)? amount,
    TResult Function(BigInt field0)? speed,
    TResult Function(String field0, BigInt field1, BigInt field2)? confirm,
    TResult Function(String field0)? success,
    TResult Function(bool field0)? myProfile,
    TResult Function(bool field0)? userProfile,
    TResult Function()? messagesHome,
    TResult Function()? chooseRecipient,
    TResult Function()? currentConversation,
    TResult Function()? conversationInfo,
    TResult Function(String field0)? test,
    TResult Function()? scan,
    required TResult orElse(),
  }) {
    if (test != null) {
      return test(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PageName_BitcoinHome value) bitcoinHome,
    required TResult Function(PageName_ViewTransaction value) viewTransaction,
    required TResult Function(PageName_Receive value) receive,
    required TResult Function(PageName_Send value) send,
    required TResult Function(PageName_Amount value) amount,
    required TResult Function(PageName_Speed value) speed,
    required TResult Function(PageName_Confirm value) confirm,
    required TResult Function(PageName_Success value) success,
    required TResult Function(PageName_MyProfile value) myProfile,
    required TResult Function(PageName_UserProfile value) userProfile,
    required TResult Function(PageName_MessagesHome value) messagesHome,
    required TResult Function(PageName_ChooseRecipient value) chooseRecipient,
    required TResult Function(PageName_CurrentConversation value)
        currentConversation,
    required TResult Function(PageName_ConversationInfo value) conversationInfo,
    required TResult Function(PageName_Test value) test,
    required TResult Function(PageName_Scan value) scan,
  }) {
    return test(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PageName_BitcoinHome value)? bitcoinHome,
    TResult? Function(PageName_ViewTransaction value)? viewTransaction,
    TResult? Function(PageName_Receive value)? receive,
    TResult? Function(PageName_Send value)? send,
    TResult? Function(PageName_Amount value)? amount,
    TResult? Function(PageName_Speed value)? speed,
    TResult? Function(PageName_Confirm value)? confirm,
    TResult? Function(PageName_Success value)? success,
    TResult? Function(PageName_MyProfile value)? myProfile,
    TResult? Function(PageName_UserProfile value)? userProfile,
    TResult? Function(PageName_MessagesHome value)? messagesHome,
    TResult? Function(PageName_ChooseRecipient value)? chooseRecipient,
    TResult? Function(PageName_CurrentConversation value)? currentConversation,
    TResult? Function(PageName_ConversationInfo value)? conversationInfo,
    TResult? Function(PageName_Test value)? test,
    TResult? Function(PageName_Scan value)? scan,
  }) {
    return test?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PageName_BitcoinHome value)? bitcoinHome,
    TResult Function(PageName_ViewTransaction value)? viewTransaction,
    TResult Function(PageName_Receive value)? receive,
    TResult Function(PageName_Send value)? send,
    TResult Function(PageName_Amount value)? amount,
    TResult Function(PageName_Speed value)? speed,
    TResult Function(PageName_Confirm value)? confirm,
    TResult Function(PageName_Success value)? success,
    TResult Function(PageName_MyProfile value)? myProfile,
    TResult Function(PageName_UserProfile value)? userProfile,
    TResult Function(PageName_MessagesHome value)? messagesHome,
    TResult Function(PageName_ChooseRecipient value)? chooseRecipient,
    TResult Function(PageName_CurrentConversation value)? currentConversation,
    TResult Function(PageName_ConversationInfo value)? conversationInfo,
    TResult Function(PageName_Test value)? test,
    TResult Function(PageName_Scan value)? scan,
    required TResult orElse(),
  }) {
    if (test != null) {
      return test(this);
    }
    return orElse();
  }
}

abstract class PageName_Test extends PageName {
  const factory PageName_Test(final String field0) = _$PageName_TestImpl;
  const PageName_Test._() : super._();

  String get field0;

  /// Create a copy of PageName
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PageName_TestImplCopyWith<_$PageName_TestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PageName_ScanImplCopyWith<$Res> {
  factory _$$PageName_ScanImplCopyWith(
          _$PageName_ScanImpl value, $Res Function(_$PageName_ScanImpl) then) =
      __$$PageName_ScanImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PageName_ScanImplCopyWithImpl<$Res>
    extends _$PageNameCopyWithImpl<$Res, _$PageName_ScanImpl>
    implements _$$PageName_ScanImplCopyWith<$Res> {
  __$$PageName_ScanImplCopyWithImpl(
      _$PageName_ScanImpl _value, $Res Function(_$PageName_ScanImpl) _then)
      : super(_value, _then);

  /// Create a copy of PageName
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PageName_ScanImpl extends PageName_Scan {
  const _$PageName_ScanImpl() : super._();

  @override
  String toString() {
    return 'PageName.scan()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$PageName_ScanImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() bitcoinHome,
    required TResult Function(String field0) viewTransaction,
    required TResult Function() receive,
    required TResult Function(String field0) send,
    required TResult Function(String field0) amount,
    required TResult Function(BigInt field0) speed,
    required TResult Function(String field0, BigInt field1, BigInt field2)
        confirm,
    required TResult Function(String field0) success,
    required TResult Function(bool field0) myProfile,
    required TResult Function(bool field0) userProfile,
    required TResult Function() messagesHome,
    required TResult Function() chooseRecipient,
    required TResult Function() currentConversation,
    required TResult Function() conversationInfo,
    required TResult Function(String field0) test,
    required TResult Function() scan,
  }) {
    return scan();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? bitcoinHome,
    TResult? Function(String field0)? viewTransaction,
    TResult? Function()? receive,
    TResult? Function(String field0)? send,
    TResult? Function(String field0)? amount,
    TResult? Function(BigInt field0)? speed,
    TResult? Function(String field0, BigInt field1, BigInt field2)? confirm,
    TResult? Function(String field0)? success,
    TResult? Function(bool field0)? myProfile,
    TResult? Function(bool field0)? userProfile,
    TResult? Function()? messagesHome,
    TResult? Function()? chooseRecipient,
    TResult? Function()? currentConversation,
    TResult? Function()? conversationInfo,
    TResult? Function(String field0)? test,
    TResult? Function()? scan,
  }) {
    return scan?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? bitcoinHome,
    TResult Function(String field0)? viewTransaction,
    TResult Function()? receive,
    TResult Function(String field0)? send,
    TResult Function(String field0)? amount,
    TResult Function(BigInt field0)? speed,
    TResult Function(String field0, BigInt field1, BigInt field2)? confirm,
    TResult Function(String field0)? success,
    TResult Function(bool field0)? myProfile,
    TResult Function(bool field0)? userProfile,
    TResult Function()? messagesHome,
    TResult Function()? chooseRecipient,
    TResult Function()? currentConversation,
    TResult Function()? conversationInfo,
    TResult Function(String field0)? test,
    TResult Function()? scan,
    required TResult orElse(),
  }) {
    if (scan != null) {
      return scan();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PageName_BitcoinHome value) bitcoinHome,
    required TResult Function(PageName_ViewTransaction value) viewTransaction,
    required TResult Function(PageName_Receive value) receive,
    required TResult Function(PageName_Send value) send,
    required TResult Function(PageName_Amount value) amount,
    required TResult Function(PageName_Speed value) speed,
    required TResult Function(PageName_Confirm value) confirm,
    required TResult Function(PageName_Success value) success,
    required TResult Function(PageName_MyProfile value) myProfile,
    required TResult Function(PageName_UserProfile value) userProfile,
    required TResult Function(PageName_MessagesHome value) messagesHome,
    required TResult Function(PageName_ChooseRecipient value) chooseRecipient,
    required TResult Function(PageName_CurrentConversation value)
        currentConversation,
    required TResult Function(PageName_ConversationInfo value) conversationInfo,
    required TResult Function(PageName_Test value) test,
    required TResult Function(PageName_Scan value) scan,
  }) {
    return scan(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PageName_BitcoinHome value)? bitcoinHome,
    TResult? Function(PageName_ViewTransaction value)? viewTransaction,
    TResult? Function(PageName_Receive value)? receive,
    TResult? Function(PageName_Send value)? send,
    TResult? Function(PageName_Amount value)? amount,
    TResult? Function(PageName_Speed value)? speed,
    TResult? Function(PageName_Confirm value)? confirm,
    TResult? Function(PageName_Success value)? success,
    TResult? Function(PageName_MyProfile value)? myProfile,
    TResult? Function(PageName_UserProfile value)? userProfile,
    TResult? Function(PageName_MessagesHome value)? messagesHome,
    TResult? Function(PageName_ChooseRecipient value)? chooseRecipient,
    TResult? Function(PageName_CurrentConversation value)? currentConversation,
    TResult? Function(PageName_ConversationInfo value)? conversationInfo,
    TResult? Function(PageName_Test value)? test,
    TResult? Function(PageName_Scan value)? scan,
  }) {
    return scan?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PageName_BitcoinHome value)? bitcoinHome,
    TResult Function(PageName_ViewTransaction value)? viewTransaction,
    TResult Function(PageName_Receive value)? receive,
    TResult Function(PageName_Send value)? send,
    TResult Function(PageName_Amount value)? amount,
    TResult Function(PageName_Speed value)? speed,
    TResult Function(PageName_Confirm value)? confirm,
    TResult Function(PageName_Success value)? success,
    TResult Function(PageName_MyProfile value)? myProfile,
    TResult Function(PageName_UserProfile value)? userProfile,
    TResult Function(PageName_MessagesHome value)? messagesHome,
    TResult Function(PageName_ChooseRecipient value)? chooseRecipient,
    TResult Function(PageName_CurrentConversation value)? currentConversation,
    TResult Function(PageName_ConversationInfo value)? conversationInfo,
    TResult Function(PageName_Test value)? test,
    TResult Function(PageName_Scan value)? scan,
    required TResult orElse(),
  }) {
    if (scan != null) {
      return scan(this);
    }
    return orElse();
  }
}

abstract class PageName_Scan extends PageName {
  const factory PageName_Scan() = _$PageName_ScanImpl;
  const PageName_Scan._() : super._();
}

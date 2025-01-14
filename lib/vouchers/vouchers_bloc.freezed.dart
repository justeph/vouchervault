// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'vouchers_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$VouchersStateTearOff {
  const _$VouchersStateTearOff();

  _VouchersState call(IList<Voucher> vouchers) {
    return _VouchersState(
      vouchers,
    );
  }
}

/// @nodoc
const $VouchersState = _$VouchersStateTearOff();

/// @nodoc
mixin _$VouchersState {
  IList<Voucher> get vouchers => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $VouchersStateCopyWith<VouchersState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VouchersStateCopyWith<$Res> {
  factory $VouchersStateCopyWith(
          VouchersState value, $Res Function(VouchersState) then) =
      _$VouchersStateCopyWithImpl<$Res>;
  $Res call({IList<Voucher> vouchers});
}

/// @nodoc
class _$VouchersStateCopyWithImpl<$Res>
    implements $VouchersStateCopyWith<$Res> {
  _$VouchersStateCopyWithImpl(this._value, this._then);

  final VouchersState _value;
  // ignore: unused_field
  final $Res Function(VouchersState) _then;

  @override
  $Res call({
    Object? vouchers = freezed,
  }) {
    return _then(_value.copyWith(
      vouchers: vouchers == freezed
          ? _value.vouchers
          : vouchers // ignore: cast_nullable_to_non_nullable
              as IList<Voucher>,
    ));
  }
}

/// @nodoc
abstract class _$VouchersStateCopyWith<$Res>
    implements $VouchersStateCopyWith<$Res> {
  factory _$VouchersStateCopyWith(
          _VouchersState value, $Res Function(_VouchersState) then) =
      __$VouchersStateCopyWithImpl<$Res>;
  @override
  $Res call({IList<Voucher> vouchers});
}

/// @nodoc
class __$VouchersStateCopyWithImpl<$Res>
    extends _$VouchersStateCopyWithImpl<$Res>
    implements _$VouchersStateCopyWith<$Res> {
  __$VouchersStateCopyWithImpl(
      _VouchersState _value, $Res Function(_VouchersState) _then)
      : super(_value, (v) => _then(v as _VouchersState));

  @override
  _VouchersState get _value => super._value as _VouchersState;

  @override
  $Res call({
    Object? vouchers = freezed,
  }) {
    return _then(_VouchersState(
      vouchers == freezed
          ? _value.vouchers
          : vouchers // ignore: cast_nullable_to_non_nullable
              as IList<Voucher>,
    ));
  }
}

/// @nodoc

class _$_VouchersState extends _VouchersState {
  _$_VouchersState(this.vouchers) : super._();

  @override
  final IList<Voucher> vouchers;

  @override
  String toString() {
    return 'VouchersState(vouchers: $vouchers)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VouchersState &&
            const DeepCollectionEquality().equals(other.vouchers, vouchers));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(vouchers));

  @JsonKey(ignore: true)
  @override
  _$VouchersStateCopyWith<_VouchersState> get copyWith =>
      __$VouchersStateCopyWithImpl<_VouchersState>(this, _$identity);
}

abstract class _VouchersState extends VouchersState {
  factory _VouchersState(IList<Voucher> vouchers) = _$_VouchersState;
  _VouchersState._() : super._();

  @override
  IList<Voucher> get vouchers;
  @override
  @JsonKey(ignore: true)
  _$VouchersStateCopyWith<_VouchersState> get copyWith =>
      throw _privateConstructorUsedError;
}

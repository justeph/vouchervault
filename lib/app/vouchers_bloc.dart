import 'package:bloc_stream/bloc_stream.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:persisted_bloc_stream/persisted_bloc_stream.dart';
import 'package:vouchervault/lib/lib.dart';

import 'package:vouchervault/models/models.dart';

final _vouchersOrder = order<Voucher>((a, b) {
  if (a.uuid == b.uuid || a == b) return Ordering.EQ;

  final compare = a.description.compareTo(b.description);
  final expiresCompare = a.expiresOption
      .map((d) => d.millisecondsSinceEpoch)
      .getOrElse(() => 0)
      .compareTo(b.expiresOption
          .map((d) => d.millisecondsSinceEpoch)
          .getOrElse(() => 0));

  if (compare > 0 || (compare == 0 && expiresCompare > 0)) {
    return Ordering.GT;
  }

  return Ordering.LT;
});

class VouchersState extends Equatable {
  VouchersState.fromIterable(Iterable<Voucher> vouchers)
      : this.vouchers = ISet.fromIterable(_vouchersOrder, vouchers),
        vouchersList = vouchers.toList();

  VouchersState.empty()
      : vouchers = ISet.empty(_vouchersOrder),
        vouchersList = [];

  VouchersState(this.vouchers)
      : vouchersList = vouchers.foldLeft([], (l, v) => l..add(v));

  final ISet<Voucher> vouchers;
  final List<Voucher> vouchersList;

  @override
  List<Object> get props => vouchersList;

  dynamic toJson() => vouchers.foldLeft([], (l, v) => l..add(v.toJson()));
  static VouchersState fromJson(dynamic json) => VouchersState.fromIterable(
        (json as List<dynamic>).map((j) => Voucher.fromJson(j)),
      );

  VouchersState copyWith({ISet<Voucher> vouchers}) =>
      VouchersState(vouchers ?? this.vouchers);
}

class VoucherActions {
  static final BlocStreamAction<VouchersState, VouchersBloc> init =
      (v, b, c) async {
    c.add(v.copyWith(
      vouchers: v.vouchers.foldLeft(
        isetWithOrder(_vouchersOrder, <Voucher>[]),
        (acc, v) => (v.removeOnceExpired &&
                v.expiresOption
                    .map(endOfDay)
                    .map((expires) => expires.isBefore(DateTime.now()))
                    .getOrElse(() => false))
            ? acc
            : acc.insert(v),
      ),
    ));
  };

  static final BlocStreamAction<VouchersState, VouchersBloc> Function(Voucher)
      add = (voucher) => (v, b, c) async {
            c.add(v.copyWith(vouchers: v.vouchers.insert(voucher)));
          };

  static final BlocStreamAction<VouchersState, VouchersBloc> Function(Voucher)
      remove = (voucher) => (v, b, c) async {
            c.add(v.copyWith(
              vouchers: v.vouchers.filter((v) => v.uuid != voucher.uuid),
            ));
          };
}

class VouchersBloc extends PersistedBlocStream<VouchersState> {
  VouchersBloc() : super(VouchersState.empty());

  @override
  dynamic toJson(VouchersState value) => value.toJson();
  @override
  VouchersState fromJson(json) => VouchersState.fromJson(json);
}

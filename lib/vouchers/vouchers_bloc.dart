import 'dart:convert';

import 'package:dart_date/dart_date.dart';
import 'package:fpdt/fpdt.dart';
import 'package:fpdt/option.dart' as O;
import 'package:fpdt/task_either.dart' as TE;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:persisted_bloc_stream/persisted_bloc_stream.dart';
import 'package:riverpod_bloc_stream/riverpod_bloc_stream.dart';
import 'package:share/share.dart';
import 'package:uuid/uuid.dart';
import 'package:vouchervault/lib/files.dart' as files;
import 'package:vouchervault/lib/milliunits.dart' as millis;
import 'package:vouchervault/models/voucher.dart';

part 'vouchers_bloc.freezed.dart';

final _log = Logger('vouchers/vouchers_bloc.dart');

final vouchersProvider = BlocStreamProvider((ref) => VouchersBloc());

final voucherProvider = Provider.autoDispose.family(
  (ref, Option<String> uuid) => ref
      .watch(vouchersProvider)
      .vouchers
      .firstWhereOption((v) => v.uuid == uuid),
);

const _uuidgen = Uuid();

final _unix =
    O.map((DateTime d) => d.millisecondsSinceEpoch).c(O.getOrElse(() => 0));

int _compareVoucher(Voucher a, Voucher b) {
  final compare = a.description.compareTo(b.description);
  final expiresCompare =
      _unix(a.normalizedExpires).compareTo(_unix(b.normalizedExpires));

  return compare != 0 ? compare : expiresCompare;
}

@freezed
class VouchersState with _$VouchersState {
  VouchersState._();
  factory VouchersState(IList<Voucher> vouchers) = _VouchersState;

  late final IList<Voucher> sortedVouchers = vouchers.sort(_compareVoucher);

  dynamic toJson() => vouchers.toJson((v) => v.toJson());
  static VouchersState fromJson(dynamic json) => VouchersState(
        IList.fromJson(json, Voucher.fromJson),
      );
}

typedef VouchersAction = BlocStreamAction<VouchersState>;

VouchersAction removeExpiredVouchers() => (value, add) => add(value.copyWith(
      vouchers: value.vouchers.fold(
        value.vouchers,
        (acc, v) =>
            v.removeAt.p(O.filter((expires) => expires.isPast)).p(O.fold(
                  () => acc,
                  (_) => acc.remove(v),
                )),
      ),
    ));

VouchersAction addVoucher(Voucher voucher) =>
    (value, add) => add(value.copyWith(
          vouchers: value.vouchers.add(voucher.copyWith(
            uuid: O.some(_uuidgen.v4()),
          )),
        ));

VouchersAction updateVoucher(Voucher voucher) =>
    (value, add) => add(value.copyWith(
          vouchers: value.vouchers.updateById([voucher], (v) => v.uuid),
        ));

VouchersAction Function(Option<String>) maybeUpdateVoucherBalance(
  Voucher v,
) =>
    (s) => (value, add) => s
        .p(O.flatMap(millis.fromString))
        .p(O.map2K(v.balanceOption, (amount, int balance) => balance - amount))
        .p(O.tap((balance) => updateVoucher(v.copyWith(
              balanceMilliunits: O.some(balance),
            ))(value, add)));

VouchersAction removeVoucher(Voucher voucher) =>
    (value, add) => add(value.copyWith(
          vouchers: value.vouchers.removeWhere((v) => v.uuid == voucher.uuid),
        ));

VouchersAction importVouchers() => (b, add) => files
    .pick(['json'])
    .p(TE.map((r) => String.fromCharCodes(r.second)))
    .p(TE.chainTryCatchK(
      jsonDecode,
      (err, s) => 'Could not parse import JSON: $err',
    ))
    .p(TE.chainNullableK(identity, (_) => 'Import was null'))
    .p(TE.chainTryCatchK(
      VouchersState.fromJson,
      (err, stack) => 'Could not convert json to VouchersState: $err',
    ))
    .p(TE.map(add))
    .p(TE.toFutureVoid(_log.warning));

VouchersAction exportVouchers() => (value, add) => TE
    .tryCatch(
      () => jsonEncode(value.toJson()),
      (err, stack) => 'encode json error: $err',
    )
    .p(TE.flatMap(files.writeString('vouchervault.json')))
    .p(TE.chainTryCatchK(
      (file) => Share.shareFiles(
        [file.path],
        subject: 'VoucherVault export',
      ),
      (err, stackTrace) => 'share files error: $err',
    ))
    .p(TE.toFutureVoid(_log.warning));

class VouchersBloc extends PersistedBlocStream<VouchersState> {
  VouchersBloc({VouchersState? initialValue})
      : super(initialValue ?? VouchersState(IList()));

  @override
  dynamic toJson(value) => value.toJson();

  @override
  VouchersState fromJson(json) => VouchersState.fromJson(json);
}

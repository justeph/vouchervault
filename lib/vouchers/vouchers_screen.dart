import 'package:flutter/material.dart';
import 'package:fpdt/fpdt.dart';
import 'package:fpdt/option.dart' as O;
import 'package:fpdt/task.dart' as T;
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vouchervault/app/app.dart';
import 'package:vouchervault/app_scaffold/app_scaffold.dart';
import 'package:vouchervault/lib/riverpod.dart';
import 'package:vouchervault/models/voucher.dart';
import 'package:vouchervault/voucher_form_dialog/voucher_form_dialog.dart';
import 'package:vouchervault/vouchers/vouchers_bloc.dart';
import 'package:vouchervault/vouchers/voucher_list/vouchers_list_container.dart';
import 'package:vouchervault/vouchers/vouchers_menu/vouchers_menu_container.dart';

part 'vouchers_screen.g.dart';

final _maybeAddVoucher = (RefRead read) => T.map(
      O
          .fromNullableWith<Voucher>()
          .c(O.map((v) => read(vouchersProvider.bloc).add(addVoucher(v)))),
    );

@cwidget
Widget vouchersScreen(BuildContext context, WidgetRef ref) {
  return AppScaffold(
    title: 'Vouchers',
    actions: const [
      VouchersMenuContainer(),
    ],
    slivers: [
      SliverPadding(
        padding: EdgeInsets.only(
          top: AppTheme.rem(1.5),
          bottom: AppTheme.space6,
        ),
        sliver: const VouchersListContainer(),
      ),
    ],
    floatingActionButton: O.some(FloatingActionButton(
      onPressed: () {
        return Navigator.push<Voucher>(
          context,
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => const VoucherFormDialog(),
          ),
        );
      }.p(_maybeAddVoucher(ref.read)),
      child: const Icon(Icons.add),
    )),
  );
}

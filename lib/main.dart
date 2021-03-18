import 'package:flutter/material.dart';
import 'package:persisted_bloc_stream/persisted_bloc_stream.dart';
import 'package:vouchervault/app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PersistedBlocStream.storage = await SharedPreferencesStorage.build();
  runApp(VoucherVaultApp());
}

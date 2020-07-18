import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:kata_note_flutter/injection.dart';
import 'package:kata_note_flutter/presentation/core/app_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureInjection(Environment.prod);
  runApp(AppWidget());
}

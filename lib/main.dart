import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:notes/injection.dart';
import 'package:notes/presentation/core/app_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureInjection(Environment.prod);
  runApp(AppWidget());
}

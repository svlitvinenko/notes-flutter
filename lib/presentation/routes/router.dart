import 'package:auto_route/auto_route_annotations.dart';
import 'package:kata_note_flutter/presentation/auth/sign_in_page.dart';
import 'package:kata_note_flutter/presentation/splash/splash_page.dart';

@MaterialAutoRouter(
  generateNavigationHelperExtension: true,
  routes: [
    MaterialRoute(page: SplashPage, initial: true),
    MaterialRoute(page: SignInPage),
  ],
)
class $Router {}

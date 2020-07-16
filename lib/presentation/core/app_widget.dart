import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kata_note_flutter/app/auth/auth_bloc.dart';
import 'package:kata_note_flutter/injection.dart';
import 'package:kata_note_flutter/presentation/auth/sign_in_page.dart';
import 'package:kata_note_flutter/presentation/routes/router.gr.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<AuthBloc>()..add(const AuthEvent.authCheckRequested()),
        )
      ],
      child: MaterialApp(
        title: 'Notes',
        debugShowCheckedModeBanner: false,
        builder: ExtendedNavigator(
          router: Router(),
        ),
        theme: ThemeData.light().copyWith(
          primaryColor: Colors.lightGreen[800],
          accentColor: Colors.purple,
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}

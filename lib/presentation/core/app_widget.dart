import 'package:flutter/material.dart';
import 'package:kata_note_flutter/presentation/auth/sign_in_page.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes',
      debugShowCheckedModeBanner: false,
      home: SignInPage(),
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.lightGreen[800],
        accentColor: Colors.purple,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

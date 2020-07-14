import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kata_note_flutter/app/auth/sign_in_form/sign_in_form_bloc.dart';
import 'package:kata_note_flutter/injection.dart';
import 'package:kata_note_flutter/presentation/auth/widgets/sign_in_form.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: BlocProvider(
        create: (context) => getIt<SignInFormBloc>(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SignInForm(),
          ),
        ),
      ),
    );
  }
}

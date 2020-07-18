import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/app/auth/sign_in_form/sign_in_form_bloc.dart';
import 'package:notes/injection.dart';
import 'package:notes/presentation/auth/widgets/sign_in_form.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: BlocProvider(
        create: (context) => getIt<SignInFormBloc>()..add(const SignInFormEvent.getThirdPartyMethodsRequested()),
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

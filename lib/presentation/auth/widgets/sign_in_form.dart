import 'package:auto_route/auto_route.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/app/auth/auth_bloc.dart';
import 'package:notes/app/auth/sign_in_form/sign_in_form_bloc.dart';
import 'package:notes/domain/auth/third_party_auth_methods.dart';
import 'package:notes/presentation/routes/router.gr.dart';
import 'package:kt_dart/kt.dart';

class SignInForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInFormBloc, SignInFormState>(
      listener: (context, state) {
        state.authFailureOrSuccessOption.fold(
          () => null,
          (eigher) => eigher.fold(
            (error) {
              final snackbar = Flushbar(
                icon: Icon(
                  Icons.error_outline,
                  size: 28.0,
                  color: Theme.of(context).errorColor,
                ),
                dismissDirection: FlushbarDismissDirection.VERTICAL,
                duration: const Duration(seconds: 3),
                animationDuration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.all(8.0),
                borderRadius: 8.0,
                shouldIconPulse: true,
                message: error.map(
                  cancelledByUser: (_) => 'Authentication is cancelled',
                  serverError: (_) => 'An unknown error occurred',
                  emailAlreadyInUse: (_) => 'This email is already in use',
                  invalidEmailAndPasswordCombination: (_) => 'Invalid email and password combination',
                  authMethodIsDenied: (_) => 'This authentication method is denied',
                ),
              );
              snackbar.show(context);
            },
            (success) {
              context.bloc<AuthBloc>().add(const AuthEvent.authCheckRequested());
              ExtendedNavigator.of(context).pushReplacementNamed(Routes.notesOverviewPage);
            },
          ),
        );
      },
      builder: (context, state) {
        return Form(
          autovalidate: state.showErrorMessages,
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              const Text(
                '⚓️',
                style: TextStyle(fontSize: 130),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                enabled: !state.isSubmitting,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: 'Email',
                ),
                autocorrect: false,
                onChanged: (value) => context.bloc<SignInFormBloc>().add(SignInFormEvent.emailChanged(value)),
                validator: (_) => context.bloc<SignInFormBloc>().state.emailAddress.value.fold(
                      (failure) => failure.maybeMap(invalidEmail: (_) => 'Invalid email', orElse: () => null),
                      (value) => null,
                    ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                enabled: !state.isSubmitting,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  labelText: 'Password',
                ),
                autocorrect: false,
                obscureText: true,
                onChanged: (value) => context.bloc<SignInFormBloc>().add(SignInFormEvent.passwordChanged(value)),
                validator: (_) => context.bloc<SignInFormBloc>().state.password.value.fold(
                      (failure) => failure.maybeMap(shortPassword: (_) => 'Too short', orElse: () => null),
                      (value) => null,
                    ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: FlatButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        context.bloc<SignInFormBloc>().add(const SignInFormEvent.signInWithEmailAndPasswordPressed());
                      },
                      child: const Text('SIGN IN'),
                    ),
                  ),
                  Expanded(
                    child: FlatButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        context.bloc<SignInFormBloc>().add(const SignInFormEvent.registerWithEmailAndPasswordPressed());
                      },
                      child: const Text('SIGN UP'),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: state.availableThirdPartyAuthMethods.getOrElse(() => listOf()).size,
                itemBuilder: (context, index) {
                  final ThirdPartyAuthMethod currentAuthMethod = state.availableThirdPartyAuthMethods.getOrElse(() => listOf())[index];
                  return RaisedButton(
                    color: Colors.lightBlue,
                    onPressed: state.isSubmitting
                        ? null
                        : () {
                            FocusScope.of(context).unfocus();
                            context.bloc<SignInFormBloc>().add(SignInFormEvent.signInWithThirdPartyMethodPressed(currentAuthMethod));
                          },
                    child: Text(
                      currentAuthMethod.map(
                        google: (_) => 'SIGN IN WITH GOOGLE',
                        apple: (_) => 'SIGN IN WITH APPLE',
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
              if (state.isSubmitting) ...[
                const SizedBox(
                  height: 10,
                ),
                const LinearProgressIndicator(),
              ]
            ],
          ),
        );
      },
    );
  }
}

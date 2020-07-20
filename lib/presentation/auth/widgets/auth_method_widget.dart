import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notes/app/auth/sign_in_form/sign_in_form_bloc.dart';
import 'package:notes/domain/auth/third_party_auth_methods.dart';
import 'package:notes/presentation/auth/widgets/auth_method_item.dart';

class AuthMethodWidget extends StatelessWidget {
  final ThirdPartyAuthMethodPresentationItem authMethod;

  const AuthMethodWidget({Key key, this.authMethod}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _initAuthorization(context),
      icon: authMethod.image,
    );
  }

  void _initAuthorization(BuildContext context) {
    context.bloc<SignInFormBloc>().add(SignInFormEvent.signInWithThirdPartyMethodPressed(authMethod.method));
  }
}

AuthMethodWidget provideWidgetForAuthMethod(BuildContext context, ThirdPartyAuthMethod authMethod) {
  return authMethod.map(
    google: (_) => AuthMethodWidget(
      authMethod: ThirdPartyAuthMethodPresentationItem(
        image: SvgPicture.asset('assets/images/google-logo.svg', width: 36, height: 36),
        method: authMethod,
      ),
    ),
    apple: (_) => AuthMethodWidget(
      authMethod: ThirdPartyAuthMethodPresentationItem(
        image: SvgPicture.asset('assets/images/apple-logo.svg', width: 36, height: 36),
        method: authMethod,
      ),
    ),
  );
}

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';
import 'package:notes/domain/auth/auth_failure.dart';
import 'package:notes/domain/auth/i_auth_facade.dart';
import 'package:notes/domain/auth/third_party_auth_methods.dart';
import 'package:notes/domain/auth/user.dart';
import 'package:notes/domain/auth/value_objects.dart';
import 'package:notes/domain/config/i_config_facade.dart';
import 'package:notes/infrastructure/auth/firebase_user_mapper.dart';

@LazySingleton(as: IAuthFacade)
class FirebaseAuthFacade implements IAuthFacade {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final IConfigFacade _configFacade;

  FirebaseAuthFacade(this._firebaseAuth, this._googleSignIn, this._configFacade);

  @override
  Future<Either<AuthFailure, Unit>> registerWithEmailAndPassword({@required EmailAddress emailAddress, @required Password password}) async {
    final String emailString = emailAddress.getOrCrash();
    final String passwordString = password.getOrCrash();

    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: emailString, password: passwordString);
      return right(unit);
    } on PlatformException catch (e) {
      if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
        return left(const AuthFailure.emailAlreadyInUse());
      } else {
        return left(const AuthFailure.serverError());
      }
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> signInWithEmailAndPassword({@required EmailAddress emailAddress, @required Password password}) async {
    final String emailString = emailAddress.getOrCrash();
    final String passwordString = password.getOrCrash();

    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: emailString, password: passwordString);
      return right(unit);
    } on PlatformException catch (e) {
      if (e.code == 'ERROR_WRONG_PASSWORD' || e.code == 'ERROR_USER_NOT_FOUND') {
        return left(const AuthFailure.invalidEmailAndPasswordCombination());
      } else {
        return left(const AuthFailure.serverError());
      }
    }
  }

  Future<Either<AuthFailure, Unit>> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleAuthResult = await _googleSignIn.signIn();

      if (googleAuthResult == null) {
        return left(const AuthFailure.cancelledByUser());
      }

      final googleAuthentication = await googleAuthResult.authentication;

      final AuthCredential authCredential = GoogleAuthProvider.getCredential(
        idToken: googleAuthentication.idToken,
        accessToken: googleAuthentication.accessToken,
      );

      await _firebaseAuth.signInWithCredential(authCredential);
      return right(unit);
    } on PlatformException {
      return left(const AuthFailure.serverError());
    }
  }

  @override
  Future<Option<User>> getSignedInUser() {
    return _firebaseAuth.currentUser().then((firebaseUser) => optionOf(firebaseUser?.toDomain()));
  }

  @override
  Future<void> signOut() => Future.wait(
        [
          _firebaseAuth.signOut(),
          _googleSignIn.signOut(),
        ],
      );

  @override
  Future<KtSet<ThirdPartyAuthMethod>> getAvailableThirdPartyAuthMethods() async {
    final KtMutableSet<ThirdPartyAuthMethod> authMethods = mutableSetOf();

    final bool isGoogleEnabled = await _configFacade.isParameterEnabled(
      parameterName: 'sign_in_with_google',
      defaultValue: false,
    );
    if (isGoogleEnabled) {
      authMethods.add(const ThirdPartyAuthMethod.google());
    }

    final bool isAppleEnabled = await _configFacade.isParameterEnabled(
      parameterName: 'sign_in_with_apple',
      defaultValue: false,
    );
    if (isAppleEnabled) {
      authMethods.add(const ThirdPartyAuthMethod.apple());
    }

    return authMethods;
  }

  @override
  Future<Either<AuthFailure, Unit>> signInWithThirdPartyMethodPressed(ThirdPartyAuthMethod authMethod) async {
    return authMethod.map(
      google: (_) => _signInWithGoogle(),
      apple: (_) => left(AuthFailure.authMethodIsDenied(authMethod)),
    );
  }
}

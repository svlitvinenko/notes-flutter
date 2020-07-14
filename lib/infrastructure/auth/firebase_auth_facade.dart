import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:kata_note_flutter/domain/auth/auth_failure.dart';
import 'package:dartz/dartz.dart';
import 'package:kata_note_flutter/domain/auth/i_auth_facade.dart';
import 'package:kata_note_flutter/domain/auth/value_objects.dart';

@LazySingleton(as: IAuthFacade)
class FirebaseAuthFacade implements IAuthFacade {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  FirebaseAuthFacade(this._firebaseAuth, this._googleSignIn);

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

  @override
  Future<Either<AuthFailure, Unit>> signInWithGoogle() async {
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
}

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:notes/domain/auth/auth_failure.dart';
import 'package:notes/domain/auth/third_party_auth_methods.dart';
import 'package:notes/domain/auth/user.dart';
import 'package:notes/domain/auth/value_objects.dart';
import 'package:kt_dart/kt.dart';

abstract class IAuthFacade {
  Future<Either<AuthFailure, Unit>> registerWithEmailAndPassword({@required EmailAddress emailAddress, @required Password password});
  Future<Either<AuthFailure, Unit>> signInWithEmailAndPassword({@required EmailAddress emailAddress, @required Password password});
  Future<Either<AuthFailure, Unit>> signInWithThirdPartyMethodPressed(ThirdPartyAuthMethod authMethod);
  Future<Option<User>> getSignedInUser();
  Future<void> signOut();
  Future<KtSet<ThirdPartyAuthMethod>> getAvailableThirdPartyAuthMethods();
}

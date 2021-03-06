import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:notes/domain/auth/third_party_auth_methods.dart';

part 'auth_failure.freezed.dart';

@freezed
abstract class AuthFailure with _$AuthFailure {
  const factory AuthFailure.cancelledByUser() = CancelledByUser;
  const factory AuthFailure.serverError() = ServerError;
  const factory AuthFailure.emailAlreadyInUse() = EmailAlreadyInUse;
  const factory AuthFailure.invalidEmailAndPasswordCombination() = InvalidEmailAndPasswordCombination;
  const factory AuthFailure.authMethodIsDenied(ThirdPartyAuthMethod deniedMethod) = AuthMethodIsDenied;
}

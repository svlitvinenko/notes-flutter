import 'package:dartz/dartz.dart';
import 'package:kata_note_flutter/domain/core/failures.dart';

Either<ValueFailure<String>, String> validateEmailAddress(String input) {
  const regex = r""".+@.+\..+""";

  if (RegExp(regex).hasMatch(input)) {
    return right(input);
  } else {
    return left(ValueFailure.invalidEmail(failedValue: input));
  }
}

Either<ValueFailure<String>, String> validatePassord(String input) {
  if (input.length >= 8) {
    return right(input);
  } else {
    return left(ValueFailure.shortPassword(failedValue: input));
  }
}

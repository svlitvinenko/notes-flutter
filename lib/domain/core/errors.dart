import 'package:flutter/foundation.dart';
import 'package:kata_note_flutter/domain/core/failures.dart';

class UnexpectedValueError extends Error {
  final ValueFailure failure;

  UnexpectedValueError({@required this.failure});

  @override
  String toString() {
    return Error.safeToString('Found an invalid value at unrecoverable palce of code logic.\n\n${failure.toString()}\n\nTerminating...');
  }
}

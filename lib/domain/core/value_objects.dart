import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kata_note_flutter/domain/core/errors.dart';
import 'package:kata_note_flutter/domain/core/failures.dart';
import 'package:uuid/uuid.dart';

@immutable
abstract class ValueObject<T> {
  const ValueObject();
  Either<ValueFailure<T>, T> get value;

  bool isValid() => value.isRight();

  /// Генерирует ошибку [UnexpectedValueError] с описанием ошибки [ValueFailure], если произведена попытка получить невалидное значение.
  T getOrCrash() => value.fold((l) => throw UnexpectedValueError(failure: l), id);

  Either<ValueFailure<dynamic>, Unit> get failureOrUnit {
    return value.fold(left, (_) => right(unit));
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ValueObject<T> && o.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Value($value)';
}

class UniqueId extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory UniqueId.generate() => UniqueId._(right(Uuid().v1()));

  factory UniqueId.fromUniqueString(String uniqueId) {
    assert(uniqueId != null);
    return UniqueId._(right(uniqueId));
  }

  const UniqueId._(this.value);
}

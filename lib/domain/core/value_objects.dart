import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kata_note_flutter/domain/core/errors.dart';
import 'package:kata_note_flutter/domain/core/failures.dart';

@immutable
abstract class ValueObject<T> {
  const ValueObject();
  Either<ValueFailure<T>, T> get value;

  bool isValid() => value.isRight();

  /// Генерирует ошибку [UnexpectedValueError] с описанием ошибки [ValueFailure], если произведена попытка получить невалидное значение.
  T getOrCrash() => value.fold((l) => throw UnexpectedValueError(failure: l), id);

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

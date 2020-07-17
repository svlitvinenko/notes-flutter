import 'dart:ui';

import 'package:dartz/dartz.dart';
import 'package:kata_note_flutter/domain/core/failures.dart';
import 'package:kata_note_flutter/domain/core/value_objects.dart';
import 'package:kata_note_flutter/domain/core/value_transformers.dart';
import 'package:kata_note_flutter/domain/core/value_validators.dart';
import 'package:kt_dart/collection.dart';

class NoteBody extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  static const int maxLength = 1000;

  factory NoteBody(String input) {
    assert(input != null);
    return NoteBody._(
      validateMaxStringLength(input, maxLength).flatMap((a) => validateStringNotEmpty(a)),
    );
  }

  factory NoteBody.empty() => NoteBody('');

  const NoteBody._(this.value);
}

class TodoName extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  static const int maxLength = 30;

  factory TodoName(String input) {
    assert(input != null);
    return TodoName._(validateMaxStringLength(input, maxLength).flatMap(validateStringNotEmpty).flatMap(validateStringIsSingleline));
  }

  const TodoName._(this.value);
}

class NoteColor extends ValueObject<Color> {
  static const List<Color> acceptableColors = [
    Color(0xfffafafa), // canvas
    Color(0xfffa8072), // salmon
    Color(0xfffedc56), // mustard
    Color(0xffd0f0c0), // tea
    Color(0xfffca3b7), // flamingo
    Color(0xff997950), // tortilla
    Color(0xfffffdd0), // cream
  ];

  @override
  final Either<ValueFailure<Color>, Color> value;

  factory NoteColor(Color input) {
    assert(input != null);
    return NoteColor._(right(makeColorOpaque(input)));
  }

  factory NoteColor.initial() => NoteColor(acceptableColors.first);

  const NoteColor._(this.value);
}

class List3<T> extends ValueObject<KtList<T>> {
  static const int maxSize = 3;

  @override
  final Either<ValueFailure<KtList<T>>, KtList<T>> value;

  static const int maxLength = 1000;

  factory List3(KtList<T> input) {
    assert(input != null);
    return List3<T>._(validateMaxListLength(input, maxLength));
  }

  factory List3.empty() => List3(emptyList());

  const List3._(this.value);

  int get length => value.getOrElse(() => emptyList()).size;

  bool get isFull => length == maxLength;
}

import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kata_note_flutter/domain/core/failures.dart';
import 'package:kata_note_flutter/domain/core/value_objects.dart';
import 'package:kata_note_flutter/domain/notes/todo_item.dart';
import 'package:kata_note_flutter/domain/notes/value_objects.dart';
import 'package:kt_dart/collection.dart';

part 'note.freezed.dart';

@immutable
@freezed
abstract class Note implements _$Note {
  const Note._();

  const factory Note({
    @required UniqueId id,
    @required NoteBody body,
    @required NoteColor color,
    @required List3<TodoItem> todos,
  }) = _Note;

  factory Note.empty() => Note(
        id: UniqueId.generate(),
        body: NoteBody.empty(),
        color: NoteColor.initial(),
        todos: List3.empty(),
      );

  /// Опция с возможной ошибкой.
  Option<ValueFailure<dynamic>> get failureOption {
    return body.failureOrUnit
        .andThen(todos.failureOrUnit)
        .andThen(todos
            .getOrCrash()
            .map((item) => item.failureOption)
            .filter((option) => option.isSome())
            .getOrElse(0, (_) => none())
            .fold(() => right(unit), (a) => left(a)))
        .fold(some, (_) => none());
  }
}

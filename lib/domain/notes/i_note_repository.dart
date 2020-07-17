import 'package:dartz/dartz.dart';
import 'package:kata_note_flutter/domain/notes/note.dart';
import 'package:kata_note_flutter/domain/notes/note_failure.dart';
import 'package:kt_dart/collection.dart';

abstract class INoteRepository {

  /// Подписка на заметки.
  Stream<Either<NoteFailure, KtList<Note>>> watchAll();

  /// Подписка на невыполненные заметки.
  Stream<Either<NoteFailure, KtList<Note>>> watchUncompleted();

  /// Создание заметки.
  Future<Either<NoteFailure, Unit>> create(Note note);

  /// Обновление заметки.
  Future<Either<NoteFailure, Unit>> update(Note note);

  /// Удаление заметки.
  Future<Either<NoteFailure, Unit>> delete(Note note);
}

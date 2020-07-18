import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:notes/domain/notes/i_note_repository.dart';
import 'package:notes/domain/notes/note_failure.dart';
import 'package:notes/domain/notes/note.dart';
import 'package:notes/infrastructure/notes/note_dtos.dart';
import 'package:kt_dart/collection.dart';
import 'package:notes/infrastructure/core/firestore_helpers.dart';
import 'package:rxdart/rxdart.dart';

@LazySingleton(as: INoteRepository)
class NoteRepository implements INoteRepository {
  final Firestore _firestore;

  NoteRepository(this._firestore);

  @override
  Stream<Either<NoteFailure, KtList<Note>>> watchAll() async* {
    //* Следит за коллекцией "users/{user ID}/notes".
    final userDocument = await _firestore.userDocument();

    yield* userDocument.noteCollection
        .orderBy('serverTimeStamp', descending: true)
        .snapshots()
        .map((snapshot) => right<NoteFailure, KtList<Note>>(snapshot.documents.map(
              (DocumentSnapshot document) {
                return NoteDto.fromFirestore(document).toDomain();
              },
            ).toImmutableList()))
        .onErrorReturnWith((e) => left(_mapExceptionToNoteFailure(e)));
  }

  @override
  Stream<Either<NoteFailure, KtList<Note>>> watchUncompleted() async* {
    final userDocument = await _firestore.userDocument();

    yield* userDocument.noteCollection
        .orderBy('serverTimeStamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.documents
            .map((DocumentSnapshot document) => NoteDto.fromFirestore(document).toDomain())
            .where((e) => e.todos.getOrCrash().any((todo) => !todo.isDone))
            .toImmutableList())
        .map((notes) => right<NoteFailure, KtList<Note>>(notes))
        .onErrorReturnWith((e) => left(_mapExceptionToNoteFailure(e)));
  }

  @override
  Future<Either<NoteFailure, Unit>> create(Note note) async {
    try {
      final userDocument = await _firestore.userDocument();
      final NoteDto dto = NoteDto.fromDomain(note);

      //! Вызвать noteCollection.add(dto.toJson()) нельзя, потому что в этом случае ID будет сгенерировано сервером,
      //! а нужное значение будет утеряно.
      await userDocument.noteCollection.document(dto.id).setData(dto.toJson());

      return right(unit);
    } on PlatformException catch (e) {
      return left(_mapExceptionToNoteFailure(e));
    }
  }

  @override
  Future<Either<NoteFailure, Unit>> delete(Note note) async {
    try {
      final userDocument = await _firestore.userDocument();
      final String noteId = note.id.getOrCrash();
      await userDocument.noteCollection.document(noteId).delete();
      return right(unit);
    } on PlatformException catch (e) {
      return left(_mapExceptionToNoteFailure(e));
    }
  }

  @override
  Future<Either<NoteFailure, Unit>> update(Note note) async {
    try {
      final userDocument = await _firestore.userDocument();
      final NoteDto dto = NoteDto.fromDomain(note);
      await userDocument.noteCollection.document(dto.id).updateData(dto.toJson());
      return right(unit);
    } on PlatformException catch (e) {
      return left(_mapExceptionToNoteFailure(e));
    }
  }

  NoteFailure _mapExceptionToNoteFailure(dynamic exception) {
    if (exception is PlatformException && exception.message.contains('PERMISSION_DENIED')) {
      return const NoteFailure.insufficientPermission();
    } else if (exception is PlatformException && exception.message.contains('NOT_FOUND')) {
      return const NoteFailure.unableToUpdate();
    } else {
      return const NoteFailure.unexpected();
    }
  }
}

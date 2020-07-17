import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:kata_note_flutter/domain/notes/i_note_repository.dart';
import 'package:kata_note_flutter/domain/notes/note_failure.dart';
import 'package:kata_note_flutter/domain/notes/note.dart';
import 'package:kata_note_flutter/infrastructure/notes/note_dtos.dart';
import 'package:kt_dart/collection.dart';
import 'package:kata_note_flutter/infrastructure/core/firestore_helpers.dart';
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
        .onErrorReturnWith(_mapExceptionToNoteFailure);
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
        .onErrorReturnWith(_mapExceptionToNoteFailure);
  }

  @override
  Future<Either<NoteFailure, Unit>> create(Note note) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<Either<NoteFailure, Unit>> delete(Note note) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Either<NoteFailure, Unit>> update(Note note) {
    // TODO: implement update
    throw UnimplementedError();
  }

  Either<NoteFailure, KtList<Note>> _mapExceptionToNoteFailure(dynamic exception) {
    if (exception is PlatformException && exception.message.contains('PERMISSION_DENIED')) {
      return left(const NoteFailure.insufficientPermission());
    } else {
      return left(const NoteFailure.unexpected());
    }
  }
}

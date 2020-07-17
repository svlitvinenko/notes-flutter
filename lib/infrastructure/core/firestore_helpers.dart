import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:kata_note_flutter/domain/auth/i_auth_facade.dart';
import 'package:kata_note_flutter/domain/auth/user.dart';
import 'package:kata_note_flutter/domain/core/errors.dart';
import 'package:kata_note_flutter/injection.dart';

extension FirestoreX on Firestore {
  Future<DocumentReference> userDocument() async {
    final Option<User> userOption = await getIt<IAuthFacade>().getSignedInUser();

    final User user = userOption.getOrElse(() => throw NotAuthorizedError());

    return Firestore.instance.collection('users').document(user.id.getOrCrash());
  }
}

extension DocumentReferenceX on DocumentReference {
  CollectionReference get noteCollection => collection('notes');
}

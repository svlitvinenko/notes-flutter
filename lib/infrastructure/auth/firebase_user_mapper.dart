import 'package:firebase_auth/firebase_auth.dart';
import 'package:kata_note_flutter/domain/auth/user.dart';
import 'package:kata_note_flutter/domain/core/value_objects.dart';

extension FirebaseDomainUserX on FirebaseUser {
  User toDomain() {
    return User(id: UniqueId.fromUniqueString(uid));
  }
}

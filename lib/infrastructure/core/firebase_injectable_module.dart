import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

@module
abstract class FirebaseInjectableModule {
  @lazySingleton
  GoogleSignIn get googleSignIn => GoogleSignIn();

  @lazySingleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @lazySingleton
  Firestore get firestore => Firestore.instance;

  @singleton
  @preResolve
  Future<RemoteConfig> get remoteConfig async {
    final RemoteConfig config = await RemoteConfig.instance;
    await config.fetch(expiration: const Duration(minutes: 1));
    await config.activateFetched();
    return config;
  }
}

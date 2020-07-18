import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:notes/domain/config/i_config_facade.dart';

@LazySingleton(as: IConfigFacade)
class FirebaseConfigFacade implements IConfigFacade {
  final RemoteConfig _remoteConfig;

  FirebaseConfigFacade(this._remoteConfig);

  @override
  Future<bool> isParameterEnabled({@required String parameterName, @required bool defaultValue}) async {
    final valueFromConfig = _remoteConfig.getValue(parameterName)?.asBool() ?? defaultValue;
    return valueFromConfig;
  }
}

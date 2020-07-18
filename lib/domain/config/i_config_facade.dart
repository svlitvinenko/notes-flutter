import 'package:flutter/foundation.dart';

/// Фасад, предоставляющий информацию о доступности того или иного функционала.
abstract class IConfigFacade {
  Future<bool> isParameterEnabled({
    @required String parameterName,
    @required bool defaultValue,
  });
}

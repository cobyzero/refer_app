import 'package:flutter/foundation.dart';

/// Log solo-desarrollo. En release es no-op: nada llega a logcat.
///
/// Usar en vez de `print()` en toda la app. Nunca pasar tokens,
/// passwords, headers `Authorization` ni cuerpos con PII.
class AppLog {
  const AppLog._();

  static void d(String message) {
    if (kDebugMode) {
      debugPrint(message);
    }
  }
}

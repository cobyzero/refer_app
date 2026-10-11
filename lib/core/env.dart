import 'secure_env.dart';

/// Fuente única de configuración. Solo envied.
///
/// Los valores se hornean en build-time desde `.env` (ver
/// `lib/core/secure_env.dart` para la lista clara de variables).
/// Nada sensible viaja como archivo en el bundle y no hay que pasar
/// `--dart-define` a mano.
///
/// Flujo:
/// 1. Edita `.env` (copia de `.env.example`).
/// 2. Regenera: `dart run build_runner build -d`
/// 3. Compila normal: `flutter run` / `flutter build apk --release`
class AppEnv {
  const AppEnv._();

  /// No-op por compatibilidad (envied no necesita carga en runtime).
  /// Se conserva para no tocar `main.dart` más de lo necesario.
  static Future<void> load() async {}

  /// `dev | prod` (case-insensitive). Default: `dev`.
  static String get env {
    final lower = SecureEnv.env.toLowerCase();
    if (lower == 'prod' || lower == 'production') return 'prod';
    return 'dev';
  }

  static bool get isProd => env == 'prod';
  static bool get isDev => !isProd;

  static String get devBaseUrl => SecureEnv.devBaseUrl;
  static String get devBaseUrlAndroid => SecureEnv.devBaseUrlAndroid;

  static String get prodBaseUrl => SecureEnv.prodBaseUrl;

  static String get prodBaseUrlAndroid =>
      SecureEnv.prodBaseUrlAndroid.isNotEmpty
          ? SecureEnv.prodBaseUrlAndroid
          : SecureEnv.prodBaseUrl;

  static String get termsUrl => SecureEnv.termsUrl;
  static String get privacyUrl => SecureEnv.privacyUrl;

  /// Key pública de Stripe. Sin fallback a test: si falta, falla en voz
  /// alta en `StripeService.init()`.
  static String get stripePublishableKey =>
      SecureEnv.stripePublishableKey.trim();

  static String get stripeMerchantIdentifier =>
      SecureEnv.stripeMerchantIdentifier;
}

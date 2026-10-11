import 'package:envied/envied.dart';

part 'secure_env.g.dart';

/// Valores horneados en build-time desde `.env` vía `build_runner`.
///
/// - NO se embarca ningún `.env` en `assets` (ver `pubspec.yaml`).
/// - Este archivo define QUÉ variables existen (claro y explícito);
///   los valores viven en `.env` local / CI y en el generado ofuscado.
/// - `secure_env.g.dart` contiene los secretos ofuscados → está en
///   `.gitignore` y se regenera en CI con el `.env` de prod.
///
/// Regenerar tras editar `.env`:
/// ```sh
/// dart run build_runner build -d
/// ```
///
/// Variables (misma tabla que `lib/core/env.dart` y `.env.example`):
/// `ENV`, `DEV_BASE_URL`, `DEV_BASE_URL_ANDROID`, `PROD_BASE_URL`,
/// `PROD_BASE_URL_ANDROID`, `TERMS_URL`, `PRIVACY_URL`,
/// `STRIPE_PUBLISHABLE_KEY`, `STRIPE_MERCHANT_IDENTIFIER`.
@Envied(path: '.env')
final class SecureEnv {
  @EnviedField(varName: 'ENV', defaultValue: 'dev')
  static const String env = _SecureEnv.env;

  @EnviedField(
    varName: 'DEV_BASE_URL',
    defaultValue: 'http://127.0.0.1:3000',
  )
  static const String devBaseUrl = _SecureEnv.devBaseUrl;

  @EnviedField(
    varName: 'DEV_BASE_URL_ANDROID',
    defaultValue: 'http://10.0.2.2:3000',
  )
  static const String devBaseUrlAndroid = _SecureEnv.devBaseUrlAndroid;

  // URLs prod y Stripe van ofuscadas: son las sensibles.
  // NOTE: ofuscado => `static final`, no `const`.
  // `defaultValue: ''` = opcional: si falta en .env, queda '' y AppEnv hace fallback.
  @EnviedField(varName: 'PROD_BASE_URL', obfuscate: true, defaultValue: '')
  static final String prodBaseUrl = _SecureEnv.prodBaseUrl;

  @EnviedField(
    varName: 'PROD_BASE_URL_ANDROID',
    obfuscate: true,
    defaultValue: '',
  )
  static final String prodBaseUrlAndroid = _SecureEnv.prodBaseUrlAndroid;

  @EnviedField(
    varName: 'TERMS_URL',
    defaultValue: 'https://refer.cobyzero.com/terms',
  )
  static const String termsUrl = _SecureEnv.termsUrl;

  @EnviedField(
    varName: 'PRIVACY_URL',
    defaultValue: 'https://refer.cobyzero.com/privacy',
  )
  static const String privacyUrl = _SecureEnv.privacyUrl;

  @EnviedField(
    varName: 'STRIPE_PUBLISHABLE_KEY',
    obfuscate: true,
    defaultValue: '',
  )
  static final String stripePublishableKey = _SecureEnv.stripePublishableKey;

  @EnviedField(
    varName: 'STRIPE_MERCHANT_IDENTIFIER',
    defaultValue: 'merchant.com.example.refer_app',
  )
  static const String stripeMerchantIdentifier =
      _SecureEnv.stripeMerchantIdentifier;
}

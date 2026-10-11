import 'dart:io';
import 'env.dart';

class AppConstants {
  /// Entorno activo: `ENV=dev | prod` vía `--dart-define` o `.env` (dev).
  /// Acepta: dev / development / prod / production (case-insensitive).
  /// Cualquier otro valor (o vacío) => dev.
  static String get environment => AppEnv.env;

  static bool get isProd => AppEnv.isProd;
  static bool get isDev => AppEnv.isDev;

  static bool get _isAndroid {
    try {
      return Platform.isAndroid;
    } catch (_) {
      return false;
    }
  }

  static String get baseUrl {
    // Variables por entorno vía AppEnv (--dart-define primero, .env solo dev).
    if (_isAndroid) {
      final v = isProd ? AppEnv.prodBaseUrlAndroid : AppEnv.devBaseUrlAndroid;
      if (v.isNotEmpty) return v.replaceAll(RegExp(r'/+$'), '');
    }
    final main = isProd ? AppEnv.prodBaseUrl : AppEnv.devBaseUrl;
    if (main.isNotEmpty) return main.replaceAll(RegExp(r'/+$'), '');

    // Defaults por plataforma (solo dev; en prod AppEnv exige PROD_BASE_URL).
    if (_isAndroid) return 'http://10.0.2.2:3000';
    return 'http://127.0.0.1:3000';
  }

  static String get apiBaseUrl => '$baseUrl/api';

  static String get socketUrl => '$baseUrl/cart';

  static String get ordersSocketUrl => '$baseUrl/orders';
}

/// Formato de dinero según la moneda configurada en el API
/// (tabla app_settings -> GET /config -> settings.currency).
class Money {
  static const _symbols = {
    'USD': '\$',
    'MXN': '\$',
    'COP': '\$',
    'CLP': '\$',
    'ARS': '\$',
    'CAD': '\$',
    'EUR': '€',
    'GBP': '£',
    'BRL': 'R\$',
    'PEN': 'S/',
  };

  /// Código ISO (USD, MXN, ...) traído del API (GET /config).
  /// Lo actualiza SplashBloc al cargar; USD hasta entonces.
  static String currencyCode = 'USD';

  static String get symbol => _symbols[currencyCode] ?? '\$';

  /// Código en minúsculas para Stripe / backend.
  static String get stripeCurrency => currencyCode.toLowerCase();

  static String format(num amount) => '$symbol${amount.toStringAsFixed(2)}';

  static String formatPlus(num amount) => '+$symbol${amount.toStringAsFixed(2)}';
}

/// Impuesto estimado del pedido, configurado por el operador en la web
/// (tabla app_settings -> GET /config -> settings.tax_enabled/tax_rate).
class TaxConfig {
  /// Si se cobra impuesto. Lo actualiza SplashBloc al cargar.
  static bool enabled = true;

  /// Tasa como fracción 0..1 (0.08 = 8%). La actualiza SplashBloc.
  static double rate = 0.08;

  /// Tasa efectiva: 0 si el impuesto está apagado.
  static double get effectiveRate => enabled ? rate : 0;

  /// Total con impuesto incluido.
  static double applyTo(double subtotal) => subtotal * (1 + effectiveRate);

  /// Etiqueta "8%" para mostrar junto al nombre del impuesto.
  static String get percentLabel {
    final pct = effectiveRate * 100;
    return pct % 1 == 0 ? '${pct.toInt()}%' : '${pct.toStringAsFixed(1)}%';
  }
}

/// Tarifa de servicio del pedido, configurada por el operador en la web
/// (tabla app_settings -> GET /config -> settings.service_fee_rate).
class ServiceFee {
  /// Tasa como fracción 0..1 (0.05 = 5%). La actualiza SplashBloc.
  static double rate = 0.0;

  /// Monto de la tarifa sobre el subtotal.
  static double amountFor(double subtotal) => subtotal * rate;
}

/// Confirmación directa sin Stripe, autorizada por el OPERADOR en la web
/// (refer_web → configuración → GET /config `features.directConfirmEnabled`).
/// La actualiza SplashBloc al cargar. Default false (fail-closed).
/// La app jamás decide por `isDev`: el servidor también valida el flag
/// en POST /orders/:id/confirm y rechaza sin pago si está apagado.
class PaymentsConfig {
  static bool directConfirmAllowed = false;
}

/// Verificación OTP de email para cuentas nuevas, decidida por el OPERADOR
/// (módulo de configuración en refer_web, o `.env` en la API) y expuesta en
/// GET /config `features.emailVerificationRequired`.
/// La actualiza SplashBloc al cargar. Default true (fail-closed = conducta
/// actual): si el flag falta (API vieja), la app asume que sí hay OTP y
/// muestra la vista de verificación. Con false, el registro/login devuelven
/// sesión directa y la app entra sin pasar por OTP.
class EmailVerification {
  static bool required = true;
}

class AppConfig {
  final String version;
  final String minVersion;
  final bool maintenance;
  final Map<String, bool> features;
  final Map<String, String> endpoints;
  final Map<String, String> settings;

  /// Monedas aceptadas por el API (SupportedCurrencies en refer_api).
  static const supportedCurrencies = {
    'USD', 'MXN', 'EUR', 'COP', 'PEN', 'CLP', 'ARS', 'BRL', 'GBP', 'CAD',
  };

  AppConfig({
    required this.version,
    required this.minVersion,
    required this.maintenance,
    required this.features,
    required this.endpoints,
    this.settings = const {},
  });

  /// Tipo de moneda configurado por el operador (tabla app_settings).
  /// Si falta o no es soportada, cae a USD.
  String get currency {
    final c = (settings['currency'] ?? 'USD').toUpperCase();
    return supportedCurrencies.contains(c) ? c : 'USD';
  }

  /// Impuesto estimado cobrado en tu pedido (tabla app_settings).
  /// Si está apagado o la tasa es inválida, no se cobra impuesto.
  bool get taxEnabled {
    final v = (settings['tax_enabled'] ?? 'true').trim().toLowerCase();
    return v == 'true' || v == '1';
  }

  /// Tasa como fracción 0..1 (0.08 = 8%). Por defecto 8%.
  double get taxRate {
    final rate = double.tryParse(settings['tax_rate'] ?? '');
    if (rate == null || rate < 0 || rate > 1) return 0.08;
    return rate;
  }

  /// Tarifa de servicio como fracción 0..1 (0.05 = 5%). Por defecto 0.
  double get serviceFeeRate {
    final rate = double.tryParse(settings['service_fee_rate'] ?? '');
    if (rate == null || rate < 0 || rate > 1) return 0.0;
    return rate;
  }

  /// Si las cuentas nuevas deben verificar email por OTP. Lo decide el
  /// operador (refer_web → configuración, o `.env` en la API →
  /// GET /config `features.emailVerificationRequired`).
  /// Fail-closed: si el flag falta (API vieja), se asume true y la app
  /// muestra la vista OTP como siempre.
  bool get emailVerificationRequired {
    return features['emailVerificationRequired'] ?? true;
  }

  /// Confirmación directa sin Stripe (solo pruebas, lo autoriza el operador
  /// en refer_web → GET /config `features.directConfirmEnabled`).
  /// Fail-closed: cualquier valor distinto de true/1 es false.
  bool get directConfirmEnabled {
    if (features['directConfirmEnabled'] == true) return true;
    final v = (settings['direct_confirm_enabled'] ?? '').trim().toLowerCase();
    return v == 'true' || v == '1';
  }

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      version: json['version'] ?? '',
      minVersion: json['minVersion'] ?? '',
      maintenance: json['maintenance'] ?? false,
      features: Map<String, bool>.from(json['features'] ?? {}),
      endpoints: Map<String, String>.from(json['endpoints'] ?? {}),
      settings: Map<String, String>.from(json['settings'] ?? {}),
    );
  }
}

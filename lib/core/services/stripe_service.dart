import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../env.dart';
import '../api_client.dart';

class StripeService {
  final ApiClient apiClient;

  /// Key pública desde AppEnv (--dart-define o .env dev).
  /// Sin fallback hardcodeado: si falta, se falla en voz alta en init().
  static String get publishableKey => AppEnv.stripePublishableKey;

  static String get merchantIdentifier => AppEnv.stripeMerchantIdentifier;

  StripeService({required this.apiClient});

  static Future<void> init() async {
    if (publishableKey.isEmpty) {
      throw StateError(
        'Falta STRIPE_PUBLISHABLE_KEY (--dart-define en release o .env en dev). '
        'Ver .env.example y lib/core/env.dart.',
      );
    }
    Stripe.publishableKey = publishableKey;
    Stripe.merchantIdentifier = merchantIdentifier;
    await Stripe.instance.applySettings();
  }

  /// Order-first flow: the intent is created for the SERVER total of a
  /// PENDING_PAYMENT order. Raw client amounts are no longer accepted.
  Future<void> payForOrder({
    required String orderId,
    required String currency,
    required Function() onSuccess,
    required Function(String) onError,
  }) async {
    try {
      // 1. Create payment intent on the backend for this order
      final response = await apiClient.dio.post(
        '/payments/create-payment-intent',
        data: {'orderId': orderId, 'currency': currency},
      );

      if (response.statusCode != 201) {
        onError('Failed to create payment intent');
        return;
      }

      final clientSecret = response.data['clientSecret'] as String? ?? '';

      // 2. Initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Artisan Espresso',
          style: ThemeMode.light,
        ),
      );

      // 3. Present payment sheet
      await Stripe.instance.presentPaymentSheet();

      // 4. On success (awaited: callers keep their busy state until confirm).
      await onSuccess();
    } catch (e) {
      if (e is StripeException) {
        onError(e.error.localizedMessage ?? 'Transaction cancelled');
      } else if (e is DioException) {
        // El backend ya devuelve mensaje limpio (p. ej. monto bajo el
        // mínimo de Stripe). Mostrarlo en vez del DioException crudo.
        final data = e.response?.data;
        final backendMsg = data is Map ? data['message']?.toString() : null;
        if (backendMsg != null && backendMsg.trim().isNotEmpty) {
          onError(backendMsg);
        } else if (e.response?.statusCode == 400) {
          onError('Payment rejected for this amount');
        } else {
          onError('Could not start payment. Try again.');
        }
      } else {
        onError(e.toString());
      }
    }
  }
}

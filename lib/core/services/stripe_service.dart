import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../api_client.dart';

class StripeService {
  final ApiClient apiClient;

  static String get publishableKey {
    final fromEnv = dotenv.env['STRIPE_PUBLISHABLE_KEY']?.trim();
    if (fromEnv != null && fromEnv.isNotEmpty) return fromEnv;
    // Fallback (matches logs pi_3TMDysBVQCFU1ZTs...)
    return 'pk_test_51OdiwLBVQCFU1ZTs1OsLhnEHt4NgzfpQ2O65r3vQsA6ZcPhNUIdXChcMYeNHiqE4wAM5lXyRPrhOoKBFB5UTcE9V00ddPMqfGS';
  }

  static String get merchantIdentifier {
    final fromEnv = dotenv.env['STRIPE_MERCHANT_IDENTIFIER']?.trim();
    if (fromEnv != null && fromEnv.isNotEmpty) return fromEnv;
    return 'merchant.com.example.refer_app';
  }

  StripeService({required this.apiClient});

  static Future<void> init() async {
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
      } else {
        onError(e.toString());
      }
    }
  }
}

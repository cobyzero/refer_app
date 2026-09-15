import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';
import '../widgets/app_snackbar.dart';

/// URLs de los documentos legales, publicados en la web de Refer.
/// Configurables en el `.env` (`TERMS_URL` / `PRIVACY_URL`); por defecto
/// apuntan a `https://refer.cobyzero.com/terms` y `/privacy`.
class LegalUrls {
  const LegalUrls._();

  static const defaultTerms = 'https://refer.cobyzero.com/terms';
  static const defaultPrivacy = 'https://refer.cobyzero.com/privacy';

  static String _env(String key) => dotenv.env[key]?.trim() ?? '';

  static String get terms {
    final v = _env('TERMS_URL');
    if (v.isNotEmpty) return v;
    return defaultTerms;
  }

  static String get privacy {
    final v = _env('PRIVACY_URL');
    if (v.isNotEmpty) return v;
    return defaultPrivacy;
  }
}

/// Abre los Términos de Servicio en el visor web in-app.
Future<bool> openTermsOfService(BuildContext context) =>
    openLegalUrl(context, LegalUrls.terms);

/// Abre la Política de Privacidad en el visor web in-app.
Future<bool> openPrivacyPolicy(BuildContext context) =>
    openLegalUrl(context, LegalUrls.privacy);

/// Abre una URL legal en el visor web in-app (SafariVC / Custom Tabs).
/// Si falla, muestra un aviso y retorna false.
Future<bool> openLegalUrl(BuildContext context, String url) async {
  try {
    final launched = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.inAppBrowserView,
    );
    if (!launched && context.mounted) {
      AppSnackBar.error(
        context,
        AppLocalizations.of(context)!.couldNotOpenLink,
      );
    }
    return launched;
  } catch (_) {
    if (context.mounted) {
      AppSnackBar.error(
        context,
        AppLocalizations.of(context)!.couldNotOpenLink,
      );
    }
    return false;
  }
}

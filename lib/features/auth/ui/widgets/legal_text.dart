import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme.dart';
import '../../../../core/utils/legal_launcher.dart';

/// Texto legal con "Términos" y "Política de Privacidad" como enlaces
/// que abren la web de Refer en el visor in-app
/// (`refer.cobyzero.com/terms` y `/privacy`).
///
/// El [text] debe contener [termsLabel] y [privacyLabel] exactamente una
/// vez cada uno, en cualquier orden (ver `agreeTermsPrivacy` y
/// `acceptTerms` en los `.arb`). Si alguno falta, se muestra texto plano.
class LegalText extends StatefulWidget {
  final String text;
  final String termsLabel;
  final String privacyLabel;
  final TextStyle? style;
  final TextStyle? linkStyle;
  final TextAlign textAlign;

  const LegalText({
    super.key,
    required this.text,
    required this.termsLabel,
    required this.privacyLabel,
    this.style,
    this.linkStyle,
    this.textAlign = TextAlign.center,
  });

  @override
  State<LegalText> createState() => _LegalTextState();
}

class _LegalTextState extends State<LegalText> {
  late final TapGestureRecognizer _termsRecognizer;
  late final TapGestureRecognizer _privacyRecognizer;

  @override
  void initState() {
    super.initState();
    _termsRecognizer = TapGestureRecognizer()
      ..onTap = () => openTermsOfService(context);
    _privacyRecognizer = TapGestureRecognizer()
      ..onTap = () => openPrivacyPolicy(context);
  }

  @override
  void dispose() {
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseStyle = widget.style ?? DefaultTextStyle.of(context).style;
    final linkStyle =
        widget.linkStyle ??
        baseStyle.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.underline,
          decorationColor: AppColors.primary,
        );

    return Text.rich(
      TextSpan(children: _buildSpans(baseStyle, linkStyle)),
      textAlign: widget.textAlign,
      style: baseStyle,
    );
  }

  List<InlineSpan> _buildSpans(TextStyle baseStyle, TextStyle linkStyle) {
    final text = widget.text;
    final termsIndex = text.indexOf(widget.termsLabel);
    final privacyIndex = text.indexOf(widget.privacyLabel);

    // Sin ambas etiquetas: texto plano como respaldo.
    if (termsIndex < 0 ||
        privacyIndex < 0 ||
        widget.termsLabel.isEmpty ||
        widget.privacyLabel.isEmpty) {
      return [TextSpan(text: text, style: baseStyle)];
    }

    final links = [
      (termsIndex, widget.termsLabel, _termsRecognizer),
      (privacyIndex, widget.privacyLabel, _privacyRecognizer),
    ]..sort((a, b) => a.$1.compareTo(b.$1));

    final spans = <InlineSpan>[];
    var cursor = 0;
    for (final (index, label, recognizer) in links) {
      // Si las etiquetas se solapan, respaldo a texto plano.
      if (index < cursor) {
        return [TextSpan(text: text, style: baseStyle)];
      }
      if (index > cursor) {
        spans.add(TextSpan(text: text.substring(cursor, index)));
      }
      spans.add(
        TextSpan(text: label, style: linkStyle, recognizer: recognizer),
      );
      cursor = index + label.length;
    }
    if (cursor < text.length) {
      spans.add(TextSpan(text: text.substring(cursor)));
    }
    return spans;
  }
}
